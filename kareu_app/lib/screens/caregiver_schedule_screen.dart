import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';
import '../services/user_service.dart';

class CaregiverScheduleScreen extends StatefulWidget {
  const CaregiverScheduleScreen({super.key});

  @override
  State<CaregiverScheduleScreen> createState() => _CaregiverScheduleScreenState();
}

class _CaregiverScheduleScreenState extends State<CaregiverScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();

  // Dados de exemplo da agenda
  final Map<DateTime, ScheduleDay> _schedule = {};

  @override
  void initState() {
    super.initState();
    // Definir tipo de usuário como cuidador
    UserService.setUserType(UserType.caregiver);
    _initializeSchedule();
  }

  void _initializeSchedule() {
    final now = DateTime.now();
    
    // Otimização: Gerar apenas dados do mês atual e próximo
    _generateScheduleForMonth(now);
    _generateScheduleForMonth(DateTime(now.year, now.month + 1));
  }

  void _generateScheduleForMonth(DateTime month) {
    final endOfMonth = DateTime(month.year, month.month + 1, 0);

    // Gerar dados de exemplo para o mês
    for (int day = 1; day <= endOfMonth.day; day++) {
      final date = DateTime(month.year, month.month, day);
      
      // Simular alguns dias com agendamentos
      if (day % 3 == 0) {
        _schedule[date] = ScheduleDay(
          date: date,
          type: ScheduleType.patient,
          appointments: [
            Appointment(
              patientName: _getRandomPatientName(day),
              time: _getRandomTimeSlot(day),
              service: _getRandomService(day),
              status: _getRandomStatus(day),
              address: _getRandomAddress(day),
            ),
          ],
        );
      } else if (day % 5 == 0) {
        _schedule[date] = ScheduleDay(
          date: date,
          type: ScheduleType.patient,
          appointments: [
            Appointment(
              patientName: 'João Santos',
              time: '14:00 - 18:00',
              service: 'Cuidados com idoso',
              status: AppointmentStatus.pending,
              address: 'Av. Principal, 456',
            ),
          ],
        );
      } else if (day % 7 == 0) {
        _schedule[date] = ScheduleDay(
          date: date,
          type: ScheduleType.unavailable,
          appointments: [],
        );
      } else {
        _schedule[date] = ScheduleDay(
          date: date,
          type: ScheduleType.available,
          appointments: [],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Calendar Header
            _buildCalendarHeader(),
            
            // Calendar
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildCalendar(),
                    
                    AppDesignSystem.verticalSpace(1),
                    
                    // Day Details
                    _buildDayDetails(),
                    
                    AppDesignSystem.verticalSpace(2),
                  ],
                ),
              ),
            ),
            
            // Bottom Navigation
            _buildProfessionalBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(AppDesignSystem.spaceSM),
              decoration: BoxDecoration(
                color: AppDesignSystem.surfaceColor,
                borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
              ),
              child: Icon(
                Icons.arrow_back_ios,
                color: AppDesignSystem.textPrimaryColor,
                size: 20,
              ),
            ),
          ),
          
          const SizedBox(width: AppDesignSystem.spaceLG),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Minha Agenda',
                  style: AppDesignSystem.h2Style,
                ),
                Text(
                  'Escala de trabalho e agendamentos',
                  style: AppDesignSystem.captionStyle.copyWith(
                    color: AppDesignSystem.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // Add availability button
          GestureDetector(
            onTap: _showAvailabilityDialog,
            child: Container(
              padding: const EdgeInsets.all(AppDesignSystem.spaceSM),
              decoration: BoxDecoration(
                color: AppDesignSystem.primaryColor,
                borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceLG),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _previousMonth,
            child: Container(
              padding: const EdgeInsets.all(AppDesignSystem.spaceSM),
              decoration: BoxDecoration(
                color: AppDesignSystem.surfaceColor,
                borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
              ),
              child: Icon(
                Icons.chevron_left,
                color: AppDesignSystem.textPrimaryColor,
              ),
            ),
          ),
          
          Text(
            _getMonthYear(_currentMonth),
            style: AppDesignSystem.h3Style.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          GestureDetector(
            onTap: _nextMonth,
            child: Container(
              padding: const EdgeInsets.all(AppDesignSystem.spaceSM),
              decoration: BoxDecoration(
                color: AppDesignSystem.surfaceColor,
                borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
              ),
              child: Icon(
                Icons.chevron_right,
                color: AppDesignSystem.textPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
      child: AppDesignSystem.styledCard(
        child: Column(
          children: [
            // Weekday headers
            Row(
              children: ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb']
                  .map((day) => Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.spaceSM),
                          child: Text(
                            day,
                            style: AppDesignSystem.captionStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppDesignSystem.textSecondaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ))
                  .toList(),
            ),
            
            const Divider(color: AppDesignSystem.borderColor),
            
            // Calendar days
            ..._buildCalendarWeeks(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCalendarWeeks() {
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday % 7;
    
    List<Widget> weeks = [];
    List<Widget> currentWeek = [];
    
    // Add empty cells for days before the first day of the month
    for (int i = 0; i < firstDayWeekday; i++) {
      currentWeek.add(Expanded(child: Container()));
    }
    
    // Add days of the month
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      currentWeek.add(Expanded(
        child: _buildCalendarDay(date),
      ));
      
      if (currentWeek.length == 7) {
        weeks.add(Row(children: currentWeek));
        currentWeek = [];
      }
    }
    
    // Add empty cells for remaining days
    while (currentWeek.length < 7) {
      currentWeek.add(Expanded(child: Container()));
    }
    if (currentWeek.isNotEmpty) {
      weeks.add(Row(children: currentWeek));
    }
    
    return weeks;
  }

  Widget _buildCalendarDay(DateTime date) {
    final scheduleDay = _schedule[date];
    final isSelected = _isSameDay(date, _selectedDate);
    final isToday = _isSameDay(date, DateTime.now());
    
    Color backgroundColor = Colors.transparent;
    Color textColor = AppDesignSystem.textPrimaryColor;
    Color? indicatorColor;
    
    if (isSelected) {
      backgroundColor = AppDesignSystem.primaryColor;
      textColor = Colors.white;
    } else if (isToday) {
      backgroundColor = AppDesignSystem.primaryColor.withValues(alpha: 0.1);
      textColor = AppDesignSystem.primaryColor;
    }
    
    if (scheduleDay != null) {
      switch (scheduleDay.type) {
        case ScheduleType.patient:
          indicatorColor = AppDesignSystem.successColor;
          break;
        case ScheduleType.available:
          indicatorColor = AppDesignSystem.infoColor;
          break;
        case ScheduleType.unavailable:
          indicatorColor = AppDesignSystem.errorColor;
          break;
      }
    }
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              date.day.toString(),
              style: AppDesignSystem.bodySmallStyle.copyWith(
                color: textColor,
                fontWeight: isSelected || isToday ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (indicatorColor != null)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : indicatorColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayDetails() {
    final scheduleDay = _schedule[_selectedDate];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _getFormattedDate(_selectedDate),
                style: AppDesignSystem.h3Style.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              _buildStatusChip(scheduleDay?.type ?? ScheduleType.available),
            ],
          ),
          
          AppDesignSystem.verticalSpace(1),
          
          if (scheduleDay?.appointments.isNotEmpty == true) ...[
            Text(
              'Agendamentos',
              style: AppDesignSystem.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            AppDesignSystem.verticalSpace(0.5),
            ...scheduleDay!.appointments.map((appointment) => 
              _buildAppointmentCard(appointment)
            ).toList(),
          ] else ...[
            AppDesignSystem.styledCard(
              child: Column(
                children: [
                  Icon(
                    scheduleDay?.type == ScheduleType.unavailable 
                      ? Icons.event_busy 
                      : Icons.event_available,
                    color: scheduleDay?.type == ScheduleType.unavailable 
                      ? AppDesignSystem.errorColor 
                      : AppDesignSystem.successColor,
                    size: 48,
                  ),
                  AppDesignSystem.verticalSpace(1),
                  Text(
                    scheduleDay?.type == ScheduleType.unavailable 
                      ? 'Dia indisponível'
                      : 'Nenhum agendamento',
                    style: AppDesignSystem.bodyStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppDesignSystem.verticalSpace(0.5),
                  Text(
                    scheduleDay?.type == ScheduleType.unavailable 
                      ? 'Você marcou este dia como indisponível'
                      : 'Você está disponível para novos agendamentos',
                    style: AppDesignSystem.bodySmallStyle.copyWith(
                      color: AppDesignSystem.textSecondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (scheduleDay?.type != ScheduleType.unavailable) ...[
                    AppDesignSystem.verticalSpace(1),
                    AppDesignSystem.primaryButton(
                      text: 'Marcar como Indisponível',
                      onPressed: () => _toggleAvailability(_selectedDate),
                      height: 40,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChip(ScheduleType type) {
    String text;
    Color color;
    
    switch (type) {
      case ScheduleType.patient:
        text = 'Com Paciente';
        color = AppDesignSystem.successColor;
        break;
      case ScheduleType.available:
        text = 'Disponível';
        color = AppDesignSystem.infoColor;
        break;
      case ScheduleType.unavailable:
        text = 'Indisponível';
        color = AppDesignSystem.errorColor;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignSystem.spaceMD,
        vertical: AppDesignSystem.spaceXS,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
      ),
      child: Text(
        text,
        style: AppDesignSystem.captionStyle.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDesignSystem.spaceSM),
      child: AppDesignSystem.styledCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDesignSystem.spaceSM),
                  decoration: BoxDecoration(
                    color: _getStatusColor(appointment.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                  ),
                  child: Icon(
                    Icons.person,
                    color: _getStatusColor(appointment.status),
                    size: 20,
                  ),
                ),
                AppDesignSystem.horizontalSpace(1),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.patientName,
                        style: AppDesignSystem.cardTitleStyle,
                      ),
                      Text(
                        appointment.time,
                        style: AppDesignSystem.bodySmallStyle.copyWith(
                          color: AppDesignSystem.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(appointment.status),
              ],
            ),
            
            AppDesignSystem.verticalSpace(1),
            
            Text(
              appointment.service,
              style: AppDesignSystem.bodySmallStyle.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            
            AppDesignSystem.verticalSpace(0.5),
            
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppDesignSystem.textSecondaryColor,
                ),
                AppDesignSystem.horizontalSpace(0.5),
                Expanded(
                  child: Text(
                    appointment.address,
                    style: AppDesignSystem.captionStyle.copyWith(
                      color: AppDesignSystem.textSecondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(AppointmentStatus status) {
    String text;
    Color color;
    
    switch (status) {
      case AppointmentStatus.confirmed:
        text = 'Confirmado';
        color = AppDesignSystem.successColor;
        break;
      case AppointmentStatus.pending:
        text = 'Pendente';
        color = AppDesignSystem.warningColor;
        break;
      case AppointmentStatus.cancelled:
        text = 'Cancelado';
        color = AppDesignSystem.errorColor;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignSystem.spaceXS,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
      ),
      child: Text(
        text,
        style: AppDesignSystem.captionStyle.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 9,
        ),
      ),
    );
  }

  Widget _buildProfessionalBottomNavigation() {
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
          _buildNavItem(Icons.home_outlined, 'Início', 0),
          _buildNavItem(Icons.chat_bubble_outline, 'Chat', 1),
          _buildNavItem(Icons.people_outline, 'Clientes', 2),
          _buildNavItem(Icons.calendar_today, 'Agenda', 3, isSelected: true),
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

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.confirmed:
        return AppDesignSystem.successColor;
      case AppointmentStatus.pending:
        return AppDesignSystem.warningColor;
      case AppointmentStatus.cancelled:
        return AppDesignSystem.errorColor;
    }
  }

  String _getMonthYear(DateTime date) {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril',
      'Maio', 'Junho', 'Julho', 'Agosto',
      'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _getFormattedDate(DateTime date) {
    const weekdays = [
      'Segunda', 'Terça', 'Quarta', 'Quinta',
      'Sexta', 'Sábado', 'Domingo'
    ];
    const months = [
      'Jan', 'Fev', 'Mar', 'Abr',
      'Mai', 'Jun', 'Jul', 'Ago',
      'Set', 'Out', 'Nov', 'Dez'
    ];
    
    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    
    return '$weekday, ${date.day} de $month';
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
      _initializeSchedule();
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
      _initializeSchedule();
    });
  }

  void _toggleAvailability(DateTime date) {
    setState(() {
      final currentSchedule = _schedule[date];
      if (currentSchedule?.type == ScheduleType.unavailable) {
        _schedule[date] = ScheduleDay(
          date: date,
          type: ScheduleType.available,
          appointments: [],
        );
      } else {
        _schedule[date] = ScheduleDay(
          date: date,
          type: ScheduleType.unavailable,
          appointments: [],
        );
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _schedule[date]?.type == ScheduleType.unavailable 
            ? 'Dia marcado como indisponível'
            : 'Dia marcado como disponível',
          style: AppDesignSystem.bodySmallStyle.copyWith(color: Colors.white),
        ),
        backgroundColor: AppDesignSystem.primaryColor,
      ),
    );
  }

  void _showAvailabilityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppDesignSystem.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
          ),
          title: Text('Configurar Disponibilidade', style: AppDesignSystem.h3Style),
          content: Text(
            'Em breve você poderá configurar sua disponibilidade semanal e horários de trabalho.',
            style: AppDesignSystem.bodyStyle,
          ),
          actions: [
            AppDesignSystem.primaryButton(
              text: 'Entendi',
              onPressed: () => Navigator.of(context).pop(),
              height: 40,
            ),
          ],
        );
      },
    );
  }

  void _onTabSelected(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home-professional');
        break;
      case 1:
        Navigator.pushNamed(context, '/chat');
        break;
      case 2:
        Navigator.pushNamed(context, '/patients-list');
        break;
      case 3:
        // Já estamos na agenda
        break;
      case 4:
        Navigator.pushNamed(context, '/professional-account');
        break;
    }
  }

  // Métodos auxiliares para otimização
  String _getRandomPatientName(int day) {
    final names = ['Maria Silva', 'João Santos', 'Ana Costa', 'Pedro Lima', 'Isabel Moreira'];
    return names[day % names.length];
  }

  String _getRandomTimeSlot(int day) {
    final slots = ['09:00 - 13:00', '14:00 - 18:00', '08:00 - 12:00', '15:00 - 19:00'];
    return slots[day % slots.length];
  }

  String _getRandomService(int day) {
    final services = [
      'Acompanhamento domiciliar',
      'Cuidados pós-operatórios',
      'Fisioterapia',
      'Acompanhamento médico',
      'Cuidados gerais'
    ];
    return services[day % services.length];
  }

  AppointmentStatus _getRandomStatus(int day) {
    final statuses = [
      AppointmentStatus.confirmed,
      AppointmentStatus.pending,
      AppointmentStatus.confirmed,
      AppointmentStatus.confirmed,
    ];
    return statuses[day % statuses.length];
  }

  String _getRandomAddress(int day) {
    final addresses = [
      'Rua das Flores, 123',
      'Av. Principal, 456',
      'Rua do Centro, 789',
      'Av. das Palmeiras, 321',
      'Rua São José, 654'
    ];
    return addresses[day % addresses.length];
  }
}

// Classes de modelo
enum ScheduleType {
  available,
  patient,
  unavailable,
}

enum AppointmentStatus {
  confirmed,
  pending,
  cancelled,
}

class ScheduleDay {
  final DateTime date;
  final ScheduleType type;
  final List<Appointment> appointments;

  ScheduleDay({
    required this.date,
    required this.type,
    required this.appointments,
  });
}

class Appointment {
  final String patientName;
  final String time;
  final String service;
  final AppointmentStatus status;
  final String address;

  Appointment({
    required this.patientName,
    required this.time,
    required this.service,
    required this.status,
    required this.address,
  });
}
