import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  
  // Controllers para os campos editáveis
  final TextEditingController _nameController = TextEditingController(text: 'Ana Silva');
  final TextEditingController _emailController = TextEditingController(text: 'ana.silva@email.com');
  final TextEditingController _phoneController = TextEditingController(text: '+55 (11) 98888-7777');
  
  bool _isEditing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      appBar: AppDesignSystem.styledAppBar(
        title: 'Minha Conta',
        context: context,
        onBackPressed: () => Navigator.of(context).pop(),
        actions: [
          IconButton(
            onPressed: _toggleEditMode,
            icon: Icon(
              _isEditing ? Icons.check : Icons.edit,
              color: AppDesignSystem.primaryColor,
            ),
            tooltip: _isEditing ? 'Salvar alterações' : 'Editar perfil',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDesignSystem.space2XL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar e informações básicas
            _buildProfileHeader(),
            
            AppDesignSystem.verticalSpace(2),
            
            // Informações pessoais
            _buildPersonalInfoSection(),
            
            AppDesignSystem.verticalSpace(2),
            
            // Configurações de conta
            _buildAccountSection(),
            
            AppDesignSystem.verticalSpace(2),
            
            // Botão de sair
            _buildLogoutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppDesignSystem.primaryColor.withValues(alpha: 0.1),
            child: Text(
              'AS',
              style: AppDesignSystem.h1Style.copyWith(
                color: AppDesignSystem.primaryColor,
              ),
            ),
          ),
          AppDesignSystem.verticalSpace(1),
          Text(
            'Ana Silva',
            style: AppDesignSystem.h2Style,
          ),
          Text(
            'Familiar/Paciente',
            style: AppDesignSystem.bodyStyle.copyWith(
              color: AppDesignSystem.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informações Pessoais',
            style: AppDesignSystem.h3Style,
          ),
          AppDesignSystem.verticalSpace(1.5),
          _buildTextField(
            'Nome',
            _nameController,
            Icons.person,
          ),
          AppDesignSystem.verticalSpace(1),
          _buildTextField(
            'E-mail',
            _emailController,
            Icons.email,
          ),
          AppDesignSystem.verticalSpace(1),
          _buildTextField(
            'Telefone',
            _phoneController,
            Icons.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configurações da Conta',
            style: AppDesignSystem.h3Style,
          ),
          AppDesignSystem.verticalSpace(1.5),
          ListTile(
            leading: Icon(
              Icons.security,
              color: AppDesignSystem.primaryColor,
            ),
            title: const Text('Privacidade e Segurança'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidade será implementada em breve'),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.notifications,
              color: AppDesignSystem.primaryColor,
            ),
            title: const Text('Notificações'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidade será implementada em breve'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutSection() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Conta', style: AppDesignSystem.h3Style),
          AppDesignSystem.verticalSpace(1.5),
          GestureDetector(
            onTap: _showLogoutDialog,
            child: Container(
              padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
              decoration: BoxDecoration(
                color: AppDesignSystem.errorColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                border: Border.all(
                  color: AppDesignSystem.errorColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: AppDesignSystem.errorColor,
                    size: 24,
                  ),
                  const SizedBox(width: AppDesignSystem.spaceMD),
                  Expanded(
                    child: Text(
                      'Sair da Conta',
                      style: AppDesignSystem.bodyStyle.copyWith(
                        color: AppDesignSystem.errorColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppDesignSystem.errorColor,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout,
                color: AppDesignSystem.errorColor,
                size: 28,
              ),
              const SizedBox(width: AppDesignSystem.spaceMD),
              Text(
                'Sair da Conta',
                style: AppDesignSystem.h3Style.copyWith(
                  color: AppDesignSystem.errorColor,
                ),
              ),
            ],
          ),
          content: Text(
            'Tem certeza que deseja sair da sua conta? Você precisará fazer login novamente para acessar o aplicativo.',
            style: AppDesignSystem.bodyStyle,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: AppDesignSystem.bodyStyle.copyWith(
                  color: AppDesignSystem.textSecondaryColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar dialog
                _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppDesignSystem.errorColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                ),
              ),
              child: Text(
                'Sair',
                style: AppDesignSystem.bodyStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performLogout() {
    // Navegar para tela de login
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (Route<dynamic> route) => false,
    );
    
    // Mostrar feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Você saiu da sua conta com sucesso'),
        backgroundColor: AppDesignSystem.successColor,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppDesignSystem.labelStyle,
        ),
        const SizedBox(height: AppDesignSystem.spaceSM),
        TextFormField(
          controller: controller,
          enabled: _isEditing,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: AppDesignSystem.primaryColor,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
              borderSide: BorderSide(
                color: AppDesignSystem.borderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
              borderSide: BorderSide(
                color: AppDesignSystem.borderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
              borderSide: BorderSide(
                color: AppDesignSystem.primaryColor,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: _isEditing 
              ? AppDesignSystem.surfaceColor 
              : AppDesignSystem.surfaceColor.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

}
