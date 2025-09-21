import 'package:flutter/material.dart';
import 'user_type_selection_screen.dart';
import '../constants/app_design_system.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final UserType? userType = ModalRoute.of(context)?.settings.arguments as UserType?;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          userType == UserType.needCaregiver 
            ? 'Cadastro - Preciso de Cuidador' 
            : 'Cadastro - Sou Cuidador'
        ),
        backgroundColor: const Color(0xFF4D64C8),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.construction,
              size: 64,
              color: Color(0xFF4D64C8),
            ),
            const SizedBox(height: 16),
            Text(
              'Tela de Registro em Desenvolvimento',
              style: AppDesignSystem.h3Style,
            ),
            const SizedBox(height: 8),
            Text(
              'Esta tela será implementada em breve',
              style: AppDesignSystem.bodySmallStyle.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            if (userType == UserType.amCaregiver)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/formation-experience');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4D64C8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Ver Tela de Formação (Demo)'),
              ),
          ],
        ),
      ),
    );
  }
}