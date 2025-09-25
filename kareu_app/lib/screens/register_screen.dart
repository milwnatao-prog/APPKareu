import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'user_type_selection_screen.dart';
import '../constants/app_design_system.dart';
import '../services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
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
  
  final List<String> _brazilianStates = [
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA',
    'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN',
    'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userType = ModalRoute.of(context)?.settings.arguments as UserType?;
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
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
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
        return _phoneController.text.isNotEmpty &&
               _cpfController.text.isNotEmpty &&
               _birthDateController.text.isNotEmpty;
      case 2:
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
      // Simular cadastro bem-sucedido
      _showSuccessDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos obrigatórios'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppDesignSystem.successColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: AppDesignSystem.successColor,
                size: 48,
              ),
            ),
            AppDesignSystem.verticalSpace(1.5),
            Text(
              'Cadastro Realizado!',
              style: AppDesignSystem.h3Style.copyWith(
                fontWeight: FontWeight.w700,
                color: AppDesignSystem.successColor,
              ),
              textAlign: TextAlign.center,
            ),
            AppDesignSystem.verticalSpace(1),
            Text(
              'Sua conta foi criada com sucesso. Agora você pode fazer login.',
              style: AppDesignSystem.bodyStyle.copyWith(
                color: AppDesignSystem.grayColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          AppDesignSystem.primaryButton(
            text: 'Fazer Login',
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Efeito blur similar ao login
          Positioned(
            left: -MediaQuery.of(context).size.width * 0.1,
            top: -MediaQuery.of(context).size.height * 0.55,
            child: Container(
              width: MediaQuery.of(context).size.width * 1.2,
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                color: AppDesignSystem.primaryColor,
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 1.3),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 46.6, sigmaY: 46.6),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppDesignSystem.primaryColor,
                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 1.3),
                  ),
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),
                
                // Progress indicator
                _buildProgressIndicator(),
                
                // Content
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildStep1(), // Dados básicos
                      _buildStep2(), // Dados pessoais
                      _buildStep3(), // Endereço e termos
                    ],
                  ),
                ),
                
                // Navigation buttons
                _buildNavigationButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDesignSystem.spacing4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          AppDesignSystem.horizontalSpace(1),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Criar Conta',
                style: AppDesignSystem.h2Style.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                _userType == UserType.needCaregiver 
                  ? 'Como Paciente/Família'
                  : 'Como Cuidador',
                style: AppDesignSystem.bodyStyle.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spacing4),
      child: Row(
        children: [
          for (int i = 0; i < 3; i++) ...[
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: i <= _currentStep 
                    ? AppDesignSystem.primaryColor
                    : AppDesignSystem.lightGrayColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            if (i < 2) AppDesignSystem.horizontalSpace(0.5),
          ],
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDesignSystem.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppDesignSystem.verticalSpace(2),
          Text(
            'Dados Básicos',
            style: AppDesignSystem.h3Style.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          AppDesignSystem.verticalSpace(0.5),
          Text(
            'Vamos começar com suas informações básicas',
            style: AppDesignSystem.bodyStyle.copyWith(
              color: AppDesignSystem.grayColor,
            ),
          ),
          AppDesignSystem.verticalSpace(2),
          
          AppDesignSystem.styledTextField(
            controller: _nameController,
            label: 'Nome Completo',
            hint: 'Digite seu nome completo',
            prefixIcon: Icons.person_outline,
            textCapitalization: TextCapitalization.words,
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          AppDesignSystem.styledTextField(
            controller: _emailController,
            label: 'E-mail',
            hint: 'Digite seu e-mail',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          AppDesignSystem.styledTextField(
            controller: _passwordController,
            label: 'Senha',
            hint: 'Digite sua senha',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: AppDesignSystem.grayColor,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          AppDesignSystem.styledTextField(
            controller: _confirmPasswordController,
            label: 'Confirmar Senha',
            hint: 'Digite sua senha novamente',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscureConfirmPassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                color: AppDesignSystem.grayColor,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
          
          AppDesignSystem.verticalSpace(1),
          
          if (_passwordController.text.isNotEmpty && _confirmPasswordController.text.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _passwordController.text == _confirmPasswordController.text
                  ? AppDesignSystem.successColor.withOpacity(0.1)
                  : AppDesignSystem.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    _passwordController.text == _confirmPasswordController.text
                      ? Icons.check_circle
                      : Icons.error,
                    color: _passwordController.text == _confirmPasswordController.text
                      ? AppDesignSystem.successColor
                      : AppDesignSystem.errorColor,
                    size: 20,
                  ),
                  AppDesignSystem.horizontalSpace(0.5),
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
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDesignSystem.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppDesignSystem.verticalSpace(2),
          Text(
            'Dados Pessoais',
            style: AppDesignSystem.h3Style.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          AppDesignSystem.verticalSpace(0.5),
          Text(
            'Precisamos de mais algumas informações',
            style: AppDesignSystem.bodyStyle.copyWith(
              color: AppDesignSystem.grayColor,
            ),
          ),
          AppDesignSystem.verticalSpace(2),
          
          AppDesignSystem.styledTextField(
            controller: _phoneController,
            label: 'Telefone',
            hint: '(11) 99999-9999',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _PhoneInputFormatter(),
            ],
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          AppDesignSystem.styledTextField(
            controller: _cpfController,
            label: 'CPF',
            hint: '000.000.000-00',
            prefixIcon: Icons.badge_outlined,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _CpfInputFormatter(),
            ],
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          AppDesignSystem.styledTextField(
            controller: _birthDateController,
            label: 'Data de Nascimento',
            hint: 'DD/MM/AAAA',
            prefixIcon: Icons.calendar_today_outlined,
            keyboardType: TextInputType.datetime,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _DateInputFormatter(),
            ],
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          // Seleção de gênero
          Text(
            'Gênero',
            style: AppDesignSystem.bodyStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: AppDesignSystem.darkColor,
            ),
          ),
          AppDesignSystem.verticalSpace(0.5),
          Row(
            children: [
              Expanded(child: _buildGenderOption('Feminino')),
              AppDesignSystem.horizontalSpace(1),
              Expanded(child: _buildGenderOption('Masculino')),
              AppDesignSystem.horizontalSpace(1),
              Expanded(child: _buildGenderOption('Outro')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDesignSystem.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppDesignSystem.verticalSpace(2),
          Text(
            'Endereço e Finalização',
            style: AppDesignSystem.h3Style.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          AppDesignSystem.verticalSpace(0.5),
          Text(
            'Últimas informações para completar seu cadastro',
            style: AppDesignSystem.bodyStyle.copyWith(
              color: AppDesignSystem.grayColor,
            ),
          ),
          AppDesignSystem.verticalSpace(2),
          
          AppDesignSystem.styledTextField(
            controller: _addressController,
            label: 'Endereço',
            hint: 'Rua, número, bairro',
            prefixIcon: Icons.location_on_outlined,
            textCapitalization: TextCapitalization.words,
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          Row(
            children: [
              Expanded(
                flex: 2,
                child: AppDesignSystem.styledTextField(
                  controller: _cityController,
                  label: 'Cidade',
                  hint: 'Digite sua cidade',
                  prefixIcon: Icons.location_city_outlined,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              AppDesignSystem.horizontalSpace(1),
              Expanded(
                child: _buildStateDropdown(),
              ),
            ],
          ),
          
          AppDesignSystem.verticalSpace(2),
          
          // Termos e condições
          AppDesignSystem.styledCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _acceptTerms,
                  onChanged: (value) {
                    setState(() {
                      _acceptTerms = value ?? false;
                    });
                  },
                  activeColor: AppDesignSystem.primaryColor,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: RichText(
                      text: TextSpan(
                        style: AppDesignSystem.captionStyle.copyWith(
                          color: AppDesignSystem.darkColor,
                        ),
                        children: [
                          const TextSpan(text: 'Aceito os '),
                          TextSpan(
                            text: 'Termos de Uso',
                            style: AppDesignSystem.captionStyle.copyWith(
                              color: AppDesignSystem.primaryColor,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(text: ' e '),
                          TextSpan(
                            text: 'Política de Privacidade',
                            style: AppDesignSystem.captionStyle.copyWith(
                              color: AppDesignSystem.primaryColor,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(text: ' do Kareu.'),
                        ],
                      ),
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

  Widget _buildGenderOption(String gender) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppDesignSystem.primaryColor : AppDesignSystem.lightGrayColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppDesignSystem.primaryColor : AppDesignSystem.borderColor,
          ),
        ),
        child: Center(
          child: Text(
            gender,
            style: AppDesignSystem.bodyStyle.copyWith(
              color: isSelected ? Colors.white : AppDesignSystem.darkColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStateDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estado',
          style: AppDesignSystem.bodyStyle.copyWith(
            fontWeight: FontWeight.w600,
            color: AppDesignSystem.darkColor,
          ),
        ),
        AppDesignSystem.verticalSpace(0.5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppDesignSystem.surfaceColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppDesignSystem.borderColor),
          ),
          child: DropdownButton<String>(
            value: _selectedState,
            hint: Text(
              'UF',
              style: AppDesignSystem.bodyStyle.copyWith(
                color: AppDesignSystem.grayColor,
              ),
            ),
            isExpanded: true,
            underline: const SizedBox(),
            items: _brazilianStates.map((state) {
              return DropdownMenuItem(
                value: state,
                child: Text(state),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedState = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(AppDesignSystem.spacing4),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            Expanded(
              child: AppDesignSystem.secondaryButton(
                text: 'Voltar',
                onPressed: _previousStep,
              ),
            ),
            AppDesignSystem.horizontalSpace(1),
          ],
          Expanded(
            flex: _currentStep == 0 ? 1 : 1,
            child: AppDesignSystem.primaryButton(
              text: _currentStep == 2 ? 'Criar Conta' : 'Próximo',
              onPressed: _validateCurrentStep() ? _nextStep : null,
            ),
          ),
        ],
      ),
    );
  }
}

// Formatadores de input
class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.length > 11) return oldValue;
    
    String formatted = '';
    if (text.length >= 1) {
      formatted = '(${text.substring(0, text.length >= 2 ? 2 : text.length)}';
      if (text.length >= 3) {
        formatted += ') ${text.substring(2, text.length >= 7 ? 7 : text.length)}';
        if (text.length >= 8) {
          formatted += '-${text.substring(7)}';
        }
      }
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.length > 11) return oldValue;
    
    String formatted = '';
    if (text.length >= 1) {
      formatted = text.substring(0, text.length >= 3 ? 3 : text.length);
      if (text.length >= 4) {
        formatted += '.${text.substring(3, text.length >= 6 ? 6 : text.length)}';
        if (text.length >= 7) {
          formatted += '.${text.substring(6, text.length >= 9 ? 9 : text.length)}';
          if (text.length >= 10) {
            formatted += '-${text.substring(9)}';
          }
        }
      }
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.length > 8) return oldValue;
    
    String formatted = '';
    if (text.length >= 1) {
      formatted = text.substring(0, text.length >= 2 ? 2 : text.length);
      if (text.length >= 3) {
        formatted += '/${text.substring(2, text.length >= 4 ? 4 : text.length)}';
        if (text.length >= 5) {
          formatted += '/${text.substring(4)}';
        }
      }
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}