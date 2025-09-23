import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_design_system.dart';

class CaregiverPaymentScreen extends StatefulWidget {
  final String? selectedPlanId;
  
  const CaregiverPaymentScreen({
    super.key,
    this.selectedPlanId,
  });

  @override
  State<CaregiverPaymentScreen> createState() => _CaregiverPaymentScreenState();
}

class _CaregiverPaymentScreenState extends State<CaregiverPaymentScreen>
    with TickerProviderStateMixin {
  
  // Estado da tela
  int _currentStep = 0;
  String _selectedPlanId = '';
  String _selectedPaymentMethod = '';
  bool _isProcessing = false;
  bool _acceptTerms = false;
  
  // Controllers dos formulários
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  
  // Planos disponíveis
  final List<PaymentPlan> _plans = [
    PaymentPlan(
      id: 'basic',
      name: 'Plano Básico',
      price: 29.90,
      period: 'mensal',
      features: [
        'Perfil verificado',
        'Até 5 agendamentos por mês',
        'Chat com pacientes',
        'Suporte básico',
      ],
      color: AppDesignSystem.infoColor,
      isPopular: false,
    ),
    PaymentPlan(
      id: 'plus',
      name: 'Plano Plus',
      price: 49.90,
      period: 'mensal',
      features: [
        'Tudo do Plano Básico',
        'Agendamentos ilimitados',
        'Destaque na busca',
        'Suporte prioritário',
        'Relatórios mensais',
      ],
      color: AppDesignSystem.warningColor,
      isPopular: true,
    ),
    PaymentPlan(
      id: 'premium',
      name: 'Plano Premium',
      price: 79.90,
      period: 'mensal',
      features: [
        'Tudo do Plano Plus',
        'Posição top na busca',
        'Badge "Premium"',
        'Suporte 24/7',
        'Marketing dedicado',
        'Análises avançadas',
      ],
      color: AppDesignSystem.primaryColor,
      isPopular: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedPlanId = widget.selectedPlanId ?? '';
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      appBar: AppDesignSystem.styledAppBar(
        title: 'Assinatura Premium',
        context: context,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Progress indicator
          _buildProgressIndicator(),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDesignSystem.spacing4),
              child: _buildCurrentStep(),
            ),
          ),
          
          // Bottom actions
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(AppDesignSystem.spacing4),
      color: Colors.white,
      child: Row(
        children: [
          _buildStepIndicator(0, 'Plano', _currentStep >= 0),
          Expanded(child: _buildStepConnector(_currentStep >= 1)),
          _buildStepIndicator(1, 'Pagamento', _currentStep >= 1),
          Expanded(child: _buildStepConnector(_currentStep >= 2)),
          _buildStepIndicator(2, 'Confirmação', _currentStep >= 2),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? AppDesignSystem.primaryColor : AppDesignSystem.lightGrayColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isActive
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      color: isActive ? Colors.white : AppDesignSystem.grayColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        AppDesignSystem.verticalSpace(0.5),
        Text(
          label,
          style: AppDesignSystem.captionStyle.copyWith(
            color: isActive ? AppDesignSystem.primaryColor : AppDesignSystem.grayColor,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector(bool isActive) {
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: isActive ? AppDesignSystem.primaryColor : AppDesignSystem.lightGrayColor,
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildPlanSelectionStep();
      case 1:
        return _buildPaymentMethodStep();
      case 2:
        return _buildConfirmationStep();
      default:
        return Container();
    }
  }

  Widget _buildPlanSelectionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Escolha seu Plano',
          style: AppDesignSystem.h2Style.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        AppDesignSystem.verticalSpace(0.5),
        Text(
          'Selecione o plano ideal para impulsionar sua carreira',
          style: AppDesignSystem.bodyStyle.copyWith(
            color: AppDesignSystem.grayColor,
          ),
        ),
        AppDesignSystem.verticalSpace(2),
        
        // Plans
        ...(_plans.map((plan) => Padding(
          padding: const EdgeInsets.only(bottom: AppDesignSystem.spacing3),
          child: _buildPlanCard(plan),
        ))),
        
        AppDesignSystem.verticalSpace(1),
        _buildBenefitsSection(),
      ],
    );
  }

  Widget _buildPlanCard(PaymentPlan plan) {
    final isSelected = _selectedPlanId == plan.id;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlanId = plan.id;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(AppDesignSystem.spacing4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
          border: Border.all(
            color: isSelected ? plan.color : AppDesignSystem.lightGrayColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected) BoxShadow(
              color: plan.color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.name,
                          style: AppDesignSystem.h3Style.copyWith(
                            fontWeight: FontWeight.w700,
                            color: plan.color,
                          ),
                        ),
                        AppDesignSystem.verticalSpace(0.5),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'R\$ ',
                                style: AppDesignSystem.bodyStyle.copyWith(
                                  color: AppDesignSystem.grayColor,
                                ),
                              ),
                              TextSpan(
                                text: plan.price.toStringAsFixed(2).replaceAll('.', ','),
                                style: AppDesignSystem.h2Style.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppDesignSystem.darkColor,
                                ),
                              ),
                              TextSpan(
                                text: '/${plan.period}',
                                style: AppDesignSystem.bodyStyle.copyWith(
                                  color: AppDesignSystem.grayColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: plan.color,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                  ],
                ),
                
                AppDesignSystem.verticalSpace(1.5),
                
                // Features
                ...plan.features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: plan.color,
                        size: 16,
                      ),
                      AppDesignSystem.horizontalSpace(0.75),
                      Expanded(
                        child: Text(
                          feature,
                          style: AppDesignSystem.bodyStyle.copyWith(
                            color: AppDesignSystem.darkColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
            
            // Popular badge
            if (plan.isPopular)
              Positioned(
                top: -8,
                right: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppDesignSystem.warningColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(AppDesignSystem.borderRadiusLarge),
                      bottomLeft: Radius.circular(AppDesignSystem.borderRadiusLarge),
                    ),
                  ),
                  child: Text(
                    'MAIS POPULAR',
                    style: AppDesignSystem.captionStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitsSection() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.workspace_premium,
                color: AppDesignSystem.warningColor,
                size: 24,
              ),
              AppDesignSystem.horizontalSpace(0.5),
              Text(
                'Benefícios da Assinatura',
                style: AppDesignSystem.h3Style.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          AppDesignSystem.verticalSpace(1),
          
          _buildBenefitItem(
            Icons.trending_up,
            'Aumento de Visibilidade',
            'Seu perfil aparece primeiro nas buscas',
          ),
          _buildBenefitItem(
            Icons.verified,
            'Credibilidade Profissional',
            'Badge verificado e selo premium',
          ),
          _buildBenefitItem(
            Icons.support_agent,
            'Suporte Especializado',
            'Atendimento prioritário quando precisar',
          ),
          _buildBenefitItem(
            Icons.analytics,
            'Relatórios Detalhados',
            'Acompanhe seu desempenho e crescimento',
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesignSystem.spacing3),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppDesignSystem.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppDesignSystem.primaryColor,
              size: 20,
            ),
          ),
          AppDesignSystem.horizontalSpace(1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppDesignSystem.bodyStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppDesignSystem.darkColor,
                  ),
                ),
                Text(
                  description,
                  style: AppDesignSystem.captionStyle.copyWith(
                    color: AppDesignSystem.grayColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Método de Pagamento',
          style: AppDesignSystem.h2Style.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        AppDesignSystem.verticalSpace(0.5),
        Text(
          'Escolha como prefere realizar o pagamento',
          style: AppDesignSystem.bodyStyle.copyWith(
            color: AppDesignSystem.grayColor,
          ),
        ),
        AppDesignSystem.verticalSpace(2),
        
        // Payment method selection
        _buildPaymentMethodSelector(),
        
        AppDesignSystem.verticalSpace(2),
        
        // Payment form
        if (_selectedPaymentMethod == 'credit_card')
          _buildCreditCardForm()
        else if (_selectedPaymentMethod == 'pix')
          _buildPixForm(),
        
        AppDesignSystem.verticalSpace(2),
        
        // Plan summary
        _buildPlanSummary(),
      ],
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      children: [
        _buildPaymentOption(
          'credit_card',
          'Cartão de Crédito',
          Icons.credit_card,
          'Aprovação instantânea',
        ),
        AppDesignSystem.verticalSpace(1),
        _buildPaymentOption(
          'pix',
          'PIX',
          Icons.qr_code,
          'Pagamento rápido e seguro',
        ),
      ],
    );
  }

  Widget _buildPaymentOption(String method, String title, IconData icon, String subtitle) {
    final isSelected = _selectedPaymentMethod == method;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(AppDesignSystem.spacing4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
          border: Border.all(
            color: isSelected ? AppDesignSystem.primaryColor : AppDesignSystem.lightGrayColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppDesignSystem.primaryColor.withOpacity(0.1)
                    : AppDesignSystem.lightGrayColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppDesignSystem.primaryColor : AppDesignSystem.grayColor,
                size: 24,
              ),
            ),
            AppDesignSystem.horizontalSpace(1),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppDesignSystem.bodyStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppDesignSystem.primaryColor : AppDesignSystem.darkColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppDesignSystem.captionStyle.copyWith(
                      color: AppDesignSystem.grayColor,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppDesignSystem.primaryColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCardForm() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dados do Cartão',
            style: AppDesignSystem.h3Style.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppDesignSystem.verticalSpace(1.5),
          
          // Card number
          AppDesignSystem.styledTextField(
            controller: _cardNumberController,
            label: 'Número do Cartão',
            hint: '1234 5678 9012 3456',
            keyboardType: TextInputType.number,
            prefixIcon: Icons.credit_card,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _CardNumberInputFormatter(),
            ],
          ),
          
          AppDesignSystem.verticalSpace(1),
          
          // Cardholder name
          AppDesignSystem.styledTextField(
            controller: _cardHolderController,
            label: 'Nome no Cartão',
            hint: 'João Silva',
            keyboardType: TextInputType.text,
            prefixIcon: Icons.person,
            textCapitalization: TextCapitalization.words,
          ),
          
          AppDesignSystem.verticalSpace(1),
          
          // Expiry and CVV
          Row(
            children: [
              Expanded(
                child: AppDesignSystem.styledTextField(
                  controller: _expiryController,
                  label: 'Validade',
                  hint: 'MM/AA',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.calendar_today,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _ExpiryDateInputFormatter(),
                  ],
                ),
              ),
              AppDesignSystem.horizontalSpace(1),
              Expanded(
                child: AppDesignSystem.styledTextField(
                  controller: _cvvController,
                  label: 'CVV',
                  hint: '123',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.lock,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                ),
              ),
            ],
          ),
          
          AppDesignSystem.verticalSpace(1),
          
          // CPF
          AppDesignSystem.styledTextField(
            controller: _cpfController,
            label: 'CPF',
            hint: '123.456.789-00',
            keyboardType: TextInputType.number,
            prefixIcon: Icons.person_outline,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _CPFInputFormatter(),
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
            'Pagamento via PIX',
            style: AppDesignSystem.h3Style.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppDesignSystem.verticalSpace(1.5),
          
          // CPF for PIX
          AppDesignSystem.styledTextField(
            controller: _cpfController,
            label: 'CPF',
            hint: '123.456.789-00',
            keyboardType: TextInputType.number,
            prefixIcon: Icons.person_outline,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _CPFInputFormatter(),
            ],
          ),
          
          AppDesignSystem.verticalSpace(2),
          
          // PIX instructions
          Container(
            padding: const EdgeInsets.all(AppDesignSystem.spacing4),
            decoration: BoxDecoration(
              color: AppDesignSystem.infoColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
              border: Border.all(
                color: AppDesignSystem.infoColor.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.qr_code_2,
                  size: 80,
                  color: AppDesignSystem.infoColor,
                ),
                AppDesignSystem.verticalSpace(1),
                Text(
                  'QR Code será gerado na próxima etapa',
                  style: AppDesignSystem.bodyStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppDesignSystem.darkColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppDesignSystem.verticalSpace(0.5),
                Text(
                  'Após confirmar, você receberá o código PIX para realizar o pagamento',
                  style: AppDesignSystem.captionStyle.copyWith(
                    color: AppDesignSystem.grayColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanSummary() {
    final selectedPlan = _plans.firstWhere((plan) => plan.id == _selectedPlanId);
    
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo do Pedido',
            style: AppDesignSystem.h3Style.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppDesignSystem.verticalSpace(1),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedPlan.name,
                style: AppDesignSystem.bodyStyle.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'R\$ ${selectedPlan.price.toStringAsFixed(2).replaceAll('.', ',')}',
                style: AppDesignSystem.bodyStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppDesignSystem.primaryColor,
                ),
              ),
            ],
          ),
          
          AppDesignSystem.verticalSpace(0.5),
          Divider(color: AppDesignSystem.lightGrayColor),
          AppDesignSystem.verticalSpace(0.5),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppDesignSystem.h3Style.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'R\$ ${selectedPlan.price.toStringAsFixed(2).replaceAll('.', ',')}/${selectedPlan.period}',
                style: AppDesignSystem.h3Style.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppDesignSystem.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationStep() {
    final selectedPlan = _plans.firstWhere((plan) => plan.id == _selectedPlanId);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirmação',
          style: AppDesignSystem.h2Style.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        AppDesignSystem.verticalSpace(0.5),
        Text(
          'Revise os dados antes de finalizar sua assinatura',
          style: AppDesignSystem.bodyStyle.copyWith(
            color: AppDesignSystem.grayColor,
          ),
        ),
        AppDesignSystem.verticalSpace(2),
        
        // Plan details
        AppDesignSystem.styledCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selectedPlan.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.workspace_premium,
                      color: selectedPlan.color,
                      size: 24,
                    ),
                  ),
                  AppDesignSystem.horizontalSpace(1),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedPlan.name,
                          style: AppDesignSystem.h3Style.copyWith(
                            fontWeight: FontWeight.w700,
                            color: selectedPlan.color,
                          ),
                        ),
                        Text(
                          'R\$ ${selectedPlan.price.toStringAsFixed(2).replaceAll('.', ',')}/${selectedPlan.period}',
                          style: AppDesignSystem.bodyStyle.copyWith(
                            color: AppDesignSystem.grayColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              AppDesignSystem.verticalSpace(1),
              Divider(color: AppDesignSystem.lightGrayColor),
              AppDesignSystem.verticalSpace(1),
              
              Text(
                'Recursos inclusos:',
                style: AppDesignSystem.bodyStyle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppDesignSystem.verticalSpace(0.5),
              
              ...selectedPlan.features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: selectedPlan.color,
                      size: 16,
                    ),
                    AppDesignSystem.horizontalSpace(0.5),
                    Expanded(
                      child: Text(
                        feature,
                        style: AppDesignSystem.captionStyle.copyWith(
                          color: AppDesignSystem.darkColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
        
        AppDesignSystem.verticalSpace(1.5),
        
        // Payment method details
        AppDesignSystem.styledCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Método de Pagamento',
                style: AppDesignSystem.bodyStyle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppDesignSystem.verticalSpace(0.5),
              
              Row(
                children: [
                  Icon(
                    _selectedPaymentMethod == 'credit_card' ? Icons.credit_card : Icons.qr_code,
                    color: AppDesignSystem.primaryColor,
                    size: 20,
                  ),
                  AppDesignSystem.horizontalSpace(0.5),
                  Text(
                    _selectedPaymentMethod == 'credit_card' ? 'Cartão de Crédito' : 'PIX',
                    style: AppDesignSystem.bodyStyle.copyWith(
                      color: AppDesignSystem.darkColor,
                    ),
                  ),
                ],
              ),
              
              if (_selectedPaymentMethod == 'credit_card' && _cardNumberController.text.isNotEmpty) ...[
                AppDesignSystem.verticalSpace(0.5),
                Text(
                  '**** **** **** ${_cardNumberController.text.replaceAll(' ', '').substring(_cardNumberController.text.replaceAll(' ', '').length - 4)}',
                  style: AppDesignSystem.captionStyle.copyWith(
                    color: AppDesignSystem.grayColor,
                  ),
                ),
              ],
            ],
          ),
        ),
        
        AppDesignSystem.verticalSpace(1.5),
        
        // Terms and conditions
        AppDesignSystem.styledCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _acceptTerms,
                onChanged: (value) {
                  setState(() {
                    _acceptTerms = value ?? false;
                  });
                },
                activeColor: AppDesignSystem.primaryColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: RichText(
                    text: TextSpan(
                      style: AppDesignSystem.captionStyle.copyWith(
                        color: AppDesignSystem.darkColor,
                      ),
                      children: [
                        const TextSpan(text: 'Aceito os '),
                        TextSpan(
                          text: 'Termos de Uso',
                          style: AppDesignSystem.captionStyle.copyWith(
                            color: AppDesignSystem.primaryColor,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const TextSpan(text: ' e '),
                        TextSpan(
                          text: 'Política de Privacidade',
                          style: AppDesignSystem.captionStyle.copyWith(
                            color: AppDesignSystem.primaryColor,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const TextSpan(text: ' do Kareu. A assinatura será renovada automaticamente.'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(AppDesignSystem.spacing4),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppDesignSystem.lightGrayColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_currentStep < 2)
            Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: AppDesignSystem.secondaryButton(
                      text: 'Voltar',
                      onPressed: () => _previousStep(),
                    ),
                  ),
                if (_currentStep > 0) AppDesignSystem.horizontalSpace(1),
                Expanded(
                  flex: _currentStep == 0 ? 1 : 1,
                  child: AppDesignSystem.primaryButton(
                    text: _getNextButtonText(),
                    onPressed: _canProceed() ? () => _nextStep() : () {},
                  ),
                ),
              ],
            )
          else
            AppDesignSystem.primaryButton(
              text: _isProcessing ? 'Processando...' : 'Confirmar Assinatura',
              onPressed: _isProcessing ? () {} : () => _processPayment(),
              width: double.infinity,
            ),
        ],
      ),
    );
  }

  String _getNextButtonText() {
    switch (_currentStep) {
      case 0:
        return 'Continuar';
      case 1:
        return 'Revisar Pedido';
      default:
        return 'Finalizar';
    }
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _selectedPlanId.isNotEmpty;
      case 1:
        if (_selectedPaymentMethod == 'credit_card') {
          return _isValidCardNumber(_cardNumberController.text) &&
                 _cardHolderController.text.trim().length >= 3 &&
                 _isValidExpiry(_expiryController.text) &&
                 _isValidCVV(_cvvController.text) &&
                 _isValidCPF(_cpfController.text);
        } else if (_selectedPaymentMethod == 'pix') {
          return _isValidCPF(_cpfController.text);
        }
        return false;
      case 2:
        return _acceptTerms;
      default:
        return false;
    }
  }

  bool _isValidCardNumber(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(' ', '');
    return cleanNumber.length == 16 && RegExp(r'^[0-9]+$').hasMatch(cleanNumber);
  }

  bool _isValidExpiry(String expiry) {
    if (expiry.length != 5) return false;
    final parts = expiry.split('/');
    if (parts.length != 2) return false;
    
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);
    
    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;
    
    final currentYear = DateTime.now().year % 100;
    final currentMonth = DateTime.now().month;
    
    if (year < currentYear) return false;
    if (year == currentYear && month < currentMonth) return false;
    
    return true;
  }

  bool _isValidCVV(String cvv) {
    return cvv.length >= 3 && cvv.length <= 4 && RegExp(r'^[0-9]+$').hasMatch(cvv);
  }

  bool _isValidCPF(String cpf) {
    final cleanCPF = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    return cleanCPF.length == 11;
  }

  void _nextStep() {
    if (_canProceed()) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _processPayment() async {
    if (!_acceptTerms) return;
    
    setState(() {
      _isProcessing = true;
    });

    try {
      // Simular processamento de pagamento
      await Future.delayed(const Duration(seconds: 3));
      
      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppDesignSystem.successColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: AppDesignSystem.successColor,
                size: 48,
              ),
            ),
            AppDesignSystem.verticalSpace(1.5),
            Text(
              'Pagamento Confirmado!',
              style: AppDesignSystem.h3Style.copyWith(
                fontWeight: FontWeight.w700,
                color: AppDesignSystem.successColor,
              ),
              textAlign: TextAlign.center,
            ),
            AppDesignSystem.verticalSpace(1),
            Text(
              'Sua assinatura foi ativada com sucesso. Aproveite todos os benefícios premium!',
              style: AppDesignSystem.bodyStyle.copyWith(
                color: AppDesignSystem.grayColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          AppDesignSystem.primaryButton(
            text: 'Voltar ao Início',
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacementNamed(context, '/home-professional');
            },
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppDesignSystem.errorColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error,
                color: AppDesignSystem.errorColor,
                size: 48,
              ),
            ),
            AppDesignSystem.verticalSpace(1.5),
            Text(
              'Erro no Pagamento',
              style: AppDesignSystem.h3Style.copyWith(
                fontWeight: FontWeight.w700,
                color: AppDesignSystem.errorColor,
              ),
              textAlign: TextAlign.center,
            ),
            AppDesignSystem.verticalSpace(1),
            Text(
              'Ocorreu um erro ao processar seu pagamento. Tente novamente.',
              style: AppDesignSystem.bodyStyle.copyWith(
                color: AppDesignSystem.grayColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          AppDesignSystem.primaryButton(
            text: 'Tentar Novamente',
            onPressed: () => Navigator.of(context).pop(),
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

// Data classes and formatters
class PaymentPlan {
  final String id;
  final String name;
  final double price;
  final String period;
  final List<String> features;
  final Color color;
  final bool isPopular;

  PaymentPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.period,
    required this.features,
    required this.color,
    required this.isPopular,
  });
}

class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    
    if (text.length > 16) {
      return oldValue;
    }
    
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i != text.length - 1) {
        buffer.write(' ');
      }
    }
    
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    if (text.length > 5) {
      return oldValue;
    }
    
    if (text.length >= 2 && !text.contains('/')) {
      final month = text.substring(0, 2);
      final year = text.substring(2);
      return TextEditingValue(
        text: '$month/$year',
        selection: TextSelection.collapsed(offset: '$month/$year'.length),
      );
    }
    
    return newValue;
  }
}

class _CPFInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (text.length > 11) {
      return oldValue;
    }
    
    String formatted = text;
    if (text.length >= 4) {
      formatted = '${text.substring(0, 3)}.${text.substring(3)}';
    }
    if (text.length >= 7) {
      formatted = '${text.substring(0, 3)}.${text.substring(3, 6)}.${text.substring(6)}';
    }
    if (text.length >= 10) {
      formatted = '${text.substring(0, 3)}.${text.substring(3, 6)}.${text.substring(6, 9)}-${text.substring(9)}';
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}