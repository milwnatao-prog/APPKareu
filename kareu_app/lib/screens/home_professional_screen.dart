import 'package:flutter/material.dart';
import '../services/session_service.dart';
import '../constants/app_design_system.dart';

class HomeProfessionalScreen extends StatelessWidget {
  const HomeProfessionalScreen({super.key});

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
                text: ' - Professional',
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
              'Resumo da semana e atalhos virão aqui...',
              style: AppDesignSystem.bodyStyle,
            ),
          ],
        ),
      ),
    );
  }
}


