import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/login_screen.dart';
import 'screens/user_type_selection_screen.dart';
import 'screens/register_screen.dart';
import 'screens/formation_experience_screen.dart';
import 'screens/availability_screen.dart';
import 'screens/home_professional_screen.dart';
import 'screens/patient_chat_screen.dart';
import 'screens/caregiver_chat_screen.dart';
import 'screens/patient_profile_screen.dart';
import 'screens/patients_list_screen.dart';
import 'screens/account_settings_screen.dart';
import 'screens/caregiver_profile_screen.dart';
import 'screens/family_address_screen.dart';


import 'screens/add_family_member_screen.dart';
import 'screens/family_member_form_screen.dart';
import 'screens/care_needs_screen.dart';
import 'screens/care_schedule_screen.dart';
import 'screens/family_description_intro_screen.dart';
import 'screens/engagement_plans_screen.dart';
import 'screens/home_patient_screen.dart';
import 'screens/search_screen.dart';
import 'screens/filters_screen.dart';
import 'screens/caregiver_schedule_screen.dart';
import 'screens/caregiver_payment_screen.dart';
import 'screens/subscription_management_screen.dart';
import 'screens/contracts_screen.dart';
import 'screens/hire_caregiver_screen.dart';
import 'screens/caregiver_account_screen.dart';
import 'screens/patient_account_screen.dart';


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
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
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
        '/login': (context) => const LoginScreen(),
        '/user-type-selection': (context) => const UserTypeSelectionScreen(),
        '/register': (context) => const RegisterScreen(),
        '/formation-experience': (context) => const FormationExperienceScreen(),
        '/availability': (context) => const AvailabilityScreen(),
        '/home-professional': (context) => const HomeProfessionalScreen(),
        '/chat': (context) => const CaregiverChatScreen(),
        '/patient-chat': (context) => const PatientChatScreen(),
        '/caregiver-chat': (context) => const CaregiverChatScreen(),
        '/patient-profile': (context) => const PatientProfileScreen(),
        '/patients-list': (context) => const PatientsListScreen(),
        '/account-settings': (context) => const AccountSettingsScreen(),
        '/caregiver-profile': (context) => const CaregiverProfileScreen(),
        '/family-address': (context) => const FamilyAddressScreen(),
        '/add-family-member': (context) => const AddFamilyMemberScreen(),
        '/family-member-form': (context) => const FamilyMemberFormScreen(),
        '/care-needs': (context) => const CareNeedsScreen(),
        '/care-schedule': (context) => const CareScheduleScreen(),
        '/family-description-intro': (context) => const FamilyDescriptionIntroScreen(),
          '/engagement-plans': (context) => const EngagementPlansScreen(),
          '/home-patient': (context) => const HomePatientScreen(),
          '/search': (context) => const SearchScreen(),
          '/filters': (context) => const FiltersScreen(),
          '/caregiver-schedule': (context) => const CaregiverScheduleScreen(),
          '/caregiver-payment': (context) => const CaregiverPaymentScreen(),
          '/subscription-management': (context) => const SubscriptionManagementScreen(),
          '/contracts': (context) => const ContractsScreen(),
          '/hire-caregiver': (context) => const HireCaregiverScreen(),
          '/caregiver-account': (context) => const CaregiverAccountScreen(),
          '/patient-account': (context) => const PatientAccountScreen(),
      },
    );
  }
}

class _KareuColors {
  static const primaryBlue = Color(0xFF4D64C8); // azul principal
  static const accentYellow = Color(0xFFFFAD00); // amarelo destaque
  static const lightBorder = Color(0xFFAAAAAA);
}
