import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_design_system.dart';
import '../services/payment_service.dart';
import '../services/user_service.dart';
import '../widgets/animated_list.dart';

class ImprovedHireScreen extends StatefulWidget {
  final Map<String, dynamic>? caregiverData;
  
  const ImprovedHireScreen({
    super.key,
    this.caregiverData,
  });

  @override
  State<ImprovedHireScreen> createState() => _ImprovedHireScreenState();
}

class _ImprovedHireScreenState extends State<ImprovedHireScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentStep = 0;
  
  // Dados do serviço
  double _hourlyRate = 25.0;
  int _totalHours = 8;
  final Set<String> _selectedServices = {};
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 16, minute: 0);

  // Funcionalidades avançadas de agendamento (da HireCaregiverScreen)
  DateTime _selectedMonth = DateTime.now();
  final Set<DateTime> _selectedDates = {};
  bool _useMultipleDates = false;
  
  // Pagamento
  String _selectedPaymentMethod = '';
  int _selectedInstallments = 1;
  bool _includeInsurance = false;
  String _couponCode = '';
  PriceCalculation? _priceCalculation;
  List<InstallmentOption> _installmentOptions = [];
  
  // Controllers
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _pixKeyController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();
  
  // Estado
  bool _isProcessingPayment = false;
  CouponValidation? _couponValidation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _handlePayment = () {
      _processPayment().catchError((error) {
        _showError('Erro no processamento do pagamento');
      });
    };
    _calculatePrice();
    _loadInstallmentOptions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Receber dados do cuidador via argumentos
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      setState(() {
        _hourlyRate = double.tryParse(args['price']?.toString().replaceAll(RegExp(r'[^\d.]'), '') ?? '25') ?? 25.0;
      });
      _calculatePrice();
      _loadInstallmentOptions();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _couponController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _pixKeyController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  void _calculatePrice() {
    final int totalHours = _useMultipleDates
        ? _calculateTotalHoursFromDates()
        : _totalHours;

    setState(() {
      _priceCalculation = PaymentService.calculatePrice(
        hourlyRate: _hourlyRate,
        totalHours: totalHours,
        additionalServices: _selectedServices.toList(),
        couponCode: _couponCode.isNotEmpty ? _couponCode : null,
        includeInsurance: _includeInsurance,
      );
    });
  }

  void _loadInstallmentOptions() {
    if (_priceCalculation != null) {
      setState(() {
        _installmentOptions = PaymentService.getInstallmentOptions(_priceCalculation!.totalAmount);
      });
    }
  }

  void _validateCoupon() {
    if (_couponController.text.isNotEmpty) {
      final validation = PaymentService.validateCoupon(
        _couponController.text,
        UserService.currentUserId,
      );
      
      setState(() {
        _couponValidation = validation;
        if (validation.isValid) {
          _couponCode = _couponController.text.toUpperCase();
        } else {
          _couponCode = '';
        }
      });
      
      _calculatePrice();
      _loadInstallmentOptions();
    }
  }

  Future<void> _processPayment() async {
    if (_selectedPaymentMethod.isEmpty) {
      _showError('Selecione uma forma de pagamento');
      return;
    }

    setState(() {
      _isProcessingPayment = true;
    });

    try {
      PaymentMethod paymentMethod;
      
      if (_selectedPaymentMethod == 'card') {
        paymentMethod = PaymentMethod(
          id: 'temp_card',
          userId: UserService.currentUserId,
          type: PaymentMethodType.creditCard,
          cardNumber: _cardNumberController.text.replaceAll(' ', ''),
          cardHolderName: _cardHolderController.text,
          expiryDate: _parseExpiryDate(_expiryController.text),
          createdAt: DateTime.now(),
        );
      } else {
        paymentMethod = PaymentMethod(
          id: 'temp_pix',
          userId: UserService.currentUserId,
          type: PaymentMethodType.pix,
          pixKey: _pixKeyController.text,
          createdAt: DateTime.now(),
        );
      }

      final request = PaymentRequest(
        userId: UserService.currentUserId,
        amount: _priceCalculation!.totalAmount,
        paymentMethod: paymentMethod,
        description: 'Contratação de cuidador - ${widget.caregiverData?['name'] ?? 'Cuidador'}',
        couponCode: _couponCode.isNotEmpty ? _couponCode : null,
        installments: _selectedInstallments,
      );

      final result = await PaymentService.processPayment(request: request);

      if (result.success) {
        _showSuccessDialog(result);
      } else {
        _showError(result.message);
      }
    } catch (e) {
      _showError('Erro no processamento do pagamento');
    } finally {
      setState(() {
        _isProcessingPayment = false;
      });
    }
  }

  late final dynamic _handlePayment;

  DateTime? _parseExpiryDate(String expiry) {
    try {
      final parts = expiry.split('/');
      if (parts.length == 2) {
        final month = int.parse(parts[0]);
        final year = 2000 + int.parse(parts[1]);
        return DateTime(year, month);
      }
    } catch (e) {
      // Ignore parsing errors
    }
    return null;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppDesignSystem.errorColor,
      ),
    );
  }

  void _navigateToRealPayment() {
    Navigator.pushNamed(
      context,
      '/real-payment',
      arguments: {
        'caregiverData': widget.caregiverData,
        'priceCalculation': _priceCalculation,
      },
    );
  }

  void _showSuccessDialog(PaymentResult result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppDesignSystem.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: AppDesignSystem.successColor,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Pagamento Aprovado!',
              style: AppDesignSystem.h2Style,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Transação: ${result.transactionId}',
              style: AppDesignSystem.captionStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Seu cuidador foi contratado com sucesso. Você receberá uma confirmação por email.',
              style: AppDesignSystem.bodyStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          AppDesignSystem.primaryButton(
            text: 'Continuar',
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      appBar: AppDesignSystem.styledAppBar(
        title: 'Contratar Cuidador',
        context: context,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Progress Indicator
          _buildProgressIndicator(),
          
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildServiceConfigPage(),
                _buildPriceReviewPage(),
                _buildPaymentPage(),
              ],
            ),
          ),
          
          // Navigation Buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildStepIndicator(0, 'Serviço'),
          Expanded(child: _buildStepLine(0)),
          _buildStepIndicator(1, 'Revisão'),
          Expanded(child: _buildStepLine(1)),
          _buildStepIndicator(2, 'Pagamento'),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep >= step;
    final isCompleted = _currentStep > step;
    
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted 
                ? AppDesignSystem.successColor 
                : isActive 
                    ? AppDesignSystem.primaryColor 
                    : AppDesignSystem.borderColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted ? Icons.check : Icons.circle,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppDesignSystem.captionStyle.copyWith(
            color: isActive 
                ? AppDesignSystem.primaryColor 
                : AppDesignSystem.textSecondaryColor,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int step) {
    final isCompleted = _currentStep > step;
    
    return Container(
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      color: isCompleted 
          ? AppDesignSystem.successColor 
          : AppDesignSystem.borderColor,
    );
  }

  Widget _buildServiceConfigPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Caregiver Info
          _buildCaregiverCard(),
          
          const SizedBox(height: 24),
          
          // Service Configuration
          _buildServiceConfig(),
          
          const SizedBox(height: 24),
          
          // Additional Services
          _buildAdditionalServices(),
          
          const SizedBox(height: 24),
          
          // Price Preview
          _buildPricePreview(),
        ],
      ),
    );
  }

  Widget _buildCaregiverCard() {
    final caregiver = widget.caregiverData ?? {
      'name': 'Maria Silva',
      'specialty': 'Cuidadora Especializada',
      'rating': 4.8,
      'experience': '5 anos',
      'hourlyRate': 25.0,
    };

    return AppDesignSystem.styledCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppDesignSystem.primaryColor.withOpacity(0.1),
            child: Text(
              caregiver['name'][0],
              style: AppDesignSystem.h2Style.copyWith(
                color: AppDesignSystem.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  caregiver['name'],
                  style: AppDesignSystem.h3Style,
                ),
                Text(
                  caregiver['specialty'],
                  style: AppDesignSystem.bodyStyle.copyWith(
                    color: AppDesignSystem.textSecondaryColor,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: AppDesignSystem.warningColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${caregiver['rating']} • ${caregiver['experience']}',
                      style: AppDesignSystem.captionStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'R\$ ${caregiver['hourlyRate'].toStringAsFixed(0)}/hora',
                style: AppDesignSystem.h3Style.copyWith(
                  color: AppDesignSystem.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceConfig() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configuração do Serviço',
            style: AppDesignSystem.h3Style,
          ),
          const SizedBox(height: 16),
          
          // Scheduling Mode Toggle
          _buildSchedulingModeToggle(),

          const SizedBox(height: 16),

          // Date and Time
          if (!_useMultipleDates) ...[
            Row(
              children: [
                Expanded(
                  child: _buildDateField(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTimeFields(),
                ),
              ],
            ),
          ] else ...[
            _buildMultipleDatesCalendar(),
          ],

          if (!_useMultipleDates) ...[
            const SizedBox(height: 16),
            // Hours Slider
            _buildHoursSlider(),
          ],
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data de Início',
          style: AppDesignSystem.bodyStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _startDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              setState(() {
                _startDate = date;
              });
              _calculatePrice();
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppDesignSystem.borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppDesignSystem.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                  style: AppDesignSystem.bodyStyle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Horário',
          style: AppDesignSystem.bodyStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTimeField('Início', _startTime, (time) {
                setState(() {
                  _startTime = time;
                  _updateTotalHours();
                });
                _calculatePrice();
              }),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTimeField('Fim', _endTime, (time) {
                setState(() {
                  _endTime = time;
                  _updateTotalHours();
                });
                _calculatePrice();
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeField(String label, TimeOfDay time, Function(TimeOfDay) onChanged) {
    return GestureDetector(
      onTap: () async {
        final newTime = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (newTime != null) {
          onChanged(newTime);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: AppDesignSystem.borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          time.format(context),
          style: AppDesignSystem.bodyStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _updateTotalHours() {
    final startMinutes = _startTime.hour * 60 + _startTime.minute;
    final endMinutes = _endTime.hour * 60 + _endTime.minute;
    final diffMinutes = endMinutes - startMinutes;
    
    if (diffMinutes > 0) {
      setState(() {
        _totalHours = (diffMinutes / 60).ceil();
      });
    }
  }

  Widget _buildHoursSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total de Horas',
              style: AppDesignSystem.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$_totalHours horas',
              style: AppDesignSystem.h3Style.copyWith(
                color: AppDesignSystem.primaryColor,
              ),
            ),
          ],
        ),
        Slider(
          value: _totalHours.toDouble(),
          min: 1,
          max: 24,
          divisions: 23,
          activeColor: AppDesignSystem.primaryColor,
          onChanged: (value) {
            setState(() {
              _totalHours = value.round();
            });
            _calculatePrice();
          },
        ),
      ],
    );
  }

  Widget _buildAdditionalServices() {
    final services = [
      {'id': 'medicacao', 'name': 'Administração de Medicamentos', 'price': 15.0},
      {'id': 'fisioterapia', 'name': 'Auxílio em Fisioterapia', 'price': 25.0},
      {'id': 'companhia', 'name': 'Companhia e Conversa', 'price': 10.0},
      {'id': 'higiene', 'name': 'Cuidados de Higiene', 'price': 20.0},
      {'id': 'alimentacao', 'name': 'Auxílio na Alimentação', 'price': 12.0},
      {'id': 'transporte', 'name': 'Acompanhamento em Consultas', 'price': 30.0},
    ];

    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Serviços Adicionais',
            style: AppDesignSystem.h3Style,
          ),
          const SizedBox(height: 16),
          ...services.map((service) {
            final isSelected = _selectedServices.contains(service['id']);
            return AnimatedCard(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedServices.remove(service['id']);
                  } else {
                    _selectedServices.add(service['id'] as String);
                  }
                });
                _calculatePrice();
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? AppDesignSystem.primaryColor : AppDesignSystem.borderColor,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected ? AppDesignSystem.primaryColor.withOpacity(0.05) : null,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppDesignSystem.primaryColor : AppDesignSystem.borderColor,
                          width: 2,
                        ),
                        color: isSelected ? AppDesignSystem.primaryColor : Colors.transparent,
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service['name'] as String,
                            style: AppDesignSystem.bodyStyle.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '+R\$ ${(service['price'] as double).toStringAsFixed(0)}',
                            style: AppDesignSystem.captionStyle.copyWith(
                              color: AppDesignSystem.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPricePreview() {
    if (_priceCalculation == null) return const SizedBox();

    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo do Valor',
            style: AppDesignSystem.h3Style,
          ),
          const SizedBox(height: 16),
          ..._priceCalculation!.breakdown.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.description,
                    style: AppDesignSystem.bodyStyle,
                  ),
                  Text(
                    'R\$ ${item.amount.toStringAsFixed(2)}',
                    style: AppDesignSystem.bodyStyle.copyWith(
                      color: item.amount < 0 
                          ? AppDesignSystem.successColor 
                          : AppDesignSystem.textPrimaryColor,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppDesignSystem.h3Style,
              ),
              Text(
                'R\$ ${_priceCalculation!.totalAmount.toStringAsFixed(2)}',
                style: AppDesignSystem.h3Style.copyWith(
                  color: AppDesignSystem.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceReviewPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Summary
          _buildServiceSummary(),
          
          const SizedBox(height: 24),
          
          // Coupon Section
          _buildCouponSection(),
          
          const SizedBox(height: 24),
          
          // Insurance Option
          _buildInsuranceOption(),
          
          const SizedBox(height: 24),
          
          // Final Price
          _buildFinalPrice(),
        ],
      ),
    );
  }

  Widget _buildServiceSummary() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo do Serviço',
            style: AppDesignSystem.h3Style,
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Cuidador', widget.caregiverData?['name'] ?? 'Maria Silva'),
          _buildSummaryRow('Data', '${_startDate.day}/${_startDate.month}/${_startDate.year}'),
          _buildSummaryRow('Horário', '${_startTime.format(context)} - ${_endTime.format(context)}'),
          _buildSummaryRow('Duração', '$_totalHours horas'),
          if (_selectedServices.isNotEmpty)
            _buildSummaryRow('Serviços Extras', '${_selectedServices.length} selecionados'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppDesignSystem.bodyStyle.copyWith(
              color: AppDesignSystem.textSecondaryColor,
            ),
          ),
          Text(
            value,
            style: AppDesignSystem.bodyStyle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponSection() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cupom de Desconto',
            style: AppDesignSystem.h3Style,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _couponController,
                  decoration: InputDecoration(
                    hintText: 'Digite o código do cupom',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      onPressed: _validateCoupon,
                      icon: const Icon(Icons.check),
                    ),
                  ),
                  textCapitalization: TextCapitalization.characters,
                ),
              ),
            ],
          ),
          if (_couponValidation != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  _couponValidation!.isValid ? Icons.check_circle : Icons.error,
                  color: _couponValidation!.isValid 
                      ? AppDesignSystem.successColor 
                      : AppDesignSystem.errorColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _couponValidation!.message,
                    style: AppDesignSystem.captionStyle.copyWith(
                      color: _couponValidation!.isValid 
                          ? AppDesignSystem.successColor 
                          : AppDesignSystem.errorColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInsuranceOption() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Proteção Adicional',
            style: AppDesignSystem.h3Style,
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            value: _includeInsurance,
            onChanged: (value) {
              setState(() {
                _includeInsurance = value ?? false;
              });
              _calculatePrice();
              _loadInstallmentOptions();
            },
            title: Text(
              'Seguro de Proteção',
              style: AppDesignSystem.bodyStyle,
            ),
            subtitle: Text(
              'Cobertura contra danos e garantia de reembolso (5% do valor)',
              style: AppDesignSystem.captionStyle,
            ),
            activeColor: AppDesignSystem.primaryColor,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildFinalPrice() {
    if (_priceCalculation == null) return const SizedBox();

    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Valor Final',
            style: AppDesignSystem.h3Style,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppDesignSystem.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total a Pagar',
                  style: AppDesignSystem.h2Style,
                ),
                Text(
                  'R\$ ${_priceCalculation!.totalAmount.toStringAsFixed(2)}',
                  style: AppDesignSystem.h2Style.copyWith(
                    color: AppDesignSystem.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Payment Methods
          _buildPaymentMethods(),
          
          const SizedBox(height: 24),
          
          // Payment Form
          if (_selectedPaymentMethod == 'card') _buildCardForm(),
          if (_selectedPaymentMethod == 'pix') _buildPixForm(),
          
          const SizedBox(height: 24),
          
          // Installment Options (for card)
          if (_selectedPaymentMethod == 'card') _buildInstallmentOptions(),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Forma de Pagamento',
            style: AppDesignSystem.h3Style,
          ),
          const SizedBox(height: 16),
          _buildPaymentOption(
            'pix',
            'PIX',
            'Pagamento instantâneo',
            Icons.pix,
            AppDesignSystem.successColor,
          ),
          const SizedBox(height: 12),
          _buildPaymentOption(
            'card',
            'Cartão de Crédito',
            'Parcelamento disponível',
            Icons.credit_card,
            AppDesignSystem.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String value, String title, String subtitle, IconData icon, Color color) {
    final isSelected = _selectedPaymentMethod == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? color : AppDesignSystem.borderColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? color.withOpacity(0.05) : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppDesignSystem.bodyStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppDesignSystem.captionStyle,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dados do Cartão',
            style: AppDesignSystem.h3Style,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _cardNumberController,
            decoration: const InputDecoration(
              labelText: 'Número do Cartão',
              hintText: '1234 5678 9012 3456',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _cardHolderController,
            decoration: const InputDecoration(
              labelText: 'Nome no Cartão',
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _expiryController,
                  decoration: const InputDecoration(
                    labelText: 'Validade',
                    hintText: 'MM/AA',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _cvvController,
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    hintText: '123',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPixForm() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PIX',
            style: AppDesignSystem.h3Style,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppDesignSystem.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.qr_code,
                  size: 64,
                  color: AppDesignSystem.successColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'Após confirmar, você receberá o código PIX para pagamento',
                  style: AppDesignSystem.bodyStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstallmentOptions() {
    if (_installmentOptions.isEmpty) return const SizedBox();

    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Parcelamento',
            style: AppDesignSystem.h3Style,
          ),
          const SizedBox(height: 16),
          ...List.generate(_installmentOptions.length.clamp(0, 6), (index) {
            final option = _installmentOptions[index];
            final isSelected = _selectedInstallments == option.installments;
            
            return RadioListTile<int>(
              value: option.installments,
              groupValue: _selectedInstallments,
              onChanged: (value) {
                setState(() {
                  _selectedInstallments = value ?? 1;
                });
              },
              title: Text(
                option.description,
                style: AppDesignSystem.bodyStyle,
              ),
              subtitle: option.installments > 1 
                  ? Text(
                      'Total: R\$ ${option.totalAmount.toStringAsFixed(2)}',
                      style: AppDesignSystem.captionStyle,
                    )
                  : null,
              activeColor: AppDesignSystem.primaryColor,
              contentPadding: EdgeInsets.zero,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: AppDesignSystem.secondaryButton(
                text: 'Voltar',
                onPressed: () {
                  setState(() {
                    _currentStep--;
                  });
                  _tabController.animateTo(_currentStep);
                },
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: _currentStep < 2
                ? AppDesignSystem.primaryButton(
                    text: _currentStep == 0 ? 'Revisar' : 'Pagar',
                    onPressed: () {
                      if (_currentStep == 0) {
                        setState(() {
                          _currentStep++;
                        });
                        _tabController.animateTo(_currentStep);
                      } else {
                        setState(() {
                          _currentStep++;
                        });
                        _tabController.animateTo(_currentStep);
                      }
                    },
                  )
                : Row(
                    children: [
                      Expanded(
                        child: AppDesignSystem.secondaryButton(
                          text: 'Pagamento Simulado',
                          onPressed: _isProcessingPayment ? null : _handlePayment,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: AppDesignSystem.primaryButton(
                          text: 'Pagamento Real',
                          onPressed: () => _navigateToRealPayment(),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // Funcionalidades avançadas de agendamento
  int _calculateTotalHoursFromDates() {
    if (_selectedDates.isEmpty) return 0;

    int startMinutes = _startTime.hour * 60 + _startTime.minute;
    int endMinutes = _endTime.hour * 60 + _endTime.minute;
    double hoursPerDay = (endMinutes - startMinutes) / 60.0;

    return (_selectedDates.length * hoursPerDay).round();
  }

  void _toggleMultipleDatesMode() {
    if (_useMultipleDates && _selectedDates.isEmpty) {
      _showError('Selecione pelo menos uma data antes de ativar o modo múltiplo');
      return;
    }

    setState(() {
      _useMultipleDates = !_useMultipleDates;
      if (!_useMultipleDates) {
        _selectedDates.clear();
      }
      _calculatePrice();
    });
  }

  void _selectDate(DateTime date) {
    if (date.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      _showError('Não é possível selecionar datas passadas');
      return;
    }

    setState(() {
      if (_selectedDates.contains(date)) {
        _selectedDates.remove(date);
      } else {
        _selectedDates.add(date);
      }
      _calculatePrice();
    });
  }

  Widget _buildSchedulingModeToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppDesignSystem.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppDesignSystem.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Modo de Agendamento',
            style: AppDesignSystem.bodyStyle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildModeOption(
                  title: 'Data Única',
                  subtitle: 'Agendar para um dia específico',
                  isSelected: !_useMultipleDates,
                  onTap: () => _toggleMultipleDatesMode(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildModeOption(
                  title: 'Múltiplas Datas',
                  subtitle: 'Selecionar vários dias',
                  isSelected: _useMultipleDates,
                  onTap: () => _toggleMultipleDatesMode(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeOption({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppDesignSystem.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppDesignSystem.primaryColor : AppDesignSystem.borderColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppDesignSystem.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? Colors.white.withOpacity(0.8)
                    : AppDesignSystem.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultipleDatesCalendar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Datas Selecionadas',
          style: AppDesignSystem.bodyStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${_selectedDates.length} dia(s) selecionado(s)',
          style: AppDesignSystem.bodySmallStyle.copyWith(
            color: AppDesignSystem.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 12),
        _buildSimpleCalendar(),
        const SizedBox(height: 16),
        _buildTimeFields(),
      ],
    );
  }

  Widget _buildSimpleCalendar() {
    final firstDayOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final lastDayOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppDesignSystem.borderColor),
      ),
      child: Column(
        children: [
          // Header with month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
                  });
                },
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                '${_getMonthName(_selectedMonth.month)} ${_selectedMonth.year}',
                style: AppDesignSystem.bodyStyle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
                  });
                },
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Days of week header
          Row(
            children: ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: AppDesignSystem.bodySmallStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppDesignSystem.textSecondaryColor,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // Calendar grid
          ...List.generate((daysInMonth + firstWeekday - 1) ~/ 7 + 1, (week) {
            return Row(
              children: List.generate(7, (day) {
                final dayIndex = week * 7 + day - firstWeekday + 1;
                if (dayIndex < 1 || dayIndex > daysInMonth) {
                  return const Expanded(child: SizedBox());
                }

                final date = DateTime(_selectedMonth.year, _selectedMonth.month, dayIndex);
                final isSelected = _selectedDates.contains(date);
                final isPast = date.isBefore(DateTime.now().subtract(const Duration(days: 1)));
                final isToday = date.day == DateTime.now().day &&
                               date.month == DateTime.now().month &&
                               date.year == DateTime.now().year;

                return Expanded(
                  child: GestureDetector(
                    onTap: isPast ? null : () => _selectDate(date),
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppDesignSystem.primaryColor
                            : isToday
                                ? AppDesignSystem.primaryColor.withOpacity(0.1)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isSelected
                              ? AppDesignSystem.primaryColor
                              : isToday
                                  ? AppDesignSystem.primaryColor
                                  : isPast
                                      ? Colors.grey[300]!
                                      : AppDesignSystem.borderColor,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          dayIndex.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : isPast
                                    ? Colors.grey[400]
                                    : isToday
                                        ? AppDesignSystem.primaryColor
                                        : AppDesignSystem.textPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return months[month - 1];
  }

}
