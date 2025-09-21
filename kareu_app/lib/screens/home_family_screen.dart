import 'package:flutter/material.dart';
import '../services/session_service.dart';
import '../constants/app_design_system.dart';

class HomeFamilyScreen extends StatelessWidget {
  const HomeFamilyScreen({super.key});

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
    );
  }
}


