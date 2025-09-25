import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';
import '../services/user_service.dart';

class CaregiverAccountScreen extends StatefulWidget {
  const CaregiverAccountScreen({super.key});

  @override
  State<CaregiverAccountScreen> createState() => _CaregiverAccountScreenState();
}

class _CaregiverAccountScreenState extends State<CaregiverAccountScreen> {
  // Controllers para os campos editáveis
  final TextEditingController _nameController = TextEditingController(text: 'Maria');
  final TextEditingController _surnameController = TextEditingController(text: 'Souza');
  final TextEditingController _documentController = TextEditingController(text: '123.456.789-01');
  final TextEditingController _addressController = TextEditingController(text: 'Rua das Flores, 123, Centro - Natal/RN');
  final TextEditingController _educationController = TextEditingController(text: 'Técnico em Enfermagem');
  final TextEditingController _emailController = TextEditingController(text: 'maria.souza@email.com');
  final TextEditingController _phoneController = TextEditingController(text: '+55 (84) 99999-9999');
  final TextEditingController _registrationController = TextEditingController(text: 'COREN 123456');
  final TextEditingController _descriptionController = TextEditingController(
    text: 'Sou técnica de enfermagem com 5 anos de experiência em cuidados domiciliares e hospitalares. Especializada em cuidados com idosos, administração de medicamentos e acompanhamento médico.'
  );
  final TextEditingController _emergencyContactController = TextEditingController(text: 'João Souza - (84) 88888-8888');
  final TextEditingController _experienceYearsController = TextEditingController(text: '5');
  final TextEditingController _specializationController = TextEditingController(text: 'Geriatria, Cuidados Paliativos');
  final TextEditingController _hourlyRateController = TextEditingController(text: 'R\$ 25,00');
  final TextEditingController _dailyRateController = TextEditingController(text: 'R\$ 180,00');
  final TextEditingController _weeklyRateController = TextEditingController(text: 'R\$ 1.200,00');
  
  // Estados dos toggles
  bool _facebookLoginEnabled = true;
  bool _googleLoginEnabled = false;
  bool _appleLoginEnabled = false;
  bool _calendarIntegrationEnabled = true;
  bool _notificationsEnabled = true;
  bool _availableForEmergency = true;
  bool _backgroundCheckCompleted = true;
  bool _insuranceActive = true;
  bool _availableWeekends = true;
  bool _availableNights = false;
  bool _ownTransportation = true;
  
  // Estado do gênero selecionado
  String _selectedGender = 'Feminino';
  
  // Data de nascimento
  DateTime _birthDate = DateTime(1990, 5, 15);
  
  // Estado de edição
  bool _isEditing = false;

  // Aspectos de personalidade selecionados
  final Set<String> _selectedPersonalityTraits = {
    'Paciente',
    'Empática',
    'Responsável',
    'Comunicativa'
  };

  // Cuidados oferecidos selecionados
  final Set<String> _selectedCareServices = {
    'Higiene pessoal',
    'Administração de medicamentos',
    'Acompanhamento médico',
    'Mobilidade e fisioterapia',
    'Alimentação'
  };

  // Certificações profissionais selecionadas
  final Set<String> _selectedCertifications = {
    'Primeiros Socorros',
    'RCP (Ressuscitação Cardiopulmonar)',
    'Cuidados com Idosos',
    'Administração de Medicamentos'
  };

  // Horários de disponibilidade selecionados
  final Set<String> _selectedAvailability = {
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira'
  };

  // Lista de aspectos de personalidade disponíveis
  final List<String> _personalityTraits = [
    'Paciente', 'Empática', 'Responsável', 'Comunicativa', 'Carinhosa',
    'Organizada', 'Pontual', 'Discreta', 'Alegre', 'Calma', 'Atenciosa',
    'Dedicada', 'Confiável', 'Flexível', 'Proativa'
  ];

  // Lista de cuidados oferecidos disponíveis
  final List<String> _careServices = [
    'Higiene pessoal', 'Administração de medicamentos', 'Acompanhamento médico',
    'Mobilidade e fisioterapia', 'Alimentação', 'Companhia', 'Limpeza doméstica',
    'Preparo de refeições', 'Transporte', 'Cuidados noturnos', 'Emergências médicas',
    'Atividades recreativas', 'Controle de sinais vitais', 'Curativos',
    'Acompanhamento em consultas'
  ];

  // Lista de certificações disponíveis
  final List<String> _certifications = [
    'Primeiros Socorros', 'RCP (Ressuscitação Cardiopulmonar)', 'Cuidados com Idosos',
    'Administração de Medicamentos', 'Cuidados Paliativos', 'Fisioterapia Básica',
    'Nutrição Geriátrica', 'Psicologia do Idoso', 'Cuidados com Demência',
    'Enfermagem Domiciliar', 'Técnico em Enfermagem', 'Auxiliar de Enfermagem',
    'Cuidados Pós-Cirúrgicos', 'Controle de Diabetes', 'Cuidados Respiratórios'
  ];

  // Lista de dias da semana disponíveis
  final List<String> _weekDays = [
    'Segunda-feira', 'Terça-feira', 'Quarta-feira', 'Quinta-feira',
    'Sexta-feira', 'Sábado', 'Domingo'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _documentController.dispose();
    _addressController.dispose();
    _educationController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _registrationController.dispose();
    _descriptionController.dispose();
    _emergencyContactController.dispose();
    _experienceYearsController.dispose();
    _specializationController.dispose();
    _hourlyRateController.dispose();
    _dailyRateController.dispose();
    _weeklyRateController.dispose();
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
        title: 'Minha Conta - Cuidador',
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
            AppDesignSystem.verticalSpace(1),
            _buildSubscriptionCard(),
            AppDesignSystem.verticalSpace(2),
            _buildPersonalInfo(),
            AppDesignSystem.verticalSpace(2),
            _buildProfessionalInfo(),
            AppDesignSystem.verticalSpace(2),
            _buildCertificationsSection(),
            AppDesignSystem.verticalSpace(2),
            _buildAvailabilitySection(),
            AppDesignSystem.verticalSpace(2),
            _buildRatesSection(),
            AppDesignSystem.verticalSpace(2),
            _buildDescriptionSection(),
            AppDesignSystem.verticalSpace(2),
            _buildPersonalitySection(),
            AppDesignSystem.verticalSpace(2),
            _buildCareServicesSection(),
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
              color: AppDesignSystem.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusSmall),
            ),
            child: Text(
              'Cuidador Profissional',
              style: AppDesignSystem.captionStyle.copyWith(
                color: AppDesignSystem.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          AppDesignSystem.verticalSpace(1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('Contratos', '12'),
              _buildStatItem('Avaliação', '4.8⭐'),
              _buildStatItem('Experiência', '5 anos'),
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
            color: AppDesignSystem.primaryColor,
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

  Widget _buildProfessionalInfo() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informações Profissionais', style: AppDesignSystem.h3Style),
          AppDesignSystem.verticalSpace(1.5),
          
          _buildTextField(
            controller: _educationController,
            label: 'Formação',
            icon: Icons.school_outlined,
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          _buildTextField(
            controller: _registrationController,
            label: 'Registro Profissional',
            icon: Icons.card_membership_outlined,
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _experienceYearsController,
                  label: 'Anos de Experiência',
                  icon: Icons.work_outline,
                ),
              ),
              const SizedBox(width: AppDesignSystem.spaceMD),
              Expanded(
                child: _buildTextField(
                  controller: _specializationController,
                  label: 'Especializações',
                  icon: Icons.medical_services_outlined,
                ),
              ),
            ],
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          _buildTextField(
            controller: _emergencyContactController,
            label: 'Contato de Emergência',
            icon: Icons.emergency_outlined,
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          Row(
            children: [
              Icon(
                Icons.emergency,
                color: AppDesignSystem.primaryColor,
                size: 20,
              ),
              const SizedBox(width: AppDesignSystem.spaceSM),
              Expanded(
                child: Text(
                  'Disponível para emergências',
                  style: AppDesignSystem.bodyStyle,
                ),
              ),
              Switch(
                value: _availableForEmergency,
                onChanged: _isEditing ? (value) {
                  setState(() {
                    _availableForEmergency = value;
                  });
                } : null,
                activeThumbColor: AppDesignSystem.primaryColor,
              ),
            ],
          ),
          
          AppDesignSystem.verticalSpace(1),
          
          Row(
            children: [
              Icon(
                Icons.verified_user,
                color: AppDesignSystem.successColor,
                size: 20,
              ),
              const SizedBox(width: AppDesignSystem.spaceSM),
              Expanded(
                child: Text(
                  'Verificação de antecedentes concluída',
                  style: AppDesignSystem.bodyStyle,
                ),
              ),
              Switch(
                value: _backgroundCheckCompleted,
                onChanged: _isEditing ? (value) {
                  setState(() {
                    _backgroundCheckCompleted = value;
                  });
                } : null,
                activeThumbColor: AppDesignSystem.successColor,
              ),
            ],
          ),
          
          AppDesignSystem.verticalSpace(1),
          
          Row(
            children: [
              Icon(
                Icons.security,
                color: AppDesignSystem.warningColor,
                size: 20,
              ),
              const SizedBox(width: AppDesignSystem.spaceSM),
              Expanded(
                child: Text(
                  'Seguro de responsabilidade civil ativo',
                  style: AppDesignSystem.bodyStyle,
                ),
              ),
              Switch(
                value: _insuranceActive,
                onChanged: _isEditing ? (value) {
                  setState(() {
                    _insuranceActive = value;
                  });
                } : null,
                activeThumbColor: AppDesignSystem.warningColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Descrição Profissional', style: AppDesignSystem.h3Style),
          AppDesignSystem.verticalSpace(1.5),
          
          TextField(
            controller: _descriptionController,
            enabled: _isEditing,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Descreva sua experiência, especialidades e abordagem de cuidado...',
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

  Widget _buildPersonalitySection() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Aspectos de Personalidade', style: AppDesignSystem.h3Style),
          AppDesignSystem.verticalSpace(0.5),
          Text(
            'Selecione as características que melhor descrevem você',
            style: AppDesignSystem.captionStyle,
          ),
          AppDesignSystem.verticalSpace(1.5),
          
          Wrap(
            spacing: AppDesignSystem.spaceSM,
            runSpacing: AppDesignSystem.spaceSM,
            children: _personalityTraits.map((trait) {
              final isSelected = _selectedPersonalityTraits.contains(trait);
              return GestureDetector(
                onTap: _isEditing ? () {
                  setState(() {
                    if (isSelected) {
                      _selectedPersonalityTraits.remove(trait);
                    } else {
                      _selectedPersonalityTraits.add(trait);
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
                      ? AppDesignSystem.primaryColor 
                      : AppDesignSystem.surfaceColor,
                    borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
                    border: Border.all(
                      color: isSelected 
                        ? AppDesignSystem.primaryColor 
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

  Widget _buildCareServicesSection() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cuidados Oferecidos', style: AppDesignSystem.h3Style),
          AppDesignSystem.verticalSpace(0.5),
          Text(
            'Selecione os tipos de cuidados que você oferece',
            style: AppDesignSystem.captionStyle,
          ),
          AppDesignSystem.verticalSpace(1.5),
          
          Wrap(
            spacing: AppDesignSystem.spaceSM,
            runSpacing: AppDesignSystem.spaceSM,
            children: _careServices.map((service) {
              final isSelected = _selectedCareServices.contains(service);
              return GestureDetector(
                onTap: _isEditing ? () {
                  setState(() {
                    if (isSelected) {
                      _selectedCareServices.remove(service);
                    } else {
                      _selectedCareServices.add(service);
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: Colors.white,
                        ),
                      if (isSelected) const SizedBox(width: AppDesignSystem.spaceXS),
                      Text(
                        service,
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
              child: Row(
                children: [
                  Radio<String>(
                    value: 'Feminino',
                    groupValue: _selectedGender,
                    onChanged: _isEditing ? (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    } : null,
                    activeColor: AppDesignSystem.primaryColor,
                  ),
                  Text('Feminino', style: AppDesignSystem.bodySmallStyle),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Radio<String>(
                    value: 'Masculino',
                    groupValue: _selectedGender,
                    onChanged: _isEditing ? (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    } : null,
                    activeColor: AppDesignSystem.primaryColor,
                  ),
                  Text('Masculino', style: AppDesignSystem.bodySmallStyle),
                ],
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

  Widget _buildCertificationsSection() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Certificações e Qualificações', style: AppDesignSystem.h3Style),
          AppDesignSystem.verticalSpace(0.5),
          Text(
            'Selecione suas certificações e qualificações profissionais',
            style: AppDesignSystem.captionStyle,
          ),
          AppDesignSystem.verticalSpace(1.5),
          
          Wrap(
            spacing: AppDesignSystem.spaceSM,
            runSpacing: AppDesignSystem.spaceSM,
            children: _certifications.map((certification) {
              final isSelected = _selectedCertifications.contains(certification);
              return GestureDetector(
                onTap: _isEditing ? () {
                  setState(() {
                    if (isSelected) {
                      _selectedCertifications.remove(certification);
                    } else {
                      _selectedCertifications.add(certification);
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
                          Icons.verified,
                          size: 16,
                          color: Colors.white,
                        ),
                      if (isSelected) const SizedBox(width: AppDesignSystem.spaceXS),
                      Text(
                        certification,
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

  Widget _buildAvailabilitySection() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Disponibilidade', style: AppDesignSystem.h3Style),
          AppDesignSystem.verticalSpace(0.5),
          Text(
            'Selecione os dias da semana em que você está disponível',
            style: AppDesignSystem.captionStyle,
          ),
          AppDesignSystem.verticalSpace(1.5),
          
          Wrap(
            spacing: AppDesignSystem.spaceSM,
            runSpacing: AppDesignSystem.spaceSM,
            children: _weekDays.map((day) {
              final isSelected = _selectedAvailability.contains(day);
              return GestureDetector(
                onTap: _isEditing ? () {
                  setState(() {
                    if (isSelected) {
                      _selectedAvailability.remove(day);
                    } else {
                      _selectedAvailability.add(day);
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
                      ? AppDesignSystem.primaryColor 
                      : AppDesignSystem.surfaceColor,
                    borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
                    border: Border.all(
                      color: isSelected 
                        ? AppDesignSystem.primaryColor 
                        : AppDesignSystem.borderColor,
                    ),
                  ),
                  child: Text(
                    day,
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
          
          AppDesignSystem.verticalSpace(1.5),
          
          Row(
            children: [
              Icon(
                Icons.weekend,
                color: AppDesignSystem.primaryColor,
                size: 20,
              ),
              const SizedBox(width: AppDesignSystem.spaceSM),
              Expanded(
                child: Text(
                  'Disponível aos fins de semana',
                  style: AppDesignSystem.bodyStyle,
                ),
              ),
              Switch(
                value: _availableWeekends,
                onChanged: _isEditing ? (value) {
                  setState(() {
                    _availableWeekends = value;
                  });
                } : null,
                activeThumbColor: AppDesignSystem.primaryColor,
              ),
            ],
          ),
          
          AppDesignSystem.verticalSpace(1),
          
          Row(
            children: [
              Icon(
                Icons.nightlight_round,
                color: AppDesignSystem.primaryColor,
                size: 20,
              ),
              const SizedBox(width: AppDesignSystem.spaceSM),
              Expanded(
                child: Text(
                  'Disponível para plantões noturnos',
                  style: AppDesignSystem.bodyStyle,
                ),
              ),
              Switch(
                value: _availableNights,
                onChanged: _isEditing ? (value) {
                  setState(() {
                    _availableNights = value;
                  });
                } : null,
                activeThumbColor: AppDesignSystem.primaryColor,
              ),
            ],
          ),
          
          AppDesignSystem.verticalSpace(1),
          
          Row(
            children: [
              Icon(
                Icons.directions_car,
                color: AppDesignSystem.primaryColor,
                size: 20,
              ),
              const SizedBox(width: AppDesignSystem.spaceSM),
              Expanded(
                child: Text(
                  'Possui transporte próprio',
                  style: AppDesignSystem.bodyStyle,
                ),
              ),
              Switch(
                value: _ownTransportation,
                onChanged: _isEditing ? (value) {
                  setState(() {
                    _ownTransportation = value;
                  });
                } : null,
                activeThumbColor: AppDesignSystem.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatesSection() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tarifas e Condições', style: AppDesignSystem.h3Style),
          AppDesignSystem.verticalSpace(1.5),
          
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _hourlyRateController,
                  label: 'Valor por Hora',
                  icon: Icons.access_time,
                ),
              ),
              const SizedBox(width: AppDesignSystem.spaceMD),
              Expanded(
                child: _buildTextField(
                  controller: _dailyRateController,
                  label: 'Valor por Dia',
                  icon: Icons.today,
                ),
              ),
            ],
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          _buildTextField(
            controller: _weeklyRateController,
            label: 'Valor por Semana',
            icon: Icons.date_range,
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          Container(
            padding: const EdgeInsets.all(AppDesignSystem.spaceMD),
            decoration: BoxDecoration(
              color: AppDesignSystem.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
              border: Border.all(
                color: AppDesignSystem.primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppDesignSystem.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: AppDesignSystem.spaceSM),
                Expanded(
                  child: Text(
                    'Os valores podem ser negociados conforme a complexidade dos cuidados necessários',
                    style: AppDesignSystem.bodySmallStyle.copyWith(
                      color: AppDesignSystem.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
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

  Widget _buildSubscriptionCard() {
    final currentTier = UserService.currentSubscriptionTier;
    final tierName = UserService.getSubscriptionDisplayName();
    final tierPrice = UserService.getSubscriptionPrice();
    
    Color tierColor;
    IconData tierIcon;
    String statusText;
    
    switch (currentTier) {
      case SubscriptionTier.free:
        tierColor = AppDesignSystem.grayColor;
        tierIcon = Icons.person_outline;
        statusText = 'Upgrade para ativar seu perfil';
        break;
      case SubscriptionTier.basic:
        tierColor = AppDesignSystem.infoColor;
        tierIcon = Icons.verified_user;
        statusText = 'Perfil ativo - 5 agendamentos/mês';
        break;
      case SubscriptionTier.plus:
        tierColor = AppDesignSystem.warningColor;
        tierIcon = Icons.star;
        statusText = 'Destaque na busca - Ilimitado';
        break;
      case SubscriptionTier.premium:
        tierColor = const Color(0xFFFFD700);
        tierIcon = Icons.workspace_premium;
        statusText = 'Posição TOP + Benefícios exclusivos';
        break;
    }
    
    return AppDesignSystem.styledCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: tierColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  tierIcon,
                  color: tierColor,
                  size: 24,
                ),
              ),
              AppDesignSystem.horizontalSpace(1),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Plano $tierName',
                          style: AppDesignSystem.h3Style.copyWith(
                            fontWeight: FontWeight.w700,
                            color: tierColor,
                          ),
                        ),
                        if (currentTier != SubscriptionTier.free) ...[
                          AppDesignSystem.horizontalSpace(0.5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppDesignSystem.successColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'ATIVO',
                              style: AppDesignSystem.captionStyle.copyWith(
                                color: AppDesignSystem.successColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      statusText,
                      style: AppDesignSystem.bodyStyle.copyWith(
                        color: AppDesignSystem.grayColor,
                      ),
                    ),
                    if (currentTier != SubscriptionTier.free)
                      Text(
                        'R\$ ${tierPrice.toStringAsFixed(2).replaceAll('.', ',')}/mês',
                        style: AppDesignSystem.captionStyle.copyWith(
                          color: AppDesignSystem.grayColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          Row(
            children: [
              Expanded(
                child: AppDesignSystem.secondaryButton(
                  text: 'Gerenciar Assinatura',
                  onPressed: () => Navigator.pushNamed(context, '/subscription-management'),
                ),
              ),
              if (currentTier != SubscriptionTier.premium) ...[
                AppDesignSystem.horizontalSpace(1),
                Expanded(
                  child: AppDesignSystem.primaryButton(
                    text: currentTier == SubscriptionTier.free ? 'Ativar Plano' : 'Upgrade',
                    onPressed: () => Navigator.pushNamed(context, '/caregiver-payment'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
