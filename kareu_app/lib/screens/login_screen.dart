import 'package:flutter/material.dart';
import 'dart:ui';
import '../constants/app_design_system.dart';
import '../services/user_service.dart';

enum Role { familiar, profissional }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Role _selected = Role.profissional; // Começa com Profissional selecionado conforme Figma
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  void _performLogin() {
    // Validação básica dos campos
    if (_emailCtrl.text.trim().isEmpty || _passCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Simular login bem-sucedido e navegar baseado no tipo de usuário
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login realizado com sucesso como ${_selected == Role.familiar ? 'Paciente' : 'Profissional'}!'),
        backgroundColor: AppDesignSystem.primaryColor,
      ),
    );

    // Navegar para a tela apropriada baseada no tipo de usuário
    if (_selected == Role.familiar) {
      // Usuário logou como paciente/familiar
      UserService.setUserType(UserType.patient);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home-patient',
        (route) => false,
      );
    } else {
      // Usuário logou como profissional
      UserService.setUserType(UserType.caregiver);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home-professional',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Efeito blur circular azul no topo com gradiente - responsivo
          Positioned(
            left: -screenWidth * 0.1,
            top: -screenHeight * 0.55,
            child: Container(
              width: screenWidth * 1.2,
              height: screenHeight * 0.9,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF2A3F8F), // Azul bem mais escuro no topo
                    Color(0xFF3D52B8), // Azul escuro no meio
                    Color(0x804D64C8), // Azul médio embaixo
                    Color(0x304D64C8), // Transparente na borda inferior
                  ],
                  stops: [0.0, 0.3, 0.7, 1.0],
                ),
                borderRadius: BorderRadius.circular(screenWidth * 1.3),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xCC2A3F8F), // Azul escuro semi-transparente no topo
                        Color(0x993D52B8), // Azul escuro transparente no meio
                        Color(0x664D64C8), // Azul médio transparente embaixo
                        Color(0x1A4D64C8), // Quase invisível na borda
                      ],
                      stops: [0.0, 0.4, 0.8, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(screenWidth * 1.3),
                  ),
                ),
              ),
            ),
          ),
          
          // Gradiente inferior - responsivo
          Positioned(
            left: 0,
            top: screenHeight * 0.28,
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.22,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00D9D9D9),
                    Color(0xFFFFFFFF),
                  ],
                ),
              ),
            ),
          ),

          // Conteúdo principal
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.05), // Espaço responsivo otimizado
                  
                  // Header profissional com logo e descrição
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                    child: Column(
                      children: [
                        // Logo "Kareu" com container melhorado
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            'Kareu',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: screenWidth < 400 ? 32 : 38,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Título de boas-vindas mais profissional
                        Text(
                          'Bem-vindo de volta',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth < 400 ? 20 : 22,
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Subtítulo mais elegante
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                          child: Text(
                            'Conectando profissionais de saúde com famílias que precisam de cuidado especializado',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w400,
                              fontSize: screenWidth < 400 ? 14 : 15,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Toggle Familiar/Profissional com design melhorado
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                    child: Column(
                      children: [
                        Text(
                          'Selecione seu tipo de acesso',
                          style: AppDesignSystem.bodyStyle.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _RoleToggle(
                          selected: _selected,
                          onChanged: (role) => setState(() => _selected = role),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Formulários com design melhorado
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                    padding: EdgeInsets.all(screenWidth < 400 ? 16 : 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título da seção de login
                        Text(
                          'Faça seu login',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: const Color(0xFF2D3748),
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth < 400 ? 18 : 20,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Campo Usuário
                        _FormField(
                          label: 'Email',
                          hintText: 'Digite seu email profissional',
                          controller: _emailCtrl,
                          prefixIcon: Icons.email_outlined,
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Campo Senha
                        _FormField(
                          label: 'Senha',
                          hintText: 'Digite sua senha',
                          controller: _passCtrl,
                          prefixIcon: Icons.lock_outlined,
                          isPassword: true,
                          obscureText: _obscure,
                          onToggleVisibility: () => setState(() => _obscure = !_obscure),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Esqueci minha senha
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Funcionalidade em desenvolvimento'),
                                  backgroundColor: AppDesignSystem.primaryColor,
                                ),
                              );
                            },
                            child: Text(
                              'Esqueci minha senha',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: AppDesignSystem.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Botão Entrar melhorado
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              _performLogin();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppDesignSystem.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              shadowColor: AppDesignSystem.primaryColor.withValues(alpha: 0.3),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.login,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Entrar',
                                  style: AppDesignSystem.buttonStyle.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Divisor "ou" melhorado
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      AppDesignSystem.borderColor,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'ou',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: AppDesignSystem.textSecondaryColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      AppDesignSystem.borderColor,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Botão Google melhorado
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Login com Google em desenvolvimento'),
                                  backgroundColor: AppDesignSystem.primaryColor,
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: AppDesignSystem.borderColor,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.white,
                              elevation: 2,
                              shadowColor: Colors.black.withValues(alpha: 0.1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/google-icon.png',
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Continuar com Google',
                                  style: AppDesignSystem.bodyStyle.copyWith(
                                    color: AppDesignSystem.textPrimaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Seção de cadastro melhorada
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ainda não possui conta? ',
                          style: AppDesignSystem.bodyStyle.copyWith(
                            color: AppDesignSystem.textSecondaryColor,
                            fontSize: 15,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            debugPrint('Navegando para tela de seleção de usuário');
                            Navigator.pushNamed(context, '/user-type-selection');
                          },
                          child: Text(
                            'Cadastre-se',
                            style: AppDesignSystem.linkStyle.copyWith(
                              color: AppDesignSystem.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget personalizado para o campo de formulário
class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.hintText,
    required this.controller,
    required this.prefixIcon,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleVisibility,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final IconData prefixIcon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label melhorado
        Text(
          label,
          style: AppDesignSystem.labelStyle.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppDesignSystem.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        
        // Campo de input melhorado
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword ? obscureText : false,
            style: AppDesignSystem.bodyStyle.copyWith(
              fontSize: 15,
              color: AppDesignSystem.textPrimaryColor,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppDesignSystem.placeholderStyle.copyWith(
                fontSize: 15,
                color: AppDesignSystem.textSecondaryColor,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              prefixIcon: Container(
                width: 48,
                height: 56,
                alignment: Alignment.center,
                child: Icon(
                  prefixIcon,
                  size: 20,
                  color: AppDesignSystem.primaryColor,
                ),
              ),
              suffixIcon: isPassword
                  ? Container(
                      width: 48,
                      height: 56,
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: onToggleVisibility,
                        child: Icon(
                          obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: 20,
                          color: AppDesignSystem.textSecondaryColor,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _RoleToggle extends StatelessWidget {
  const _RoleToggle({
    required this.selected,
    required this.onChanged,
  });

  final Role selected;
  final ValueChanged<Role> onChanged;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final toggleWidth = screenWidth * 0.84;
    final halfWidth = toggleWidth / 2;
    
    return Container(
      width: toggleWidth,
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Fundo selecionado que se move
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: selected == Role.profissional ? 0 : halfWidth - 4,
            top: 0,
            child: Container(
              width: halfWidth,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppDesignSystem.primaryColor,
                    AppDesignSystem.primaryColor.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppDesignSystem.primaryColor.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          
          // Botões
          Row(
            children: [
              // Botão Profissional
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(Role.profissional),
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          size: 20,
                          color: selected == Role.profissional 
                            ? Colors.white 
                            : Colors.white.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Profissional',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: selected == Role.profissional 
                              ? FontWeight.w600 
                              : FontWeight.w500,
                            fontSize: 14,
                            color: selected == Role.profissional 
                              ? Colors.white 
                              : Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Botão Familiar
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(Role.familiar),
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.family_restroom_outlined,
                          size: 20,
                          color: selected == Role.familiar 
                            ? Colors.white 
                            : Colors.white.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Familiar',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: selected == Role.familiar 
                              ? FontWeight.w600 
                              : FontWeight.w500,
                            fontSize: 14,
                            color: selected == Role.familiar 
                              ? Colors.white 
                              : Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}