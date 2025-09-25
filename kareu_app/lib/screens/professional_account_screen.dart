import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';

class ProfessionalAccountScreen extends StatefulWidget {
  const ProfessionalAccountScreen({super.key});

  @override
  State<ProfessionalAccountScreen> createState() => _ProfessionalAccountScreenState();
}

class _ProfessionalAccountScreenState extends State<ProfessionalAccountScreen> {
  // Controllers para os campos editáveis
  final TextEditingController _nameController = TextEditingController(text: 'Maria');
  final TextEditingController _surnameController = TextEditingController(text: 'Santos');
  final TextEditingController _documentController = TextEditingController(text: '123.456.789-00');
  final TextEditingController _addressController = TextEditingController(text: 'Rua das Flores, 123, Petrópolis - Natal/RN');
  final TextEditingController _emailController = TextEditingController(text: 'maria.santos@email.com');
  final TextEditingController _phoneController = TextEditingController(text: '+55 (84) 99999-9999');
  final TextEditingController _professionalRegistrationController = TextEditingController(text: 'COREN-RN 12345');
  final TextEditingController _professionalDescriptionController = TextEditingController(
    text: 'Profissional dedicada com 8 anos de experiência em cuidados domiciliares. Especializada em cuidados com idosos, administração de medicamentos e acompanhamento médico. Tenho paixão por proporcionar qualidade de vida e bem-estar aos pacientes.'
  );
  final TextEditingController _hourlyRateController = TextEditingController(text: '45,00');
  
  // Características de personalidade
  final Set<String> _selectedPersonalityTraits = {
    'Empática',
    'Paciente',
    'Responsável',
    'Comunicativa'
  };
  
  // Estados dos toggles
  bool _facebookLoginEnabled = true;
  bool _googleLoginEnabled = false;
  bool _appleLoginEnabled = false;
  bool _calendarIntegrationEnabled = true;
  bool _notificationsEnabled = true;
  bool _shareLocationEnabled = true;
  bool _acceptUrgentCalls = true;
  bool _availableWeekendsEnabled = false;
  
  // Estado do gênero selecionado
  String _selectedGender = 'Feminino';
  
  // Data de nascimento
  DateTime _birthDate = DateTime(1990, 3, 15);
  
  // Estado de edição
  bool _isEditing = false;

  // Especialidades profissionais selecionadas
  final Set<String> _selectedSpecialties = {
    'Cuidados com Idosos',
    'Administração de Medicamentos',
    'Cuidados Pós-Cirúrgicos',
    'Fisioterapia Domiciliar'
  };

  // Informações de assinatura
  String _currentPlan = 'Premium';
  DateTime _planExpiryDate = DateTime(2024, 12, 31);
  bool _autoRenewal = true;

  // Níveis de experiência selecionados
  final Set<String> _selectedExperienceLevels = {
    'Experiente (5+ anos)',
    'Certificações Profissionais',
    'Primeiros Socorros'
  };

  // Disponibilidade de horários
  final Set<String> _selectedAvailability = {
    'Manhã (6h-12h)',
    'Tarde (12h-18h)',
    'Noite (18h-24h)'
  };

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _documentController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _professionalRegistrationController.dispose();
    _professionalDescriptionController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    // Aqui você implementaria a lógica para salvar as alterações
    setState(() {
      _isEditing = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alterações salvas com sucesso!'),
        backgroundColor: AppDesignSystem.primaryColor,
      ),
    );
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
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
              'Profissional de Cuidados',
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
              _buildStatItem('Avaliação', '4.8'),
              _buildStatItem('Pacientes', '47'),
              _buildStatItem('Atendimentos', '234'),
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



  Widget _buildDropdownField(String label, String value, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppDesignSystem.captionStyle,
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: _isEditing ? onChanged : null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
            ),
            contentPadding: const EdgeInsets.all(AppDesignSystem.spaceMD),
          ),
          items: options.map<DropdownMenuItem<String>>((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPersonalInfo() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informações Pessoais',
            style: AppDesignSystem.sectionTitleStyle,
          ),
          AppDesignSystem.verticalSpace(1),
          
          _buildInfoRow(
            'Nome',
            _nameController,
            Icons.person_outline,
            enabled: _isEditing,
          ),
          
          _buildInfoRow(
            'Sobrenome',
            _surnameController,
            Icons.person_outline,
            enabled: _isEditing,
          ),
          
          _buildInfoRow(
            'CPF',
            _documentController,
            Icons.assignment_ind_outlined,
            enabled: _isEditing,
          ),
          
          _buildInfoRow(
            'Registro Profissional',
            _professionalRegistrationController,
            Icons.verified_user_outlined,
            enabled: _isEditing,
          ),

          _buildGenderSelector(),
          
          _buildDateSelector(),
          
          _buildInfoRow(
            'Endereço',
            _addressController,
            Icons.location_on_outlined,
            enabled: _isEditing,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contato',
            style: AppDesignSystem.sectionTitleStyle,
          ),
          AppDesignSystem.verticalSpace(1),
          
          _buildInfoRow(
            'E-mail',
            _emailController,
            Icons.email_outlined,
            enabled: _isEditing,
          ),
          
          _buildInfoRow(
            'Telefone',
            _phoneController,
            Icons.phone_outlined,
            enabled: _isEditing,
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
          const Text(
            'Informações Profissionais',
            style: AppDesignSystem.sectionTitleStyle,
          ),
          AppDesignSystem.verticalSpace(1),
          
          AppDesignSystem.styledTextField(
            label: 'Descrição Profissional',
            hint: 'Conte sobre sua experiência e especialidades',
            controller: _professionalDescriptionController,
            maxLines: 4,
          ),
          
          AppDesignSystem.verticalSpace(1),
          
          _buildMultiSelectSection(
            'Especialidades',
            _selectedSpecialties,
            [
              'Cuidados com Idosos',
              'Administração de Medicamentos',
              'Cuidados Pós-Cirúrgicos',
              'Fisioterapia Domiciliar',
              'Cuidados Paliativos',
              'Enfermagem Domiciliar',
              'Acompanhamento Médico',
              'Reabilitação',
            ],
          ),
          
          AppDesignSystem.verticalSpace(1),
          
          _buildMultiSelectSection(
            'Nível de Experiência',
            _selectedExperienceLevels,
            [
              'Iniciante (1-2 anos)',
              'Intermediário (2-5 anos)',
              'Experiente (5+ anos)',
              'Certificações Profissionais',
              'Primeiros Socorros',
              'Especialização Técnica',
            ],
          ),
          
          AppDesignSystem.verticalSpace(1),
          
          _buildMultiSelectSection(
            'Disponibilidade de Horários',
            _selectedAvailability,
            [
              'Madrugada (0h-6h)',
              'Manhã (6h-12h)',
              'Tarde (12h-18h)',
              'Noite (18h-24h)',
              'Finais de Semana',
              'Feriados',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Preferências Profissionais',
            style: AppDesignSystem.sectionTitleStyle,
          ),
          AppDesignSystem.verticalSpace(1),
          
          _buildSwitchTile(
            'Aceitar Chamadas Urgentes',
            'Receber notificações para casos urgentes',
            _acceptUrgentCalls,
            (value) => setState(() => _acceptUrgentCalls = value),
            Icons.emergency_outlined,
          ),
          
          _buildSwitchTile(
            'Disponível aos Finais de Semana',
            'Trabalhar em sábados e domingos',
            _availableWeekendsEnabled,
            (value) => setState(() => _availableWeekendsEnabled = value),
            Icons.weekend_outlined,
          ),
          
          _buildSwitchTile(
            'Compartilhar Localização',
            'Permitir que famílias vejam sua localização',
            _shareLocationEnabled,
            (value) => setState(() => _shareLocationEnabled = value),
            Icons.location_on_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Privacidade e Configurações',
            style: AppDesignSystem.sectionTitleStyle,
          ),
          AppDesignSystem.verticalSpace(1),
          
          _buildSwitchTile(
            'Login com Facebook',
            'Usar Facebook para entrar na conta',
            _facebookLoginEnabled,
            (value) => setState(() => _facebookLoginEnabled = value),
            Icons.facebook,
          ),
          
          _buildSwitchTile(
            'Login com Google',
            'Usar Google para entrar na conta',
            _googleLoginEnabled,
            (value) => setState(() => _googleLoginEnabled = value),
            Icons.g_mobiledata,
          ),
          
          _buildSwitchTile(
            'Login com Apple',
            'Usar Apple ID para entrar na conta',
            _appleLoginEnabled,
            (value) => setState(() => _appleLoginEnabled = value),
            Icons.apple,
          ),
          
          _buildSwitchTile(
            'Integração com Calendário',
            'Sincronizar agendamentos com seu calendário',
            _calendarIntegrationEnabled,
            (value) => setState(() => _calendarIntegrationEnabled = value),
            Icons.calendar_today_outlined,
          ),
          
          _buildSwitchTile(
            'Notificações Push',
            'Receber notificações no dispositivo',
            _notificationsEnabled,
            (value) => setState(() => _notificationsEnabled = value),
            Icons.notifications_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool enabled = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesignSystem.spaceLG),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppDesignSystem.surfaceColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppDesignSystem.primaryColor,
              size: 20,
            ),
          ),
          AppDesignSystem.horizontalSpace(1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppDesignSystem.captionStyle,
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: controller,
                  enabled: enabled,
                  maxLines: maxLines,
                  style: enabled 
                    ? AppDesignSystem.bodyStyle 
                    : AppDesignSystem.bodyStyle.copyWith(
                        color: AppDesignSystem.textSecondaryColor,
                      ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: enabled 
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppDesignSystem.borderColor),
                        )
                      : InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppDesignSystem.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppDesignSystem.primaryColor, width: 2),
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

  Widget _buildGenderSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesignSystem.spaceLG),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppDesignSystem.surfaceColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.people_outline,
              color: AppDesignSystem.primaryColor,
              size: 20,
            ),
          ),
          AppDesignSystem.horizontalSpace(1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gênero',
                  style: AppDesignSystem.captionStyle,
                ),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  onChanged: _isEditing ? (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    }
                  } : null,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: _isEditing 
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppDesignSystem.borderColor),
                        )
                      : InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppDesignSystem.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppDesignSystem.primaryColor, width: 2),
                    ),
                  ),
                  items: ['Masculino', 'Feminino', 'Outro', 'Prefiro não informar']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesignSystem.spaceLG),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppDesignSystem.surfaceColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.calendar_today_outlined,
              color: AppDesignSystem.primaryColor,
              size: 20,
            ),
          ),
          AppDesignSystem.horizontalSpace(1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Data de Nascimento',
                  style: AppDesignSystem.captionStyle,
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: _isEditing ? _showDatePicker : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: _isEditing 
                        ? Border.all(color: AppDesignSystem.borderColor)
                        : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_birthDate.day.toString().padLeft(2, '0')}/${_birthDate.month.toString().padLeft(2, '0')}/${_birthDate.year}',
                          style: _isEditing 
                            ? AppDesignSystem.bodyStyle 
                            : AppDesignSystem.bodyStyle.copyWith(
                                color: AppDesignSystem.textSecondaryColor,
                              ),
                        ),
                        if (_isEditing)
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: AppDesignSystem.primaryColor,
                          ),
                      ],
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

  Widget _buildMultiSelectSection(String title, Set<String> selectedItems, List<String> allItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppDesignSystem.labelStyle,
        ),
        AppDesignSystem.verticalSpace(0.5),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allItems.map((item) {
            final isSelected = selectedItems.contains(item);
            return FilterChip(
              label: Text(
                item,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppDesignSystem.textPrimaryColor,
                  fontSize: AppDesignSystem.fontSizeBodySmall,
                ),
              ),
              selected: isSelected,
              onSelected: _isEditing ? (bool selected) {
                setState(() {
                  if (selected) {
                    selectedItems.add(item);
                  } else {
                    selectedItems.remove(item);
                  }
                });
              } : null,
              backgroundColor: AppDesignSystem.surfaceColor,
              selectedColor: AppDesignSystem.primaryColor,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected ? AppDesignSystem.primaryColor : AppDesignSystem.borderColor,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesignSystem.spaceLG),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppDesignSystem.surfaceColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppDesignSystem.primaryColor,
              size: 20,
            ),
          ),
          AppDesignSystem.horizontalSpace(1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppDesignSystem.bodyStyle,
                ),
                Text(
                  subtitle,
                  style: AppDesignSystem.captionStyle,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppDesignSystem.primaryColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      appBar: AppDesignSystem.styledAppBar(
        context: context,
        title: 'Minha Conta - Profissional',
        onBackPressed: () => Navigator.of(context).pop(),
        actions: [
          IconButton(
            onPressed: _isEditing ? _saveChanges : _toggleEditing,
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
            _buildContactInfo(),
            AppDesignSystem.verticalSpace(2),
            _buildProfessionalInfo(),
            AppDesignSystem.verticalSpace(2),
            _buildPersonalityTraitsSection(),
            AppDesignSystem.verticalSpace(2),
            _buildPricingSection(),
            AppDesignSystem.verticalSpace(2),
            _buildSubscriptionSection(),
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

  Widget _buildPersonalityTraitsSection() {
    final availableTraits = [
      'Empática', 'Paciente', 'Responsável', 'Comunicativa', 'Carinhosa',
      'Atenta', 'Dedicada', 'Pontual', 'Organizada', 'Flexível',
      'Calma', 'Energética', 'Motivadora', 'Discreta', 'Confiável'
    ];

    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology,
                color: AppDesignSystem.primaryColor,
                size: 24,
              ),
              AppDesignSystem.horizontalSpace(0.5),
              Text(
                'Características de Personalidade',
                style: AppDesignSystem.h3Style,
              ),
            ],
          ),
          AppDesignSystem.verticalSpace(1),
          Text(
            'Selecione suas principais características pessoais que ajudam no cuidado:',
            style: AppDesignSystem.bodySmallStyle.copyWith(
              color: AppDesignSystem.textSecondaryColor,
            ),
          ),
          AppDesignSystem.verticalSpace(1),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableTraits.map((trait) {
              final isSelected = _selectedPersonalityTraits.contains(trait);
              return FilterChip(
                label: Text(
                  trait,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppDesignSystem.textPrimaryColor,
                    fontSize: AppDesignSystem.fontSizeBodySmall,
                  ),
                ),
                selected: isSelected,
                onSelected: _isEditing ? (bool selected) {
                  setState(() {
                    if (selected) {
                      _selectedPersonalityTraits.add(trait);
                    } else {
                      _selectedPersonalityTraits.remove(trait);
                    }
                  });
                } : null,
                backgroundColor: AppDesignSystem.surfaceColor,
                selectedColor: AppDesignSystem.primaryColor,
                checkmarkColor: Colors.white,
                side: BorderSide(
                  color: isSelected ? AppDesignSystem.primaryColor : AppDesignSystem.borderColor,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.monetization_on,
                color: AppDesignSystem.primaryColor,
                size: 24,
              ),
              AppDesignSystem.horizontalSpace(0.5),
              Text(
                'Valor por Hora',
                style: AppDesignSystem.h3Style,
              ),
            ],
          ),
          AppDesignSystem.verticalSpace(1),
          Text(
            'Defina seu valor por hora de serviço:',
            style: AppDesignSystem.bodySmallStyle.copyWith(
              color: AppDesignSystem.textSecondaryColor,
            ),
          ),
          AppDesignSystem.verticalSpace(1),
          Row(
            children: [
              Text(
                'R\$',
                style: AppDesignSystem.h2Style.copyWith(
                  color: AppDesignSystem.primaryColor,
                ),
              ),
              AppDesignSystem.horizontalSpace(0.5),
              Expanded(
                child: TextField(
                  controller: _hourlyRateController,
                  enabled: _isEditing,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: '45,00',
                    suffixText: '/hora',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppDesignSystem.spaceMD,
                      vertical: AppDesignSystem.spaceMD,
                    ),
                  ),
                ),
              ),
            ],
          ),
          AppDesignSystem.verticalSpace(1),
          Container(
            padding: EdgeInsets.all(AppDesignSystem.spaceMD),
            decoration: BoxDecoration(
              color: AppDesignSystem.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppDesignSystem.primaryColor,
                  size: 20,
                ),
                AppDesignSystem.horizontalSpace(0.5),
                Expanded(
                  child: Text(
                    'Seus ganhos podem variar de acordo com a demanda e avaliações dos pacientes.',
                    style: AppDesignSystem.captionStyle.copyWith(
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

  Widget _buildSubscriptionSection() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.workspace_premium,
                color: AppDesignSystem.primaryColor,
                size: 24,
              ),
              AppDesignSystem.horizontalSpace(0.5),
              Text(
                'Plano de Assinatura',
                style: AppDesignSystem.h3Style,
              ),
            ],
          ),
          AppDesignSystem.verticalSpace(1),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppDesignSystem.spaceLG),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppDesignSystem.primaryColor,
                  AppDesignSystem.primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.diamond,
                      color: Colors.white,
                      size: 20,
                    ),
                    AppDesignSystem.horizontalSpace(0.5),
                    Text(
                      'Plano $_currentPlan',
                      style: AppDesignSystem.h3Style.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                AppDesignSystem.verticalSpace(0.5),
                Text(
                  'Válido até: ${_planExpiryDate.day}/${_planExpiryDate.month}/${_planExpiryDate.year}',
                  style: AppDesignSystem.bodySmallStyle.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          AppDesignSystem.verticalSpace(1),
          _buildSwitchTile(
            'Renovação Automática',
            'Renova automaticamente na data de vencimento',
            _autoRenewal,
            (value) {
              setState(() {
                _autoRenewal = value;
              });
            },
            Icons.autorenew,
          ),
          Row(
            children: [
              Expanded(
                child: AppDesignSystem.secondaryButton(
                  text: 'Alterar Plano',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Funcionalidade de alteração de plano em desenvolvimento'),
                        backgroundColor: AppDesignSystem.infoColor,
                      ),
                    );
                  },
                ),
              ),
              AppDesignSystem.horizontalSpace(1),
              Expanded(
                child: AppDesignSystem.primaryButton(
                  text: 'Ver Benefícios',
                  onPressed: () {
                    _showSubscriptionBenefits();
                  },
                ),
              ),
            ],
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
          Row(
            children: [
              Icon(
                Icons.logout,
                color: AppDesignSystem.errorColor,
                size: 24,
              ),
              AppDesignSystem.horizontalSpace(0.5),
              Text(
                'Sair do Aplicativo',
                style: AppDesignSystem.h3Style.copyWith(
                  color: AppDesignSystem.errorColor,
                ),
              ),
            ],
          ),
          AppDesignSystem.verticalSpace(1),
          Text(
            'Você será desconectado e precisará fazer login novamente.',
            style: AppDesignSystem.bodySmallStyle.copyWith(
              color: AppDesignSystem.textSecondaryColor,
            ),
          ),
          AppDesignSystem.verticalSpace(1),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showLogoutConfirmation(),
              icon: Icon(
                Icons.exit_to_app,
                color: AppDesignSystem.errorColor,
              ),
              label: Text(
                'Sair do App',
                style: TextStyle(
                  color: AppDesignSystem.errorColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppDesignSystem.errorColor),
                padding: EdgeInsets.symmetric(vertical: AppDesignSystem.spaceLG),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSubscriptionBenefits() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.workspace_premium,
                color: AppDesignSystem.primaryColor,
              ),
              AppDesignSystem.horizontalSpace(0.5),
              Text(
                'Benefícios Premium',
                style: AppDesignSystem.h3Style,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBenefitItem('✓ Prioridade nas buscas de trabalho'),
              _buildBenefitItem('✓ Comissão reduzida da plataforma'),
              _buildBenefitItem('✓ Acesso a clientes premium'),
              _buildBenefitItem('✓ Estatísticas avançadas de performance'),
              _buildBenefitItem('✓ Suporte prioritário 24/7'),
              _buildBenefitItem('✓ Certificações gratuitas'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDesignSystem.spaceSM),
      child: Text(
        text,
        style: AppDesignSystem.bodyStyle,
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning,
                color: AppDesignSystem.warningColor,
              ),
              AppDesignSystem.horizontalSpace(0.5),
              Text(
                'Confirmar Saída',
                style: AppDesignSystem.h3Style,
              ),
            ],
          ),
          content: Text(
            'Tem certeza que deseja sair do aplicativo? Você precisará fazer login novamente.',
            style: AppDesignSystem.bodyStyle,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(color: AppDesignSystem.textSecondaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o dialog
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppDesignSystem.errorColor,
              ),
              child: Text(
                'Sair',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAccessSecurity() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Acesso e Segurança',
            style: AppDesignSystem.h3Style,
          ),
          AppDesignSystem.verticalSpace(1.5),
          _buildSwitchRow(
            'Notificações',
            'Receber notificações push',
            _notificationsEnabled,
            (value) => setState(() => _notificationsEnabled = value),
            Icons.notifications_outlined,
          ),
          AppDesignSystem.verticalSpace(1),
          _buildSwitchRow(
            'Compartilhar Localização',
            'Permitir que pacientes vejam sua localização',
            _shareLocationEnabled,
            (value) => setState(() => _shareLocationEnabled = value),
            Icons.location_on_outlined,
          ),
          AppDesignSystem.verticalSpace(1),
          _buildSwitchRow(
            'Disponível nos Finais de Semana',
            'Aceitar trabalhos nos finais de semana',
            _availableWeekendsEnabled,
            (value) => setState(() => _availableWeekendsEnabled = value),
            Icons.weekend_outlined,
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
          Text(
            'Login Social',
            style: AppDesignSystem.h3Style,
          ),
          AppDesignSystem.verticalSpace(1.5),
          _buildSwitchRow(
            'Login com Facebook',
            'Permitir login através do Facebook',
            _facebookLoginEnabled,
            (value) => setState(() => _facebookLoginEnabled = value),
            Icons.facebook,
          ),
          AppDesignSystem.verticalSpace(1),
          _buildSwitchRow(
            'Login com Google',
            'Permitir login através do Google',
            _googleLoginEnabled,
            (value) => setState(() => _googleLoginEnabled = value),
            Icons.login,
          ),
          AppDesignSystem.verticalSpace(1),
          _buildSwitchRow(
            'Login com Apple',
            'Permitir login através do Apple ID',
            _appleLoginEnabled,
            (value) => setState(() => _appleLoginEnabled = value),
            Icons.apple,
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
          Text(
            'Preferências de Trabalho',
            style: AppDesignSystem.h3Style,
          ),
          AppDesignSystem.verticalSpace(1.5),
          _buildSwitchRow(
            'Aceitar Chamadas de Emergência',
            'Disponível para atendimentos urgentes',
            _acceptUrgentCalls,
            (value) => setState(() => _acceptUrgentCalls = value),
            Icons.emergency,
          ),
          AppDesignSystem.verticalSpace(1),
          _buildSwitchRow(
            'Integração com Calendário',
            'Sincronizar agenda com calendário do dispositivo',
            _calendarIntegrationEnabled,
            (value) => setState(() => _calendarIntegrationEnabled = value),
            Icons.calendar_today,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String title, String subtitle, bool value, Function(bool) onChanged, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppDesignSystem.textSecondaryColor,
          size: 20,
        ),
        AppDesignSystem.horizontalSpace(1),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppDesignSystem.bodyStyle,
              ),
              Text(
                subtitle,
                style: AppDesignSystem.captionStyle,
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppDesignSystem.primaryColor,
        ),
      ],
    );
  }
}
