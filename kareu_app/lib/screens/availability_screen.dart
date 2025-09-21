
import 'package:flutter/material.dart';
import 'preferences_specialties_screen.dart';
import '../constants/app_design_system.dart';

class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({super.key});

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  Set<String> selectedDays = {};
  Set<String> selectedShifts = {};
  Set<String> selectedLocations = {};

  final List<Map<String, String>> weekDays = [
    {'full': 'Segunda-feira', 'short': 'SEG'},
    {'full': 'Terça-feira', 'short': 'TER'},
    {'full': 'Quarta-feira', 'short': 'QUA'},
    {'full': 'Quinta-feira', 'short': 'QUI'},
    {'full': 'Sexta-feira', 'short': 'SEX'},
    {'full': 'Sábado', 'short': 'SÁB'},
    {'full': 'Domingo', 'short': 'DOM'},
  ];

  final List<Map<String, String>> shifts = [
    {'name': 'Manhã', 'time': '06:00 - 12:00'},
    {'name': 'Tarde', 'time': '12:00 - 18:00'},
    {'name': 'Noite', 'time': '18:00 - 00:00'},
    {'name': '12h', 'time': '12 horas'},
    {'name': '6h', 'time': '6 horas'},
  ];

  final List<Map<String, String>> locations = [
    {'name': 'Hospitalar', 'description': 'Atendimento em hospitais'},
    {'name': 'Domicílio', 'description': 'Atendimento domiciliar'},
    {'name': 'Viagens curtas', 'description': 'Acompanhamento em viagens'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Disponibilidade',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título principal
              const Text(
                'Disponibilidade de Trabalho',
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
          'Dias disponíveis',
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
          children: weekDays.map((day) => _buildDayChip(day)).toList(),
        ),
      ],
    );
  }

  Widget _buildDayChip(Map<String, String> day) {
    bool isSelected = selectedDays.contains(day['full']);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedDays.remove(day['full']);
          } else {
            selectedDays.add(day['full']!);
          }
        });
      },
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
          'Turnos disponíveis',
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
          children: shifts.map((shift) => _buildShiftCard(shift)).toList(),
        ),
      ],
    );
  }

  Widget _buildShiftCard(Map<String, String> shift) {
    bool isSelected = selectedShifts.contains(shift['name']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              selectedShifts.remove(shift['name']);
            } else {
              selectedShifts.add(shift['name']!);
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4D64C8).withOpacity(0.1) : Colors.grey[50],
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
          children: locations.map((location) => _buildLocationCard(location)).toList(),
        ),
      ],
    );
  }

  Widget _buildLocationCard(Map<String, String> location) {
    bool isSelected = selectedLocations.contains(location['name']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              selectedLocations.remove(location['name']);
            } else {
              selectedLocations.add(location['name']!);
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4D64C8).withOpacity(0.1) : Colors.grey[50],
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

  IconData _getLocationIcon(String locationName) {
    switch (locationName) {
      case 'Hospitalar':
        return Icons.local_hospital;
      case 'Domicílio':
        return Icons.home;
      case 'Viagens curtas':
        return Icons.directions_car;
      default:
        return Icons.location_on;
    }
  }

  Widget _buildNextButton() {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        onPressed: () {
          // Validar se pelo menos uma opção foi selecionada em cada categoria
          if (selectedDays.isEmpty || selectedShifts.isEmpty || selectedLocations.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Por favor, selecione pelo menos uma opção em cada categoria'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          // Navegar diretamente para a próxima tela
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PreferencesSpecialtiesScreen(),
            ),
          );
        },
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
