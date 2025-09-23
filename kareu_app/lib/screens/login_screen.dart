import 'package:flutter/material.dart';
import 'dart:ui';
import '../constants/app_design_system.dart';

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
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home-patient',
        (route) => false,
      );
    } else {
      // Usuário logou como profissional
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
                  SizedBox(height: screenHeight * 0.08), // Espaço responsivo
                  
                  // Logo "Kareu"
                  Container(
                    width: 156,
                    height: 101,
                    alignment: Alignment.center,
                    child: Text(
                      'Kareu',
                      style: AppDesignSystem.logoStyle,
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // "Bem-Vindo"
                  Text(
                    'Bem-Vindo',
                    style: AppDesignSystem.bodyStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // "Conectamos cuidadores e pacientes"
                  Text(
                    'Conectamos cuidadores e pacientes',
                    textAlign: TextAlign.center,
                    style: AppDesignSystem.bodyStyle.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Toggle Familiar/Profissional
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
                    child: _RoleToggle(
                      selected: _selected,
                      onChanged: (role) => setState(() => _selected = role),
                    ),
                  ),
                  
                  const SizedBox(height: 37),
                  
                  // Formulários
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.074),
                    child: Column(
                      children: [
                        // Campo Usuário
                        _FormField(
                          label: 'Usuário',
                          hintText: 'Digite seu email',
                          controller: _emailCtrl,
                          prefixIcon: 'assets/images/user-icon-combined.svg',
                        ),
                        
                        const SizedBox(height: 10),
                        
                        // Campo Senha
                        _FormField(
                          label: 'Senha',
                          hintText: 'Digite sua senha',
                          controller: _passCtrl,
                          prefixIcon: 'assets/images/lock-icon-combined.svg',
                          isPassword: true,
                          obscureText: _obscure,
                          onToggleVisibility: () => setState(() => _obscure = !_obscure),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Esqueci minha senha
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'Esqueci minha senha',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                height: 1.5,
                                color: Color(0xFF4E4E4E),
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 28),
                        
                        // Botão Entrar
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            onPressed: () {
                              _performLogin();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4D64C8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Entrar',
                              style: AppDesignSystem.buttonStyle,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 42),
                        
                        // Divisor "ou"
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: const Color(0xFFAAAAAA),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 13),
                              child: Text(
                                'ou',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  height: 1.5,
                                  color: Color(0xFF4E4E4E),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: const Color(0xFFAAAAAA),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 42),
                        
                        // Botão Google
                        SizedBox(
                          width: double.infinity,
                          height: 38,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFAAAAAA)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/google-icon.png',
                                  width: 23,
                                  height: 23,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Entrar com Google',
                                  style: AppDesignSystem.bodyStyle.copyWith(
                                    color: AppDesignSystem.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 64),
                        
                        // Criar Perfil
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: GestureDetector(
                            onTap: () {
                              print('Navegando para tela de seleção de usuário');
                              Navigator.pushNamed(context, '/user-type-selection');
                            },
                            child: Text(
                              'Ainda não possui conta? Cadastre-se',
                              style: AppDesignSystem.linkStyle.copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
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
  final String prefixIcon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;

  IconData _getIconFromPath(String path) {
    if (path.contains('user-icon')) {
      return Icons.person_outline;
    } else if (path.contains('lock-icon')) {
      return Icons.lock_outline;
    } else if (path.contains('briefcase-icon')) {
      return Icons.work_outline;
    } else {
      return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: AppDesignSystem.labelStyle.copyWith(
            fontSize: AppDesignSystem.fontSizeCaption,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 1),
        
        // Campo de input
        Container(
          height: 45.58,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(8.85),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
              width: 1.0,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword ? obscureText : false,
            style: AppDesignSystem.bodySmallStyle.copyWith(
              fontSize: AppDesignSystem.fontSizeCaption,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppDesignSystem.placeholderStyle.copyWith(
                fontSize: AppDesignSystem.fontSizeCaption,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              prefixIcon: Container(
                width: 40,
                height: 45.58,
                alignment: Alignment.center,
                child: Icon(
                  _getIconFromPath(prefixIcon),
                  size: 16,
                  color: const Color(0xFF666666),
                ),
              ),
              suffixIcon: isPassword
                  ? Container(
                      width: 40,
                      height: 45.58,
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: onToggleVisibility,
                        child: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                          size: 18,
                          color: const Color(0xFF666666),
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
    final toggleWidth = screenWidth * 0.82;
    final halfWidth = toggleWidth / 2;
    
    return Container(
      width: toggleWidth,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFFFAD00),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          // Fundo selecionado que se move
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            left: selected == Role.profissional ? 0 : halfWidth,
            top: 0,
            child: Container(
              width: halfWidth,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF4D64C8),
                borderRadius: BorderRadius.circular(30),
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
                    height: 32,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.work_outline,
                          size: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Profissional',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            height: 1.5,
                            color: Colors.white,
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
                    height: 32,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.family_restroom,
                          size: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Familiar',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            height: 1.5,
                            color: Colors.white,
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