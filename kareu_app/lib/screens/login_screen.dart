import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../widgets/animated_list.dart';

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
      UserService.setUserType(UserType.needCaregiver);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home-patient',
        (route) => false,
      );
    } else {
      // Usuário logou como profissional
      UserService.setUserType(UserType.amCaregiver);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home-professional',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      body: Column(
        children: [
          // Header com fundo azul
          _buildHeader(),
          
          // Conteúdo scrollável
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDesignSystem.space2XL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppDesignSystem.spaceLG),
                  
                  // Card principal de login com animação
                  FadeInUpAnimation(
                    duration: const Duration(milliseconds: 800),
                    child: _buildLoginCard(),
                  ),
                  
                  const SizedBox(height: AppDesignSystem.space2XL),
                  
                  // Links de rodapé
                  _buildFooterLinks(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppDesignSystem.space4XL,
        horizontal: AppDesignSystem.space2XL,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppDesignSystem.primaryColor,
            AppDesignSystem.primaryColor.withValues(alpha: 0.8),
            AppDesignSystem.accentColor,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          // Nome Kareu em destaque
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDesignSystem.space2XL,
              vertical: AppDesignSystem.spaceLG,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
                child: Text(
                  'Kareu',
                  style: AppDesignSystem.logoStyle.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
          ),
          
          const SizedBox(height: AppDesignSystem.space2XL),
          
          // Subtítulo com destaque amarelo
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppDesignSystem.h2Style.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w500,
              ),
              children: [
                const TextSpan(text: 'Conectando '),
                TextSpan(
                  text: 'cuidadores',
                  style: TextStyle(
                    color: AppDesignSystem.secondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: ' e '),
                TextSpan(
                  text: 'famílias',
                  style: TextStyle(
                    color: AppDesignSystem.secondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppDesignSystem.spaceMD),
          
          // Linha decorativa
          Container(
            width: 60,
            height: 3,
            decoration: BoxDecoration(
              color: AppDesignSystem.secondaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Seletor de tipo de usuário
          _buildUserTypeSelector(),
          
          const SizedBox(height: AppDesignSystem.space2XL),
          
          // Campos de login
          _buildLoginForm(),
          
          const SizedBox(height: AppDesignSystem.spaceLG),
          
          // Esqueci minha senha
          _buildForgotPassword(),
          
          const SizedBox(height: AppDesignSystem.space2XL),
          
          // Botão de login
          _buildLoginButton(),
          
          const SizedBox(height: AppDesignSystem.spaceLG),
          
          // Divisor
          _buildDivider(),
          
          const SizedBox(height: AppDesignSystem.spaceLG),
          
          // Login social
          _buildSocialLogin(),
        ],
      ),
    );
  }

  Widget _buildUserTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Entrar como:',
          style: AppDesignSystem.h3Style,
        ),
        const SizedBox(height: AppDesignSystem.spaceMD),
        Row(
          children: [
            Expanded(
              child: _buildUserTypeOption(
                Role.familiar,
                'Paciente/Família',
                Icons.family_restroom,
                'Busco cuidadores',
              ),
            ),
            const SizedBox(width: AppDesignSystem.spaceMD),
            Expanded(
              child: _buildUserTypeOption(
                Role.profissional,
                'Profissional',
                Icons.medical_services,
                'Ofereço cuidados',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserTypeOption(Role role, String title, IconData icon, String subtitle) {
    final isSelected = _selected == role;
    
    return GestureDetector(
      onTap: () => setState(() => _selected = role),
      child: Container(
        padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppDesignSystem.primaryColor.withValues(alpha: 0.1)
              : AppDesignSystem.surfaceColor,
          border: Border.all(
            color: isSelected 
                ? AppDesignSystem.primaryColor
                : AppDesignSystem.borderColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? AppDesignSystem.primaryColor
                  : AppDesignSystem.textSecondaryColor,
              size: 32,
            ),
            const SizedBox(height: AppDesignSystem.spaceSM),
            Text(
              title,
              style: AppDesignSystem.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected 
                    ? AppDesignSystem.primaryColor
                    : AppDesignSystem.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDesignSystem.spaceXS),
            Text(
              subtitle,
              style: AppDesignSystem.captionStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDesignSystem.styledTextField(
          label: 'E-mail',
          controller: _emailCtrl,
          hint: 'Digite seu e-mail',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        
        const SizedBox(height: AppDesignSystem.spaceLG),
        
        AppDesignSystem.styledTextField(
          label: 'Senha',
          controller: _passCtrl,
          hint: 'Digite sua senha',
          obscureText: _obscure,
          prefixIcon: Icons.lock_outline,
          suffixIcon: IconButton(
            icon: Icon(
              _obscure ? Icons.visibility_off : Icons.visibility,
              size: 20,
            ),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // TODO: Implementar recuperação de senha
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Funcionalidade em desenvolvimento'),
              backgroundColor: AppDesignSystem.infoColor,
            ),
          );
        },
        child: Text(
          'Esqueci minha senha',
          style: AppDesignSystem.captionStyle.copyWith(
            color: AppDesignSystem.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return AnimatedCard(
      onTap: _performLogin,
      elevation: 8.0,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppDesignSystem.primaryColor,
              AppDesignSystem.primaryColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppDesignSystem.primaryColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Entrar',
            style: AppDesignSystem.buttonStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceMD),
          child: Text(
            'ou',
            style: AppDesignSystem.captionStyle,
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        _buildSocialButton(
          'Continuar com Google',
          Icons.login,
          Colors.red,
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login com Google em desenvolvimento'),
                backgroundColor: AppDesignSystem.infoColor,
              ),
            );
          },
        ),
        const SizedBox(height: AppDesignSystem.spaceMD),
        _buildSocialButton(
          'Continuar com Apple',
          Icons.apple,
          Colors.black,
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login com Apple em desenvolvimento'),
                backgroundColor: AppDesignSystem.infoColor,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSocialButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color, size: 20),
      label: Text(
        text,
        style: AppDesignSystem.bodyStyle.copyWith(
          color: AppDesignSystem.textPrimaryColor,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.spaceLG),
        side: BorderSide(color: AppDesignSystem.borderColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
        ),
      ),
    );
  }

  Widget _buildFooterLinks() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Não tem uma conta? ',
              style: AppDesignSystem.bodyStyle.copyWith(
                color: AppDesignSystem.textSecondaryColor,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/user-type-selection');
              },
              child: Text(
                'Cadastre-se',
                style: AppDesignSystem.bodyStyle.copyWith(
                  color: AppDesignSystem.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDesignSystem.spaceMD),
        TextButton(
          onPressed: () {
            // TODO: Implementar ajuda
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Central de ajuda em desenvolvimento'),
                backgroundColor: AppDesignSystem.infoColor,
              ),
            );
          },
          child: Text(
            'Precisa de ajuda?',
            style: AppDesignSystem.captionStyle.copyWith(
              color: AppDesignSystem.textSecondaryColor,
            ),
          ),
        ),
      ],
    );
  }
}