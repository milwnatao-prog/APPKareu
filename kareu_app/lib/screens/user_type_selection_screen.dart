import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';

enum UserType { needCaregiver, amCaregiver }

class UserTypeSelectionScreen extends StatefulWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  State<UserTypeSelectionScreen> createState() => _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  UserType? _selectedType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      appBar: AppDesignSystem.styledAppBar(
        title: 'Criar Conta',
        context: context,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDesignSystem.space2XL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header com logo e boas-vindas
            _buildHeader(),
            
            const SizedBox(height: AppDesignSystem.space3XL),
            
            // Título da seleção
            _buildSelectionTitle(),
            
            const SizedBox(height: AppDesignSystem.space2XL),
            
            // Opções de tipo de usuário
            _buildUserTypeOptions(),
            
            const SizedBox(height: AppDesignSystem.space3XL),
            
            // Botão continuar
            _buildContinueButton(),
            
            const SizedBox(height: AppDesignSystem.space2XL),
            
            // Link para login
            _buildLoginLink(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo Kareu
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignSystem.spaceLG,
            vertical: AppDesignSystem.spaceMD,
          ),
          decoration: BoxDecoration(
            color: AppDesignSystem.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Kareu',
            style: AppDesignSystem.logoStyle.copyWith(
              fontSize: 32,
              color: AppDesignSystem.primaryColor,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        
        const SizedBox(height: AppDesignSystem.spaceLG),
        
        // Mensagem de boas-vindas
        Text(
          'Bem-vindo ao Kareu!',
          style: AppDesignSystem.h1Style,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppDesignSystem.spaceSM),
        
        Text(
          'Para começar, nos conte qual é o seu perfil',
          style: AppDesignSystem.bodyStyle.copyWith(
            color: AppDesignSystem.textSecondaryColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSelectionTitle() {
    return Column(
      children: [
        Text(
          'Eu sou...',
          style: AppDesignSystem.h2Style,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDesignSystem.spaceSM),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            color: AppDesignSystem.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildUserTypeOptions() {
    return Column(
      children: [
        // Opção: Paciente/Família
        _buildUserTypeCard(
          type: UserType.needCaregiver,
          title: 'Paciente ou Família',
          subtitle: 'Preciso de cuidadores profissionais',
          description: 'Encontre cuidadores qualificados para você ou sua família',
          icon: Icons.family_restroom,
          color: AppDesignSystem.primaryColor,
        ),
        
        const SizedBox(height: AppDesignSystem.spaceLG),
        
        // Opção: Profissional
        _buildUserTypeCard(
          type: UserType.amCaregiver,
          title: 'Profissional de Saúde',
          subtitle: 'Sou um cuidador profissional',
          description: 'Ofereço serviços de cuidados e quero encontrar pacientes',
          icon: Icons.medical_services,
          color: AppDesignSystem.accentColor,
        ),
      ],
    );
  }

  Widget _buildUserTypeCard({
    required UserType type,
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedType == type;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
        decoration: BoxDecoration(
          color: isSelected 
              ? color.withOpacity(0.1) 
              : AppDesignSystem.surfaceColor,
          border: Border.all(
            color: isSelected 
                ? color 
                : AppDesignSystem.borderColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
          boxShadow: isSelected ? [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Ícone
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? color 
                        : color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected 
                        ? Colors.white 
                        : color,
                    size: 24,
                  ),
                ),
                
                const SizedBox(width: AppDesignSystem.spaceLG),
                
                // Título e subtítulo
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppDesignSystem.h3Style.copyWith(
                          color: isSelected 
                              ? color 
                              : AppDesignSystem.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: AppDesignSystem.spaceXS),
                      Text(
                        subtitle,
                        style: AppDesignSystem.bodySmallStyle.copyWith(
                          color: AppDesignSystem.textSecondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Indicador de seleção
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected 
                          ? color 
                          : AppDesignSystem.borderColor,
                      width: 2,
                    ),
                    color: isSelected 
                        ? color 
                        : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
              ],
            ),
            
            const SizedBox(height: AppDesignSystem.spaceMD),
            
            // Descrição
            Text(
              description,
              style: AppDesignSystem.bodySmallStyle.copyWith(
                color: AppDesignSystem.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return AppDesignSystem.primaryButton(
      text: 'Continuar',
      onPressed: _selectedType != null ? () => _handleContinue() : () {},
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Já tem uma conta? ',
          style: AppDesignSystem.bodyStyle.copyWith(
            color: AppDesignSystem.textSecondaryColor,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Fazer login',
            style: AppDesignSystem.bodyStyle.copyWith(
              color: AppDesignSystem.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _handleContinue() {
    if (_selectedType == null) return;
    
    // Navegar para a tela de cadastro unificada passando o tipo de usuário
    Navigator.pushNamed(
      context, 
      '/register',
      arguments: _selectedType,
    );
  }
}

