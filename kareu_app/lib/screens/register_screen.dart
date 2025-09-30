import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _pageController = PageController();
  int _currentStep = 0;
  
  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  
  // Estado
  String _selectedGender = 'Feminino';
  String? _selectedState;
  UserType? _userType;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  
  // Campos específicos para profissionais
  final _crefController = TextEditingController();
  final _experienceController = TextEditingController();
  final _referenceNameController = TextEditingController();
  final _referencePhoneController = TextEditingController();
  String? _selectedSpecialty;
  String? _selectedEducation;
  String? _selectedExperienceYears;
  Set<String> _selectedCareAreas = {};
  
  // Campos específicos para pacientes
  final _medicalConditionsController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _specialNeedsController = TextEditingController();
  String? _selectedMobilityLevel;
  String? _selectedCareType;
  Set<String> _selectedPatientNeeds = {};
  Set<String> _selectedPersonalityTraits = {};
  
  final List<String> _specialties = [
    'Enfermagem',
    'Fisioterapia',
    'Cuidador de Idosos',
    'Técnico em Enfermagem',
    'Auxiliar de Enfermagem',
    'Acompanhante Hospitalar',
    'Cuidador Infantil',
    'Medicina',
    'Psicologia',
    'Terapia Ocupacional',
    'Nutrição',
    'Outros',
  ];
  
  final List<String> _educationOptions = [
    'Ensino Fundamental',
    'Ensino Médio',
    'Ensino Superior',
    'Pós-graduação',
    'Mestrado',
    'Doutorado'
  ];

  final List<String> _experienceYearsOptions = [
    'Menos de 1 ano',
    '1-2 anos',
    '3-5 anos',
    '6-10 anos',
    'Mais de 10 anos'
  ];

  final List<Map<String, dynamic>> _careAreas = [
    {
      'id': 'idosos',
      'title': 'Idosos',
      'icon': Icons.elderly,
    },
    {
      'id': 'hospitalizadas',
      'title': 'Pessoas hospitalizadas',
      'icon': Icons.local_hospital,
    },
    {
      'id': 'domiciliar',
      'title': 'Domiciliar',
      'icon': Icons.home,
    },
    {
      'id': 'criancas',
      'title': 'Crianças',
      'icon': Icons.child_care,
    },
    {
      'id': 'deficiencias',
      'title': 'Pessoas com deficiência',
      'icon': Icons.accessible,
    },
    {
      'id': 'outros',
      'title': 'Outros',
      'icon': Icons.more_horiz,
    },
  ];

  final List<String> _mobilityLevels = [
    'Totalmente independente',
    'Parcialmente dependente',
    'Dependente com assistência',
    'Totalmente dependente',
    'Cadeirante',
    'Acamado',
  ];

  final List<String> _careTypes = [
    'Cuidados básicos',
    'Cuidados médicos',
    'Acompanhamento hospitalar',
    'Cuidados paliativos',
    'Reabilitação',
    'Cuidados pós-cirúrgicos',
    'Cuidados de longa duração',
  ];

  final List<Map<String, dynamic>> _patientNeeds = [
    {
      'id': 'higiene',
      'title': 'Higiene pessoal',
      'icon': Icons.shower,
    },
    {
      'id': 'alimentacao',
      'title': 'Auxílio alimentação',
      'icon': Icons.restaurant,
    },
    {
      'id': 'medicacao',
      'title': 'Administração medicamentos',
      'icon': Icons.medication,
    },
    {
      'id': 'mobilidade',
      'title': 'Auxílio mobilidade',
      'icon': Icons.accessible,
    },
    {
      'id': 'companhia',
      'title': 'Companhia',
      'icon': Icons.people,
    },
    {
      'id': 'exercicios',
      'title': 'Exercícios/Fisioterapia',
      'icon': Icons.fitness_center,
    },
    {
      'id': 'transporte',
      'title': 'Transporte/Acompanhamento',
      'icon': Icons.directions_car,
    },
    {
      'id': 'domesticas',
      'title': 'Atividades domésticas',
      'icon': Icons.home_work,
    },
  ];

  final List<Map<String, dynamic>> _personalityTraits = [
    {
      'id': 'calmo',
      'title': 'Calmo',
      'icon': Icons.self_improvement,
    },
    {
      'id': 'comunicativo',
      'title': 'Comunicativo',
      'icon': Icons.chat,
    },
    {
      'id': 'independente',
      'title': 'Independente',
      'icon': Icons.person,
    },
    {
      'id': 'sociavel',
      'title': 'Sociável',
      'icon': Icons.groups,
    },
    {
      'id': 'ativo',
      'title': 'Ativo',
      'icon': Icons.directions_run,
    },
    {
      'id': 'pacifico',
      'title': 'Pacífico',
      'icon': Icons.favorite,
    },
    {
      'id': 'colaborativo',
      'title': 'Colaborativo',
      'icon': Icons.handshake,
    },
    {
      'id': 'reservado',
      'title': 'Reservado',
      'icon': Icons.visibility_off,
    },
  ];
  
  final List<String> _brazilianStates = [
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA',
    'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN',
    'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userType = ModalRoute.of(context)?.settings.arguments as UserType?;

    // Definir o tipo de usuário no serviço global
    if (_userType != null) {
      UserService.setUserType(_userType!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _cpfController.dispose();
    _birthDateController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _crefController.dispose();
    _experienceController.dispose();
    _referenceNameController.dispose();
    _referencePhoneController.dispose();
    _medicalConditionsController.dispose();
    _medicationsController.dispose();
    _allergiesController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    _specialNeedsController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    int maxSteps = _userType == UserType.amCaregiver ? 3 : 3; // Agora pacientes também têm 4 etapas
    if (_currentStep < maxSteps) {
      if (_validateCurrentStep()) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      _submitForm();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _nameController.text.isNotEmpty &&
               _emailController.text.isNotEmpty &&
               _passwordController.text.isNotEmpty &&
               _confirmPasswordController.text.isNotEmpty &&
               _passwordController.text == _confirmPasswordController.text;
      case 1:
        bool basicValidation = _phoneController.text.isNotEmpty &&
                              _cpfController.text.isNotEmpty &&
                              _birthDateController.text.isNotEmpty;
        
        // Validação adicional para profissionais
        if (_userType == UserType.amCaregiver) {
          return basicValidation &&
                 _selectedSpecialty != null &&
                 _selectedEducation != null &&
                 _selectedExperienceYears != null &&
                 _selectedCareAreas.isNotEmpty &&
                 _experienceController.text.isNotEmpty;
        }
        
        return basicValidation;
      case 2:
        // Para profissionais: validação das referências (opcional)
        if (_userType == UserType.amCaregiver) {
          return true; // Referências são opcionais
        }
        // Para pacientes: validação das informações de saúde e necessidades
        return _selectedMobilityLevel != null &&
               _selectedCareType != null &&
               _selectedPatientNeeds.isNotEmpty &&
               _emergencyContactController.text.isNotEmpty &&
               _emergencyPhoneController.text.isNotEmpty;
      case 3:
        // Etapa final para profissionais (endereço)
        return _addressController.text.isNotEmpty &&
               _cityController.text.isNotEmpty &&
               _selectedState != null &&
               _acceptTerms;
      default:
        return false;
    }
  }

  void _submitForm() {
    if (_validateCurrentStep()) {
      // Simular criação de conta
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Conta criada com sucesso como ${_userType == UserType.needCaregiver ? 'Paciente' : 'Profissional'}!'),
          backgroundColor: AppDesignSystem.successColor,
        ),
      );
      
      // Navegar para login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      appBar: AppDesignSystem.styledAppBar(
        title: _userType == UserType.amCaregiver 
            ? 'Cadastro Profissional' 
            : 'Cadastro Paciente/Família',
        context: context,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Indicador de progresso
          _buildProgressIndicator(),
          
          // Conteúdo do formulário
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: _userType == UserType.amCaregiver
                  ? [
                      _buildStep1(),
                      _buildStep2(),
                      _buildStep3Professional(),
                      _buildStep4Professional(),
                    ]
                  : [
                      _buildStep1(),
                      _buildStep2(),
                      _buildStep3PatientHealth(),
                      _buildStep4PatientAddress(),
                    ],
            ),
          ),
          
          // Botões de navegação
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(AppDesignSystem.space2XL),
      child: Column(
        children: [
          // Título do passo atual
          Text(
            _getStepTitle(),
            style: AppDesignSystem.h2Style,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDesignSystem.spaceMD),
          
          // Subtítulo
          Text(
            _getStepSubtitle(),
            style: AppDesignSystem.bodyStyle.copyWith(
              color: AppDesignSystem.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDesignSystem.space2XL),
          
          // Indicador de progresso
          Row(
            children: List.generate(
              4, // Agora ambos os tipos têm 4 etapas
              (index) {
                int totalSteps = 4;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      right: index < totalSteps - 1 ? AppDesignSystem.spaceSM : 0,
                    ),
                    height: 4,
                    decoration: BoxDecoration(
                      color: index <= _currentStep
                          ? AppDesignSystem.primaryColor
                          : AppDesignSystem.borderColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle() {
    if (_userType == UserType.amCaregiver) {
      switch (_currentStep) {
        case 0:
          return 'Informações Básicas';
        case 1:
          return 'Dados Pessoais e Profissionais';
        case 2:
          return 'Referências Profissionais';
        case 3:
          return 'Endereço e Finalização';
        default:
          return '';
      }
    } else {
      switch (_currentStep) {
        case 0:
          return 'Informações Básicas';
        case 1:
          return 'Dados Pessoais';
        case 2:
          return 'Informações de Saúde e Necessidades';
        case 3:
          return 'Endereço e Finalização';
        default:
          return '';
      }
    }
  }

  String _getStepSubtitle() {
    if (_userType == UserType.amCaregiver) {
      switch (_currentStep) {
        case 0:
          return 'Vamos começar com suas informações de acesso';
        case 1:
          return 'Dados pessoais e sua formação profissional';
        case 2:
          return 'Referências profissionais (opcional)';
        case 3:
          return 'Por último, seu endereço e aceite dos termos';
        default:
          return '';
      }
    } else {
      switch (_currentStep) {
        case 0:
          return 'Vamos começar com suas informações de acesso';
        case 1:
          return 'Agora precisamos de alguns dados pessoais';
        case 2:
          return 'Informações médicas e necessidades de cuidado';
        case 3:
          return 'Por último, seu endereço e aceite dos termos';
        default:
          return '';
      }
    }
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDesignSystem.space2XL),
      child: AppDesignSystem.styledCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tipo de usuário selecionado
            _buildUserTypeBadge(),
            
            const SizedBox(height: AppDesignSystem.space2XL),
            
            // Nome completo
            _buildFormField(
              label: 'Nome Completo',
              controller: _nameController,
              hintText: 'Digite seu nome completo',
              prefixIcon: Icons.person_outline,
              keyboardType: TextInputType.name,
            ),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            // E-mail
            _buildFormField(
              label: 'E-mail',
              controller: _emailController,
              hintText: 'Digite seu e-mail',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            // Senha
            _buildFormField(
              label: 'Senha',
              controller: _passwordController,
              hintText: 'Digite sua senha',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            // Confirmar senha
            _buildFormField(
              label: 'Confirmar Senha',
              controller: _confirmPasswordController,
              hintText: 'Confirme sua senha',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscureConfirmPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
            ),
            
            // Validação de senha
            if (_passwordController.text.isNotEmpty && _confirmPasswordController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppDesignSystem.spaceSM),
                child: Row(
                  children: [
                    Icon(
                      _passwordController.text == _confirmPasswordController.text
                          ? Icons.check_circle
                          : Icons.error,
                      color: _passwordController.text == _confirmPasswordController.text
                          ? AppDesignSystem.successColor
                          : AppDesignSystem.errorColor,
                      size: 16,
                    ),
                    const SizedBox(width: AppDesignSystem.spaceXS),
                    Text(
                      _passwordController.text == _confirmPasswordController.text
                          ? 'Senhas coincidem'
                          : 'Senhas não coincidem',
                      style: AppDesignSystem.captionStyle.copyWith(
                        color: _passwordController.text == _confirmPasswordController.text
                            ? AppDesignSystem.successColor
                            : AppDesignSystem.errorColor,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDesignSystem.space2XL),
      child: AppDesignSystem.styledCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Telefone
            _buildFormField(
              label: 'Telefone',
              controller: _phoneController,
              hintText: '(00) 00000-0000',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            // CPF
            _buildFormField(
              label: 'CPF',
              controller: _cpfController,
              hintText: '000.000.000-00',
              prefixIcon: Icons.badge_outlined,
              keyboardType: TextInputType.number,
            ),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            // Data de nascimento
            _buildFormField(
              label: 'Data de Nascimento',
              controller: _birthDateController,
              hintText: 'DD/MM/AAAA',
              prefixIcon: Icons.calendar_today_outlined,
              keyboardType: TextInputType.datetime,
              onTap: () => _selectDate(),
              readOnly: true,
            ),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            // Gênero
            _buildGenderSelector(),
            
            // Campos específicos para profissionais
            if (_userType == UserType.amCaregiver) ...[
              const SizedBox(height: AppDesignSystem.space2XL),
              
              // Título da seção profissional
              Text(
                'Informações Profissionais',
                style: AppDesignSystem.h3Style.copyWith(
                  color: AppDesignSystem.primaryColor,
                ),
              ),
              
              const SizedBox(height: AppDesignSystem.spaceLG),
              
              // Especialidade
              _buildSpecialtySelector(),
              
              const SizedBox(height: AppDesignSystem.spaceLG),
              
              // Escolaridade
              _buildEducationSelector(),
              
              const SizedBox(height: AppDesignSystem.spaceLG),
              
              // Anos de experiência
              _buildExperienceYearsSelector(),
              
              const SizedBox(height: AppDesignSystem.spaceLG),
              
              // Áreas de cuidado
              _buildCareAreasSelector(),
              
              const SizedBox(height: AppDesignSystem.spaceLG),
              
              // CREF (opcional)
              _buildFormField(
                label: 'CREF/Registro Profissional (Opcional)',
                controller: _crefController,
                hintText: 'Ex: CREF 123456-G/SP, COREN 123456',
                prefixIcon: Icons.card_membership_outlined,
                keyboardType: TextInputType.text,
              ),
              
              const SizedBox(height: AppDesignSystem.spaceLG),
              
              // Experiência detalhada
              _buildFormField(
                label: 'Experiência Profissional Detalhada',
                controller: _experienceController,
                hintText: 'Descreva sua experiência na área, certificações, cursos...',
                prefixIcon: Icons.work_outline,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStep4PatientAddress() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDesignSystem.space2XL),
      child: AppDesignSystem.styledCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Endereço
            _buildFormField(
              label: 'Endereço Completo',
              controller: _addressController,
              hintText: 'Rua, número, bairro',
              prefixIcon: Icons.location_on_outlined,
              keyboardType: TextInputType.streetAddress,
            ),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            // Cidade
            _buildFormField(
              label: 'Cidade',
              controller: _cityController,
              hintText: 'Digite sua cidade',
              prefixIcon: Icons.location_city_outlined,
              keyboardType: TextInputType.text,
            ),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            // Estado
            _buildStateSelector(),
            
            const SizedBox(height: AppDesignSystem.space2XL),
            
            // Termos de uso
            _buildTermsCheckbox(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTypeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignSystem.spaceLG,
        vertical: AppDesignSystem.spaceMD,
      ),
      decoration: BoxDecoration(
        color: AppDesignSystem.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
        border: Border.all(
          color: AppDesignSystem.primaryColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _userType == UserType.needCaregiver
                ? Icons.family_restroom
                : Icons.medical_services,
            color: AppDesignSystem.primaryColor,
            size: 20,
          ),
          const SizedBox(width: AppDesignSystem.spaceSM),
          Text(
            _userType == UserType.needCaregiver
                ? 'Cadastro como Paciente/Família'
                : 'Cadastro como Profissional',
            style: AppDesignSystem.bodyStyle.copyWith(
              color: AppDesignSystem.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    VoidCallback? onTap,
    bool readOnly = false,
    int maxLines = 1,
  }) {
    return AppDesignSystem.styledTextField(
      label: label,
      controller: controller,
      hint: hintText,
      prefixIcon: prefixIcon,
      keyboardType: keyboardType,
      obscureText: obscureText,
      suffixIcon: suffixIcon,
      onChanged: onTap != null ? (_) => onTap!() : null,
      maxLines: maxLines,
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gênero',
          style: AppDesignSystem.captionStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDesignSystem.spaceXS),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceLG),
          decoration: BoxDecoration(
            color: AppDesignSystem.surfaceColor,
            borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
            border: Border.all(color: AppDesignSystem.borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedGender,
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue ?? 'Feminino';
                });
              },
              items: ['Feminino', 'Masculino', 'Outro', 'Prefiro não informar']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estado',
          style: AppDesignSystem.captionStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDesignSystem.spaceXS),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceLG),
          decoration: BoxDecoration(
            color: AppDesignSystem.surfaceColor,
            borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
            border: Border.all(color: AppDesignSystem.borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedState,
              isExpanded: true,
              hint: const Text('Selecione seu estado'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedState = newValue;
                });
              },
              items: _brazilianStates.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialtySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Especialidade',
          style: AppDesignSystem.captionStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDesignSystem.spaceXS),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceLG),
          decoration: BoxDecoration(
            color: AppDesignSystem.surfaceColor,
            borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
            border: Border.all(color: AppDesignSystem.borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedSpecialty,
              hint: Text(
                'Selecione sua especialidade',
                style: AppDesignSystem.bodyStyle.copyWith(
                  color: AppDesignSystem.textSecondaryColor,
                ),
              ),
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSpecialty = newValue;
                });
              },
              items: _specialties.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (bool? value) {
            setState(() {
              _acceptTerms = value ?? false;
            });
          },
          activeColor: AppDesignSystem.primaryColor,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptTerms = !_acceptTerms;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: RichText(
                text: TextSpan(
                  style: AppDesignSystem.bodyStyle.copyWith(
                    color: AppDesignSystem.textSecondaryColor,
                  ),
                  children: [
                    const TextSpan(text: 'Eu aceito os '),
                    TextSpan(
                      text: 'Termos de Uso',
                      style: AppDesignSystem.bodyStyle.copyWith(
                        color: AppDesignSystem.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(text: ' e a '),
                    TextSpan(
                      text: 'Política de Privacidade',
                      style: AppDesignSystem.bodyStyle.copyWith(
                        color: AppDesignSystem.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(AppDesignSystem.space2XL),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: AppDesignSystem.secondaryButton(
                text: 'Voltar',
                onPressed: _previousStep,
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: AppDesignSystem.spaceLG),
          Expanded(
            flex: _currentStep == 0 ? 1 : 1,
            child: Opacity(
              opacity: _validateCurrentStep() ? 1.0 : 0.5,
              child: AppDesignSystem.primaryButton(
                text: _currentStep == 3 ? 'Criar Conta' : 'Próximo',
                onPressed: () {
                  if (_validateCurrentStep()) {
                    if (_currentStep == 3) {
                      _submitForm();
                    } else {
                      _nextStep();
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3PatientHealth() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDesignSystem.space2XL),
      child: AppDesignSystem.styledCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título da seção
            Text(
              'Informações de Saúde e Necessidades',
              style: AppDesignSystem.h3Style.copyWith(
                color: AppDesignSystem.primaryColor,
              ),
            ),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            // Nível de mobilidade
            _buildMobilityLevelSelector(),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            // Tipo de cuidado necessário
            _buildCareTypeSelector(),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            // Necessidades de cuidado
            _buildPatientNeedsSelector(),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            // Traços de personalidade
            _buildPersonalityTraitsSelector(),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            // Condições médicas
            _buildFormField(
              label: 'Condições Médicas/Comorbidades',
              controller: _medicalConditionsController,
              hintText: 'Ex: Diabetes, Hipertensão, Alzheimer...',
              prefixIcon: Icons.medical_information_outlined,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
            ),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            // Medicações
            _buildFormField(
              label: 'Medicações em Uso',
              controller: _medicationsController,
              hintText: 'Liste os medicamentos e horários...',
              prefixIcon: Icons.medication_outlined,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
            ),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            // Alergias
            _buildFormField(
              label: 'Alergias',
              controller: _allergiesController,
              hintText: 'Medicamentos, alimentos, outros...',
              prefixIcon: Icons.warning_outlined,
              keyboardType: TextInputType.multiline,
              maxLines: 2,
            ),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            // Necessidades especiais
            _buildFormField(
              label: 'Necessidades Especiais',
              controller: _specialNeedsController,
              hintText: 'Equipamentos, cuidados específicos...',
              prefixIcon: Icons.accessibility_new_outlined,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
            ),
            
            const SizedBox(height: AppDesignSystem.space2XL),
            
            // Contato de emergência
            Text(
              'Contato de Emergência',
              style: AppDesignSystem.h3Style.copyWith(
                color: AppDesignSystem.primaryColor,
              ),
            ),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            // Nome do contato de emergência
            _buildFormField(
              label: 'Nome do Contato',
              controller: _emergencyContactController,
              hintText: 'Nome completo',
              prefixIcon: Icons.contact_emergency_outlined,
              keyboardType: TextInputType.name,
            ),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            // Telefone do contato de emergência
            _buildFormField(
              label: 'Telefone do Contato',
              controller: _emergencyPhoneController,
              hintText: '(00) 00000-0000',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep3Professional() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDesignSystem.space2XL),
      child: AppDesignSystem.styledCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título da seção
            Text(
              'Referências Profissionais',
              style: AppDesignSystem.h3Style.copyWith(
                color: AppDesignSystem.primaryColor,
              ),
            ),
            
            const SizedBox(height: AppDesignSystem.spaceMD),
            
            Text(
              'Forneça referências profissionais para validar sua experiência (opcional)',
              style: AppDesignSystem.bodyStyle.copyWith(
                color: AppDesignSystem.textSecondaryColor,
              ),
            ),
            
            const SizedBox(height: AppDesignSystem.space2XL),
            
            // Nome da referência
            _buildFormField(
              label: 'Nome da Referência',
              controller: _referenceNameController,
              hintText: 'Ex: Dr. João Silva',
              prefixIcon: Icons.person_outline,
              keyboardType: TextInputType.name,
            ),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            // Telefone da referência
            _buildFormField(
              label: 'Telefone da Referência',
              controller: _referencePhoneController,
              hintText: '(00) 00000-0000',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            
            const SizedBox(height: AppDesignSystem.space2XL),
            
            // Nota informativa
            Container(
              padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
              decoration: BoxDecoration(
                color: AppDesignSystem.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                border: Border.all(
                  color: AppDesignSystem.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppDesignSystem.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: AppDesignSystem.spaceMD),
                  Expanded(
                    child: Text(
                      'As referências são opcionais, mas ajudam a validar sua experiência profissional.',
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
      ),
    );
  }

  Widget _buildStep4Professional() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDesignSystem.space2XL),
      child: AppDesignSystem.styledCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Endereço
            _buildFormField(
              label: 'Endereço Completo',
              controller: _addressController,
              hintText: 'Rua, número, bairro',
              prefixIcon: Icons.location_on_outlined,
              keyboardType: TextInputType.streetAddress,
            ),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            // Cidade
            _buildFormField(
              label: 'Cidade',
              controller: _cityController,
              hintText: 'Digite sua cidade',
              prefixIcon: Icons.location_city_outlined,
              keyboardType: TextInputType.text,
            ),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            // Estado
            _buildStateSelector(),
            
            const SizedBox(height: AppDesignSystem.space2XL),
            
            // Termos de uso
            _buildTermsCheckbox(),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Escolaridade',
          style: AppDesignSystem.captionStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDesignSystem.spaceXS),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceLG),
          decoration: BoxDecoration(
            color: AppDesignSystem.surfaceColor,
            borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
            border: Border.all(color: AppDesignSystem.borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedEducation,
              hint: Text(
                'Selecione sua escolaridade',
                style: AppDesignSystem.bodyStyle.copyWith(
                  color: AppDesignSystem.textSecondaryColor,
                ),
              ),
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedEducation = newValue;
                });
              },
              items: _educationOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExperienceYearsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Anos de Experiência',
          style: AppDesignSystem.captionStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDesignSystem.spaceXS),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceLG),
          decoration: BoxDecoration(
            color: AppDesignSystem.surfaceColor,
            borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
            border: Border.all(color: AppDesignSystem.borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedExperienceYears,
              hint: Text(
                'Selecione sua experiência',
                style: AppDesignSystem.bodyStyle.copyWith(
                  color: AppDesignSystem.textSecondaryColor,
                ),
              ),
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedExperienceYears = newValue;
                });
              },
              items: _experienceYearsOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCareAreasSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Áreas de Cuidado',
          style: AppDesignSystem.captionStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDesignSystem.spaceMD),
        Text(
          'Selecione as áreas em que você tem experiência:',
          style: AppDesignSystem.bodySmallStyle.copyWith(
            color: AppDesignSystem.textSecondaryColor,
          ),
        ),
        const SizedBox(height: AppDesignSystem.spaceLG),
        Wrap(
          spacing: AppDesignSystem.spaceMD,
          runSpacing: AppDesignSystem.spaceMD,
          children: _careAreas.map((area) {
            final isSelected = _selectedCareAreas.contains(area['id']);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedCareAreas.remove(area['id']);
                  } else {
                    _selectedCareAreas.add(area['id']);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDesignSystem.spaceLG,
                  vertical: AppDesignSystem.spaceMD,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppDesignSystem.primaryColor.withOpacity(0.1)
                      : AppDesignSystem.surfaceColor,
                  borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                  border: Border.all(
                    color: isSelected
                        ? AppDesignSystem.primaryColor
                        : AppDesignSystem.borderColor,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      area['icon'],
                      color: isSelected
                          ? AppDesignSystem.primaryColor
                          : AppDesignSystem.textSecondaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: AppDesignSystem.spaceSM),
                    Text(
                      area['title'],
                      style: AppDesignSystem.bodySmallStyle.copyWith(
                        color: isSelected
                            ? AppDesignSystem.primaryColor
                            : AppDesignSystem.textPrimaryColor,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMobilityLevelSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nível de Mobilidade',
          style: AppDesignSystem.captionStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDesignSystem.spaceXS),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceLG),
          decoration: BoxDecoration(
            color: AppDesignSystem.surfaceColor,
            borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
            border: Border.all(color: AppDesignSystem.borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedMobilityLevel,
              hint: Text(
                'Selecione o nível de mobilidade',
                style: AppDesignSystem.bodyStyle.copyWith(
                  color: AppDesignSystem.textSecondaryColor,
                ),
              ),
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedMobilityLevel = newValue;
                });
              },
              items: _mobilityLevels.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCareTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de Cuidado Necessário',
          style: AppDesignSystem.captionStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDesignSystem.spaceXS),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceLG),
          decoration: BoxDecoration(
            color: AppDesignSystem.surfaceColor,
            borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
            border: Border.all(color: AppDesignSystem.borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCareType,
              hint: Text(
                'Selecione o tipo de cuidado',
                style: AppDesignSystem.bodyStyle.copyWith(
                  color: AppDesignSystem.textSecondaryColor,
                ),
              ),
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCareType = newValue;
                });
              },
              items: _careTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPatientNeedsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Necessidades de Cuidado',
          style: AppDesignSystem.captionStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDesignSystem.spaceMD),
        Text(
          'Selecione as necessidades de cuidado:',
          style: AppDesignSystem.bodySmallStyle.copyWith(
            color: AppDesignSystem.textSecondaryColor,
          ),
        ),
        const SizedBox(height: AppDesignSystem.spaceLG),
        Wrap(
          spacing: AppDesignSystem.spaceMD,
          runSpacing: AppDesignSystem.spaceMD,
          children: _patientNeeds.map((need) {
            final isSelected = _selectedPatientNeeds.contains(need['id']);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedPatientNeeds.remove(need['id']);
                  } else {
                    _selectedPatientNeeds.add(need['id']);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDesignSystem.spaceLG,
                  vertical: AppDesignSystem.spaceMD,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppDesignSystem.primaryColor.withOpacity(0.1)
                      : AppDesignSystem.surfaceColor,
                  borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                  border: Border.all(
                    color: isSelected
                        ? AppDesignSystem.primaryColor
                        : AppDesignSystem.borderColor,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      need['icon'],
                      color: isSelected
                          ? AppDesignSystem.primaryColor
                          : AppDesignSystem.textSecondaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: AppDesignSystem.spaceSM),
                    Text(
                      need['title'],
                      style: AppDesignSystem.bodySmallStyle.copyWith(
                        color: isSelected
                            ? AppDesignSystem.primaryColor
                            : AppDesignSystem.textPrimaryColor,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPersonalityTraitsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Características de Personalidade',
          style: AppDesignSystem.captionStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDesignSystem.spaceMD),
        Text(
          'Selecione as características que descrevem a personalidade:',
          style: AppDesignSystem.bodySmallStyle.copyWith(
            color: AppDesignSystem.textSecondaryColor,
          ),
        ),
        const SizedBox(height: AppDesignSystem.spaceLG),
        Wrap(
          spacing: AppDesignSystem.spaceMD,
          runSpacing: AppDesignSystem.spaceMD,
          children: _personalityTraits.map((trait) {
            final isSelected = _selectedPersonalityTraits.contains(trait['id']);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedPersonalityTraits.remove(trait['id']);
                  } else {
                    _selectedPersonalityTraits.add(trait['id']);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDesignSystem.spaceLG,
                  vertical: AppDesignSystem.spaceMD,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppDesignSystem.accentColor.withOpacity(0.1)
                      : AppDesignSystem.surfaceColor,
                  borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                  border: Border.all(
                    color: isSelected
                        ? AppDesignSystem.accentColor
                        : AppDesignSystem.borderColor,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      trait['icon'],
                      color: isSelected
                          ? AppDesignSystem.accentColor
                          : AppDesignSystem.textSecondaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: AppDesignSystem.spaceSM),
                    Text(
                      trait['title'],
                      style: AppDesignSystem.bodySmallStyle.copyWith(
                        color: isSelected
                            ? AppDesignSystem.accentColor
                            : AppDesignSystem.textPrimaryColor,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 anos atrás
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppDesignSystem.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }
}