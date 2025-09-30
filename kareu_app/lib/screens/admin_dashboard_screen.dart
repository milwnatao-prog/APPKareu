import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';
import '../models/user_model.dart';
import '../services/analytics_service.dart';
import '../services/user_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PlatformMetrics _platformMetrics;
  late SubscriptionMetrics _subscriptionMetrics;
  late ContractMetrics _contractMetrics;
  late EngagementMetrics _engagementMetrics;
  late Map<String, KPI> _kpis;
  late List<AdminAlert> _alerts;
  late List<TopCaregiver> _topCaregivers;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  void _loadData() {
    _platformMetrics = AnalyticsService.getPlatformMetrics();
    _subscriptionMetrics = AnalyticsService.getSubscriptionMetrics();
    _contractMetrics = AnalyticsService.getContractMetrics();
    _engagementMetrics = AnalyticsService.getEngagementMetrics();
    _kpis = AnalyticsService.getKPIs();
    _alerts = AnalyticsService.getAdminAlerts();
    _topCaregivers = AnalyticsService.getTopCaregivers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      appBar: AppDesignSystem.styledAppBar(
        title: 'Dashboard Administrativo',
        context: context,
        onBackPressed: () => Navigator.pop(context),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _loadData();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dados atualizados!'),
                  backgroundColor: AppDesignSystem.successColor,
                ),
              );
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppDesignSystem.primaryColor,
              unselectedLabelColor: AppDesignSystem.textSecondaryColor,
              indicatorColor: AppDesignSystem.primaryColor,
              tabs: const [
                Tab(text: 'Visão Geral'),
                Tab(text: 'Usuários'),
                Tab(text: 'Receita'),
                Tab(text: 'Relatórios'),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildUsersTab(),
                _buildRevenueTab(),
                _buildReportsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPIs Principais
          _buildKPISection(),
          
          const SizedBox(height: AppDesignSystem.space2XL),
          
          // Métricas Rápidas
          _buildQuickMetrics(),
          
          const SizedBox(height: AppDesignSystem.space2XL),
          
          // Alertas
          _buildAlertsSection(),
          
          const SizedBox(height: AppDesignSystem.space2XL),
          
          // Top Cuidadores
          _buildTopCaregiversSection(),
        ],
      ),
    );
  }

  Widget _buildKPISection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'KPIs Principais',
          style: AppDesignSystem.h2Style,
        ),
        const SizedBox(height: AppDesignSystem.spaceLG),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: AppDesignSystem.spaceMD,
          mainAxisSpacing: AppDesignSystem.spaceMD,
          childAspectRatio: 1.5,
          children: _kpis.entries.map((entry) {
            return _buildKPICard(entry.value);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildKPICard(KPI kpi) {
    Color trendColor;
    IconData trendIcon;
    
    switch (kpi.trend) {
      case KPITrend.up:
        trendColor = AppDesignSystem.successColor;
        trendIcon = Icons.trending_up;
        break;
      case KPITrend.down:
        trendColor = AppDesignSystem.errorColor;
        trendIcon = Icons.trending_down;
        break;
      case KPITrend.stable:
        trendColor = AppDesignSystem.warningColor;
        trendIcon = Icons.trending_flat;
        break;
    }

    String formattedValue;
    switch (kpi.format) {
      case KPIFormat.currency:
        formattedValue = 'R\$ ${kpi.value.toStringAsFixed(2)}';
        break;
      case KPIFormat.percentage:
        formattedValue = '${kpi.value.toStringAsFixed(1)}%';
        break;
      case KPIFormat.number:
        formattedValue = kpi.value.toStringAsFixed(0);
        break;
    }

    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            kpi.name,
            style: AppDesignSystem.captionStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            formattedValue,
            style: AppDesignSystem.h3Style.copyWith(
              color: AppDesignSystem.primaryColor,
            ),
          ),
          Row(
            children: [
              Icon(
                trendIcon,
                color: trendColor,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${kpi.changePercent > 0 ? '+' : ''}${kpi.changePercent.toStringAsFixed(1)}%',
                style: AppDesignSystem.captionStyle.copyWith(
                  color: trendColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Métricas Rápidas',
          style: AppDesignSystem.h2Style,
        ),
        const SizedBox(height: AppDesignSystem.spaceLG),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Usuários Totais',
                _platformMetrics.totalUsers.toString(),
                Icons.people,
                AppDesignSystem.primaryColor,
              ),
            ),
            const SizedBox(width: AppDesignSystem.spaceMD),
            Expanded(
              child: _buildMetricCard(
                'Receita Mensal',
                'R\$ ${_platformMetrics.totalMonthlyRevenue.toStringAsFixed(0)}',
                Icons.attach_money,
                AppDesignSystem.successColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDesignSystem.spaceMD),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Contratos Ativos',
                _contractMetrics.activeContracts.toString(),
                Icons.assignment,
                AppDesignSystem.warningColor,
              ),
            ),
            const SizedBox(width: AppDesignSystem.spaceMD),
            Expanded(
              child: _buildMetricCard(
                'Taxa Conversão',
                '${_subscriptionMetrics.conversionRate.toStringAsFixed(1)}%',
                Icons.trending_up,
                AppDesignSystem.infoColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return AppDesignSystem.styledCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: AppDesignSystem.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppDesignSystem.captionStyle,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppDesignSystem.h3Style.copyWith(
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Alertas Recentes',
              style: AppDesignSystem.h2Style,
            ),
            TextButton(
              onPressed: () {
                // Navegar para tela de todos os alertas
              },
              child: const Text('Ver todos'),
            ),
          ],
        ),
        const SizedBox(height: AppDesignSystem.spaceLG),
        ..._alerts.take(3).map((alert) => _buildAlertCard(alert)),
      ],
    );
  }

  Widget _buildAlertCard(AdminAlert alert) {
    Color alertColor;
    IconData alertIcon;
    
    switch (alert.type) {
      case AlertType.info:
        alertColor = AppDesignSystem.infoColor;
        alertIcon = Icons.info_outline;
        break;
      case AlertType.warning:
        alertColor = AppDesignSystem.warningColor;
        alertIcon = Icons.warning_outlined;
        break;
      case AlertType.error:
        alertColor = AppDesignSystem.errorColor;
        alertIcon = Icons.error_outline;
        break;
      case AlertType.success:
        alertColor = AppDesignSystem.successColor;
        alertIcon = Icons.check_circle_outline;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppDesignSystem.spaceMD),
      child: AppDesignSystem.styledCard(
        child: Row(
          children: [
            Icon(
              alertIcon,
              color: alertColor,
              size: 24,
            ),
            const SizedBox(width: AppDesignSystem.spaceMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert.title,
                    style: AppDesignSystem.bodyStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alert.message,
                    style: AppDesignSystem.captionStyle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(alert.timestamp),
                    style: AppDesignSystem.captionStyle.copyWith(
                      color: AppDesignSystem.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCaregiversSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Cuidadores',
          style: AppDesignSystem.h2Style,
        ),
        const SizedBox(height: AppDesignSystem.spaceLG),
        AppDesignSystem.styledCard(
          child: Column(
            children: _topCaregivers.take(5).map((caregiver) {
              return _buildCaregiverRow(caregiver);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCaregiverRow(TopCaregiver caregiver) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.spaceMD),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppDesignSystem.primaryColor.withOpacity(0.1),
            child: Text(
              caregiver.name[0],
              style: AppDesignSystem.bodyStyle.copyWith(
                color: AppDesignSystem.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppDesignSystem.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  caregiver.name,
                  style: AppDesignSystem.bodyStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${caregiver.contractsCompleted} contratos • ⭐ ${caregiver.rating}',
                  style: AppDesignSystem.captionStyle,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'R\$ ${caregiver.totalEarnings.toStringAsFixed(0)}',
                style: AppDesignSystem.bodyStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppDesignSystem.successColor,
                ),
              ),
              _buildSubscriptionBadge(caregiver.subscriptionTier),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionBadge(SubscriptionTier tier) {
    Color color;
    String text;
    
    switch (tier) {
      case SubscriptionTier.free:
        color = AppDesignSystem.textSecondaryColor;
        text = 'Free';
        break;
      case SubscriptionTier.basic:
        color = AppDesignSystem.infoColor;
        text = 'Basic';
        break;
      case SubscriptionTier.plus:
        color = AppDesignSystem.warningColor;
        text = 'Plus';
        break;
      case SubscriptionTier.premium:
        color = AppDesignSystem.primaryColor;
        text = 'Premium';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: AppDesignSystem.captionStyle.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildUsersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gestão de Usuários',
            style: AppDesignSystem.h2Style,
          ),
          const SizedBox(height: AppDesignSystem.spaceLG),
          
          // Estatísticas de usuários
          _buildUserStats(),
          
          const SizedBox(height: AppDesignSystem.space2XL),
          
          // Distribuição de assinaturas
          _buildSubscriptionDistribution(),
        ],
      ),
    );
  }

  Widget _buildUserStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estatísticas de Usuários',
          style: AppDesignSystem.h3Style,
        ),
        const SizedBox(height: AppDesignSystem.spaceLG),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Cuidadores',
                _platformMetrics.totalCaregivers.toString(),
                Icons.medical_services,
                AppDesignSystem.primaryColor,
              ),
            ),
            const SizedBox(width: AppDesignSystem.spaceMD),
            Expanded(
              child: _buildStatCard(
                'Pacientes',
                _platformMetrics.totalPatients.toString(),
                Icons.people,
                AppDesignSystem.successColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDesignSystem.spaceMD),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Novos (Mês)',
                _platformMetrics.newUsersThisMonth.toString(),
                Icons.person_add,
                AppDesignSystem.warningColor,
              ),
            ),
            const SizedBox(width: AppDesignSystem.spaceMD),
            Expanded(
              child: _buildStatCard(
                'Ativos',
                _platformMetrics.activeUsers.toString(),
                Icons.online_prediction,
                AppDesignSystem.infoColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return AppDesignSystem.styledCard(
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: AppDesignSystem.spaceMD),
          Text(
            value,
            style: AppDesignSystem.h2Style.copyWith(
              color: color,
            ),
          ),
          Text(
            title,
            style: AppDesignSystem.captionStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionDistribution() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Distribuição de Assinaturas',
          style: AppDesignSystem.h3Style,
        ),
        const SizedBox(height: AppDesignSystem.spaceLG),
        AppDesignSystem.styledCard(
          child: Column(
            children: [
              _buildSubscriptionRow('Free', _subscriptionMetrics.freeUsers, AppDesignSystem.textSecondaryColor),
              _buildSubscriptionRow('Basic', _subscriptionMetrics.basicUsers, AppDesignSystem.infoColor),
              _buildSubscriptionRow('Plus', _subscriptionMetrics.plusUsers, AppDesignSystem.warningColor),
              _buildSubscriptionRow('Premium', _subscriptionMetrics.premiumUsers, AppDesignSystem.primaryColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionRow(String tier, int count, Color color) {
    final total = _subscriptionMetrics.freeUsers + 
                  _subscriptionMetrics.basicUsers + 
                  _subscriptionMetrics.plusUsers + 
                  _subscriptionMetrics.premiumUsers;
    final percentage = (count / total * 100);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.spaceMD),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tier,
                style: AppDesignSystem.bodyStyle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$count usuários (${percentage.toStringAsFixed(1)}%)',
                style: AppDesignSystem.captionStyle,
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Análise de Receita',
            style: AppDesignSystem.h2Style,
          ),
          const SizedBox(height: AppDesignSystem.spaceLG),
          
          // Cards de receita
          _buildRevenueCards(),
          
          const SizedBox(height: AppDesignSystem.space2XL),
          
          // Métricas de contratos
          _buildContractMetrics(),
        ],
      ),
    );
  }

  Widget _buildRevenueCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildRevenueCard(
                'Receita Mensal',
                'R\$ ${_platformMetrics.totalMonthlyRevenue.toStringAsFixed(2)}',
                Icons.calendar_month,
                AppDesignSystem.successColor,
                '+8.5%',
              ),
            ),
            const SizedBox(width: AppDesignSystem.spaceMD),
            Expanded(
              child: _buildRevenueCard(
                'Receita Anual',
                'R\$ ${_platformMetrics.totalYearlyRevenue.toStringAsFixed(2)}',
                Icons.calendar_today,
                AppDesignSystem.primaryColor,
                '+15.2%',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDesignSystem.spaceMD),
        Row(
          children: [
            Expanded(
              child: _buildRevenueCard(
                'ARPU',
                'R\$ ${_platformMetrics.averageRevenuePerUser.toStringAsFixed(2)}',
                Icons.person,
                AppDesignSystem.warningColor,
                '+3.2%',
              ),
            ),
            const SizedBox(width: AppDesignSystem.spaceMD),
            Expanded(
              child: _buildRevenueCard(
                'Comissão Total',
                'R\$ ${_contractMetrics.totalCommissionEarned.toStringAsFixed(2)}',
                Icons.percent,
                AppDesignSystem.infoColor,
                '+12.1%',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRevenueCard(String title, String value, IconData icon, Color color, String change) {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppDesignSystem.captionStyle,
              ),
            ],
          ),
          const SizedBox(height: AppDesignSystem.spaceMD),
          Text(
            value,
            style: AppDesignSystem.h3Style.copyWith(
              color: color,
            ),
          ),
          Text(
            change,
            style: AppDesignSystem.captionStyle.copyWith(
              color: AppDesignSystem.successColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Métricas de Contratos',
          style: AppDesignSystem.h3Style,
        ),
        const SizedBox(height: AppDesignSystem.spaceLG),
        AppDesignSystem.styledCard(
          child: Column(
            children: [
              _buildContractMetricRow(
                'Total de Contratos',
                _contractMetrics.totalContracts.toString(),
                Icons.assignment,
              ),
              _buildContractMetricRow(
                'Contratos Concluídos',
                _contractMetrics.completedContracts.toString(),
                Icons.check_circle,
              ),
              _buildContractMetricRow(
                'Contratos Ativos',
                _contractMetrics.activeContracts.toString(),
                Icons.pending,
              ),
              _buildContractMetricRow(
                'Valor Médio',
                'R\$ ${_contractMetrics.averageContractValue.toStringAsFixed(2)}',
                Icons.attach_money,
              ),
              _buildContractMetricRow(
                'Taxa de Comissão',
                '${_contractMetrics.platformCommission}%',
                Icons.percent,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContractMetricRow(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.spaceMD),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppDesignSystem.primaryColor,
            size: 20,
          ),
          const SizedBox(width: AppDesignSystem.spaceMD),
          Expanded(
            child: Text(
              title,
              style: AppDesignSystem.bodyStyle,
            ),
          ),
          Text(
            value,
            style: AppDesignSystem.bodyStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: AppDesignSystem.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Relatórios e Analytics',
            style: AppDesignSystem.h2Style,
          ),
          const SizedBox(height: AppDesignSystem.spaceLG),
          
          // Botões de relatórios
          _buildReportButtons(),
          
          const SizedBox(height: AppDesignSystem.space2XL),
          
          // Métricas de engajamento
          _buildEngagementMetrics(),
        ],
      ),
    );
  }

  Widget _buildReportButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gerar Relatórios',
          style: AppDesignSystem.h3Style,
        ),
        const SizedBox(height: AppDesignSystem.spaceLG),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: AppDesignSystem.spaceMD,
          mainAxisSpacing: AppDesignSystem.spaceMD,
          childAspectRatio: 1.2,
          children: [
            _buildReportButton(
              'Relatório Financeiro',
              Icons.account_balance,
              AppDesignSystem.successColor,
              () => _generateReport('financial'),
            ),
            _buildReportButton(
              'Relatório de Usuários',
              Icons.people,
              AppDesignSystem.primaryColor,
              () => _generateReport('users'),
            ),
            _buildReportButton(
              'Relatório de Contratos',
              Icons.assignment,
              AppDesignSystem.warningColor,
              () => _generateReport('contracts'),
            ),
            _buildReportButton(
              'Relatório de Performance',
              Icons.analytics,
              AppDesignSystem.infoColor,
              () => _generateReport('performance'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReportButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AppDesignSystem.styledCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: AppDesignSystem.spaceMD),
            Text(
              title,
              style: AppDesignSystem.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Métricas de Engajamento',
          style: AppDesignSystem.h3Style,
        ),
        const SizedBox(height: AppDesignSystem.spaceLG),
        AppDesignSystem.styledCard(
          child: Column(
            children: [
              _buildEngagementRow(
                'Usuários Ativos Diários',
                _engagementMetrics.dailyActiveUsers.toString(),
                Icons.today,
              ),
              _buildEngagementRow(
                'Usuários Ativos Semanais',
                _engagementMetrics.weeklyActiveUsers.toString(),
                Icons.date_range,
              ),
              _buildEngagementRow(
                'Usuários Ativos Mensais',
                _engagementMetrics.monthlyActiveUsers.toString(),
                Icons.calendar_month,
              ),
              _buildEngagementRow(
                'Tempo Médio de Sessão',
                '${_engagementMetrics.averageSessionTime.toStringAsFixed(1)} min',
                Icons.access_time,
              ),
              _buildEngagementRow(
                'Mensagens de Chat',
                _engagementMetrics.totalChatMessages.toString(),
                Icons.chat,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEngagementRow(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.spaceMD),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppDesignSystem.primaryColor,
            size: 20,
          ),
          const SizedBox(width: AppDesignSystem.spaceMD),
          Expanded(
            child: Text(
              title,
              style: AppDesignSystem.bodyStyle,
            ),
          ),
          Text(
            value,
            style: AppDesignSystem.bodyStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: AppDesignSystem.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m atrás';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h atrás';
    } else {
      return '${difference.inDays}d atrás';
    }
  }

  void _generateReport(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Gerando relatório de $type...'),
        backgroundColor: AppDesignSystem.infoColor,
      ),
    );
    
    // Simular geração de relatório
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Relatório de $type gerado com sucesso!'),
            backgroundColor: AppDesignSystem.successColor,
          ),
        );
      }
    });
  }
}
