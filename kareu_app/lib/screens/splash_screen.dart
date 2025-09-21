import 'package:flutter/material.dart';
import '../services/session_service.dart';
import '../constants/app_design_system.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_navigate);
  }

  void _navigate() {
    final session = SessionService.instance;
    if (!session.isLoggedIn) {
      Navigator.of(context).pushReplacementNamed('/login');
      return;
    }
    if (session.isProfessional) {
      Navigator.of(context).pushReplacementNamed('/home_professional');
    } else {
      Navigator.of(context).pushReplacementNamed('/home_family');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Kareu
            Text(
              'Kareu',
              style: AppDesignSystem.logoStyle.copyWith(
                color: AppDesignSystem.primaryColor,
              ),
            ),
            AppDesignSystem.verticalSpace(2),
            // Indicador de carregamento
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppDesignSystem.primaryColor),
            ),
            AppDesignSystem.verticalSpace(1),
            Text(
              'Carregando...',
              style: AppDesignSystem.captionStyle,
            ),
          ],
        ),
      ),
    );
  }
}


