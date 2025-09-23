import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';

class EngagementPlansScreen extends StatefulWidget {
  const EngagementPlansScreen({super.key});

  @override
  State<EngagementPlansScreen> createState() => _EngagementPlansScreenState();
}

class _EngagementPlansScreenState extends State<EngagementPlansScreen> {
  int _selectedTabIndex = 0;
  String? _selectedPlan;

  final List<Map<String, dynamic>> _plans = [
    {
      'title': 'Plano Básico',
      'price': 'R\$ 29',
      'period': '/semana',
      'description': 'Destaque regional por 7 dias',
      'features': ['Destaque na busca regional', 'Prioridade em resultados', 'Badge de profissional destacado'],
      'id': 'basic',
      'color': const Color(0xFF10B981),
      'recommended': false
    },
    {
      'title': 'Plano Plus',
      'price': 'R\$ 79',
      'period': '/mês',
      'description': 'Destaque premium + recomendações',
      'features': ['Tudo do Básico', 'Aparece em "Recomendados"', 'Notificações prioritárias', 'Suporte especializado'],
      'id': 'plus',
      'color': AppDesignSystem.primaryColor,
      'recommended': true
    },
    {
      'title': 'Plano Pro',
      'price': 'R\$ 149',
      'period': '/mês',
      'description': 'Máxima visibilidade e recursos',
      'features': ['Tudo do Plus', 'Destaque em toda região', 'Análises detalhadas', 'Marketing personalizado'],
      'id': 'pro',
      'color': const Color(0xFF8B5CF6),
      'recommended': false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      appBar: AppDesignSystem.styledAppBar(
        title: 'Destaque seu Perfil',
        context: context,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDesignSystem.space2XL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            _buildHeroSection(),
            
            AppDesignSystem.verticalSpace(2),
            
            // Performance Section
            _buildPerformanceSection(),
            
            AppDesignSystem.verticalSpace(2),
                    
                    // Plans Section
                    _buildPlansSection(),
                    
            AppDesignSystem.verticalSpace(2),
            
            // Benefits Section
            _buildBenefitsSection(),
            
            AppDesignSystem.verticalSpace(2),
            
            // Action Button
            _buildActionButton(),
            
            AppDesignSystem.verticalSpace(4),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeroSection() {
    return AppDesignSystem.styledCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDesignSystem.spaceMD),
                decoration: BoxDecoration(
                  color: AppDesignSystem.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: AppDesignSystem.primaryColor,
                  size: 32,
                ),
              ),
              AppDesignSystem.horizontalSpace(1),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seja visto por mais famílias',
                      style: AppDesignSystem.h2Style.copyWith(
                        color: AppDesignSystem.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AppDesignSystem.verticalSpace(0.5),
                    Text(
                      'Destaque seu perfil e aumente suas oportunidades de trabalho',
                      style: AppDesignSystem.bodySmallStyle.copyWith(
                        color: AppDesignSystem.textSecondaryColor,
                      ),
                    ),
          ],
        ),
      ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSection() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seu desempenho atual',
            style: AppDesignSystem.h3Style.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppDesignSystem.verticalSpace(1),
          Text(
            'Veja como seu perfil está performando nesta semana',
            style: AppDesignSystem.bodySmallStyle.copyWith(
              color: AppDesignSystem.textSecondaryColor,
            ),
          ),
          AppDesignSystem.verticalSpace(1.5),
          Row(
            children: [
              Expanded(child: _buildStatItem('127', 'Visualizações', Icons.visibility, AppDesignSystem.infoColor)),
              Container(
                width: 1,
                height: 40,
                color: AppDesignSystem.borderColor,
              ),
              Expanded(child: _buildStatItem('+85%', 'Potencial de aumento', Icons.trending_up, AppDesignSystem.successColor)),
              Container(
                width: 1,
                height: 40,
                color: AppDesignSystem.borderColor,
              ),
              Expanded(child: _buildStatItem('3.2⭐', 'Avaliação média', Icons.star, AppDesignSystem.warningColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.spaceSM),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          AppDesignSystem.verticalSpace(0.5),
          Text(
            value,
            style: AppDesignSystem.h3Style.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          AppDesignSystem.verticalSpace(0.25),
          Text(
            label,
            style: AppDesignSystem.captionStyle.copyWith(
              color: AppDesignSystem.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPlansSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Escolha seu plano de destaque',
          style: AppDesignSystem.h3Style.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppDesignSystem.verticalSpace(0.5),
        Text(
          'Selecione o plano que melhor se adapta às suas necessidades',
          style: AppDesignSystem.bodySmallStyle.copyWith(
            color: AppDesignSystem.textSecondaryColor,
          ),
        ),
        AppDesignSystem.verticalSpace(1.5),
        ..._plans.map((plan) => _buildPlanCard(plan)).toList(),
      ],
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    final bool isSelected = _selectedPlan == plan['id'];
    final bool isRecommended = plan['recommended'] == true;
    final Color planColor = plan['color'];
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppDesignSystem.spaceLG),
      child: GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlan = plan['id'];
        });
      },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
            color: isSelected ? planColor.withValues(alpha: 0.05) : AppDesignSystem.cardColor,
            borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
            border: Border.all(
              color: isSelected ? planColor : AppDesignSystem.borderColor,
              width: isSelected ? 2 : 1,
            ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: isSelected ? 0.1 : 0.04),
              offset: const Offset(0, 4),
                blurRadius: isSelected ? 12 : 8,
            ),
          ],
        ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppDesignSystem.space2XL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                  plan['title'],
                                style: AppDesignSystem.h3Style.copyWith(
                                  color: planColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              AppDesignSystem.verticalSpace(0.25),
                              Text(
                                plan['description'],
                                style: AppDesignSystem.bodySmallStyle.copyWith(
                                  color: AppDesignSystem.textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppDesignSystem.horizontalSpace(1),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: plan['price'],
                                    style: AppDesignSystem.h2Style.copyWith(
                                      color: planColor,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  TextSpan(
                                    text: plan['period'],
                                    style: AppDesignSystem.captionStyle.copyWith(
                                      color: AppDesignSystem.textSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Container(
                                margin: const EdgeInsets.only(top: AppDesignSystem.spaceSM),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDesignSystem.spaceMD,
                                  vertical: AppDesignSystem.spaceXS,
                                ),
                                decoration: BoxDecoration(
                                  color: planColor,
                                  borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    AppDesignSystem.verticalSpace(1.5),
                    ...plan['features'].map<Widget>((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: AppDesignSystem.spaceSM),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: planColor.withValues(alpha: 0.8),
                            size: 16,
                          ),
                          AppDesignSystem.horizontalSpace(0.5),
                          Expanded(
                child: Text(
                              feature,
                              style: AppDesignSystem.bodySmallStyle,
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ],
                ),
              ),
              if (isRecommended)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDesignSystem.spaceLG,
                      vertical: AppDesignSystem.spaceSM,
                    ),
                    decoration: BoxDecoration(
                      color: AppDesignSystem.warningColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(AppDesignSystem.borderRadiusLarge),
                        bottomLeft: Radius.circular(AppDesignSystem.borderRadiusLarge),
                      ),
                    ),
                child: Text(
                      'RECOMENDADO',
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
      ),
    );
  }

  Widget _buildBenefitsSection() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Por que destacar seu perfil?',
            style: AppDesignSystem.h3Style.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppDesignSystem.verticalSpace(1.5),
          _buildBenefitItem(
            Icons.visibility,
            'Maior visibilidade',
            'Seu perfil aparece primeiro nos resultados de busca',
            AppDesignSystem.infoColor,
          ),
          _buildBenefitItem(
            Icons.trending_up,
            'Mais oportunidades',
            'Até 85% mais visualizações e contatos de famílias',
            AppDesignSystem.successColor,
          ),
          _buildBenefitItem(
            Icons.star,
            'Confiança dos clientes',
            'Badge de profissional destacado aumenta a credibilidade',
            AppDesignSystem.warningColor,
          ),
          _buildBenefitItem(
            Icons.schedule,
            'Resultados rápidos',
            'Ativação imediata após confirmação do pagamento',
            AppDesignSystem.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesignSystem.spaceLG),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDesignSystem.spaceSM),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
            ),
            child: Icon(
              icon,
              color: color,
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
                  ),
                ),
                AppDesignSystem.verticalSpace(0.25),
                Text(
                  description,
                  style: AppDesignSystem.bodySmallStyle.copyWith(
                    color: AppDesignSystem.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    if (_selectedPlan == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDesignSystem.space2XL),
        decoration: BoxDecoration(
          color: AppDesignSystem.surfaceColor,
          borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
          border: Border.all(color: AppDesignSystem.borderColor),
        ),
        child: Column(
          children: [
            Icon(
              Icons.touch_app,
              color: AppDesignSystem.textSecondaryColor,
              size: 32,
            ),
            AppDesignSystem.verticalSpace(1),
            Text(
              'Selecione um plano acima',
              style: AppDesignSystem.bodyStyle.copyWith(
                color: AppDesignSystem.textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            AppDesignSystem.verticalSpace(0.5),
            Text(
              'Escolha o plano que melhor se adapta às suas necessidades para continuar',
              style: AppDesignSystem.bodySmallStyle.copyWith(
                color: AppDesignSystem.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final selectedPlanData = _plans.firstWhere((plan) => plan['id'] == _selectedPlan);
    
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDesignSystem.space2XL),
          decoration: BoxDecoration(
            color: selectedPlanData['color'].withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
            border: Border.all(color: selectedPlanData['color'].withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: selectedPlanData['color'],
                    size: 24,
                  ),
                  AppDesignSystem.horizontalSpace(1),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Plano selecionado: ${selectedPlanData['title']}',
                          style: AppDesignSystem.bodyStyle.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${selectedPlanData['price']}${selectedPlanData['period']}',
                          style: AppDesignSystem.h3Style.copyWith(
                            color: selectedPlanData['color'],
            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        AppDesignSystem.verticalSpace(1.5),
        AppDesignSystem.primaryButton(
          text: 'Destacar meu perfil agora',
          onPressed: _onHighlightPressed,
          width: double.infinity,
          height: 56,
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 73,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Início', 0),
          _buildNavItem(Icons.chat_bubble_outline, 'Chat', 1),
          _buildNavItem(Icons.people_outline, 'Clientes', 2),
          _buildNavItem(Icons.calendar_today, 'Agenda', 3),
          _buildNavItem(Icons.account_circle_outlined, 'Perfil', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF4D64C8) : const Color(0xFF49454F),
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: isSelected ? const Color(0xFF4D64C8) : const Color(0xFF49454F),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
    
    String section = '';
    switch (index) {
      case 0:
        section = 'Início';
        Navigator.pushReplacementNamed(context, '/home-professional');
        break;
      case 1:
        section = 'Chat';
        Navigator.pushNamed(context, '/chat');
        break;
      case 2:
        section = 'Clientes';
        break;
      case 3:
        section = 'Agenda';
        Navigator.pushNamed(context, '/caregiver-schedule');
        break;
      case 4:
        section = 'Perfil';
        break;
    }
    
    if (section.isNotEmpty && index != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navegando para $section'),
          duration: const Duration(seconds: 1),
          backgroundColor: const Color(0xFF4D64C8),
        ),
      );
    }
  }

  void _onHighlightPressed() {
    if (_selectedPlan == null) return;
    
    final selectedPlanData = _plans.firstWhere((plan) => plan['id'] == _selectedPlan);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDesignSystem.space2XL),
            child: Column(
            mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppDesignSystem.spaceMD),
                      decoration: BoxDecoration(
                        color: selectedPlanData['color'].withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                      ),
                      child: Icon(
                        Icons.payment,
                        color: selectedPlanData['color'],
                        size: 24,
                      ),
                    ),
                    AppDesignSystem.horizontalSpace(1),
                    Expanded(
                      child: Text(
                        'Confirmar compra',
                        style: AppDesignSystem.h3Style.copyWith(
                          color: AppDesignSystem.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                
                AppDesignSystem.verticalSpace(2),
                
                // Plan Details
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
                  decoration: BoxDecoration(
                    color: selectedPlanData['color'].withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                    border: Border.all(color: selectedPlanData['color'].withValues(alpha: 0.2)),
                  ),
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                        selectedPlanData['title'],
                        style: AppDesignSystem.h3Style.copyWith(
                          color: selectedPlanData['color'],
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      AppDesignSystem.verticalSpace(0.5),
                      Text(
                        selectedPlanData['description'],
                        style: AppDesignSystem.bodySmallStyle,
                      ),
                      AppDesignSystem.verticalSpace(1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Valor total:',
                            style: AppDesignSystem.bodyStyle.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: selectedPlanData['price'],
                                  style: AppDesignSystem.h2Style.copyWith(
                                    color: selectedPlanData['color'],
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                TextSpan(
                                  text: selectedPlanData['period'],
                                  style: AppDesignSystem.bodySmallStyle.copyWith(
                                    color: AppDesignSystem.textSecondaryColor,
                                  ),
                                ),
                              ],
                ),
              ),
            ],
          ),
                    ],
                  ),
                ),
                
                AppDesignSystem.verticalSpace(1.5),
                
                // Benefits
                ...selectedPlanData['features'].take(3).map<Widget>((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDesignSystem.spaceSM),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppDesignSystem.successColor,
                        size: 16,
                      ),
                      AppDesignSystem.horizontalSpace(0.5),
                      Expanded(
                        child: Text(
                          feature,
                          style: AppDesignSystem.bodySmallStyle,
                        ),
                      ),
                    ],
                  ),
                )).toList(),
                
                AppDesignSystem.verticalSpace(2),
                
                // Actions
                Row(
                  children: [
                    Expanded(
                      child: AppDesignSystem.secondaryButton(
                        text: 'Cancelar',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    AppDesignSystem.horizontalSpace(1),
                    Expanded(
                      child: AppDesignSystem.primaryButton(
                        text: 'Confirmar',
              onPressed: () {
                Navigator.of(context).pop();
                _processPurchase(selectedPlanData);
              },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _processPurchase(Map<String, dynamic> plan) {
    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDesignSystem.space2XL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: AppDesignSystem.primaryColor,
              ),
              AppDesignSystem.verticalSpace(1.5),
              Text(
                'Processando pagamento...',
                style: AppDesignSystem.bodyStyle.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              AppDesignSystem.verticalSpace(0.5),
              Text(
                'Aguarde enquanto confirmamos sua compra',
                style: AppDesignSystem.bodySmallStyle.copyWith(
                  color: AppDesignSystem.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );

    // Simular processamento
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Fechar loading

      // Mostrar sucesso
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDesignSystem.space2XL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
                  decoration: BoxDecoration(
                    color: AppDesignSystem.successColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: AppDesignSystem.successColor,
                    size: 48,
                  ),
                ),
                AppDesignSystem.verticalSpace(1.5),
                Text(
                  'Compra realizada com sucesso!',
                  style: AppDesignSystem.h3Style.copyWith(
                    color: AppDesignSystem.successColor,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppDesignSystem.verticalSpace(1),
                Text(
                  'Seu plano ${plan['title']} foi ativado.\nSeu perfil já está sendo destacado!',
                  style: AppDesignSystem.bodySmallStyle.copyWith(
                    color: AppDesignSystem.textSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppDesignSystem.verticalSpace(2),
                AppDesignSystem.primaryButton(
                  text: 'Continuar',
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(); // Voltar para tela anterior
                  },
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      );
    });
    
    // Reset selection
    setState(() {
      _selectedPlan = null;
    });
  }
}
