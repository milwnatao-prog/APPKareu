import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/user_type_selection_screen.dart';
import 'screens/register_screen.dart';
import 'screens/formation_experience_screen.dart';
import 'screens/availability_screen.dart';

void main() {
  runApp(const KareuApp());
}

class KareuApp extends StatelessWidget {
  const KareuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kareu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: _KareuColors.primaryBlue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _KareuColors.primaryBlue,
          primary: _KareuColors.primaryBlue,
          secondary: _KareuColors.accentYellow,
          surface: Colors.white,
        ),
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF6F6F6),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _KareuColors.lightBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _KareuColors.primaryBlue, width: 1.6),
          ),
        ),
      ),
      home: const LoginScreen(),
      routes: {
        '/user-type-selection': (context) => const UserTypeSelectionScreen(),
        '/register': (context) => const RegisterScreen(),
        '/formation-experience': (context) => const FormationExperienceScreen(),
        '/availability': (context) => const AvailabilityScreen(),
      },
    );
  }
}

class _KareuColors {
  static const primaryBlue = Color(0xFF4D64C8); // azul principal
  static const accentYellow = Color(0xFFFFAD00); // amarelo destaque
  static const lightBorder = Color(0xFFAAAAAA);
}
