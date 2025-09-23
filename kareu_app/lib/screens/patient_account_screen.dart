import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';

class PatientAccountScreen extends StatefulWidget {
  const PatientAccountScreen({super.key});

  @override
  State<PatientAccountScreen> createState() => _PatientAccountScreenState();
}

class _PatientAccountScreenState extends State<PatientAccountScreen> {
  // Controllers para os campos editáveis
  final TextEditingController _nameController = TextEditingController(text: 'João');
  final TextEditingController _surnameController = TextEditingController(text: 'Silva');
  final TextEditingController _documentController = TextEditingController(text: '987.654.321-00');
  final TextEditingController _addressController = TextEditingController(text: 'Av. Principal, 456, Tirol - Natal/RN');
  final TextEditingController _emailController = TextEditingController(text: 'joao.silva@email.com');
  final TextEditingController _phoneController = TextEditingController(text: '+55 (84) 88888-8888');
  final TextEditingController _emergencyContactController = TextEditingController(text: 'Maria Silva - (84) 99999-9999');
  final TextEditingController _healthInsuranceController = TextEditingController(text: 'Unimed - 123456789');
  final TextEditingController _familyDescriptionController = TextEditingController(
    text: 'Somos uma família que busca cuidados especializados para nosso ente querido. Valorizamos profissionais carinhosos, responsáveis e com experiência em cuidados domiciliares.'
  );
  
  // Estados dos toggles
  bool _facebookLoginEnabled = true;
  bool _googleLoginEnabled = false;
  bool _appleLoginEnabled = false;
  bool _calendarIntegrationEnabled = true;
  bool _notificationsEnabled = true;
  bool _shareLocationEnabled = false;
  
  // Estado do gênero selecionado
  String _selectedGender = 'Masculino';
  
  // Data de nascimento
  DateTime _birthDate = DateTime(1975, 8, 20);
  
  // Estado de edição
  bool _isEditing = false;

  // Aspectos de personalidade da família selecionados
  final Set<String> _selectedFamilyTraits = {
    'Acolhedora',
    'Respeitosa',
    'Comunicativa',
    'Organizada'
  };

  // Cuidados necessários selecionados
  final Set<String> _selectedCareNeeds = {
    'Acompanhamento médico',
    'Administração de medicamentos',
    'Higiene pessoal',
    'Mobilidade',
    'Companhia'
  };

  // Lista de aspectos de personalidade da família disponíveis
  final List<String> _familyTraits = [
    'Acolhedora', 'Respeitosa', 'Comunicativa', 'Organizada', 'Carinhosa',
    'Paciente', 'Compreensiva', 'Colaborativa', 'Flexível', 'Atenciosa',
    'Dedicada', 'Confiante', 'Tranquila', 'Presente', 'Cuidadosa'
  ];

  // Lista de cuidados necessários disponíveis
  final List<String> _careNeeds = [
    'Acompanhamento médico', 'Administração de medicamentos', 'Higiene pessoal',
    'Mobilidade', 'Companhia', 'Alimentação', 'Fisioterapia', 'Transporte',
    'Cuidados noturnos', 'Emergências médicas', 'Atividades recreativas',
    'Controle de sinais vitais', 'Curativos', 'Limpeza do ambiente',
    'Preparo de refeições', 'Acompanhamento em consultas'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _documentController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyContactController.dispose();
    _healthInsuranceController.dispose();
    _familyDescriptionController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    setState(() {
      _isEditing = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perfil atualizado com sucesso!'),
        backgroundColor: AppDesignSystem.successColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      appBar: AppDesignSystem.styledAppBar(
        context: context,
        title: 'Minha Conta - Paciente',
        onBackPressed: () => Navigator.of(context).pop(),
        actions: [
          IconButton(
            onPressed: _isEditing ? _saveChanges : _toggleEditMode,
            icon: Icon(
              _isEditing ? Icons.check : Icons.edit,
              color: AppDesignSystem.textPrimaryColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDesignSystem.space2XL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            AppDesignSystem.verticalSpace(2),
            _buildPersonalInfo(),
            AppDesignSystem.verticalSpace(2),
            _buildHealthInfo(),
            AppDesignSystem.verticalSpace(2),
            _buildFamilyDescriptionSection(),
            AppDesignSystem.verticalSpace(2),
            _buildFamilyTraitsSection(),
            AppDesignSystem.verticalSpace(2),
            _buildCareNeedsSection(),
            AppDesignSystem.verticalSpace(2),
            _buildAccessSecurity(),
            AppDesignSystem.verticalSpace(2),
            _buildSocialLogin(),
            AppDesignSystem.verticalSpace(2),
            _buildPreferences(),
            AppDesignSystem.verticalSpace(2),
            _buildLogoutSection(),
            AppDesignSystem.verticalSpace(3),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return AppDesignSystem.styledCard(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppDesignSystem.primaryColor.withValues(alpha: 0.1),
            child: Text(
              '${_nameController.text[0]}${_surnameController.text[0]}',
              style: AppDesignSystem.h1Style.copyWith(
                color: AppDesignSystem.primaryColor,
              ),
            ),
          ),
          AppDesignSystem.verticalSpace(1),
          Text(
            '${_nameController.text} ${_surnameController.text}',
            style: AppDesignSystem.h2Style,
          ),
          AppDesignSystem.verticalSpace(0.5),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDesignSystem.spaceMD,
              vertical: AppDesignSystem.spaceXS,
            ),
            decoration: BoxDecoration(
              color: AppDesignSystem.successColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusSmall),
            ),
            child: Text(
              'Paciente/Família',
              style: AppDesignSystem.captionStyle.copyWith(
                color: AppDesignSystem.successColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          AppDesignSystem.verticalSpace(1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('Contratos', '3'),
              _buildStatItem('Cuidadores', '2'),
              _buildStatItem('Desde', '2024'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppDesignSystem.h3Style.copyWith(
            color: AppDesignSystem.successColor,
          ),
        ),
        Text(
          label,
          style: AppDesignSystem.captionStyle,
        ),
      ],
    );
  }

  Widget _buildPersonalInfo() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informações Pessoais', style: AppDesignSystem.h3Style),
          AppDesignSystem.verticalSpace(1.5),
          
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _nameController,
                  label: 'Nome',
                  icon: Icons.person_outline,
                ),
              ),
              const SizedBox(width: AppDesignSystem.spaceMD),
              Expanded(
                child: _buildTextField(
                  controller: _surnameController,
                  label: 'Sobrenome',
                  icon: Icons.person_outline,
                ),
              ),
            ],
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          _buildTextField(
            controller: _documentController,
            label: 'CPF',
            icon: Icons.badge_outlined,
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          _buildGenderSelector(),
          
          AppDesignSystem.verticalSpace(1.5),
          
          _buildDateSelector(),
          
          AppDesignSystem.verticalSpace(1.5),
          
          _buildTextField(
            controller: _addressController,
            label: 'Endereço',
            icon: Icons.location_on_outlined,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthInfo() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informações de Saúde', style: AppDesignSystem.h3Style),
          AppDesignSystem.verticalSpace(1.5),
          
          _buildTextField(
            controller: _emergencyContactController,
            label: 'Contato de Emergência',
            icon: Icons.emergency_outlined,
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          _buildTextField(
            controller: _healthInsuranceController,
            label: 'Plano de Saúde',
            icon: Icons.local_hospital_outlined,
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppDesignSystem.primaryColor,
                size: 20,
              ),
              const SizedBox(width: AppDesignSystem.spaceSM),
              Expanded(
                child: Text(
                  'Compartilhar localização em emergências',
                  style: AppDesignSystem.bodyStyle,
                ),
              ),
              Switch(
                value: _shareLocationEnabled,
                onChanged: _isEditing ? (value) {
                  setState(() {
                    _shareLocationEnabled = value;
                  });
                } : null,
                activeColor: AppDesignSystem.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyDescriptionSection() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Descrição da Família', style: AppDesignSystem.h3Style),
          AppDesignSystem.verticalSpace(1.5),
          
          TextField(
            controller: _familyDescriptionController,
            enabled: _isEditing,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Descreva sua família, necessidades específicas e o que vocês valorizam em um cuidador...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                borderSide: BorderSide(color: AppDesignSystem.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                borderSide: BorderSide(color: AppDesignSystem.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                borderSide: BorderSide(color: AppDesignSystem.primaryColor, width: 2),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                borderSide: BorderSide(color: AppDesignSystem.borderColor.withValues(alpha: 0.5)),
              ),
              filled: true,
              fillColor: _isEditing ? Colors.white : AppDesignSystem.surfaceColor,
              contentPadding: const EdgeInsets.all(AppDesignSystem.spaceLG),
            ),
            style: AppDesignSystem.bodyStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyTraitsSection() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Características da Família', style: AppDesignSystem.h3Style),
          AppDesignSystem.verticalSpace(0.5),
          Text(
            'Selecione as características que descrevem sua família',
            style: AppDesignSystem.captionStyle,
          ),
          AppDesignSystem.verticalSpace(1.5),
          
          Wrap(
            spacing: AppDesignSystem.spaceSM,
            runSpacing: AppDesignSystem.spaceSM,
            children: _familyTraits.map((trait) {
              final isSelected = _selectedFamilyTraits.contains(trait);
              return GestureDetector(
                onTap: _isEditing ? () {
                  setState(() {
                    if (isSelected) {
                      _selectedFamilyTraits.remove(trait);
                    } else {
                      _selectedFamilyTraits.add(trait);
                    }
                  });
                } : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesignSystem.spaceMD,
                    vertical: AppDesignSystem.spaceSM,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected 
                      ? AppDesignSystem.successColor 
                      : AppDesignSystem.surfaceColor,
                    borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
                    border: Border.all(
                      color: isSelected 
                        ? AppDesignSystem.successColor 
                        : AppDesignSystem.borderColor,
                    ),
                  ),
                  child: Text(
                    trait,
                    style: AppDesignSystem.bodySmallStyle.copyWith(
                      color: isSelected 
                        ? Colors.white 
                        : AppDesignSystem.textPrimaryColor,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCareNeedsSection() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cuidados Necessários', style: AppDesignSystem.h3Style),
          AppDesignSystem.verticalSpace(0.5),
          Text(
            'Selecione os tipos de cuidados que você precisa',
            style: AppDesignSystem.captionStyle,
          ),
          AppDesignSystem.verticalSpace(1.5),
          
          Wrap(
            spacing: AppDesignSystem.spaceSM,
            runSpacing: AppDesignSystem.spaceSM,
            children: _careNeeds.map((need) {
              final isSelected = _selectedCareNeeds.contains(need);
              return GestureDetector(
                onTap: _isEditing ? () {
                  setState(() {
                    if (isSelected) {
                      _selectedCareNeeds.remove(need);
                    } else {
                      _selectedCareNeeds.add(need);
                    }
                  });
                } : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesignSystem.spaceMD,
                    vertical: AppDesignSystem.spaceSM,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected 
                      ? AppDesignSystem.warningColor 
                      : AppDesignSystem.surfaceColor,
                    borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
                    border: Border.all(
                      color: isSelected 
                        ? AppDesignSystem.warningColor 
                        : AppDesignSystem.borderColor,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected)
                        Icon(
                          Icons.medical_services,
                          size: 16,
                          color: Colors.white,
                        ),
                      if (isSelected) const SizedBox(width: AppDesignSystem.spaceXS),
                      Text(
                        need,
                        style: AppDesignSystem.bodySmallStyle.copyWith(
                          color: isSelected 
                            ? Colors.white 
                            : AppDesignSystem.textPrimaryColor,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessSecurity() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Acesso e Segurança', style: AppDesignSystem.h3Style),
          AppDesignSystem.verticalSpace(1.5),
          
          _buildTextField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email_outlined,
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          _buildTextField(
            controller: _phoneController,
            label: 'Telefone',
            icon: Icons.phone_outlined,
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.lock_outline,
              color: AppDesignSystem.primaryColor,
            ),
            title: Text('Alterar Senha', style: AppDesignSystem.bodyStyle),
            trailing: Icon(
              Icons.chevron_right,
              color: AppDesignSystem.textSecondaryColor,
            ),
            onTap: () {
              // Implementar alteração de senha
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidade de alteração de senha será implementada'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLogin() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Login Social', style: AppDesignSystem.h3Style),
          AppDesignSystem.verticalSpace(1.5),
          
          _buildSocialToggle(
            'Facebook',
            Icons.facebook,
            _facebookLoginEnabled,
            (value) => setState(() => _facebookLoginEnabled = value),
          ),
          
          _buildSocialToggle(
            'Google',
            Icons.g_mobiledata,
            _googleLoginEnabled,
            (value) => setState(() => _googleLoginEnabled = value),
          ),
          
          _buildSocialToggle(
            'Apple',
            Icons.apple,
            _appleLoginEnabled,
            (value) => setState(() => _appleLoginEnabled = value),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferences() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Preferências', style: AppDesignSystem.h3Style),
          AppDesignSystem.verticalSpace(1.5),
          
          _buildPreferenceToggle(
            'Integração com Calendário',
            Icons.calendar_today_outlined,
            _calendarIntegrationEnabled,
            (value) => setState(() => _calendarIntegrationEnabled = value),
          ),
          
          _buildPreferenceToggle(
            'Notificações Push',
            Icons.notifications_outlined,
            _notificationsEnabled,
            (value) => setState(() => _notificationsEnabled = value),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      enabled: _isEditing,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppDesignSystem.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
          borderSide: BorderSide(color: AppDesignSystem.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
          borderSide: BorderSide(color: AppDesignSystem.primaryColor, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
          borderSide: BorderSide(color: AppDesignSystem.borderColor.withValues(alpha: 0.5)),
        ),
        filled: true,
        fillColor: _isEditing ? Colors.white : AppDesignSystem.surfaceColor,
      ),
      style: AppDesignSystem.bodyStyle,
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person_outline, color: AppDesignSystem.primaryColor),
            const SizedBox(width: AppDesignSystem.spaceSM),
            Text('Gênero', style: AppDesignSystem.bodyStyle),
          ],
        ),
        AppDesignSystem.verticalSpace(0.5),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text('Feminino', style: AppDesignSystem.bodySmallStyle),
                value: 'Feminino',
                groupValue: _selectedGender,
                onChanged: _isEditing ? (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                } : null,
                activeColor: AppDesignSystem.primaryColor,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text('Masculino', style: AppDesignSystem.bodySmallStyle),
                value: 'Masculino',
                groupValue: _selectedGender,
                onChanged: _isEditing ? (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                } : null,
                activeColor: AppDesignSystem.primaryColor,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return GestureDetector(
      onTap: _isEditing ? () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _birthDate,
          firstDate: DateTime(1940),
          lastDate: DateTime(2010),
        );
        if (picked != null && picked != _birthDate) {
          setState(() {
            _birthDate = picked;
          });
        }
      } : null,
      child: Container(
        padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
        decoration: BoxDecoration(
          border: Border.all(color: AppDesignSystem.borderColor),
          borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
          color: _isEditing ? Colors.white : AppDesignSystem.surfaceColor,
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, color: AppDesignSystem.primaryColor),
            const SizedBox(width: AppDesignSystem.spaceSM),
            Text(
              'Data de Nascimento: ${_birthDate.day}/${_birthDate.month}/${_birthDate.year}',
              style: AppDesignSystem.bodyStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialToggle(String title, IconData icon, bool value, Function(bool) onChanged) {
    return Row(
      children: [
        Icon(icon, color: AppDesignSystem.primaryColor),
        const SizedBox(width: AppDesignSystem.spaceSM),
        Expanded(
          child: Text(title, style: AppDesignSystem.bodyStyle),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppDesignSystem.primaryColor,
        ),
      ],
    );
  }

  Widget _buildPreferenceToggle(String title, IconData icon, bool value, Function(bool) onChanged) {
    return Row(
      children: [
        Icon(icon, color: AppDesignSystem.primaryColor),
        const SizedBox(width: AppDesignSystem.spaceSM),
        Expanded(
          child: Text(title, style: AppDesignSystem.bodyStyle),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppDesignSystem.primaryColor,
        ),
      ],
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
    // Limpar dados do usuário
    // UserService.clearUserData(); // Implementar se necessário
    
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
}
