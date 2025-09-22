import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';

class CareScheduleScreen extends StatefulWidget {
  const CareScheduleScreen({super.key});

  @override
  State<CareScheduleScreen> createState() => _CareScheduleScreenState();
}

class _CareScheduleScreenState extends State<CareScheduleScreen> {
  final Set<String> _diasSelecionados = {};
  final Set<String> _turnosSelecionados = {};
  final Set<String> _locaisSelecionados = {};

  final List<Map<String, String>> _diasSemana = [
    {'full': 'Segunda-feira', 'short': 'SEG'},
    {'full': 'Terça-feira', 'short': 'TER'},
    {'full': 'Quarta-feira', 'short': 'QUA'},
    {'full': 'Quinta-feira', 'short': 'QUI'},
    {'full': 'Sexta-feira', 'short': 'SEX'},
    {'full': 'Sábado', 'short': 'SÁB'},
    {'full': 'Domingo', 'short': 'DOM'},
  ];

  final List<Map<String, String>> _turnos = [
    {'name': 'Manhã', 'time': '06:00 - 12:00'},
    {'name': 'Tarde', 'time': '12:00 - 18:00'},
    {'name': 'Noite', 'time': '18:00 - 00:00'},
    {'name': 'Integral', 'time': '24 horas'},
    {'name': 'Plantão de 12h', 'time': '12 horas'},
  ];

  final List<Map<String, String>> _locais = [
    {'name': 'Hospital', 'description': 'Atendimento hospitalar'},
    {'name': 'Residência', 'description': 'Atendimento domiciliar'},
    {'name': 'Viagem curta', 'description': 'Acompanhamento em viagens'},
  ];

  void _toggleDia(String dia) {
    setState(() {
      if (_diasSelecionados.contains(dia)) {
        _diasSelecionados.remove(dia);
      } else {
        _diasSelecionados.add(dia);
      }
    });
  }

  void _toggleTurno(String turno) {
    setState(() {
      if (_turnosSelecionados.contains(turno)) {
        _turnosSelecionados.remove(turno);
      } else {
        _turnosSelecionados.add(turno);
      }
    });
  }

  void _toggleLocal(String local) {
    setState(() {
      if (_locaisSelecionados.contains(local)) {
        _locaisSelecionados.remove(local);
      } else {
        _locaisSelecionados.add(local);
      }
    });
  }

  IconData _getLocationIcon(String locationName) {
    switch (locationName) {
      case 'Hospital':
        return Icons.local_hospital;
      case 'Residência':
        return Icons.home;
      case 'Viagem curta':
        return Icons.directions_car;
      default:
        return Icons.location_on;
    }
  }

  void _onNextPressed() {
    if (_diasSelecionados.isEmpty || _turnosSelecionados.isEmpty || _locaisSelecionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione pelo menos um item em cada seção'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Agendamento configurado: ${_diasSelecionados.length} dias, ${_turnosSelecionados.length} turnos, ${_locaisSelecionados.length} locais'),
        backgroundColor: AppDesignSystem.primaryColor,
      ),
    );
    
    Navigator.pushNamed(context, '/family-description-intro');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título principal
              const Text(
                'Em quais dias você precisa de ajuda?',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              
              const SizedBox(height: 21),
              
              // Seção Dias Disponíveis
              _buildDaysSection(),
              
              const SizedBox(height: 36),
              
              // Seção Turnos Disponíveis
              _buildShiftsSection(),
              
              const SizedBox(height: 36),
              
              // Seção Locais de Atendimento
              _buildLocationsSection(),
              
              const SizedBox(height: 154),
              
              // Botão Próximo
              _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDaysSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dias da semana',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        
        // Grid de dias da semana
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _diasSemana.map((day) => _buildDayChip(day)).toList(),
        ),
      ],
    );
  }

  Widget _buildDayChip(Map<String, String> day) {
    bool isSelected = _diasSelecionados.contains(day['full']);
    
    return GestureDetector(
      onTap: () => _toggleDia(day['full']!),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4D64C8) : Colors.grey[200],
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? const Color(0xFF4D64C8) : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              day['short']!,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              day['full']!.split('-')[0],
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: isSelected ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Turnos necessários',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        
        // Lista de turnos
        Column(
          children: _turnos.map((shift) => _buildShiftCard(shift)).toList(),
        ),
      ],
    );
  }

  Widget _buildShiftCard(Map<String, String> shift) {
    bool isSelected = _turnosSelecionados.contains(shift['name']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => _toggleTurno(shift['name']!),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4D64C8).withValues(alpha: 0.1) : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF4D64C8) : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? const Color(0xFF4D64C8) : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF4D64C8) : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shift['name']!,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? const Color(0xFF4D64C8) : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      shift['time']!,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Locais de atendimento',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        
        // Lista de locais
        Column(
          children: _locais.map((location) => _buildLocationCard(location)).toList(),
        ),
      ],
    );
  }

  Widget _buildLocationCard(Map<String, String> location) {
    bool isSelected = _locaisSelecionados.contains(location['name']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => _toggleLocal(location['name']!),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4D64C8).withValues(alpha: 0.1) : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF4D64C8) : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? const Color(0xFF4D64C8) : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF4D64C8) : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location['name']!,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? const Color(0xFF4D64C8) : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      location['description']!,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                _getLocationIcon(location['name']!),
                color: isSelected ? const Color(0xFF4D64C8) : Colors.grey[400],
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        onPressed: _onNextPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4D64C8),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Próximo',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}