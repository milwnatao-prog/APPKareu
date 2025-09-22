import 'package:flutter/material.dart';
import '../services/session_service.dart';
import 'professional_chat_screen.dart';

class HomeProfessionalScreen extends StatefulWidget {
  const HomeProfessionalScreen({super.key});

  @override
  State<HomeProfessionalScreen> createState() => _HomeProfessionalScreenState();
}

class _HomeProfessionalScreenState extends State<HomeProfessionalScreen> {
  int _selectedTabIndex = 0;
  final Set<String> _patientsScheduledDays = {'2', '5'}; // Dias com pacientes agendados

  void _logout(BuildContext context) {
    SessionService.instance.logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _onEngagePressed() {
    Navigator.pushNamed(context, '/engagement-plans');
  }

  void _onPatientCardTapped(String patient) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalhes do Paciente'),
          content: Text('Visualizando detalhes de $patient'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _onCalendarDayTapped(String day) {
    if (day.isNotEmpty) {
      if (_patientsScheduledDays.contains(day)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dia $day - Paciente agendado'),
            backgroundColor: const Color(0xFF4D64C8),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dia $day - Sem agendamentos'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
  }

  void _onStatisticCardTapped(String type) {
    String message;
    switch (type) {
      case 'ratings':
        message = 'Visualizando suas avaliações detalhadas...';
        break;
      case 'patients':
        message = 'Visualizando histórico de pacientes atendidos...';
        break;
      case 'hours':
        message = 'Visualizando relatório de horas trabalhadas...';
        break;
      default:
        message = 'Carregando detalhes...';
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4D64C8),
      ),
    );
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
    
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
        // Navegar para Chat
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfessionalChatScreen(),
          ),
        );
        break;
      case 2:
        // Navegar para Lista de Pacientes
        Navigator.pushNamed(context, '/patients-list');
        break;
      case 3:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Navegando para Agenda'),
            duration: Duration(seconds: 1),
            backgroundColor: Color(0xFF4D64C8),
          ),
        );
        break;
      case 4:
        // Navegar para Configurações da Conta
        Navigator.pushNamed(context, '/account-settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Status Bar Space
            const SizedBox(height: 8),
            
            // Header Section
            _buildHeader(),
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    
                    // Profile Section
                    _buildProfileSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Statistics Cards
                    _buildStatisticsSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Engagement Banner
                    _buildEngagementBanner(),
                    
                    const SizedBox(height: 24),
                    
                    // Next Patients Section
                    _buildNextPatientsSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Calendar Section
                    _buildCalendarSection(),
                    
                    const SizedBox(height: 100), // Space for bottom navigation
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          // Logo centralizado
          const Text(
            'Kareu',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4D64C8),
              height: 0.37,
              letterSpacing: -0.43,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Profile Image centralizada
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4D64C8).withValues(alpha: 0.1),
                border: Border.all(
                  color: const Color(0xFF4D64C8),
                  width: 3,
                ),
              ),
              child: const CircleAvatar(
                radius: 45,
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Color(0xFF4D64C8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Greeting
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15.69,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              height: 1.5,
            ),
            children: [
              TextSpan(text: 'Olá,\n'),
              TextSpan(text: 'Maria Souza, 29'),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Welcome back
        const Text(
          'Bem-vinda de volta',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w300,
            color: Colors.black,
            height: 1.5,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Verification Badge
        Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Color(0xFF0088FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 12,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'Profissional verificado Kareu',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                height: 1.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatisticsSection() {
    return Row(
      children: [
        // Ratings Card
        Expanded(
          child: GestureDetector(
            onTap: () => _onStatisticCardTapped('ratings'),
            child: Container(
              height: 107,
              padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF4D64C8),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '4,9',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Avaliações',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 10),
        
        // Patients Card
        Expanded(
          child: GestureDetector(
            onTap: () => _onStatisticCardTapped('patients'),
            child: Container(
              height: 107,
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 11),
              decoration: BoxDecoration(
                color: const Color(0xFF4D64C8),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '12',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Pacientes\natendidos',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 10),
        
        // Hours Card
        Expanded(
          child: GestureDetector(
            onTap: () => _onStatisticCardTapped('hours'),
            child: Container(
              height: 107,
              padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF4D64C8),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '120h',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFFFFFFF),
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Horas\ntrabalhadas',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFFFFFF),
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEngagementBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF47E),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            offset: const Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Seu perfil perfil recebeu 2 visitas hoje, engaje seu perfil e atraia mais clientes.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: _onEngagePressed,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFFFBB00),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.transparent),
              ),
              child: const Text(
                'Engajar',
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.19,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextPatientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Próximos pacientes',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            height: 1.5,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Patient Card 1
        GestureDetector(
          onTap: () => _onPatientCardTapped('Francisca - Hospital São Lucas'),
          child: _buildPatientCard(
            date: '02/11/25',
            time: '10:00 às 18:00',
            patient: 'Francisca - Hospital São Lucas',
            color: const Color(0xFF6B73FF),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Patient Card 2
        GestureDetector(
          onTap: () => _onPatientCardTapped('Narciso - Domicílio'),
          child: _buildPatientCard(
            date: '05/11/25',
            time: '07:00 às 19:00',
            patient: 'Narciso - Domicílio',
            color: const Color(0xFFFF6B6B),
          ),
        ),
      ],
    );
  }

  Widget _buildPatientCard({
    required String date,
    required String time,
    required String patient,
    required Color color,
  }) {
    return Container(
      height: 63,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            offset: const Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          // Color indicator
          Container(
            width: 65,
            height: 63,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
          ),
          
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    patient,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Arrow
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.chevron_right,
              color: Color(0xFF3B55C4),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            offset: const Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Agenda',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      height: 1.25,
                    ),
                  ),
                  Text(
                    'Ver agenda completa',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
              // Removido o horário 9:41 AM
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Simplified Calendar
          _buildSimplifiedCalendar(),
        ],
      ),
    );
  }

  Widget _buildSimplifiedCalendar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Nov 2025',
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      height: 1.29,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: const Color(0xFF3B55C4),
                    size: 16,
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.chevron_left,
                    color: const Color(0xFF3B55C4),
                    size: 16,
                  ),
                  const SizedBox(width: 15),
                  Icon(
                    Icons.chevron_right,
                    color: const Color(0xFF3B55C4),
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Days of week
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['SUN', 'MON', 'WED', 'THU', 'FRI', 'SAT', 'SUN']
                .map((day) => Text(
                      day,
                      style: TextStyle(
                        fontFamily: 'SF Pro',
                        fontSize: 7,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withValues(alpha: 0.35),
                        height: 1.38,
                      ),
                    ))
                .toList(),
          ),
          
          const SizedBox(height: 8),
          
          // Calendar grid (simplified)
          Column(
            children: [
              _buildCalendarWeek(['', '', '1', '2', '3', '4', '5']),
              _buildCalendarWeek(['6', '7', '8', '9', '10', '11', '12']),
              _buildCalendarWeek(['13', '14', '15', '16', '17', '18', '19']),
              _buildCalendarWeek(['20', '21', '22', '23', '24', '25', '26']),
              _buildCalendarWeek(['27', '28', '29', '30', '', '', '']),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarWeek(List<String> days) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((day) {
          bool hasPatient = _patientsScheduledDays.contains(day);
          bool isCurrent = day == '1';
          
          return GestureDetector(
            onTap: () => _onCalendarDayTapped(day),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: hasPatient 
                    ? const Color(0xFF4D64C8).withValues(alpha: 0.15)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: hasPatient 
                    ? Border.all(color: const Color(0xFF4D64C8), width: 2)
                    : null,
              ),
              child: Center(
                child: day.isEmpty
                    ? const SizedBox()
                    : Text(
                        day,
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: isCurrent ? 20 : 16,
                          fontWeight: hasPatient 
                              ? FontWeight.w700 
                              : FontWeight.w400,
                          color: hasPatient 
                              ? const Color(0xFF4D64C8)
                              : Colors.black,
                          height: 1.25,
                        ),
                      ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 73,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Início', 0),
          _buildNavItem(Icons.chat_bubble_outline, 'Chat', 1),
          _buildNavItem(Icons.people_outline, 'Clientes', 2),
          _buildNavItem(Icons.calendar_today, 'Agenda', 3),
          _buildNavItem(Icons.account_circle_outlined, 'Perfil', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    
    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: const Color(0xFF49454F),
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Color(0xFF49454F),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


