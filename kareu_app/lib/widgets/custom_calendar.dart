import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../constants/app_design_system.dart';

// Será definido na tela do paciente
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
  cancelled,
  completed,
}

enum CalendarViewType {
  professional, // Para cuidadores - foco em disponibilidade
  patient,      // Para pacientes - foco em agendamentos
}

class CustomCalendar extends StatefulWidget {
  final CalendarViewType viewType;
  final DateTime? selectedDay;
  final DateTime focusedDay;
  final CalendarFormat calendarFormat;
  final Map<DateTime, List<dynamic>>? events;
  final Function(DateTime, DateTime)? onDaySelected;
  final Function(CalendarFormat)? onFormatChanged;
  final Function(DateTime)? onPageChanged;
  final bool showTodayButton;
  final bool showNavigation;
  final List<String>? availableDays; // Para profissionais - dias disponíveis
  final Map<DateTime, ScheduleDay>? scheduleData; // Para profissionais

  const CustomCalendar({
    super.key,
    this.viewType = CalendarViewType.patient,
    this.selectedDay,
    required this.focusedDay,
    this.calendarFormat = CalendarFormat.month,
    this.events,
    this.onDaySelected,
    this.onFormatChanged,
    this.onPageChanged,
    this.showTodayButton = true,
    this.showNavigation = true,
    this.availableDays,
    this.scheduleData,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late CalendarFormat _calendarFormat;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDay ?? DateTime.now();
    _focusedDay = widget.focusedDay;
    _calendarFormat = widget.calendarFormat;
  }

  @override
  void didUpdateWidget(CustomCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDay != oldWidget.selectedDay) {
      _selectedDay = widget.selectedDay ?? DateTime.now();
    }
    if (widget.focusedDay != oldWidget.focusedDay) {
      _focusedDay = widget.focusedDay;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Controles de navegação e formato
        if (widget.showNavigation) _buildCalendarControls(),

        // Calendário principal
        AppDesignSystem.styledCard(
          child: TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            calendarStyle: _getCalendarStyle(),
            headerStyle: _getHeaderStyle(),
            daysOfWeekStyle: _getDaysOfWeekStyle(),
            calendarBuilders: _getCalendarBuilders(),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              widget.onDaySelected?.call(selectedDay, focusedDay);
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
              widget.onFormatChanged?.call(format);
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
              widget.onPageChanged?.call(focusedDay);
            },
            eventLoader: (day) {
              return widget.events?[day] ?? [];
            },
          ),
        ),

        // Botão "Hoje" para pacientes
        if (widget.showTodayButton && widget.viewType == CalendarViewType.patient)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _selectedDay = DateTime.now();
                    _focusedDay = DateTime.now();
                  });
                  widget.onDaySelected?.call(DateTime.now(), DateTime.now());
                },
                child: Text(
                  'Hoje',
                  style: AppDesignSystem.bodyStyle.copyWith(
                    color: AppDesignSystem.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCalendarControls() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Controles de formato para pacientes
          if (widget.viewType == CalendarViewType.patient)
            Row(
              children: [
                _buildFormatButton('Mês', CalendarFormat.month),
                const SizedBox(width: 8),
                _buildFormatButton('Semana', CalendarFormat.week),
                const SizedBox(width: 8),
                _buildFormatButton('2 Semanas', CalendarFormat.twoWeeks),
              ],
            ),

          // Controles de navegação para profissionais
          if (widget.viewType == CalendarViewType.professional)
            Row(
              children: [
                IconButton(
                  onPressed: () => _changeMonth(-1),
                  icon: Icon(Icons.chevron_left, color: AppDesignSystem.primaryColor),
                ),
                Text(
                  _getMonthYear(_focusedDay),
                  style: AppDesignSystem.h3Style.copyWith(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () => _changeMonth(1),
                  icon: Icon(Icons.chevron_right, color: AppDesignSystem.primaryColor),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildFormatButton(String text, CalendarFormat format) {
    final isSelected = _calendarFormat == format;

    return GestureDetector(
      onTap: () {
        setState(() {
          _calendarFormat = format;
        });
        widget.onFormatChanged?.call(format);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppDesignSystem.primaryColor : AppDesignSystem.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppDesignSystem.primaryColor : AppDesignSystem.borderColor,
          ),
        ),
        child: Text(
          text,
          style: AppDesignSystem.captionStyle.copyWith(
            color: isSelected ? Colors.white : AppDesignSystem.textSecondaryColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _changeMonth(int months) {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + months, 1);
    });
    widget.onPageChanged?.call(_focusedDay);
  }

  String _getMonthYear(DateTime date) {
    final months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  CalendarStyle _getCalendarStyle() {
    return CalendarStyle(
      todayDecoration: BoxDecoration(
        color: AppDesignSystem.primaryColor.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      selectedDecoration: BoxDecoration(
        color: AppDesignSystem.primaryColor,
        shape: BoxShape.circle,
      ),
      todayTextStyle: AppDesignSystem.bodyStyle.copyWith(
        color: AppDesignSystem.primaryColor,
        fontWeight: FontWeight.w600,
      ),
      selectedTextStyle: AppDesignSystem.bodyStyle.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      defaultTextStyle: AppDesignSystem.bodyStyle,
      weekendTextStyle: AppDesignSystem.bodyStyle.copyWith(
        color: AppDesignSystem.errorColor,
      ),
      outsideTextStyle: AppDesignSystem.bodyStyle.copyWith(
        color: AppDesignSystem.textSecondaryColor.withOpacity(0.5),
      ),
      // Estilo para dias com eventos (profissionais) - temporariamente desabilitado
      // markerDecoration: widget.viewType == CalendarViewType.professional
      //     ? BoxDecoration(
      //         color: AppDesignSystem.successColor,
      //         shape: BoxShape.circle,
      //       )
      //     : null,
    );
  }

  HeaderStyle _getHeaderStyle() {
    return HeaderStyle(
      formatButtonVisible: false, // Usamos controles customizados
      titleCentered: true,
      titleTextStyle: AppDesignSystem.h3Style.copyWith(
        fontWeight: FontWeight.w600,
      ),
      leftChevronVisible: !widget.showNavigation, // Desabilitar controles padrão se temos controles customizados
      rightChevronVisible: !widget.showNavigation,
    );
  }

  DaysOfWeekStyle _getDaysOfWeekStyle() {
    return DaysOfWeekStyle(
      weekdayStyle: AppDesignSystem.captionStyle.copyWith(
        fontWeight: FontWeight.w600,
        color: AppDesignSystem.textSecondaryColor,
      ),
      weekendStyle: AppDesignSystem.captionStyle.copyWith(
        fontWeight: FontWeight.w600,
        color: AppDesignSystem.errorColor,
      ),
    );
  }

  CalendarBuilders _getCalendarBuilders() {
    return CalendarBuilders(
      // Para profissionais - mostrar status de disponibilidade
      defaultBuilder: widget.viewType == CalendarViewType.professional
          ? (context, day, focusedDay) {
              final scheduleDay = widget.scheduleData?[day];
              if (scheduleDay != null) {
                Color? backgroundColor;
                switch (scheduleDay.type) {
                  case ScheduleType.patient:
                    backgroundColor = AppDesignSystem.successColor.withOpacity(0.2);
                    break;
                  case ScheduleType.available:
                    backgroundColor = AppDesignSystem.infoColor.withOpacity(0.1);
                    break;
                  case ScheduleType.unavailable:
                    backgroundColor = AppDesignSystem.errorColor.withOpacity(0.1);
                    break;
                }

                return Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      day.day.toString(),
                      style: AppDesignSystem.bodyStyle.copyWith(
                        color: scheduleDay.type == ScheduleType.unavailable
                            ? AppDesignSystem.textSecondaryColor
                            : AppDesignSystem.textPrimaryColor,
                      ),
                    ),
                  ),
                );
              }
              return null;
            }
          : null,

      // Para pacientes - mostrar eventos com cores baseadas no status
      markerBuilder: widget.viewType == CalendarViewType.patient
          ? (context, day, events) {
              if (events.isNotEmpty && events is List<ScheduleAppointment>) {
                // Determinar cor baseada no status do primeiro agendamento
                Color markerColor = AppDesignSystem.successColor;

                for (var appointment in events) {
                  switch (appointment.status) {
                    case AppointmentStatus.confirmed:
                    case AppointmentStatus.completed:
                      markerColor = AppDesignSystem.successColor;
                      break;
                    case AppointmentStatus.pending:
                      markerColor = AppDesignSystem.warningColor;
                      break;
                    case AppointmentStatus.cancelled:
                      markerColor = AppDesignSystem.errorColor;
                      break;
                  }
                  break; // Usar cor do primeiro agendamento
                }

                return Positioned(
                  bottom: 1,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: markerColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }
              return null;
            }
          : null,
    );
  }
}

// Tipos de agendamento para profissionais
enum ScheduleType {
  available,    // Dia disponível para agendamento
  patient,      // Dia com paciente agendado
  unavailable,  // Dia indisponível
}

class ScheduleDay {
  final DateTime date;
  final ScheduleType type;
  final List<dynamic> appointments;

  ScheduleDay({
    required this.date,
    required this.type,
    required this.appointments,
  });
}
