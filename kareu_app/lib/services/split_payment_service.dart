import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/user_service.dart';

class SplitPaymentService {
  static const String _accessToken = 'TEST-your-access-token-here';
  static const String _baseUrl = 'https://api.mercadopago.com';
  
  // Configurações da Kareu
  static const double _kareuServiceFeeRate = 0.08; // 8% taxa de serviço
  static const String _kareuAccountId = 'kareu_main_account'; // Conta principal da Kareu
  
  /// Cria um pagamento com split automático
  static Future<SplitPaymentResponse> createSplitPayment({
    required SplitPaymentRequest request,
  }) async {
    try {
      // Calcular valores do split
      final splitCalculation = _calculateSplit(
        totalAmount: request.totalAmount,
        caregiverAccountId: request.caregiverAccountId,
      );

      final headers = {
        'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/json',
        'X-Idempotency-Key': _generateIdempotencyKey(),
      };

      final body = {
        'transaction_amount': request.totalAmount,
        'description': request.description,
        'payment_method_id': request.paymentMethodId,
        'payer': {
          'email': request.payerEmail,
          'first_name': request.payerName,
          'last_name': request.payerSurname,
          'identification': {
            'type': 'CPF',
            'number': request.payerCPF,
          },
        },
        'external_reference': request.externalReference,
        'notification_url': 'https://kareu.com/webhooks/mercadopago',
        
        // CONFIGURAÇÃO DO SPLIT DE PAGAMENTO
        'application_fee': splitCalculation.kareuServiceFee,
        'marketplace_fee': splitCalculation.kareuServiceFee,
        
        // Destinatários do split
        'additional_info': {
          'split_payments': [
            {
              'amount': splitCalculation.caregiverAmount,
              'account_id': request.caregiverAccountId,
              'description': 'Pagamento ao cuidador',
            },
            {
              'amount': splitCalculation.kareuServiceFee,
              'account_id': _kareuAccountId,
              'description': 'Taxa de Serviço Kareu',
            },
          ],
        },
        
        // Metadados para controle interno
        'metadata': {
          'kareu_service_fee_rate': _kareuServiceFeeRate,
          'caregiver_id': request.caregiverId,
          'contract_id': request.contractId,
          'split_type': 'automatic',
        },
      };

      // Se for cartão, incluir dados específicos
      if (request.cardToken != null) {
        body['token'] = request.cardToken!;
        body['installments'] = request.installments ?? 1;
        body['issuer_id'] = request.issuerId!;
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/v1/payments'),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return SplitPaymentResponse.fromJson(data, splitCalculation);
      } else {
        throw SplitPaymentException('Erro no split payment: ${response.body}');
      }
    } catch (e) {
      throw SplitPaymentException('Erro no processamento: $e');
    }
  }

  /// Cria um marketplace split (método alternativo)
  static Future<MarketplaceSplitResponse> createMarketplaceSplit({
    required MarketplaceSplitRequest request,
  }) async {
    try {
      final splitCalculation = _calculateSplit(
        totalAmount: request.totalAmount,
        caregiverAccountId: request.caregiverAccountId,
      );

      final headers = {
        'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/json',
      };

      // Primeiro, criar o pagamento principal na conta da Kareu
      final mainPayment = await _createMainPayment(request, headers);
      
      // Depois, criar transferência para o cuidador
      final transfer = await _createTransferToCaregiver(
        request.caregiverAccountId,
        splitCalculation.caregiverAmount,
        mainPayment.id,
        headers,
      );

      return MarketplaceSplitResponse(
        mainPayment: mainPayment,
        caregiverTransfer: transfer,
        splitCalculation: splitCalculation,
      );
    } catch (e) {
      throw SplitPaymentException('Erro no marketplace split: $e');
    }
  }

  /// Processa repasse manual para cuidador
  static Future<TransferResponse> transferToCaregiver({
    required String caregiverAccountId,
    required double amount,
    required String contractId,
    String? description,
  }) async {
    try {
      final headers = {
        'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/json',
      };

      final body = {
        'amount': amount,
        'currency_id': 'BRL',
        'description': description ?? 'Repasse de pagamento - Contrato $contractId',
        'receiver_id': caregiverAccountId,
        'external_reference': 'transfer_$contractId',
        'metadata': {
          'contract_id': contractId,
          'transfer_type': 'caregiver_payment',
          'processed_by': 'kareu_system',
        },
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/v1/money_requests'),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return TransferResponse.fromJson(data);
      } else {
        throw SplitPaymentException('Erro na transferência: ${response.body}');
      }
    } catch (e) {
      throw SplitPaymentException('Erro no repasse: $e');
    }
  }

  /// Consulta saldo da conta Kareu
  static Future<AccountBalance> getKareuBalance() async {
    try {
      final headers = {
        'Authorization': 'Bearer $_accessToken',
      };

      final response = await http.get(
        Uri.parse('$_baseUrl/v1/account/balance'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AccountBalance.fromJson(data);
      } else {
        throw SplitPaymentException('Erro ao consultar saldo: ${response.body}');
      }
    } catch (e) {
      throw SplitPaymentException('Erro na consulta de saldo: $e');
    }
  }

  /// Obtém relatório de comissões
  static Future<CommissionReport> getCommissionReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final headers = {
        'Authorization': 'Bearer $_accessToken',
      };

      final queryParams = {
        'begin_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'operation_type': 'marketplace_fee',
      };

      final uri = Uri.parse('$_baseUrl/v1/account/settlement_report')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CommissionReport.fromJson(data);
      } else {
        throw SplitPaymentException('Erro no relatório: ${response.body}');
      }
    } catch (e) {
      throw SplitPaymentException('Erro no relatório de comissões: $e');
    }
  }

  // Métodos auxiliares privados
  static SplitCalculation _calculateSplit({
    required double totalAmount,
    required String caregiverAccountId,
  }) {
    final kareuServiceFee = totalAmount * _kareuServiceFeeRate;
    final caregiverAmount = totalAmount - kareuServiceFee;
    
    return SplitCalculation(
      totalAmount: totalAmount,
      kareuServiceFee: kareuServiceFee,
      caregiverAmount: caregiverAmount,
      serviceFeeRate: _kareuServiceFeeRate,
    );
  }

  static Future<MainPayment> _createMainPayment(
    MarketplaceSplitRequest request,
    Map<String, String> headers,
  ) async {
    final body = {
      'transaction_amount': request.totalAmount,
      'description': request.description,
      'payment_method_id': request.paymentMethodId,
      'payer': {
        'email': request.payerEmail,
        'first_name': request.payerName,
        'last_name': request.payerSurname,
        'identification': {
          'type': 'CPF',
          'number': request.payerCPF,
        },
      },
      'external_reference': request.externalReference,
    };

    if (request.cardToken != null) {
      body['token'] = request.cardToken!;
      body['installments'] = request.installments ?? 1;
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/v1/payments'),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return MainPayment.fromJson(data);
    } else {
      throw SplitPaymentException('Erro no pagamento principal: ${response.body}');
    }
  }

  static Future<CaregiverTransfer> _createTransferToCaregiver(
    String caregiverAccountId,
    double amount,
    String paymentId,
    Map<String, String> headers,
  ) async {
    final body = {
      'amount': amount,
      'currency_id': 'BRL',
      'receiver_id': caregiverAccountId,
      'description': 'Repasse automático - Pagamento $paymentId',
      'external_reference': 'auto_transfer_$paymentId',
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/v1/money_requests'),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return CaregiverTransfer.fromJson(data);
    } else {
      throw SplitPaymentException('Erro na transferência: ${response.body}');
    }
  }

  static String _generateIdempotencyKey() {
    return 'kareu_${DateTime.now().millisecondsSinceEpoch}';
  }
}

// ===== CLASSES DE DADOS =====

class SplitPaymentRequest {
  final double totalAmount;
  final String description;
  final String paymentMethodId;
  final String payerEmail;
  final String payerName;
  final String payerSurname;
  final String payerCPF;
  final String caregiverAccountId;
  final String caregiverId;
  final String contractId;
  final String externalReference;
  final String? cardToken;
  final int? installments;
  final String? issuerId;

  SplitPaymentRequest({
    required this.totalAmount,
    required this.description,
    required this.paymentMethodId,
    required this.payerEmail,
    required this.payerName,
    required this.payerSurname,
    required this.payerCPF,
    required this.caregiverAccountId,
    required this.caregiverId,
    required this.contractId,
    required this.externalReference,
    this.cardToken,
    this.installments,
    this.issuerId,
  });
}

class SplitCalculation {
  final double totalAmount;
  final double kareuServiceFee;
  final double caregiverAmount;
  final double serviceFeeRate;

  SplitCalculation({
    required this.totalAmount,
    required this.kareuServiceFee,
    required this.caregiverAmount,
    required this.serviceFeeRate,
  });

  Map<String, dynamic> toJson() => {
    'total_amount': totalAmount,
    'kareu_service_fee': kareuServiceFee,
    'caregiver_amount': caregiverAmount,
    'service_fee_rate': serviceFeeRate,
  };
}

class SplitPaymentResponse {
  final String id;
  final String status;
  final double transactionAmount;
  final SplitCalculation splitCalculation;
  final DateTime createdAt;

  SplitPaymentResponse({
    required this.id,
    required this.status,
    required this.transactionAmount,
    required this.splitCalculation,
    required this.createdAt,
  });

  factory SplitPaymentResponse.fromJson(Map<String, dynamic> json, SplitCalculation split) {
    return SplitPaymentResponse(
      id: json['id'].toString(),
      status: json['status'],
      transactionAmount: json['transaction_amount'].toDouble(),
      splitCalculation: split,
      createdAt: DateTime.parse(json['date_created']),
    );
  }
}

class MarketplaceSplitRequest {
  final double totalAmount;
  final String description;
  final String paymentMethodId;
  final String payerEmail;
  final String payerName;
  final String payerSurname;
  final String payerCPF;
  final String caregiverAccountId;
  final String externalReference;
  final String? cardToken;
  final int? installments;

  MarketplaceSplitRequest({
    required this.totalAmount,
    required this.description,
    required this.paymentMethodId,
    required this.payerEmail,
    required this.payerName,
    required this.payerSurname,
    required this.payerCPF,
    required this.caregiverAccountId,
    required this.externalReference,
    this.cardToken,
    this.installments,
  });
}

class MarketplaceSplitResponse {
  final MainPayment mainPayment;
  final CaregiverTransfer caregiverTransfer;
  final SplitCalculation splitCalculation;

  MarketplaceSplitResponse({
    required this.mainPayment,
    required this.caregiverTransfer,
    required this.splitCalculation,
  });
}

class MainPayment {
  final String id;
  final String status;
  final double amount;

  MainPayment({
    required this.id,
    required this.status,
    required this.amount,
  });

  factory MainPayment.fromJson(Map<String, dynamic> json) {
    return MainPayment(
      id: json['id'].toString(),
      status: json['status'],
      amount: json['transaction_amount'].toDouble(),
    );
  }
}

class CaregiverTransfer {
  final String id;
  final String status;
  final double amount;

  CaregiverTransfer({
    required this.id,
    required this.status,
    required this.amount,
  });

  factory CaregiverTransfer.fromJson(Map<String, dynamic> json) {
    return CaregiverTransfer(
      id: json['id'].toString(),
      status: json['status'],
      amount: json['amount'].toDouble(),
    );
  }
}

class TransferResponse {
  final String id;
  final String status;
  final double amount;
  final String receiverId;

  TransferResponse({
    required this.id,
    required this.status,
    required this.amount,
    required this.receiverId,
  });

  factory TransferResponse.fromJson(Map<String, dynamic> json) {
    return TransferResponse(
      id: json['id'].toString(),
      status: json['status'],
      amount: json['amount'].toDouble(),
      receiverId: json['receiver_id'],
    );
  }
}

class AccountBalance {
  final double availableBalance;
  final double unavailableBalance;
  final double totalBalance;

  AccountBalance({
    required this.availableBalance,
    required this.unavailableBalance,
    required this.totalBalance,
  });

  factory AccountBalance.fromJson(Map<String, dynamic> json) {
    return AccountBalance(
      availableBalance: json['available_balance'].toDouble(),
      unavailableBalance: json['unavailable_balance'].toDouble(),
      totalBalance: json['total_balance'].toDouble(),
    );
  }
}

class CommissionReport {
  final double totalCommissions;
  final int totalTransactions;
  final List<CommissionItem> items;

  CommissionReport({
    required this.totalCommissions,
    required this.totalTransactions,
    required this.items,
  });

  factory CommissionReport.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as List<dynamic>;
    final items = results.map((item) => CommissionItem.fromJson(item)).toList();
    
    return CommissionReport(
      totalCommissions: items.fold(0.0, (sum, item) => sum + item.amount),
      totalTransactions: items.length,
      items: items,
    );
  }
}

class CommissionItem {
  final String id;
  final double amount;
  final DateTime date;
  final String description;

  CommissionItem({
    required this.id,
    required this.amount,
    required this.date,
    required this.description,
  });

  factory CommissionItem.fromJson(Map<String, dynamic> json) {
    return CommissionItem(
      id: json['id'].toString(),
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date_created']),
      description: json['description'] ?? '',
    );
  }
}

class SplitPaymentException implements Exception {
  final String message;
  SplitPaymentException(this.message);
  
  @override
  String toString() => 'SplitPaymentException: $message';
}
