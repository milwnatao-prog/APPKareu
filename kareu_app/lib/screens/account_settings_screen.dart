import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';
import '../services/session_service.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  // Controllers para os campos editáveis
  final TextEditingController _nameController = TextEditingController(text: 'Maria');
  final TextEditingController _surnameController = TextEditingController(text: 'Souza');
  final TextEditingController _documentController = TextEditingController(text: '123.456.789-01');
  final TextEditingController _addressController = TextEditingController(text: 'Rua das Flores, 123, Centro - Natal/RN');
  final TextEditingController _educationController = TextEditingController(text: 'Ensino Superior Completo');
  final TextEditingController _emailController = TextEditingController(text: 'maria.souza@email.com');
  final TextEditingController _phoneController = TextEditingController(text: '+55 (84) 99999-9999');
  final TextEditingController _experienceController = TextEditingController(text: 'Cuidados com idosos, Enfermagem, Fisioterapia');
  
  // Estados dos toggles
  bool _facebookLoginEnabled = true;
  bool _googleLoginEnabled = false;
  bool _appleLoginEnabled = false;
  bool _calendarIntegrationEnabled = true;
  bool _notificationsEnabled = true;
  
  // Estado do gênero selecionado
  String _selectedGender = 'Feminino';
  
  // Data de nascimento
  DateTime _birthDate = DateTime(1996, 1, 24);
  
  // Estado de edição
  bool _isEditing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _documentController.dispose();
    _addressController.dispose();
    _educationController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
    
    if (!_isEditing) {
      _saveChanges();
    }
  }
  
  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Perfil atualizado com sucesso!',
          style: AppDesignSystem.bodySmallStyle.copyWith(color: Colors.white),
        ),
        backgroundColor: AppDesignSystem.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
        ),
      ),
    );
  }

  void _showGenderDialog() {
    if (!_isEditing) return;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppDesignSystem.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
          ),
          title: Text('Selecionar Gênero', style: AppDesignSystem.h3Style),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildGenderOption('Masculino'),
              _buildGenderOption('Feminino'),
              _buildGenderOption('Outro'),
              _buildGenderOption('Prefiro não informar'),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildGenderOption(String gender) {
    return RadioListTile<String>(
      title: Text(gender, style: AppDesignSystem.bodyStyle),
      value: gender,
      groupValue: _selectedGender,
      activeColor: AppDesignSystem.primaryColor,
      onChanged: (value) {
        setState(() {
          _selectedGender = value!;
        });
        Navigator.of(context).pop();
      },
    );
  }

  void _showDatePicker() async {
    if (!_isEditing) return;
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppDesignSystem.primaryColor,
              onPrimary: Colors.white,
              surface: AppDesignSystem.cardColor,
              onSurface: AppDesignSystem.textPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _birthDate = picked;
      });
    }
  }
  
  String get _formattedBirthDate {
    return '${_birthDate.day.toString().padLeft(2, '0')}/${_birthDate.month.toString().padLeft(2, '0')}/${_birthDate.year}';
  }

  void _showCoursesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppDesignSystem.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
          ),
          title: Text('Certificados e Cursos', style: AppDesignSystem.h3Style),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.upload_file_outlined,
                size: 64,
                color: AppDesignSystem.primaryColor,
              ),
              AppDesignSystem.verticalSpace(1),
              Text(
                'Anexe seus certificados e cursos',
                style: AppDesignSystem.bodyStyle,
                textAlign: TextAlign.center,
              ),
              AppDesignSystem.verticalSpace(0.5),
              Text(
                'Formatos aceitos: PDF, JPG, PNG',
                style: AppDesignSystem.captionStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            AppDesignSystem.secondaryButton(
              text: 'Cancelar',
              onPressed: () => Navigator.of(context).pop(),
              height: 40,
            ),
            AppDesignSystem.primaryButton(
              text: 'Selecionar Arquivos',
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Funcionalidade de upload será implementada em breve',
                      style: AppDesignSystem.bodySmallStyle.copyWith(color: Colors.white),
                    ),
                    backgroundColor: AppDesignSystem.infoColor,
                  ),
                );
              },
              height: 40,
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      appBar: AppDesignSystem.styledAppBar(
        title: 'Minha Conta',
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
            
            // Seção Informações Pessoais
            _buildPersonalInfoSection(),
            
            AppDesignSystem.verticalSpace(2),
            
            // Seção Acesso e Segurança
            _buildSecuritySection(),
            
            AppDesignSystem.verticalSpace(2),
            
            // Seção Preferências
            _buildPreferencesSection(),
            
            AppDesignSystem.verticalSpace(4),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return AppDesignSystem.styledCard(
      child: Column(
        children: [
          // Avatar - Centralizado
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppDesignSystem.primaryColor.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: AppDesignSystem.primaryColor,
                  ),
                ),
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Funcionalidade de alterar foto será implementada em breve',
                            style: AppDesignSystem.bodySmallStyle.copyWith(color: Colors.white),
                          ),
                          backgroundColor: AppDesignSystem.infoColor,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(AppDesignSystem.spaceXS),
                      decoration: BoxDecoration(
                        color: AppDesignSystem.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppDesignSystem.backgroundColor,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          AppDesignSystem.verticalSpace(1),
          
          // Nome completo
          Text(
            '${_nameController.text} ${_surnameController.text}',
            style: AppDesignSystem.h2Style,
            textAlign: TextAlign.center,
          ),
          
          AppDesignSystem.verticalSpace(0.25),
          
          // Email
          Text(
            _emailController.text,
            style: AppDesignSystem.bodySmallStyle.copyWith(
              color: AppDesignSystem.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          
          AppDesignSystem.verticalSpace(0.5),
          
          // Status de verificação
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDesignSystem.spaceMD,
              vertical: AppDesignSystem.spaceXS,
            ),
            decoration: BoxDecoration(
              color: AppDesignSystem.successColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified,
                  size: 16,
                  color: AppDesignSystem.successColor,
                ),
                const SizedBox(width: AppDesignSystem.spaceXS),
                Text(
                  'Perfil Verificado',
                  style: AppDesignSystem.captionStyle.copyWith(
                    color: AppDesignSystem.successColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informações Pessoais',
          style: AppDesignSystem.sectionTitleStyle,
        ),
        
        AppDesignSystem.verticalSpace(1),
        
        AppDesignSystem.styledCard(
          child: Column(
            children: [
              _buildModernField(
                label: 'Nome',
                controller: _nameController,
                icon: Icons.person_outline,
              ),
              
              const Divider(height: 1),
              
              _buildModernField(
                label: 'Sobrenome',
                controller: _surnameController,
                icon: Icons.person_outline,
              ),
              
              const Divider(height: 1),
              
              _buildModernField(
                label: 'Documento (CPF)',
                controller: _documentController,
                icon: Icons.badge_outlined,
              ),
              
              const Divider(height: 1),
              
              _buildGenderField(),
              
              const Divider(height: 1),
              
              _buildDateField(),
              
              const Divider(height: 1),
              
              _buildModernField(
                label: 'Endereço',
                controller: _addressController,
                icon: Icons.location_on_outlined,
                maxLines: 2,
              ),
              
              const Divider(height: 1),
              
              _buildModernField(
                label: 'Escolaridade',
                controller: _educationController,
                icon: Icons.school_outlined,
              ),
              
              const Divider(height: 1),
              
              _buildModernField(
                label: 'Áreas de Experiência',
                controller: _experienceController,
                icon: Icons.work_outline,
                maxLines: 3,
              ),
              
              const Divider(height: 1),
              
              _buildCoursesField(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModernField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppDesignSystem.textSecondaryColor,
            size: 20,
          ),
          
          const SizedBox(width: AppDesignSystem.spaceLG),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppDesignSystem.labelStyle.copyWith(
                    fontSize: AppDesignSystem.fontSizeCaption,
                    color: AppDesignSystem.textSecondaryColor,
                  ),
                ),
                
                const SizedBox(height: AppDesignSystem.spaceXS),
                
                _isEditing
                  ? TextFormField(
                      controller: controller,
                      maxLines: maxLines,
                      style: AppDesignSystem.bodySmallStyle,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Digite $label',
                        hintStyle: AppDesignSystem.placeholderStyle,
                      ),
                    )
                  : Text(
                      controller.text,
                      style: AppDesignSystem.bodySmallStyle,
                      maxLines: maxLines,
                      overflow: TextOverflow.ellipsis,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            color: AppDesignSystem.textSecondaryColor,
            size: 20,
          ),
          
          const SizedBox(width: AppDesignSystem.spaceLG),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Data de Nascimento',
                  style: AppDesignSystem.labelStyle.copyWith(
                    fontSize: AppDesignSystem.fontSizeCaption,
                    color: AppDesignSystem.textSecondaryColor,
                  ),
                ),
                
                const SizedBox(height: AppDesignSystem.spaceXS),
                
                GestureDetector(
                  onTap: _showDatePicker,
                  child: Text(
                    _formattedBirthDate,
                    style: AppDesignSystem.bodySmallStyle.copyWith(
                      color: _isEditing 
                        ? AppDesignSystem.primaryColor 
                        : AppDesignSystem.textPrimaryColor,
                      decoration: _isEditing ? TextDecoration.underline : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          if (_isEditing)
            Icon(
              Icons.edit,
              color: AppDesignSystem.primaryColor,
              size: 16,
            ),
        ],
      ),
    );
  }
  
  Widget _buildGenderField() {
    return Padding(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.person_outline,
            color: AppDesignSystem.textSecondaryColor,
            size: 20,
          ),
          
          const SizedBox(width: AppDesignSystem.spaceLG),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gênero',
                  style: AppDesignSystem.labelStyle.copyWith(
                    fontSize: AppDesignSystem.fontSizeCaption,
                    color: AppDesignSystem.textSecondaryColor,
                  ),
                ),
                
                const SizedBox(height: AppDesignSystem.spaceXS),
                
                GestureDetector(
                  onTap: _showGenderDialog,
                  child: Text(
                    _selectedGender,
                    style: AppDesignSystem.bodySmallStyle.copyWith(
                      color: _isEditing 
                        ? AppDesignSystem.primaryColor 
                        : AppDesignSystem.textPrimaryColor,
                      decoration: _isEditing ? TextDecoration.underline : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          if (_isEditing)
            Icon(
              Icons.edit,
              color: AppDesignSystem.primaryColor,
              size: 16,
            ),
        ],
      ),
    );
  }

  Widget _buildCoursesField() {
    return Padding(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.school_outlined,
            color: AppDesignSystem.textSecondaryColor,
            size: 20,
          ),
          
          const SizedBox(width: AppDesignSystem.spaceLG),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Certificados e Cursos',
                  style: AppDesignSystem.labelStyle.copyWith(
                    fontSize: AppDesignSystem.fontSizeCaption,
                    color: AppDesignSystem.textSecondaryColor,
                  ),
                ),
                
                const SizedBox(height: AppDesignSystem.spaceXS),
                
                GestureDetector(
                  onTap: _showCoursesDialog,
                  child: Text(
                    'Anexar certificados',
                    style: AppDesignSystem.bodySmallStyle.copyWith(
                      color: AppDesignSystem.primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          GestureDetector(
            onTap: _showCoursesDialog,
            child: Icon(
              Icons.upload_file_outlined,
              color: AppDesignSystem.primaryColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSecuritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acesso e Segurança',
          style: AppDesignSystem.sectionTitleStyle,
        ),
        
        AppDesignSystem.verticalSpace(1),
        
        AppDesignSystem.styledCard(
          child: Column(
            children: [
              _buildSecurityField(
                label: 'E-mail',
                value: _emailController.text,
                icon: Icons.email_outlined,
                controller: _emailController,
              ),
              
              const Divider(height: 1),
              
              _buildSecurityField(
                label: 'Telefone',
                value: _phoneController.text,
                icon: Icons.phone_outlined,
                controller: _phoneController,
              ),
              
              const Divider(height: 1),
              
              _buildPasswordField(),
            ],
          ),
        ),
        
        AppDesignSystem.verticalSpace(1.5),
        
        // Login Social
        Text(
          'Login Social',
          style: AppDesignSystem.labelStyle.copyWith(
            fontSize: AppDesignSystem.fontSizeBody,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        AppDesignSystem.verticalSpace(0.5),
        
        AppDesignSystem.styledCard(
          child: Column(
            children: [
              _buildSocialLoginToggle(
                'Facebook',
                'Permitir login pelo Facebook',
                _facebookLoginEnabled,
                (value) => setState(() => _facebookLoginEnabled = value),
                Icons.facebook,
              ),
              
              const Divider(height: 1),
              
              _buildSocialLoginToggle(
                'Google',
                'Permitir login pelo Google',
                _googleLoginEnabled,
                (value) => setState(() => _googleLoginEnabled = value),
                Icons.g_mobiledata,
              ),
              
              const Divider(height: 1),
              
              _buildSocialLoginToggle(
                'Apple',
                'Permitir login pelo Apple',
                _appleLoginEnabled,
                (value) => setState(() => _appleLoginEnabled = value),
                Icons.apple,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityField({
    required String label,
    required String value,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppDesignSystem.textSecondaryColor,
            size: 20,
          ),
          
          const SizedBox(width: AppDesignSystem.spaceLG),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppDesignSystem.labelStyle.copyWith(
                    fontSize: AppDesignSystem.fontSizeCaption,
                    color: AppDesignSystem.textSecondaryColor,
                  ),
                ),
                
                const SizedBox(height: AppDesignSystem.spaceXS),
                
                _isEditing
                  ? TextFormField(
                      controller: controller,
                      style: AppDesignSystem.bodySmallStyle,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Digite $label',
                        hintStyle: AppDesignSystem.placeholderStyle,
                      ),
                    )
                  : Text(
                      value,
                      style: AppDesignSystem.bodySmallStyle,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lock_outline,
            color: AppDesignSystem.textSecondaryColor,
            size: 20,
          ),
          
          const SizedBox(width: AppDesignSystem.spaceLG),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Senha',
                  style: AppDesignSystem.labelStyle.copyWith(
                    fontSize: AppDesignSystem.fontSizeCaption,
                    color: AppDesignSystem.textSecondaryColor,
                  ),
                ),
                
                const SizedBox(height: AppDesignSystem.spaceXS),
                
                Text(
                  '••••••••',
                  style: AppDesignSystem.bodySmallStyle,
                ),
              ],
            ),
          ),
          
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Funcionalidade de alterar senha será implementada em breve',
                    style: AppDesignSystem.bodySmallStyle.copyWith(color: Colors.white),
                  ),
                  backgroundColor: AppDesignSystem.infoColor,
                ),
              );
            },
            child: Text(
              'Alterar',
              style: AppDesignSystem.bodySmallStyle.copyWith(
                color: AppDesignSystem.primaryColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSocialLoginToggle(
    String platform,
    String description,
    bool isEnabled,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppDesignSystem.surfaceColor,
              borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusSmall),
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppDesignSystem.textSecondaryColor,
            ),
          ),
          
          const SizedBox(width: AppDesignSystem.spaceLG),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  platform,
                  style: AppDesignSystem.bodySmallStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: AppDesignSystem.captionStyle,
                ),
              ],
            ),
          ),
          
          Switch(
            value: isEnabled,
            onChanged: onChanged,
            activeThumbColor: AppDesignSystem.successColor,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppDesignSystem.borderColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferências',
          style: AppDesignSystem.sectionTitleStyle,
        ),
        
        AppDesignSystem.verticalSpace(1),
        
        AppDesignSystem.styledCard(
          child: Column(
            children: [
              _buildPreferenceToggle(
                'Integração com Calendário',
                'Sincronizar agendamentos com o calendário do dispositivo',
                _calendarIntegrationEnabled,
                (value) => setState(() => _calendarIntegrationEnabled = value),
                Icons.calendar_today_outlined,
              ),
              
              const Divider(height: 1),
              
              _buildPreferenceToggle(
                'Notificações Push',
                'Receber notificações sobre agendamentos e mensagens',
                _notificationsEnabled,
                (value) => setState(() => _notificationsEnabled = value),
                Icons.notifications_outlined,
              ),
            ],
          ),
        ),
        
        AppDesignSystem.verticalSpace(2),
        
        // Botões de ação
        Column(
          children: [
            AppDesignSystem.secondaryButton(
              text: 'Termos de Uso e Privacidade',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Redirecionando para os termos...',
                      style: AppDesignSystem.bodySmallStyle.copyWith(color: Colors.white),
                    ),
                    backgroundColor: AppDesignSystem.infoColor,
                  ),
                );
              },
              width: double.infinity,
            ),
            
            AppDesignSystem.verticalSpace(0.75),
            
            AppDesignSystem.secondaryButton(
              text: 'Sair da Conta',
              onPressed: () => _showLogoutDialog(),
              width: double.infinity,
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildPreferenceToggle(
    String title,
    String description,
    bool isEnabled,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppDesignSystem.textSecondaryColor,
            size: 20,
          ),
          
          const SizedBox(width: AppDesignSystem.spaceLG),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppDesignSystem.bodySmallStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: AppDesignSystem.captionStyle,
                ),
              ],
            ),
          ),
          
          Switch(
            value: isEnabled,
            onChanged: onChanged,
            activeThumbColor: AppDesignSystem.primaryColor,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppDesignSystem.borderColor,
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
          backgroundColor: AppDesignSystem.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
          ),
          title: Text('Sair da Conta', style: AppDesignSystem.h3Style),
          content: Text(
            'Tem certeza que deseja sair da sua conta?',
            style: AppDesignSystem.bodyStyle,
          ),
          actions: [
            AppDesignSystem.secondaryButton(
              text: 'Cancelar',
              onPressed: () => Navigator.of(context).pop(),
              height: 40,
            ),
            AppDesignSystem.primaryButton(
              text: 'Sair',
              onPressed: () {
                // Limpar a sessão do usuário
                SessionService.instance.logout();
                
                // Fechar o diálogo
                Navigator.of(context).pop();
                
                // Navegar para a tela de login e limpar o histórico
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              },
              height: 40,
            ),
          ],
        );
      },
    );
  }
}
