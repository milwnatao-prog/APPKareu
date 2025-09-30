import '../services/user_service.dart';
import '../services/reputation_service.dart';
import '../models/user_model.dart';

class AnalyticsService {
  // Simulação de dados - em produção viria do banco de dados
  static final Map<String, dynamic> _mockData = {
    'users': {
      'total': 1247,
      'caregivers': 423,
      'patients': 824,
      'newThisMonth': 89,
      'activeUsers': 892,
    },
    'revenue': {
      'totalMonthly': 12450.00,
      'totalYearly': 89320.00,
      'averagePerUser': 29.45,
      'projectedGrowth': 15.2,
    },
    'subscriptions': {
      'free': 234,
      'basic': 156,
      'plus': 89,
      'premium': 45,
      'conversionRate': 12.8,
    },
    'platform': {
      'totalContracts': 567,
      'completedContracts': 489,
      'activeContracts': 78,
      'averageContractValue': 450.00,
      'platformCommission': 8.5,
    },
    'engagement': {
      'dailyActiveUsers': 234,
      'weeklyActiveUsers': 567,
      'monthlyActiveUsers': 892,
      'averageSessionTime': 12.5,
      'chatMessages': 2340,
    }
  };

  /// Obtém métricas gerais da plataforma
  static PlatformMetrics getPlatformMetrics() {
    final data = _mockData;
    
    return PlatformMetrics(
      totalUsers: data['users']['total'],
      totalCaregivers: data['users']['caregivers'],
      totalPatients: data['users']['patients'],
      newUsersThisMonth: data['users']['newThisMonth'],
      activeUsers: data['users']['activeUsers'],
      totalMonthlyRevenue: data['revenue']['totalMonthly'],
      totalYearlyRevenue: data['revenue']['totalYearly'],
      averageRevenuePerUser: data['revenue']['averagePerUser'],
      projectedGrowth: data['revenue']['projectedGrowth'],
    );
  }

  /// Obtém dados de assinaturas
  static SubscriptionMetrics getSubscriptionMetrics() {
    final data = _mockData['subscriptions'];
    
    return SubscriptionMetrics(
      freeUsers: data['free'],
      basicUsers: data['basic'],
      plusUsers: data['plus'],
      premiumUsers: data['premium'],
      conversionRate: data['conversionRate'],
      totalPaidUsers: data['basic'] + data['plus'] + data['premium'],
    );
  }

  /// Obtém métricas de contratos
  static ContractMetrics getContractMetrics() {
    final data = _mockData['platform'];
    
    return ContractMetrics(
      totalContracts: data['totalContracts'],
      completedContracts: data['completedContracts'],
      activeContracts: data['activeContracts'],
      averageContractValue: data['averageContractValue'],
      platformCommission: data['platformCommission'],
      totalCommissionEarned: (data['totalContracts'] * data['averageContractValue'] * data['platformCommission'] / 100),
    );
  }

  /// Obtém métricas de engajamento
  static EngagementMetrics getEngagementMetrics() {
    final data = _mockData['engagement'];
    
    return EngagementMetrics(
      dailyActiveUsers: data['dailyActiveUsers'],
      weeklyActiveUsers: data['weeklyActiveUsers'],
      monthlyActiveUsers: data['monthlyActiveUsers'],
      averageSessionTime: data['averageSessionTime'],
      totalChatMessages: data['chatMessages'],
    );
  }

  /// Obtém dados para gráficos de crescimento
  static List<ChartData> getGrowthChartData() {
    return [
      ChartData('Jan', 156, 89),
      ChartData('Fev', 189, 112),
      ChartData('Mar', 234, 145),
      ChartData('Abr', 278, 167),
      ChartData('Mai', 312, 189),
      ChartData('Jun', 356, 234),
      ChartData('Jul', 423, 267),
      ChartData('Ago', 489, 298),
      ChartData('Set', 567, 334),
      ChartData('Out', 634, 378),
      ChartData('Nov', 712, 423),
      ChartData('Dez', 824, 489),
    ];
  }

  /// Obtém dados de receita mensal
  static List<RevenueData> getRevenueChartData() {
    return [
      RevenueData('Jan', 4500.00, 2800.00),
      RevenueData('Fev', 5200.00, 3200.00),
      RevenueData('Mar', 6100.00, 3800.00),
      RevenueData('Abr', 7300.00, 4500.00),
      RevenueData('Mai', 8200.00, 5100.00),
      RevenueData('Jun', 9400.00, 5800.00),
      RevenueData('Jul', 10200.00, 6300.00),
      RevenueData('Ago', 11100.00, 6900.00),
      RevenueData('Set', 11800.00, 7300.00),
      RevenueData('Out', 12200.00, 7600.00),
      RevenueData('Nov', 12450.00, 7800.00),
      RevenueData('Dez', 13500.00, 8400.00), // Projeção
    ];
  }

  /// Obtém top cuidadores por receita
  static List<TopCaregiver> getTopCaregivers() {
    return [
      TopCaregiver(
        id: 'caregiver_001',
        name: 'Maria Silva',
        totalEarnings: 4500.00,
        contractsCompleted: 23,
        rating: 4.9,
        subscriptionTier: SubscriptionTier.premium,
      ),
      TopCaregiver(
        id: 'caregiver_002',
        name: 'João Santos',
        totalEarnings: 3800.00,
        contractsCompleted: 19,
        rating: 4.8,
        subscriptionTier: SubscriptionTier.plus,
      ),
      TopCaregiver(
        id: 'caregiver_003',
        name: 'Ana Costa',
        totalEarnings: 3200.00,
        contractsCompleted: 16,
        rating: 4.7,
        subscriptionTier: SubscriptionTier.plus,
      ),
      TopCaregiver(
        id: 'caregiver_004',
        name: 'Carlos Oliveira',
        totalEarnings: 2900.00,
        contractsCompleted: 14,
        rating: 4.6,
        subscriptionTier: SubscriptionTier.basic,
      ),
      TopCaregiver(
        id: 'caregiver_005',
        name: 'Lucia Ferreira',
        totalEarnings: 2600.00,
        contractsCompleted: 12,
        rating: 4.8,
        subscriptionTier: SubscriptionTier.plus,
      ),
    ];
  }

  /// Obtém alertas e notificações para administradores
  static List<AdminAlert> getAdminAlerts() {
    return [
      AdminAlert(
        type: AlertType.warning,
        title: 'Taxa de Conversão Baixa',
        message: 'A conversão de gratuito para pago caiu 3% este mês',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        priority: AlertPriority.medium,
      ),
      AdminAlert(
        type: AlertType.success,
        title: 'Meta de Receita Atingida',
        message: 'Receita mensal ultrapassou R\$ 12.000',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        priority: AlertPriority.low,
      ),
      AdminAlert(
        type: AlertType.error,
        title: 'Problema no Sistema de Pagamento',
        message: '3 pagamentos falharam nas últimas 24h',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        priority: AlertPriority.high,
      ),
      AdminAlert(
        type: AlertType.info,
        title: 'Novo Cuidador Premium',
        message: '5 cuidadores upgradearam para Premium hoje',
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
        priority: AlertPriority.low,
      ),
    ];
  }

  /// Calcula KPIs principais
  static Map<String, KPI> getKPIs() {
    final metrics = getPlatformMetrics();
    final subscriptions = getSubscriptionMetrics();
    final contracts = getContractMetrics();
    
    return {
      'mrr': KPI(
        name: 'MRR (Receita Recorrente Mensal)',
        value: metrics.totalMonthlyRevenue,
        format: KPIFormat.currency,
        trend: KPITrend.up,
        changePercent: 8.5,
      ),
      'arpu': KPI(
        name: 'ARPU (Receita Média por Usuário)',
        value: metrics.averageRevenuePerUser,
        format: KPIFormat.currency,
        trend: KPITrend.up,
        changePercent: 3.2,
      ),
      'conversion': KPI(
        name: 'Taxa de Conversão',
        value: subscriptions.conversionRate,
        format: KPIFormat.percentage,
        trend: KPITrend.down,
        changePercent: -2.1,
      ),
      'churn': KPI(
        name: 'Taxa de Churn',
        value: 4.2,
        format: KPIFormat.percentage,
        trend: KPITrend.down,
        changePercent: -1.5,
      ),
      'ltv': KPI(
        name: 'LTV (Lifetime Value)',
        value: 450.00,
        format: KPIFormat.currency,
        trend: KPITrend.up,
        changePercent: 12.3,
      ),
      'cac': KPI(
        name: 'CAC (Custo de Aquisição)',
        value: 85.00,
        format: KPIFormat.currency,
        trend: KPITrend.down,
        changePercent: -5.8,
      ),
    };
  }
}

// ===== CLASSES DE DADOS =====

class PlatformMetrics {
  final int totalUsers;
  final int totalCaregivers;
  final int totalPatients;
  final int newUsersThisMonth;
  final int activeUsers;
  final double totalMonthlyRevenue;
  final double totalYearlyRevenue;
  final double averageRevenuePerUser;
  final double projectedGrowth;

  PlatformMetrics({
    required this.totalUsers,
    required this.totalCaregivers,
    required this.totalPatients,
    required this.newUsersThisMonth,
    required this.activeUsers,
    required this.totalMonthlyRevenue,
    required this.totalYearlyRevenue,
    required this.averageRevenuePerUser,
    required this.projectedGrowth,
  });
}

class SubscriptionMetrics {
  final int freeUsers;
  final int basicUsers;
  final int plusUsers;
  final int premiumUsers;
  final double conversionRate;
  final int totalPaidUsers;

  SubscriptionMetrics({
    required this.freeUsers,
    required this.basicUsers,
    required this.plusUsers,
    required this.premiumUsers,
    required this.conversionRate,
    required this.totalPaidUsers,
  });
}

class ContractMetrics {
  final int totalContracts;
  final int completedContracts;
  final int activeContracts;
  final double averageContractValue;
  final double platformCommission;
  final double totalCommissionEarned;

  ContractMetrics({
    required this.totalContracts,
    required this.completedContracts,
    required this.activeContracts,
    required this.averageContractValue,
    required this.platformCommission,
    required this.totalCommissionEarned,
  });
}

class EngagementMetrics {
  final int dailyActiveUsers;
  final int weeklyActiveUsers;
  final int monthlyActiveUsers;
  final double averageSessionTime;
  final int totalChatMessages;

  EngagementMetrics({
    required this.dailyActiveUsers,
    required this.weeklyActiveUsers,
    required this.monthlyActiveUsers,
    required this.averageSessionTime,
    required this.totalChatMessages,
  });
}

class ChartData {
  final String month;
  final int caregivers;
  final int patients;

  ChartData(this.month, this.caregivers, this.patients);
}

class RevenueData {
  final String month;
  final double revenue;
  final double commission;

  RevenueData(this.month, this.revenue, this.commission);
}

class TopCaregiver {
  final String id;
  final String name;
  final double totalEarnings;
  final int contractsCompleted;
  final double rating;
  final SubscriptionTier subscriptionTier;

  TopCaregiver({
    required this.id,
    required this.name,
    required this.totalEarnings,
    required this.contractsCompleted,
    required this.rating,
    required this.subscriptionTier,
  });
}

class AdminAlert {
  final AlertType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final AlertPriority priority;

  AdminAlert({
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.priority,
  });
}

class KPI {
  final String name;
  final double value;
  final KPIFormat format;
  final KPITrend trend;
  final double changePercent;

  KPI({
    required this.name,
    required this.value,
    required this.format,
    required this.trend,
    required this.changePercent,
  });
}

// ===== ENUMS =====

enum AlertType { info, warning, error, success }
enum AlertPriority { low, medium, high, critical }
enum KPIFormat { currency, percentage, number }
enum KPITrend { up, down, stable }
