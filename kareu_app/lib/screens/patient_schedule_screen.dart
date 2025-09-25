import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';

class PatientScheduleScreen extends StatefulWidget {
  const PatientScheduleScreen({super.key});

  @override
  State<PatientScheduleScreen> createState() => _PatientScheduleScreenState();
}

class _PatientScheduleScreenState extends State<PatientScheduleScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  int _currentIndex = 3; // Índice da agenda na navegação

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Mock data para agendamentos
  final List<ScheduleAppointment> _appointments = [
    ScheduleAppointment(
      id: '1',
      caregiverName: 'Maria Santos',
      caregiverPhoto: null,
      serviceType: 'Cuidados Gerais',
      date: DateTime.now(),
      startTime: '08:00',
      endTime: '12:00',
      status: AppointmentStatus.confirmed,
      location: 'Domicílio',
      description: 'Cuidados matinais, administração de medicamentos e atividades de vida diária',
    ),
    ScheduleAppointment(
      id: '2',
      caregiverName: 'Ana Costa',
      caregiverPhoto: null,
      serviceType: 'Fisioterapia',
      date: DateTime.now().add(const Duration(days: 1)),
      startTime: '14:00',
      endTime: '15:30',
      status: AppointmentStatus.pending,
      location: 'Domicílio',
      description: 'Sessão de fisioterapia para reabilitação motora',
    ),
    ScheduleAppointment(
      id: '3',
      caregiverName: 'João Silva',
      caregiverPhoto: null,
      serviceType: 'Acompanhamento Médico',
      date: DateTime.now().add(const Duration(days: 2)),
      startTime: '10:00',
      endTime: '11:00',
      status: AppointmentStatus.confirmed,
      location: 'Hospital do Coração',
      description: 'Acompanhamento em consulta cardiológica',
    ),
    ScheduleAppointment(
      id: '4',
      caregiverName: 'Maria Santos',
      caregiverPhoto: null,
      serviceType: 'Cuidados Gerais',
      date: DateTime.now().subtract(const Duration(days: 1)),
      startTime: '08:00',
      endTime: '12:00',
      status: AppointmentStatus.completed,
      location: 'Domicílio',
      description: 'Cuidados matinais realizados com sucesso',
    ),
  ];

  List<ScheduleAppointment> get _todayAppointments {
    return _appointments.where((apt) => 
      apt.date.year == DateTime.now().year &&
      apt.date.month == DateTime.now().month &&
      apt.date.day == DateTime.now().day
    ).toList();
  }

  List<ScheduleAppointment> get _upcomingAppointments {
    return _appointments.where((apt) => 
      apt.date.isAfter(DateTime.now()) &&
      apt.status != AppointmentStatus.completed
    ).toList();
  }

  List<ScheduleAppointment> get _pastAppointments {
    return _appointments.where((apt) => 
      apt.date.isBefore(DateTime.now()) ||
      apt.status == AppointmentStatus.completed
    ).toList();
  }

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;
    
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home-patient');
        break;
      case 1:
        Navigator.pushNamed(context, '/patient-chat');
        break;
      case 2:
        Navigator.pushNamed(context, '/contracts');
        break;
      case 3:
        // Já estamos na agenda
        break;
      case 4:
        Navigator.pushNamed(context, '/patient-account');
        break;
    }
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppDesignSystem.primaryColor,
            AppDesignSystem.accentColor,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Minha Agenda',
                    style: TextStyle(
                      fontSize: AppDesignSystem.fontSizeH1,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Ação para adicionar novo agendamento
                    _showAddAppointmentDialog();
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
            AppDesignSystem.verticalSpace(1),
            // Quick stats
            Row(
              children: [
                Expanded(
                  child: _buildQuickStat(
                    'Hoje',
                    _todayAppointments.length.toString(),
                    Icons.today,
                  ),
                ),
                AppDesignSystem.horizontalSpace(1),
                Expanded(
                  child: _buildQuickStat(
                    'Próximos',
                    _upcomingAppointments.length.toString(),
                    Icons.schedule,
                  ),
                ),
                AppDesignSystem.horizontalSpace(1),
                Expanded(
                  child: _buildQuickStat(
                    'Este Mês',
                    _appointments.length.toString(),
                    Icons.calendar_month,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppDesignSystem.spaceMD),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: AppDesignSystem.fontSizeH2,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: AppDesignSystem.fontSizeCaption,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabView() {
    return Expanded(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(AppDesignSystem.spaceLG),
            decoration: BoxDecoration(
              color: AppDesignSystem.surfaceColor,
              borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppDesignSystem.primaryColor,
              unselectedLabelColor: AppDesignSystem.textSecondaryColor,
              indicatorColor: AppDesignSystem.primaryColor,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontSize: AppDesignSystem.fontSizeBodySmall,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Hoje'),
                Tab(text: 'Próximos'),
                Tab(text: 'Histórico'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAppointmentsList(_todayAppointments, 'Nenhum agendamento para hoje'),
                _buildAppointmentsList(_upcomingAppointments, 'Nenhum agendamento próximo'),
                _buildAppointmentsList(_pastAppointments, 'Nenhum histórico disponível'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(List<ScheduleAppointment> appointments, String emptyMessage) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: AppDesignSystem.textSecondaryColor.withValues(alpha: 0.5),
            ),
            AppDesignSystem.verticalSpace(1),
            Text(
              emptyMessage,
              style: AppDesignSystem.bodyStyle.copyWith(
                color: AppDesignSystem.textSecondaryColor,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceLG),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return _buildAppointmentCard(appointments[index]);
      },
    );
  }

  Widget _buildAppointmentCard(ScheduleAppointment appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDesignSystem.spaceLG),
      child: AppDesignSystem.styledCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppDesignSystem.primaryColor,
                  child: appointment.caregiverPhoto != null
                    ? ClipOval(
                        child: Image.network(
                          appointment.caregiverPhoto!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24,
                      ),
                ),
                AppDesignSystem.horizontalSpace(1),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.caregiverName,
                        style: AppDesignSystem.cardTitleStyle,
                      ),
                      Text(
                        appointment.serviceType,
                        style: AppDesignSystem.cardSubtitleStyle,
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(appointment.status),
              ],
            ),
            AppDesignSystem.verticalSpace(1),
            Container(
              padding: const EdgeInsets.all(AppDesignSystem.spaceMD),
              decoration: BoxDecoration(
                color: AppDesignSystem.surfaceColor,
                borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppDesignSystem.textSecondaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${appointment.startTime} - ${appointment.endTime}',
                        style: AppDesignSystem.bodySmallStyle,
                      ),
                      const Spacer(),
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppDesignSystem.textSecondaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        appointment.location,
                        style: AppDesignSystem.bodySmallStyle,
                      ),
                    ],
                  ),
                  if (appointment.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      appointment.description,
                      style: AppDesignSystem.captionStyle,
                    ),
                  ],
                ],
              ),
            ),
            AppDesignSystem.verticalSpace(1),
            Row(
              children: [
                if (appointment.status == AppointmentStatus.pending) ...[
                  Expanded(
                    child: AppDesignSystem.secondaryButton(
                      text: 'Reagendar',
                      onPressed: () => _rescheduleAppointment(appointment),
                    ),
                  ),
                  AppDesignSystem.horizontalSpace(1),
                  Expanded(
                    child: AppDesignSystem.primaryButton(
                      text: 'Confirmar',
                      onPressed: () => _confirmAppointment(appointment),
                    ),
                  ),
                ] else if (appointment.status == AppointmentStatus.confirmed) ...[
                  Expanded(
                    child: AppDesignSystem.secondaryButton(
                      text: 'Detalhes',
                      onPressed: () => _viewAppointmentDetails(appointment),
                    ),
                  ),
                  AppDesignSystem.horizontalSpace(1),
                  Expanded(
                    child: AppDesignSystem.primaryButton(
                      text: 'Chat',
                      onPressed: () => Navigator.pushNamed(context, '/patient-chat'),
                    ),
                  ),
                ] else if (appointment.status == AppointmentStatus.completed) ...[
                  Expanded(
                    child: AppDesignSystem.secondaryButton(
                      text: 'Avaliar',
                      onPressed: () => _rateAppointment(appointment),
                    ),
                  ),
                  AppDesignSystem.horizontalSpace(1),
                  Expanded(
                    child: AppDesignSystem.primaryButton(
                      text: 'Reagendar',
                      onPressed: () => _rescheduleAppointment(appointment),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(AppointmentStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case AppointmentStatus.pending:
        backgroundColor = AppDesignSystem.warningColor.withValues(alpha: 0.1);
        textColor = AppDesignSystem.warningColor;
        text = 'Pendente';
        break;
      case AppointmentStatus.confirmed:
        backgroundColor = AppDesignSystem.successColor.withValues(alpha: 0.1);
        textColor = AppDesignSystem.successColor;
        text = 'Confirmado';
        break;
      case AppointmentStatus.completed:
        backgroundColor = AppDesignSystem.primaryColor.withValues(alpha: 0.1);
        textColor = AppDesignSystem.primaryColor;
        text = 'Concluído';
        break;
      case AppointmentStatus.cancelled:
        backgroundColor = AppDesignSystem.errorColor.withValues(alpha: 0.1);
        textColor = AppDesignSystem.errorColor;
        text = 'Cancelado';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppDesignSystem.fontSizeCaption,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppDesignSystem.primaryColor,
        unselectedItemColor: AppDesignSystem.textSecondaryColor,
        selectedLabelStyle: const TextStyle(
          fontSize: AppDesignSystem.fontSizeCaption,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: AppDesignSystem.fontSizeCaption,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            activeIcon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description),
            label: 'Contratos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  void _showAddAppointmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Novo Agendamento'),
          content: const Text('Funcionalidade em desenvolvimento.\nEm breve você poderá agendar novos cuidados diretamente pelo app.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Entendi'),
            ),
          ],
        );
      },
    );
  }

  void _confirmAppointment(ScheduleAppointment appointment) {
    setState(() {
      appointment.status = AppointmentStatus.confirmed;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Agendamento confirmado com sucesso!'),
        backgroundColor: AppDesignSystem.successColor,
      ),
    );
  }

  void _rescheduleAppointment(ScheduleAppointment appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reagendar'),
          content: const Text('Funcionalidade em desenvolvimento.\nEntre em contato com o cuidador pelo chat para reagendar.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Chat'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _viewAppointmentDetails(ScheduleAppointment appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalhes - ${appointment.caregiverName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Serviço: ${appointment.serviceType}'),
              const SizedBox(height: 8),
              Text('Data: ${appointment.date.day}/${appointment.date.month}/${appointment.date.year}'),
              const SizedBox(height: 8),
              Text('Horário: ${appointment.startTime} - ${appointment.endTime}'),
              const SizedBox(height: 8),
              Text('Local: ${appointment.location}'),
              const SizedBox(height: 8),
              Text('Descrição: ${appointment.description}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _rateAppointment(ScheduleAppointment appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Avaliar Atendimento'),
          content: const Text('Funcionalidade em desenvolvimento.\nEm breve você poderá avaliar os cuidadores.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Entendi'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      body: Column(
        children: [
          _buildHeader(),
          _buildTabView(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}

// Classes de modelo para os agendamentos
class ScheduleAppointment {
  final String id;
  final String caregiverName;
  final String? caregiverPhoto;
  final String serviceType;
  final DateTime date;
  final String startTime;
  final String endTime;
  AppointmentStatus status;
  final String location;
  final String description;

  ScheduleAppointment({
    required this.id,
    required this.caregiverName,
    this.caregiverPhoto,
    required this.serviceType,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.location,
    required this.description,
  });
}

enum AppointmentStatus {
  pending,
  confirmed,
  completed,
  cancelled,
}
