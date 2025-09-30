import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../services/user_service.dart';

class MercadoPagoService {
  // IMPORTANTE: Em produção, essas chaves devem vir de variáveis de ambiente
  static const String _publicKey = 'TEST-your-public-key-here'; // Chave pública de teste
  static const String _accessToken = 'TEST-your-access-token-here'; // Token de acesso de teste
  static const String _baseUrl = 'https://api.mercadopago.com';
  
  /// Cria uma preferência de pagamento para checkout
  static Future<MercadoPagoPreference> createPaymentPreference({
    required PaymentPreferenceRequest request,
  }) async {
    try {
      final headers = {
        'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/json',
      };

      final body = {
        'items': [
          {
            'id': request.itemId,
            'title': request.title,
            'description': request.description,
            'quantity': 1,
            'currency_id': 'BRL',
            'unit_price': request.amount,
          }
        ],
        'payer': {
          'name': request.payerName,
          'surname': request.payerSurname,
          'email': request.payerEmail,
          'phone': {
            'area_code': request.payerPhoneArea,
            'number': request.payerPhoneNumber,
          },
          'identification': {
            'type': 'CPF',
            'number': request.payerCPF,
          },
        },
        'payment_methods': {
          'excluded_payment_methods': [],
          'excluded_payment_types': [],
          'installments': request.maxInstallments,
        },
        'back_urls': {
          'success': 'https://kareu.com/payment/success',
          'failure': 'https://kareu.com/payment/failure',
          'pending': 'https://kareu.com/payment/pending',
        },
        'auto_return': 'approved',
        'external_reference': request.externalReference,
        'notification_url': 'https://kareu.com/webhooks/mercadopago',
        'statement_descriptor': 'KAREU',
        'expires': true,
        'expiration_date_from': DateTime.now().toIso8601String(),
        'expiration_date_to': DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/checkout/preferences'),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return MercadoPagoPreference.fromJson(data);
      } else {
        throw MercadoPagoException('Erro ao criar preferência: ${response.body}');
      }
    } catch (e) {
      throw MercadoPagoException('Erro na comunicação: $e');
    }
  }

  /// Cria um pagamento PIX
  static Future<PixPaymentResponse> createPixPayment({
    required PixPaymentRequest request,
  }) async {
    try {
      final headers = {
        'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/json',
        'X-Idempotency-Key': _generateIdempotencyKey(),
      };

      final body = {
        'transaction_amount': request.amount,
        'description': request.description,
        'payment_method_id': 'pix',
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
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/v1/payments'),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return PixPaymentResponse.fromJson(data);
      } else {
        throw MercadoPagoException('Erro ao criar PIX: ${response.body}');
      }
    } catch (e) {
      throw MercadoPagoException('Erro na comunicação PIX: $e');
    }
  }

  /// Processa pagamento com cartão de crédito
  static Future<CardPaymentResponse> processCardPayment({
    required CardPaymentRequest request,
  }) async {
    try {
      final headers = {
        'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/json',
        'X-Idempotency-Key': _generateIdempotencyKey(),
      };

      final body = {
        'transaction_amount': request.amount,
        'token': request.cardToken, // Token do cartão (gerado no frontend)
        'description': request.description,
        'installments': request.installments,
        'payment_method_id': request.paymentMethodId,
        'issuer_id': request.issuerId,
        'payer': {
          'email': request.payerEmail,
          'identification': {
            'type': 'CPF',
            'number': request.payerCPF,
          },
        },
        'external_reference': request.externalReference,
        'notification_url': 'https://kareu.com/webhooks/mercadopago',
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/v1/payments'),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return CardPaymentResponse.fromJson(data);
      } else {
        throw MercadoPagoException('Erro no pagamento: ${response.body}');
      }
    } catch (e) {
      throw MercadoPagoException('Erro no pagamento com cartão: $e');
    }
  }

  /// Consulta status de um pagamento
  static Future<PaymentStatus> getPaymentStatus(String paymentId) async {
    try {
      final headers = {
        'Authorization': 'Bearer $_accessToken',
      };

      final response = await http.get(
        Uri.parse('$_baseUrl/v1/payments/$paymentId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PaymentStatus.fromJson(data);
      } else {
        throw MercadoPagoException('Erro ao consultar pagamento: ${response.body}');
      }
    } catch (e) {
      throw MercadoPagoException('Erro na consulta: $e');
    }
  }

  /// Obtém métodos de pagamento disponíveis
  static Future<List<PaymentMethod>> getPaymentMethods() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/v1/payment_methods?public_key=$_publicKey'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => PaymentMethod.fromJson(item)).toList();
      } else {
        throw MercadoPagoException('Erro ao obter métodos: ${response.body}');
      }
    } catch (e) {
      throw MercadoPagoException('Erro ao obter métodos: $e');
    }
  }

  /// Obtém opções de parcelamento para um método de pagamento
  static Future<List<InstallmentOption>> getInstallmentOptions({
    required String paymentMethodId,
    required double amount,
    String? issuerId,
  }) async {
    try {
      final queryParams = {
        'public_key': _publicKey,
        'amount': amount.toString(),
        'payment_method_id': paymentMethodId,
        if (issuerId != null) 'issuer_id': issuerId,
      };

      final uri = Uri.parse('$_baseUrl/v1/payment_methods/installments')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final installments = data.first['payer_costs'] as List<dynamic>;
        
        return installments.map((item) => InstallmentOption(
          installments: item['installments'],
          installmentAmount: item['installment_amount'].toDouble(),
          totalAmount: item['total_amount'].toDouble(),
          interestRate: item['installment_rate'].toDouble(),
          description: '${item['installments']}x de R\$ ${item['installment_amount'].toStringAsFixed(2)}',
        )).toList();
      } else {
        throw MercadoPagoException('Erro ao obter parcelamento: ${response.body}');
      }
    } catch (e) {
      throw MercadoPagoException('Erro no parcelamento: $e');
    }
  }

  /// Processa webhook do Mercado Pago
  static Future<WebhookProcessResult> processWebhook(Map<String, dynamic> webhookData) async {
    try {
      final type = webhookData['type'];
      final dataId = webhookData['data']['id'];

      if (type == 'payment') {
        final paymentStatus = await getPaymentStatus(dataId.toString());
        
        // Aqui você processaria a atualização do status no seu sistema
        // Exemplo: atualizar banco de dados, enviar notificações, etc.
        
        return WebhookProcessResult(
          success: true,
          message: 'Webhook processado com sucesso',
          paymentStatus: paymentStatus,
        );
      }

      return WebhookProcessResult(
        success: false,
        message: 'Tipo de webhook não suportado: $type',
      );
    } catch (e) {
      return WebhookProcessResult(
        success: false,
        message: 'Erro ao processar webhook: $e',
      );
    }
  }

  /// Gera chave de idempotência para evitar pagamentos duplicados
  static String _generateIdempotencyKey() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomNum = random.nextInt(999999);
    return '$timestamp-$randomNum';
  }

  /// Valida CPF (implementação básica)
  static bool isValidCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cpf.length != 11) return false;
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;
    
    // Validação dos dígitos verificadores
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (10 - i);
    }
    int digit1 = 11 - (sum % 11);
    if (digit1 >= 10) digit1 = 0;
    
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cpf[i]) * (11 - i);
    }
    int digit2 = 11 - (sum % 11);
    if (digit2 >= 10) digit2 = 0;
    
    return cpf[9] == digit1.toString() && cpf[10] == digit2.toString();
  }
}

// ===== CLASSES DE DADOS =====

class PaymentPreferenceRequest {
  final String itemId;
  final String title;
  final String description;
  final double amount;
  final String payerName;
  final String payerSurname;
  final String payerEmail;
  final String payerPhoneArea;
  final String payerPhoneNumber;
  final String payerCPF;
  final int maxInstallments;
  final String externalReference;

  PaymentPreferenceRequest({
    required this.itemId,
    required this.title,
    required this.description,
    required this.amount,
    required this.payerName,
    required this.payerSurname,
    required this.payerEmail,
    required this.payerPhoneArea,
    required this.payerPhoneNumber,
    required this.payerCPF,
    this.maxInstallments = 12,
    required this.externalReference,
  });
}

class MercadoPagoPreference {
  final String id;
  final String initPoint;
  final String sandboxInitPoint;

  MercadoPagoPreference({
    required this.id,
    required this.initPoint,
    required this.sandboxInitPoint,
  });

  factory MercadoPagoPreference.fromJson(Map<String, dynamic> json) {
    return MercadoPagoPreference(
      id: json['id'],
      initPoint: json['init_point'],
      sandboxInitPoint: json['sandbox_init_point'],
    );
  }
}

class PixPaymentRequest {
  final double amount;
  final String description;
  final String payerEmail;
  final String payerName;
  final String payerSurname;
  final String payerCPF;
  final String externalReference;

  PixPaymentRequest({
    required this.amount,
    required this.description,
    required this.payerEmail,
    required this.payerName,
    required this.payerSurname,
    required this.payerCPF,
    required this.externalReference,
  });
}

class PixPaymentResponse {
  final String id;
  final String status;
  final String qrCodeBase64;
  final String qrCode;
  final DateTime expirationDate;

  PixPaymentResponse({
    required this.id,
    required this.status,
    required this.qrCodeBase64,
    required this.qrCode,
    required this.expirationDate,
  });

  factory PixPaymentResponse.fromJson(Map<String, dynamic> json) {
    return PixPaymentResponse(
      id: json['id'].toString(),
      status: json['status'],
      qrCodeBase64: json['point_of_interaction']['transaction_data']['qr_code_base64'],
      qrCode: json['point_of_interaction']['transaction_data']['qr_code'],
      expirationDate: DateTime.parse(json['date_of_expiration']),
    );
  }
}

class CardPaymentRequest {
  final double amount;
  final String cardToken;
  final String description;
  final int installments;
  final String paymentMethodId;
  final String issuerId;
  final String payerEmail;
  final String payerCPF;
  final String externalReference;

  CardPaymentRequest({
    required this.amount,
    required this.cardToken,
    required this.description,
    required this.installments,
    required this.paymentMethodId,
    required this.issuerId,
    required this.payerEmail,
    required this.payerCPF,
    required this.externalReference,
  });
}

class CardPaymentResponse {
  final String id;
  final String status;
  final String statusDetail;
  final double transactionAmount;

  CardPaymentResponse({
    required this.id,
    required this.status,
    required this.statusDetail,
    required this.transactionAmount,
  });

  factory CardPaymentResponse.fromJson(Map<String, dynamic> json) {
    return CardPaymentResponse(
      id: json['id'].toString(),
      status: json['status'],
      statusDetail: json['status_detail'],
      transactionAmount: json['transaction_amount'].toDouble(),
    );
  }
}

class PaymentStatus {
  final String id;
  final String status;
  final String statusDetail;
  final double transactionAmount;
  final DateTime dateCreated;
  final DateTime? dateApproved;

  PaymentStatus({
    required this.id,
    required this.status,
    required this.statusDetail,
    required this.transactionAmount,
    required this.dateCreated,
    this.dateApproved,
  });

  factory PaymentStatus.fromJson(Map<String, dynamic> json) {
    return PaymentStatus(
      id: json['id'].toString(),
      status: json['status'],
      statusDetail: json['status_detail'],
      transactionAmount: json['transaction_amount'].toDouble(),
      dateCreated: DateTime.parse(json['date_created']),
      dateApproved: json['date_approved'] != null 
          ? DateTime.parse(json['date_approved'])
          : null,
    );
  }

  bool get isApproved => status == 'approved';
  bool get isPending => status == 'pending';
  bool get isRejected => status == 'rejected';
}

class PaymentMethod {
  final String id;
  final String name;
  final String paymentTypeId;
  final String thumbnail;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.paymentTypeId,
    required this.thumbnail,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      name: json['name'],
      paymentTypeId: json['payment_type_id'],
      thumbnail: json['thumbnail'] ?? '',
    );
  }
}

class InstallmentOption {
  final int installments;
  final double installmentAmount;
  final double totalAmount;
  final double interestRate;
  final String description;

  InstallmentOption({
    required this.installments,
    required this.installmentAmount,
    required this.totalAmount,
    required this.interestRate,
    required this.description,
  });
}

class WebhookProcessResult {
  final bool success;
  final String message;
  final PaymentStatus? paymentStatus;

  WebhookProcessResult({
    required this.success,
    required this.message,
    this.paymentStatus,
  });
}

class MercadoPagoException implements Exception {
  final String message;
  MercadoPagoException(this.message);
  
  @override
  String toString() => 'MercadoPagoException: $message';
}
