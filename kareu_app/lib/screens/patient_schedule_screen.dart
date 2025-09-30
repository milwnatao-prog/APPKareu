import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../constants/app_design_system.dart';
import '../widgets/custom_calendar.dart';

class PatientScheduleScreen extends StatefulWidget {
  const PatientScheduleScreen({super.key});

  @override
  State<PatientScheduleScreen> createState() => _PatientScheduleScreenState();
}

class _PatientScheduleScreenState extends State<PatientScheduleScreen> {
  // CalendarFormat removido - será usado pelo CustomCalendar
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime _firstDay = DateTime.now().subtract(const Duration(days: 365));
  DateTime _lastDay = DateTime.now().add(const Duration(days: 365));

  // Variáveis para controle do calendário
  CalendarFormat _calendarFormat = CalendarFormat.month;

  int _currentIndex = 3; // Índice da agenda na navegação

  // Mock data para agendamentos com mais detalhes sobre cuidados
  final Map<DateTime, List<ScheduleAppointment>> _appointments = {
    DateTime.now(): [
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
        careTypes: ['Higiene pessoal', 'Administração de medicamentos', 'Atividades de vida diária'],
        isRecurring: true,
        recurrencePattern: 'Segunda a Sexta',
      ),
    ],
    DateTime.now().add(const Duration(days: 1)): [
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
        careTypes: ['Fisioterapia', 'Exercícios de mobilidade'],
        isRecurring: false,
      ),
    ],
    DateTime.now().add(const Duration(days: 2)): [
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
        careTypes: ['Consulta médica', 'Exames de rotina'],
        isRecurring: false,
      ),
    ],
    DateTime.now().add(const Duration(days: 3)): [
      ScheduleAppointment(
        id: '4',
        caregiverName: 'Maria Santos',
        caregiverPhoto: null,
        serviceType: 'Cuidados Gerais',
        date: DateTime.now().add(const Duration(days: 3)),
        startTime: '08:00',
        endTime: '12:00',
        status: AppointmentStatus.confirmed,
        location: 'Domicílio',
        description: 'Cuidados matinais realizados com sucesso',
        careTypes: ['Higiene pessoal', 'Administração de medicamentos'],
        isRecurring: true,
        recurrencePattern: 'Segunda a Sexta',
      ),
    ],
    DateTime.now().add(const Duration(days: 4)): [
      ScheduleAppointment(
        id: '5',
        caregiverName: 'Carlos Oliveira',
        caregiverPhoto: null,
        serviceType: 'Enfermagem',
        date: DateTime.now().add(const Duration(days: 4)),
        startTime: '16:00',
        endTime: '18:00',
        status: AppointmentStatus.confirmed,
        location: 'Domicílio',
        description: 'Cuidados de enfermagem especializados',
        careTypes: ['Curativos', 'Monitoramento de sinais vitais', 'Administração de medicamentos injetáveis'],
        isRecurring: true,
        recurrencePattern: 'Segunda, Quarta, Sexta',
      ),
    ],
  };

  List<ScheduleAppointment> _getAppointmentsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _appointments[normalizedDay] ?? [];
  }

  List<ScheduleAppointment> get _upcomingAppointments {
    final today = DateTime.now();
    final upcoming = <ScheduleAppointment>[];

    for (var entry in _appointments.entries) {
      if (entry.key.isAfter(today) || (entry.key.isAtSameMomentAs(today))) {
        upcoming.addAll(entry.value.where((apt) => apt.status != AppointmentStatus.completed));
      }
    }

    upcoming.sort((a, b) => a.date.compareTo(b.date));
    return upcoming;
  }

  List<ScheduleAppointment> get _pastAppointments {
    final today = DateTime.now();
    final past = <ScheduleAppointment>[];

    for (var entry in _appointments.entries) {
      if (entry.key.isBefore(today)) {
        past.addAll(entry.value.where((apt) => apt.status == AppointmentStatus.completed));
      }
    }

    past.sort((a, b) => b.date.compareTo(a.date));
    return past;
  }

  int _getAppointmentCountForDay(DateTime day) {
    return _getAppointmentsForDay(day).length;
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
    final todayCount = _getAppointmentCountForDay(DateTime.now());
    final upcomingCount = _upcomingAppointments.length;
    final totalCount = _appointments.values.fold(0, (sum, list) => sum + list.length);

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
                    todayCount.toString(),
                    Icons.today,
                  ),
                ),
                AppDesignSystem.horizontalSpace(1),
                Expanded(
                  child: _buildQuickStat(
                    'Próximos',
                    upcomingCount.toString(),
                    Icons.schedule,
                  ),
                ),
                AppDesignSystem.horizontalSpace(1),
                Expanded(
                  child: _buildQuickStat(
                    'Total',
                    totalCount.toString(),
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



  Widget _buildAppointmentCard(ScheduleAppointment appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDesignSystem.spaceLG),
      child: AppDesignSystem.styledCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com cuidador e status
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
                Column(
                  children: [
                    _buildStatusChip(appointment.status),
                    if (appointment.isRecurring && appointment.recurrencePattern != null) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppDesignSystem.accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Recorrente',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppDesignSystem.accentColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),

            AppDesignSystem.verticalSpace(1),

            // Horário e localização
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
                  if (appointment.recurrencePattern != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.repeat,
                          size: 14,
                          color: AppDesignSystem.accentColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          appointment.recurrencePattern!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppDesignSystem.accentColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Tipos de cuidados
            if (appointment.careTypes.isNotEmpty) ...[
              AppDesignSystem.verticalSpace(1),
              Container(
                padding: const EdgeInsets.all(AppDesignSystem.spaceMD),
                decoration: BoxDecoration(
                  color: AppDesignSystem.primaryColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.medical_services,
                          size: 16,
                          color: AppDesignSystem.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Cuidados Prestados',
                          style: TextStyle(
                            fontSize: AppDesignSystem.fontSizeBodySmall,
                            fontWeight: FontWeight.w600,
                            color: AppDesignSystem.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: appointment.careTypes.map((careType) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppDesignSystem.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            careType,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppDesignSystem.primaryColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],

            // Descrição
            if (appointment.description.isNotEmpty) ...[
              AppDesignSystem.verticalSpace(1),
              Text(
                appointment.description,
                style: AppDesignSystem.captionStyle,
              ),
            ],

            AppDesignSystem.verticalSpace(1),

            // Botões de ação
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

  Widget _buildCalendarView() {
    return Column(
      children: [
        CustomCalendar(
          viewType: CalendarViewType.patient,
          selectedDay: _selectedDay,
          focusedDay: _focusedDay,
          calendarFormat: CalendarFormat.month,
          events: _appointments,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),

        // Legenda do calendário
        _buildCalendarLegend(),
      ],
    );
  }

  Widget _buildCalendarLegend() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppDesignSystem.successColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Agendado',
                style: AppDesignSystem.captionStyle,
              ),
            ],
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppDesignSystem.warningColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Pendente',
                style: AppDesignSystem.captionStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList() {
    final selectedAppointments = _selectedDay != null
        ? _getAppointmentsForDay(_selectedDay!)
        : _getAppointmentsForDay(DateTime.now());

    if (selectedAppointments.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event_note,
                size: 64,
                color: AppDesignSystem.textSecondaryColor.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Nenhum agendamento para este dia',
                style: AppDesignSystem.bodyStyle.copyWith(
                  color: AppDesignSystem.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
        itemCount: selectedAppointments.length,
        itemBuilder: (context, index) {
          return _buildAppointmentCard(selectedAppointments[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      body: Column(
        children: [
          _buildHeader(),
          _buildCalendarView(),
          _buildAppointmentsList(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Método para obter eventos do dia para o calendário
  List<dynamic> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _appointments[normalizedDay] ?? [];
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
  final List<String> careTypes;
  final bool isRecurring;
  final String? recurrencePattern;

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
    this.careTypes = const [],
    this.isRecurring = false,
    this.recurrencePattern,
  });
}

enum AppointmentStatus {
  pending,
  confirmed,
  completed,
  cancelled,
}
