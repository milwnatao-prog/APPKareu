import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../widgets/animated_list.dart';
import 'caregiver_chat_screen.dart';

class HomeProfessionalScreen extends StatefulWidget {
  const HomeProfessionalScreen({super.key});

  @override
  State<HomeProfessionalScreen> createState() => _HomeProfessionalScreenState();
}

class _HomeProfessionalScreenState extends State<HomeProfessionalScreen> 
    with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true; // Otimização: manter estado vivo

  @override
  void initState() {
    super.initState();
    // Definir tipo de usuário como cuidador
    UserService.setUserType(UserType.amCaregiver);
    _calculateStatistics();
  }
  
  // Dados sincronizados com o chat do cuidador
  final List<PatientData> _patients = [
    PatientData(
      name: 'Família Silva',
      info: 'Dona Maria, 78 anos',
      service: 'Acompanhamento domiciliar',
      nextAppointment: 'Hoje às 14:30',
      status: PatientStatus.active,
      hasUnreadMessages: true,
      rating: 4.8,
      totalHours: 45,
      isFamily: true,
    ),
    PatientData(
      name: 'João Santos',
      info: '65 anos - Acompanhamento',
      service: 'Cuidados especializados',
      nextAppointment: 'Amanhã às 09:00',
      status: PatientStatus.active,
      hasUnreadMessages: true,
      rating: 4.9,
      totalHours: 32,
      isFamily: false,
    ),
    PatientData(
      name: 'Família Costa',
      info: 'Sr. Pedro, 82 anos',
      service: 'Fisioterapia domiciliar',
      nextAppointment: 'Segunda às 10:00',
      status: PatientStatus.scheduled,
      hasUnreadMessages: false,
      rating: 4.7,
      totalHours: 28,
      isFamily: true,
    ),
    PatientData(
      name: 'Ana Oliveira',
      info: '70 anos - Fisioterapia',
      service: 'Exercícios terapêuticos',
      nextAppointment: 'Terça às 15:00',
      status: PatientStatus.completed,
      hasUnreadMessages: false,
      rating: 5.0,
      totalHours: 18,
      isFamily: false,
    ),
  ];

  // Estatísticas calculadas dinamicamente
  late Map<String, dynamic> _statistics;


  void _calculateStatistics() {
    final activePatients = _patients.where((p) => p.status == PatientStatus.active).length;
    final totalHours = _patients.fold(0, (sum, p) => sum + p.totalHours);
    final averageRating = _patients.fold(0.0, (sum, p) => sum + p.rating) / _patients.length;
    final unreadMessages = _patients.where((p) => p.hasUnreadMessages).length;
    
    _statistics = {
      'activePatients': activePatients,
      'totalHours': totalHours,
      'averageRating': averageRating,
      'unreadMessages': unreadMessages,
      'weeklyEarnings': (totalHours * 25.0), // R$ 25/hora estimado
      'completedServices': _patients.where((p) => p.status == PatientStatus.completed).length,
    };
  }


  void _onTabSelected(int index) {
    switch (index) {
      case 0:
        // Já estamos na tela inicial
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Você já está na tela inicial'),
            duration: Duration(seconds: 1),
          ),
        );
        break;
      case 1:
        // Navegar para Chat do Cuidador
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CaregiverChatScreen(),
          ),
        );
        break;
      case 2:
        // Navegar para Lista de Pacientes
        Navigator.pushNamed(context, '/patients-list');
        break;
      case 3:
        Navigator.pushNamed(context, '/caregiver-schedule');
        break;
      case 4:
        // Navegar para Configurações da Conta
        Navigator.pushNamed(context, '/professional-account');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Chamada obrigatória para AutomaticKeepAliveClientMixin
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDesignSystem.space2XL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    _buildWelcomeSection(),
                    
                    AppDesignSystem.verticalSpace(2),
                    
                    // Quick Stats
                    _buildQuickStats(),
                    
                    AppDesignSystem.verticalSpace(2),
                    
                    // Today's Schedule
                    _buildTodaySchedule(),
                    
                    AppDesignSystem.verticalSpace(2),
                    
                    // Active Patients
                    _buildActivePatients(),
                    
                    AppDesignSystem.verticalSpace(2),
                    
                    // Quick Actions
                    _buildQuickActions(),
                    
                    AppDesignSystem.verticalSpace(4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }


  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
      child: Row(
        children: [
          // Profile Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppDesignSystem.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppDesignSystem.primaryColor.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.person,
              color: AppDesignSystem.primaryColor,
              size: 28,
            ),
          ),
          
          AppDesignSystem.horizontalSpace(1),
          
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá, Cuidador!',
                  style: AppDesignSystem.h3Style.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Tenha um ótimo dia de trabalho',
                  style: AppDesignSystem.captionStyle.copyWith(
                    color: AppDesignSystem.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          
          // Notifications
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDesignSystem.spaceSM),
                decoration: BoxDecoration(
                  color: AppDesignSystem.surfaceColor,
                  borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: AppDesignSystem.textPrimaryColor,
                  size: 24,
                ),
              ),
              if (_statistics['unreadMessages'] > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppDesignSystem.errorColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    final now = DateTime.now();
    final greeting = now.hour < 12 ? 'Bom dia' : now.hour < 18 ? 'Boa tarde' : 'Boa noite';
    
    return AppDesignSystem.styledCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting!',
                  style: AppDesignSystem.h2Style.copyWith(
                    color: AppDesignSystem.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppDesignSystem.verticalSpace(0.5),
                Text(
                  'Você tem ${_statistics['activePatients']} pacientes ativos hoje',
                  style: AppDesignSystem.bodyStyle,
                ),
                AppDesignSystem.verticalSpace(0.5),
                Text(
                  'Próximo atendimento em 2 horas',
                  style: AppDesignSystem.bodySmallStyle.copyWith(
                    color: AppDesignSystem.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
            decoration: BoxDecoration(
              color: AppDesignSystem.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
            ),
            child: Icon(
              Icons.medical_services,
              color: AppDesignSystem.primaryColor,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumo do Mês',
          style: AppDesignSystem.h3Style.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppDesignSystem.verticalSpace(1),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Horas Trabalhadas',
                '${_statistics['totalHours']}h',
                Icons.access_time,
                AppDesignSystem.infoColor,
                () => _showStatDetails('hours'),
              ),
            ),
            AppDesignSystem.horizontalSpace(1),
            Expanded(
              child: _buildStatCard(
                'Avaliação Média',
                '${_statistics['averageRating'].toStringAsFixed(1)}⭐',
                Icons.star,
                AppDesignSystem.warningColor,
                () => _showStatDetails('rating'),
              ),
            ),
          ],
        ),
        AppDesignSystem.verticalSpace(1),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Ganhos Estimados',
                'R\$ ${_statistics['weeklyEarnings'].toStringAsFixed(0)}',
                Icons.attach_money,
                AppDesignSystem.successColor,
                () => _showStatDetails('earnings'),
              ),
            ),
            AppDesignSystem.horizontalSpace(1),
            Expanded(
              child: _buildStatCard(
                'Serviços Concluídos',
                '${_statistics['completedServices']}',
                Icons.check_circle,
                AppDesignSystem.primaryColor,
                () => _showStatDetails('completed'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AppDesignSystem.styledCard(
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            AppDesignSystem.verticalSpace(0.5),
            Text(
              value,
              style: AppDesignSystem.h3Style.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            AppDesignSystem.verticalSpace(0.25),
            Text(
              title,
              style: AppDesignSystem.captionStyle.copyWith(
                color: AppDesignSystem.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaySchedule() {
    final todayPatients = _patients.where((p) => 
      p.nextAppointment.contains('Hoje') || p.nextAppointment.contains('Amanhã')
    ).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Agenda de Hoje',
              style: AppDesignSystem.h3Style.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/caregiver-schedule'),
              child: Text(
                'Ver agenda completa',
                style: AppDesignSystem.bodySmallStyle.copyWith(
                  color: AppDesignSystem.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        AppDesignSystem.verticalSpace(1),
        if (todayPatients.isEmpty)
          AppDesignSystem.styledCard(
            child: Column(
              children: [
                Icon(
                  Icons.event_available,
                  color: AppDesignSystem.successColor,
                  size: 48,
                ),
                AppDesignSystem.verticalSpace(1),
                Text(
                  'Nenhum agendamento hoje',
                  style: AppDesignSystem.bodyStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppDesignSystem.verticalSpace(0.5),
                Text(
                  'Aproveite para descansar ou buscar novos clientes',
                  style: AppDesignSystem.bodySmallStyle.copyWith(
                    color: AppDesignSystem.textSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ...todayPatients.map((patient) => _buildScheduleCard(patient)).toList(),
      ],
    );
  }

  Widget _buildScheduleCard(PatientData patient) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDesignSystem.spaceSM),
      child: AppDesignSystem.styledCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesignSystem.spaceMD),
              decoration: BoxDecoration(
                color: patient.isFamily 
                  ? AppDesignSystem.warningColor.withValues(alpha: 0.1)
                  : AppDesignSystem.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
              ),
              child: Icon(
                patient.isFamily ? Icons.family_restroom : Icons.person,
                color: patient.isFamily 
                  ? AppDesignSystem.warningColor
                  : AppDesignSystem.primaryColor,
                size: 24,
              ),
            ),
            
            AppDesignSystem.horizontalSpace(1),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: AppDesignSystem.cardTitleStyle,
                  ),
                  AppDesignSystem.verticalSpace(0.25),
                  Text(
                    patient.service,
                    style: AppDesignSystem.bodySmallStyle.copyWith(
                      color: AppDesignSystem.textSecondaryColor,
                    ),
                  ),
                  AppDesignSystem.verticalSpace(0.25),
                  Text(
                    patient.nextAppointment,
                    style: AppDesignSystem.bodySmallStyle.copyWith(
                      color: AppDesignSystem.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            GestureDetector(
              onTap: () => _openPatientChat(patient),
              child: Container(
                padding: const EdgeInsets.all(AppDesignSystem.spaceSM),
                decoration: BoxDecoration(
                  color: AppDesignSystem.primaryColor,
                  borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                ),
                child: const Icon(
                  Icons.chat,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivePatients() {
    final activePatients = _patients.where((p) => p.status == PatientStatus.active).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Pacientes Ativos',
              style: AppDesignSystem.h3Style.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/chat'),
              child: Text(
                'Ver todos',
                style: AppDesignSystem.bodySmallStyle.copyWith(
                  color: AppDesignSystem.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        AppDesignSystem.verticalSpace(1),
        ...activePatients.take(3).map((patient) {
          return AnimatedCard(
            onTap: () => _openPatientChat(patient),
            child: _buildPatientCard(patient),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildPatientCard(PatientData patient) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDesignSystem.spaceSM),
      child: AppDesignSystem.styledCard(
        child: Row(
          children: [
            // Avatar with status
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: patient.isFamily 
                      ? AppDesignSystem.warningColor.withValues(alpha: 0.1)
                      : AppDesignSystem.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    patient.isFamily ? Icons.family_restroom : Icons.person,
                    color: patient.isFamily 
                      ? AppDesignSystem.warningColor
                      : AppDesignSystem.primaryColor,
                    size: 24,
                  ),
                ),
                if (patient.hasUnreadMessages)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppDesignSystem.errorColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            AppDesignSystem.horizontalSpace(1),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          patient.name,
                          style: AppDesignSystem.cardTitleStyle,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDesignSystem.spaceXS,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(patient.status).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getStatusText(patient.status),
                          style: AppDesignSystem.captionStyle.copyWith(
                            color: _getStatusColor(patient.status),
                            fontWeight: FontWeight.w600,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppDesignSystem.verticalSpace(0.25),
                  Text(
                    patient.info,
                    style: AppDesignSystem.bodySmallStyle.copyWith(
                      color: AppDesignSystem.textSecondaryColor,
                    ),
                  ),
                  AppDesignSystem.verticalSpace(0.25),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 12,
                        color: AppDesignSystem.warningColor,
                      ),
                      AppDesignSystem.horizontalSpace(0.25),
                      Text(
                        patient.rating.toString(),
                        style: AppDesignSystem.captionStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      AppDesignSystem.horizontalSpace(1),
                      Text(
                        '${patient.totalHours}h trabalhadas',
                        style: AppDesignSystem.captionStyle.copyWith(
                          color: AppDesignSystem.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            GestureDetector(
              onTap: () => _openPatientChat(patient),
              child: Container(
                padding: const EdgeInsets.all(AppDesignSystem.spaceSM),
                decoration: BoxDecoration(
                  color: AppDesignSystem.primaryColor,
                  borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                ),
                child: const Icon(
                  Icons.chat,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ações Rápidas',
          style: AppDesignSystem.h3Style.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppDesignSystem.verticalSpace(1),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Assinatura Premium',
                'Acesse recursos exclusivos',
                Icons.workspace_premium,
                AppDesignSystem.warningColor,
                () => Navigator.pushNamed(context, '/caregiver-payment'),
              ),
            ),
            AppDesignSystem.horizontalSpace(1),
            Expanded(
              child: _buildActionCard(
                'Nova Agenda',
                'Configurar disponibilidade',
                Icons.calendar_today,
                AppDesignSystem.infoColor,
                () => Navigator.pushNamed(context, '/caregiver-schedule'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AppDesignSystem.styledCard(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesignSystem.spaceMD),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            AppDesignSystem.verticalSpace(1),
            Text(
              title,
              style: AppDesignSystem.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            AppDesignSystem.verticalSpace(0.25),
            Text(
              subtitle,
              style: AppDesignSystem.captionStyle.copyWith(
                color: AppDesignSystem.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
      decoration: BoxDecoration(
        color: AppDesignSystem.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, 'Início', 0, isSelected: true),
          _buildNavItem(Icons.chat_bubble_outline, 'Chat', 1),
          _buildNavItem(Icons.people_outline, 'Clientes', 2),
          _buildNavItem(Icons.calendar_today, 'Agenda', 3),
          _buildNavItem(Icons.account_circle_outlined, 'Perfil', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesignSystem.spaceMD,
          vertical: AppDesignSystem.spaceSM,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected 
                ? AppDesignSystem.primaryColor 
                : AppDesignSystem.textSecondaryColor,
              size: 24,
            ),
            const SizedBox(height: AppDesignSystem.spaceXS),
            Text(
              label,
              style: AppDesignSystem.captionStyle.copyWith(
                color: isSelected 
                  ? AppDesignSystem.primaryColor 
                  : AppDesignSystem.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Métodos auxiliares
  Color _getStatusColor(PatientStatus status) {
    switch (status) {
      case PatientStatus.active:
        return AppDesignSystem.successColor;
      case PatientStatus.scheduled:
        return AppDesignSystem.infoColor;
      case PatientStatus.completed:
        return AppDesignSystem.textSecondaryColor;
    }
  }

  String _getStatusText(PatientStatus status) {
    switch (status) {
      case PatientStatus.active:
        return 'ATIVO';
      case PatientStatus.scheduled:
        return 'AGENDADO';
      case PatientStatus.completed:
        return 'CONCLUÍDO';
    }
  }

  void _openPatientChat(PatientData patient) {
    Navigator.pushNamed(context, '/chat');
  }

  void _showStatDetails(String type) {
    String title;
    String content;
    
    switch (type) {
      case 'hours':
        title = 'Horas Trabalhadas';
        content = 'Total de ${_statistics['totalHours']} horas trabalhadas este mês.\n\nMédia de ${(_statistics['totalHours'] / 30).toStringAsFixed(1)} horas por dia.';
        break;
      case 'rating':
        title = 'Avaliação Média';
        content = 'Sua avaliação média é ${_statistics['averageRating'].toStringAsFixed(1)} estrelas.\n\nBaseado em avaliações de ${_patients.length} pacientes.';
        break;
      case 'earnings':
        title = 'Ganhos Estimados';
        content = 'Ganhos estimados: R\$ ${_statistics['weeklyEarnings'].toStringAsFixed(2)}\n\nBaseado em ${_statistics['totalHours']} horas × R\$ 25,00/hora.';
        break;
      case 'completed':
        title = 'Serviços Concluídos';
        content = '${_statistics['completedServices']} serviços concluídos com sucesso.\n\nTaxa de conclusão: 100%';
        break;
      default:
        title = 'Detalhes';
        content = 'Informações detalhadas não disponíveis.';
    }
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppDesignSystem.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
          ),
          title: Text(title, style: AppDesignSystem.h3Style),
          content: Text(content, style: AppDesignSystem.bodyStyle),
          actions: [
            AppDesignSystem.primaryButton(
              text: 'Fechar',
              onPressed: () => Navigator.of(context).pop(),
              height: 40,
            ),
          ],
        );
      },
    );
  }
}

// Classes de modelo
enum PatientStatus {
  active,
  scheduled,
  completed,
}

class PatientData {
  final String name;
  final String info;
  final String service;
  final String nextAppointment;
  final PatientStatus status;
  final bool hasUnreadMessages;
  final double rating;
  final int totalHours;
  final bool isFamily;

  PatientData({
    required this.name,
    required this.info,
    required this.service,
    required this.nextAppointment,
    required this.status,
    required this.hasUnreadMessages,
    required this.rating,
    required this.totalHours,
    required this.isFamily,
  });
}
