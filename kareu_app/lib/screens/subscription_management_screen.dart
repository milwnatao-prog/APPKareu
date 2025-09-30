import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../services/reputation_service.dart';
import 'caregiver_payment_screen.dart';

class SubscriptionManagementScreen extends StatefulWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  State<SubscriptionManagementScreen> createState() => _SubscriptionManagementScreenState();
}

class _SubscriptionManagementScreenState extends State<SubscriptionManagementScreen> {
  late SubscriptionTier _currentTier;
  late ReputationStats _reputationStats;
  late ReputationLevel _reputationLevel;

  @override
  void initState() {
    super.initState();
    _currentTier = UserService.currentSubscriptionTier;
    _reputationStats = ReputationService.getReputationStats(UserService.currentUserId);
    _reputationLevel = ReputationService.getReputationLevel(UserService.currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      appBar: AppDesignSystem.styledAppBar(
        title: 'Minha Assinatura',
        context: context,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDesignSystem.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status atual da assinatura
            _buildCurrentSubscriptionCard(),
            
            AppDesignSystem.verticalSpace(2),
            
            // Estatísticas de desempenho
            _buildPerformanceStats(),
            
            AppDesignSystem.verticalSpace(2),
            
            // Benefícios da assinatura atual
            _buildCurrentBenefits(),
            
            AppDesignSystem.verticalSpace(2),
            
            // Opções de upgrade
            if (_currentTier != SubscriptionTier.premium) _buildUpgradeOptions(),
            
            AppDesignSystem.verticalSpace(2),
            
            // Histórico de pagamentos
            _buildPaymentHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentSubscriptionCard() {
    final tierColor = _getTierColor(_currentTier);
    final tierIcon = _getTierIcon(_currentTier);
    
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: tierColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  tierIcon,
                  color: tierColor,
                  size: 24,
                ),
              ),
              AppDesignSystem.horizontalSpace(1),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plano ${UserService.getSubscriptionDisplayName()}',
                      style: AppDesignSystem.h3Style.copyWith(
                        fontWeight: FontWeight.w700,
                        color: tierColor,
                      ),
                    ),
                    if (_currentTier != SubscriptionTier.free)
                      Text(
                        'R\$ ${UserService.getSubscriptionPrice().toStringAsFixed(2).replaceAll('.', ',')}/mês',
                        style: AppDesignSystem.bodyStyle.copyWith(
                          color: AppDesignSystem.grayColor,
                        ),
                      ),
                  ],
                ),
              ),
              if (_currentTier != SubscriptionTier.free)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppDesignSystem.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'ATIVO',
                    style: AppDesignSystem.captionStyle.copyWith(
                      color: AppDesignSystem.successColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          // Status de renovação
          if (_currentTier != SubscriptionTier.free) ...[
            Row(
              children: [
                Icon(
                  Icons.autorenew,
                  color: AppDesignSystem.infoColor,
                  size: 16,
                ),
                AppDesignSystem.horizontalSpace(0.5),
                Text(
                  'Renovação automática em 15 dias',
                  style: AppDesignSystem.captionStyle.copyWith(
                    color: AppDesignSystem.grayColor,
                  ),
                ),
              ],
            ),
            AppDesignSystem.verticalSpace(1),
          ],
          
          // Limites e uso atual
          _buildUsageLimits(),
        ],
      ),
    );
  }

  Widget _buildUsageLimits() {
    final monthlyLimit = UserService.getMonthlyBookingLimit();
    final currentUsage = 3; // Simulação - viria do banco de dados
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Agendamentos este mês',
              style: AppDesignSystem.bodyStyle.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              monthlyLimit == -1 
                  ? '$currentUsage/Ilimitado'
                  : '$currentUsage/$monthlyLimit',
              style: AppDesignSystem.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: AppDesignSystem.primaryColor,
              ),
            ),
          ],
        ),
        
        if (monthlyLimit > 0) ...[
          AppDesignSystem.verticalSpace(0.5),
          LinearProgressIndicator(
            value: currentUsage / monthlyLimit,
            backgroundColor: AppDesignSystem.lightGrayColor,
            valueColor: AlwaysStoppedAnimation<Color>(
              currentUsage / monthlyLimit > 0.8 
                  ? AppDesignSystem.warningColor
                  : AppDesignSystem.primaryColor,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPerformanceStats() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics,
                color: AppDesignSystem.primaryColor,
                size: 24,
              ),
              AppDesignSystem.horizontalSpace(0.5),
              Text(
                'Desempenho Profissional',
                style: AppDesignSystem.h3Style.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          // Estatísticas em grid
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Avaliação',
                  _reputationStats.averageRating.toStringAsFixed(1),
                  Icons.star,
                  AppDesignSystem.warningColor,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Avaliações',
                  _reputationStats.totalRatings.toString(),
                  Icons.rate_review,
                  AppDesignSystem.infoColor,
                ),
              ),
            ],
          ),
          
          AppDesignSystem.verticalSpace(1),
          
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Nível',
                  _reputationLevel.displayName,
                  Icons.workspace_premium,
                  _getReputationColor(_reputationLevel),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Contratos',
                  'R\$ ${_reputationStats.totalContractValue.toStringAsFixed(0)}',
                  Icons.monetization_on,
                  AppDesignSystem.successColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
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
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: AppDesignSystem.captionStyle.copyWith(
              color: AppDesignSystem.grayColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentBenefits() {
    final benefits = _getBenefitsForTier(_currentTier);
    
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Benefícios Ativos',
            style: AppDesignSystem.h3Style.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          AppDesignSystem.verticalSpace(1),
          
          ...benefits.map((benefit) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
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
                    benefit,
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
    );
  }

  Widget _buildUpgradeOptions() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upgrade Disponível',
            style: AppDesignSystem.h3Style.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          AppDesignSystem.verticalSpace(1),
          
          Text(
            'Desbloqueie mais recursos e aumente sua visibilidade',
            style: AppDesignSystem.bodyStyle.copyWith(
              color: AppDesignSystem.grayColor,
            ),
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          AppDesignSystem.primaryButton(
            text: 'Ver Planos Disponíveis',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CaregiverPaymentScreen(),
                ),
              );
            },
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistory() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Histórico de Pagamentos',
            style: AppDesignSystem.h3Style.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          AppDesignSystem.verticalSpace(1),
          
          if (_currentTier == SubscriptionTier.free)
            Text(
              'Nenhum pagamento realizado ainda',
              style: AppDesignSystem.bodyStyle.copyWith(
                color: AppDesignSystem.grayColor,
              ),
            )
          else
            ..._buildPaymentItems(),
        ],
      ),
    );
  }

  List<Widget> _buildPaymentItems() {
    // Simulação de histórico de pagamentos
    final payments = [
      {
        'date': '15/09/2024',
        'amount': UserService.getSubscriptionPrice(),
        'status': 'Pago',
        'method': 'Cartão de Crédito',
      },
      {
        'date': '15/08/2024',
        'amount': UserService.getSubscriptionPrice(),
        'status': 'Pago',
        'method': 'PIX',
      },
    ];

    return payments.map((payment) => Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppDesignSystem.lightGrayColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                payment['date'] as String,
                style: AppDesignSystem.bodyStyle.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                payment['method'] as String,
                style: AppDesignSystem.captionStyle.copyWith(
                  color: AppDesignSystem.grayColor,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'R\$ ${(payment['amount'] as double).toStringAsFixed(2).replaceAll('.', ',')}',
                style: AppDesignSystem.bodyStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppDesignSystem.successColor,
                ),
              ),
              Text(
                payment['status'] as String,
                style: AppDesignSystem.captionStyle.copyWith(
                  color: AppDesignSystem.successColor,
                ),
              ),
            ],
          ),
        ],
      ),
    )).toList();
  }

  Color _getTierColor(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return AppDesignSystem.grayColor;
      case SubscriptionTier.basic:
        return AppDesignSystem.infoColor;
      case SubscriptionTier.plus:
        return AppDesignSystem.warningColor;
      case SubscriptionTier.premium:
        return const Color(0xFFFFD700); // Dourado
    }
  }

  IconData _getTierIcon(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return Icons.person;
      case SubscriptionTier.basic:
        return Icons.verified_user;
      case SubscriptionTier.plus:
        return Icons.star;
      case SubscriptionTier.premium:
        return Icons.workspace_premium;
    }
  }

  Color _getReputationColor(ReputationLevel level) {
    switch (level) {
      case ReputationLevel.newbie:
        return AppDesignSystem.grayColor;
      case ReputationLevel.developing:
        return AppDesignSystem.infoColor;
      case ReputationLevel.trusted:
        return AppDesignSystem.successColor;
      case ReputationLevel.expert:
        return AppDesignSystem.warningColor;
      case ReputationLevel.elite:
        return const Color(0xFF8B5CF6); // Roxo
    }
  }

  List<String> _getBenefitsForTier(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return [
          'Perfil básico na plataforma',
          'Visualização de oportunidades',
          'Chat limitado',
        ];
      case SubscriptionTier.basic:
        return [
          'Perfil verificado',
          'Até 5 agendamentos por mês',
          'Chat com pacientes',
          'Suporte básico',
        ];
      case SubscriptionTier.plus:
        return [
          'Tudo do Plano Básico',
          'Agendamentos ilimitados',
          'Destaque na busca',
          'Suporte prioritário',
          'Relatórios mensais',
        ];
      case SubscriptionTier.premium:
        return [
          'Tudo do Plano Plus',
          'Posição top na busca',
          'Badge "Premium"',
          'Suporte 24/7',
          'Marketing dedicado',
          'Análises avançadas',
          'Proteção contratual',
        ];
    }
  }
}
