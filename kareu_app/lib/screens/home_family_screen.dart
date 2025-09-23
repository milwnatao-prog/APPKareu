import 'package:flutter/material.dart';
import '../services/session_service.dart';
import '../constants/app_design_system.dart';

class HomeFamilyScreen extends StatefulWidget {
  const HomeFamilyScreen({super.key});

  @override
  State<HomeFamilyScreen> createState() => _HomeFamilyScreenState();
}

class _HomeFamilyScreenState extends State<HomeFamilyScreen> {

  void _logout(BuildContext context) {
    SessionService.instance.logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Kareu',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextSpan(
                text: ' - Familiar',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(onPressed: () => _logout(context), icon: const Icon(Icons.logout)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Encontre um cuidador qualificado',
              style: AppDesignSystem.h3Style,
            ),
            AppDesignSystem.verticalSpace(0.75),
            Text(
              'Lista/descoberta de profissionais virá aqui...',
              style: AppDesignSystem.bodyStyle,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
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
          _buildNavItem(Icons.assignment, 'Contratos', 2),
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
        // Navegar para Chat de Paciente
        Navigator.pushNamed(context, '/patient-chat');
        break;
      case 2:
        // Navegar para Contratos
        Navigator.pushNamed(context, '/contracts');
        break;
      case 3:
        // Navegar para Agenda
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tela de agenda será implementada em breve'),
            backgroundColor: AppDesignSystem.infoColor,
          ),
        );
        break;
      case 4:
        // Navegar para Perfil
        Navigator.pushNamed(context, '/account-settings');
        break;
    }
  }
}


