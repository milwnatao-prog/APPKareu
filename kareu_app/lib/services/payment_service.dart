import 'dart:async';
import 'dart:math';
import '../services/user_service.dart';

class PaymentService {
  static final Map<String, PaymentMethod> _paymentMethods = {};
  static final List<PaymentTransaction> _transactions = [];
  static final Map<String, CouponCode> _coupons = {
    'KAREU10': CouponCode(
      code: 'KAREU10',
      discount: 10.0,
      type: DiscountType.percentage,
      isActive: true,
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      usageLimit: 100,
      usedCount: 15,
    ),
    'PRIMEIRA': CouponCode(
      code: 'PRIMEIRA',
      discount: 50.0,
      type: DiscountType.percentage,
      isActive: true,
      expiryDate: DateTime.now().add(const Duration(days: 60)),
      usageLimit: 50,
      usedCount: 8,
      isFirstTimeOnly: true,
    ),
    'DESCONTO25': CouponCode(
      code: 'DESCONTO25',
      discount: 25.0,
      type: DiscountType.fixed,
      isActive: true,
      expiryDate: DateTime.now().add(const Duration(days: 15)),
      usageLimit: 200,
      usedCount: 45,
    ),
  };

  /// Calcula o preço total com base nos parâmetros
  static PriceCalculation calculatePrice({
    required double hourlyRate,
    required int totalHours,
    required List<String> additionalServices,
    String? couponCode,
    bool includeInsurance = false,
    bool includePlatformFee = true,
  }) {
    double baseAmount = hourlyRate * totalHours;
    double servicesAmount = 0.0;
    double discountAmount = 0.0;
    double insuranceAmount = 0.0;
    double platformFee = 0.0;
    
    // Calcular serviços adicionais
    for (String service in additionalServices) {
      servicesAmount += _getServicePrice(service);
    }
    
    double subtotal = baseAmount + servicesAmount;
    
    // Aplicar cupom de desconto
    if (couponCode != null && _coupons.containsKey(couponCode.toUpperCase())) {
      final coupon = _coupons[couponCode.toUpperCase()]!;
      if (coupon.isValid()) {
        if (coupon.type == DiscountType.percentage) {
          discountAmount = subtotal * (coupon.discount / 100);
        } else {
          discountAmount = coupon.discount;
        }
      }
    }
    
    // Calcular seguro (opcional)
    if (includeInsurance) {
      insuranceAmount = subtotal * 0.05; // 5% do valor
    }
    
    // Taxa da plataforma (padrão 8%)
    if (includePlatformFee) {
      platformFee = (subtotal - discountAmount) * 0.08;
    }
    
    double totalAmount = subtotal - discountAmount + insuranceAmount + platformFee;
    
    return PriceCalculation(
      baseAmount: baseAmount,
      servicesAmount: servicesAmount,
      subtotal: subtotal,
      discountAmount: discountAmount,
      insuranceAmount: insuranceAmount,
      platformFee: platformFee,
      totalAmount: totalAmount,
      appliedCoupon: couponCode,
      breakdown: _generateBreakdown(
        baseAmount, servicesAmount, discountAmount, 
        insuranceAmount, platformFee, additionalServices
      ),
    );
  }

  /// Valida um cupom de desconto
  static CouponValidation validateCoupon(String code, String userId) {
    final coupon = _coupons[code.toUpperCase()];
    
    if (coupon == null) {
      return CouponValidation(
        isValid: false,
        message: 'Cupom não encontrado',
      );
    }
    
    if (!coupon.isValid()) {
      return CouponValidation(
        isValid: false,
        message: 'Cupom expirado ou inativo',
      );
    }
    
    if (coupon.usedCount >= coupon.usageLimit) {
      return CouponValidation(
        isValid: false,
        message: 'Cupom esgotado',
      );
    }
    
    if (coupon.isFirstTimeOnly && _hasUserMadePayment(userId)) {
      return CouponValidation(
        isValid: false,
        message: 'Cupom válido apenas para primeira contratação',
      );
    }
    
    return CouponValidation(
      isValid: true,
      message: 'Cupom válido',
      discount: coupon.discount,
      type: coupon.type,
    );
  }

  /// Processa um pagamento
  static Future<PaymentResult> processPayment({
    required PaymentRequest request,
  }) async {
    try {
      // Simular processamento
      await Future.delayed(const Duration(seconds: 2));
      
      // Validar dados do pagamento
      final validation = _validatePaymentData(request);
      if (!validation.isValid) {
        return PaymentResult(
          success: false,
          message: validation.message,
          transactionId: null,
        );
      }
      
      // Simular diferentes cenários de pagamento
      final random = Random();
      final successRate = 0.95; // 95% de sucesso
      
      if (random.nextDouble() > successRate) {
        return PaymentResult(
          success: false,
          message: 'Pagamento recusado pelo banco. Tente outro cartão.',
          transactionId: null,
        );
      }
      
      // Criar transação
      final transaction = PaymentTransaction(
        id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
        userId: request.userId,
        amount: request.amount,
        paymentMethod: request.paymentMethod,
        status: PaymentStatus.completed,
        createdAt: DateTime.now(),
        contractId: request.contractId,
        description: request.description,
      );
      
      _transactions.add(transaction);
      
      // Aplicar cupom se usado
      if (request.couponCode != null) {
        _applyCoupon(request.couponCode!);
      }
      
      return PaymentResult(
        success: true,
        message: 'Pagamento processado com sucesso',
        transactionId: transaction.id,
        transaction: transaction,
      );
      
    } catch (e) {
      return PaymentResult(
        success: false,
        message: 'Erro interno no processamento',
        transactionId: null,
      );
    }
  }

  /// Salva um método de pagamento
  static Future<bool> savePaymentMethod(PaymentMethod method) async {
    try {
      _paymentMethods[method.id] = method;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Obtém métodos de pagamento salvos
  static List<PaymentMethod> getSavedPaymentMethods(String userId) {
    return _paymentMethods.values
        .where((method) => method.userId == userId)
        .toList();
  }

  /// Obtém histórico de transações
  static List<PaymentTransaction> getTransactionHistory(String userId) {
    return _transactions
        .where((transaction) => transaction.userId == userId)
        .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Gera simulação de parcelamento
  static List<InstallmentOption> getInstallmentOptions(double amount) {
    final options = <InstallmentOption>[];
    
    // À vista (sem juros)
    options.add(InstallmentOption(
      installments: 1,
      installmentAmount: amount,
      totalAmount: amount,
      interestRate: 0.0,
      description: 'À vista',
    ));
    
    // Parcelamento com juros
    for (int i = 2; i <= 12; i++) {
      double monthlyRate = 0.025; // 2.5% ao mês
      double totalWithInterest = amount * pow(1 + monthlyRate, i);
      double installmentAmount = totalWithInterest / i;
      
      options.add(InstallmentOption(
        installments: i,
        installmentAmount: installmentAmount,
        totalAmount: totalWithInterest,
        interestRate: monthlyRate * 100,
        description: '${i}x de R\$ ${installmentAmount.toStringAsFixed(2)}',
      ));
    }
    
    return options;
  }

  // Métodos auxiliares privados
  static double _getServicePrice(String service) {
    final prices = {
      'medicacao': 15.0,
      'fisioterapia': 25.0,
      'companhia': 10.0,
      'higiene': 20.0,
      'alimentacao': 12.0,
      'transporte': 30.0,
    };
    return prices[service] ?? 0.0;
  }

  static bool _hasUserMadePayment(String userId) {
    return _transactions.any((t) => t.userId == userId && t.status == PaymentStatus.completed);
  }

  static PaymentValidation _validatePaymentData(PaymentRequest request) {
    if (request.amount <= 0) {
      return PaymentValidation(false, 'Valor inválido');
    }
    
    if (request.paymentMethod.type == PaymentMethodType.creditCard) {
      if (request.paymentMethod.cardNumber?.length != 16) {
        return PaymentValidation(false, 'Número do cartão inválido');
      }
      if (request.paymentMethod.expiryDate?.isBefore(DateTime.now()) == true) {
        return PaymentValidation(false, 'Cartão expirado');
      }
    }
    
    return PaymentValidation(true, 'Dados válidos');
  }

  static void _applyCoupon(String code) {
    final coupon = _coupons[code.toUpperCase()];
    if (coupon != null) {
      coupon.usedCount++;
    }
  }

  static List<PriceBreakdownItem> _generateBreakdown(
    double base, double services, double discount, 
    double insurance, double platformFee, List<String> additionalServices
  ) {
    final items = <PriceBreakdownItem>[];
    
    items.add(PriceBreakdownItem('Valor base', base));
    
    if (services > 0) {
      items.add(PriceBreakdownItem('Serviços adicionais', services));
    }
    
    if (discount > 0) {
      items.add(PriceBreakdownItem('Desconto', -discount));
    }
    
    if (insurance > 0) {
      items.add(PriceBreakdownItem('Seguro', insurance));
    }
    
    if (platformFee > 0) {
      items.add(PriceBreakdownItem('Taxa da plataforma', platformFee));
    }
    
    return items;
  }
}

// ===== CLASSES DE DADOS =====

class PriceCalculation {
  final double baseAmount;
  final double servicesAmount;
  final double subtotal;
  final double discountAmount;
  final double insuranceAmount;
  final double platformFee;
  final double totalAmount;
  final String? appliedCoupon;
  final List<PriceBreakdownItem> breakdown;

  PriceCalculation({
    required this.baseAmount,
    required this.servicesAmount,
    required this.subtotal,
    required this.discountAmount,
    required this.insuranceAmount,
    required this.platformFee,
    required this.totalAmount,
    this.appliedCoupon,
    required this.breakdown,
  });
}

class PriceBreakdownItem {
  final String description;
  final double amount;

  PriceBreakdownItem(this.description, this.amount);
}

class CouponCode {
  final String code;
  final double discount;
  final DiscountType type;
  final bool isActive;
  final DateTime expiryDate;
  final int usageLimit;
  int usedCount;
  final bool isFirstTimeOnly;

  CouponCode({
    required this.code,
    required this.discount,
    required this.type,
    required this.isActive,
    required this.expiryDate,
    required this.usageLimit,
    required this.usedCount,
    this.isFirstTimeOnly = false,
  });

  bool isValid() {
    return isActive && 
           DateTime.now().isBefore(expiryDate) && 
           usedCount < usageLimit;
  }
}

class CouponValidation {
  final bool isValid;
  final String message;
  final double? discount;
  final DiscountType? type;

  CouponValidation({
    required this.isValid,
    required this.message,
    this.discount,
    this.type,
  });
}

class PaymentMethod {
  final String id;
  final String userId;
  final PaymentMethodType type;
  final String? cardNumber;
  final String? cardHolderName;
  final DateTime? expiryDate;
  final String? brand;
  final String? pixKey;
  final bool isDefault;
  final DateTime createdAt;

  PaymentMethod({
    required this.id,
    required this.userId,
    required this.type,
    this.cardNumber,
    this.cardHolderName,
    this.expiryDate,
    this.brand,
    this.pixKey,
    this.isDefault = false,
    required this.createdAt,
  });

  String get displayName {
    switch (type) {
      case PaymentMethodType.creditCard:
        return '**** **** **** ${cardNumber?.substring(12) ?? '****'}';
      case PaymentMethodType.pix:
        return 'PIX - ${pixKey ?? 'Chave não informada'}';
    }
  }
}

class PaymentRequest {
  final String userId;
  final double amount;
  final PaymentMethod paymentMethod;
  final String? contractId;
  final String description;
  final String? couponCode;
  final int? installments;

  PaymentRequest({
    required this.userId,
    required this.amount,
    required this.paymentMethod,
    this.contractId,
    required this.description,
    this.couponCode,
    this.installments,
  });
}

class PaymentResult {
  final bool success;
  final String message;
  final String? transactionId;
  final PaymentTransaction? transaction;

  PaymentResult({
    required this.success,
    required this.message,
    this.transactionId,
    this.transaction,
  });
}

class PaymentTransaction {
  final String id;
  final String userId;
  final double amount;
  final PaymentMethod paymentMethod;
  final PaymentStatus status;
  final DateTime createdAt;
  final String? contractId;
  final String description;

  PaymentTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.contractId,
    required this.description,
  });
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

class PaymentValidation {
  final bool isValid;
  final String message;

  PaymentValidation(this.isValid, this.message);
}

// ===== ENUMS =====

enum PaymentMethodType { creditCard, pix }
enum PaymentStatus { pending, processing, completed, failed, cancelled }
enum DiscountType { percentage, fixed }
