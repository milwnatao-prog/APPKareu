import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';
import '../services/split_payment_service.dart';

class KareuFinancialDashboard extends StatefulWidget {
  const KareuFinancialDashboard({super.key});

  @override
  State<KareuFinancialDashboard> createState() => _KareuFinancialDashboardState();
}

class _KareuFinancialDashboardState extends State<KareuFinancialDashboard> {
  AccountBalance? _balance;
  CommissionReport? _monthlyReport;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFinancialData();
  }

  Future<void> _loadFinancialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simular dados financeiros (em produção viria da API)
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _balance = AccountBalance(
          availableBalance: 15420.50,
          unavailableBalance: 2340.00,
          totalBalance: 17760.50,
        );
        
        _monthlyReport = CommissionReport(
          totalCommissions: 5967.16, // 8% de R$ 74.589
          totalTransactions: 156,
          items: _generateMockCommissions(),
        );
        
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar dados: $e'),
          backgroundColor: AppDesignSystem.errorColor,
        ),
      );
    }
  }

  List<CommissionItem> _generateMockCommissions() {
    return [
      CommissionItem(
        id: '1',
        amount: 30.40,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        description: 'Taxa de Serviço - Contrato Maria Silva',
      ),
      CommissionItem(
        id: '2',
        amount: 44.80,
        date: DateTime.now().subtract(const Duration(hours: 5)),
        description: 'Taxa de Serviço - Contrato João Santos',
      ),
      CommissionItem(
        id: '3',
        amount: 25.60,
        date: DateTime.now().subtract(const Duration(days: 1)),
        description: 'Taxa de Serviço - Contrato Ana Costa',
      ),
      CommissionItem(
        id: '4',
        amount: 59.40,
        date: DateTime.now().subtract(const Duration(days: 1)),
        description: 'Taxa de Serviço - Contrato Carlos Oliveira',
      ),
      CommissionItem(
        id: '5',
        amount: 35.20,
        date: DateTime.now().subtract(const Duration(days: 2)),
        description: 'Taxa de Serviço - Contrato Lucia Ferreira',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      appBar: AppDesignSystem.styledAppBar(
        title: 'Dashboard Financeiro Kareu',
        context: context,
        onBackPressed: () => Navigator.pop(context),
        actions: [
          IconButton(
            onPressed: _loadFinancialData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppDesignSystem.primaryColor,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Saldo da Conta
                  _buildBalanceCard(),
                  
                  const SizedBox(height: 24),
                  
                  // Métricas do Mês
                  _buildMonthlyMetrics(),
                  
                  const SizedBox(height: 24),
                  
                  // Comissões Recentes
                  _buildRecentCommissions(),
                  
                  const SizedBox(height: 24),
                  
                  // Ações Rápidas
                  _buildQuickActions(),
                ],
              ),
            ),
    );
  }

  Widget _buildBalanceCard() {
    if (_balance == null) return const SizedBox();

    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: AppDesignSystem.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Saldo da Conta Kareu',
                style: AppDesignSystem.h3Style,
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Saldo Total
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppDesignSystem.primaryColor,
                  AppDesignSystem.primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Saldo Total',
                  style: AppDesignSystem.captionStyle.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'R\$ ${_balance!.totalBalance.toStringAsFixed(2)}',
                  style: AppDesignSystem.h1Style.copyWith(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Detalhamento do Saldo
          Row(
            children: [
              Expanded(
                child: _buildBalanceDetail(
                  'Disponível',
                  _balance!.availableBalance,
                  AppDesignSystem.successColor,
                  Icons.check_circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildBalanceDetail(
                  'Bloqueado',
                  _balance!.unavailableBalance,
                  AppDesignSystem.warningColor,
                  Icons.schedule,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceDetail(String label, double amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppDesignSystem.captionStyle.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'R\$ ${amount.toStringAsFixed(2)}',
            style: AppDesignSystem.h3Style.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyMetrics() {
    if (_monthlyReport == null) return const SizedBox();

    final avgCommission = _monthlyReport!.totalCommissions / _monthlyReport!.totalTransactions;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Métricas do Mês',
          style: AppDesignSystem.h2Style,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Taxas de Serviço',
                'R\$ ${_monthlyReport!.totalCommissions.toStringAsFixed(2)}',
                Icons.monetization_on,
                AppDesignSystem.successColor,
                '+15.2%',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                'Transações',
                _monthlyReport!.totalTransactions.toString(),
                Icons.receipt_long,
                AppDesignSystem.primaryColor,
                '+8.7%',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Taxa Média',
                'R\$ ${avgCommission.toStringAsFixed(2)}',
                Icons.trending_up,
                AppDesignSystem.warningColor,
                '+3.1%',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                'Taxa de Serviço',
                '8%',
                Icons.percent,
                AppDesignSystem.infoColor,
                'Estável',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color, String change) {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppDesignSystem.captionStyle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppDesignSystem.h3Style.copyWith(
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            change,
            style: AppDesignSystem.captionStyle.copyWith(
              color: change.startsWith('+') 
                  ? AppDesignSystem.successColor 
                  : AppDesignSystem.textSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCommissions() {
    if (_monthlyReport == null || _monthlyReport!.items.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Taxas de Serviço Recentes',
              style: AppDesignSystem.h2Style,
            ),
            TextButton(
              onPressed: () {
                // Navegar para tela de todas as comissões
              },
              child: const Text('Ver todas'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppDesignSystem.styledCard(
          child: Column(
            children: _monthlyReport!.items.take(5).map((commission) {
              return _buildCommissionItem(commission);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCommissionItem(CommissionItem commission) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppDesignSystem.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.attach_money,
              color: AppDesignSystem.successColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  commission.description,
                  style: AppDesignSystem.bodyStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _formatDateTime(commission.date),
                  style: AppDesignSystem.captionStyle.copyWith(
                    color: AppDesignSystem.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'R\$ ${commission.amount.toStringAsFixed(2)}',
            style: AppDesignSystem.bodyStyle.copyWith(
              color: AppDesignSystem.successColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ações Rápidas',
          style: AppDesignSystem.h2Style,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Sacar Dinheiro',
                Icons.account_balance,
                AppDesignSystem.primaryColor,
                () => _showWithdrawDialog(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                'Relatório Completo',
                Icons.assessment,
                AppDesignSystem.infoColor,
                () => _generateFullReport(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Configurar Taxa',
                Icons.settings,
                AppDesignSystem.warningColor,
                () => _showCommissionSettings(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                'Exportar Dados',
                Icons.file_download,
                AppDesignSystem.successColor,
                () => _exportData(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppDesignSystem.bodyStyle.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m atrás';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h atrás';
    } else {
      return '${difference.inDays}d atrás';
    }
  }

  void _showWithdrawDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sacar Dinheiro'),
        content: const Text('Funcionalidade de saque será implementada em breve.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _generateFullReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gerando relatório completo...'),
        backgroundColor: AppDesignSystem.infoColor,
      ),
    );
  }

  void _showCommissionSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configurar Taxa de Comissão'),
        content: const Text('Configurações de taxa serão implementadas em breve.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exportando dados financeiros...'),
        backgroundColor: AppDesignSystem.successColor,
      ),
    );
  }
}
