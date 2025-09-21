import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_design_system.dart';

class ProfessionalRegisterScreen extends StatefulWidget {
  const ProfessionalRegisterScreen({Key? key}) : super(key: key);

  @override
  State<ProfessionalRegisterScreen> createState() => _ProfessionalRegisterScreenState();
}

class _ProfessionalRegisterScreenState extends State<ProfessionalRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthDateController = TextEditingController();
  
  String _selectedGender = 'Masculino';
  String? _selectedState;

  final List<String> _brazilianStates = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Cadastro Profissional',
          style: AppDesignSystem.h3Style,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Bar Space
                  const SizedBox(height: 20),
                  
                  // Title Section
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Text(
                        'Dados pessoais',
                        style: AppDesignSystem.bodyStyle.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Nome completo
                  _buildInputField(
                    label: 'Nome completo',
                    controller: _nameController,
                    placeholder: 'digite seu nome',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite seu nome';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Data de nascimento
                  _buildInputField(
                    label: 'Data de nascimento',
                    controller: _birthDateController,
                    placeholder: '    /     /',
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _DateInputFormatter(),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite sua data de nascimento';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Gênero
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
        Text(
          'Gênero',
          style: AppDesignSystem.labelStyle,
        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildGenderOption('Masculino'),
                          const SizedBox(width: 10),
                          _buildGenderOption('Feminino'),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // CPF
                  _buildInputField(
                    label: 'CPF',
                    controller: _cpfController,
                    placeholder: 'digite seu cpf',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _CpfInputFormatter(),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite seu CPF';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Endereço completo
                  _buildInputField(
                    label: 'Endereço completo',
                    controller: _addressController,
                    placeholder: 'digite seu endereçõ',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite seu endereço';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Cidade
                  _buildInputField(
                    label: 'Cidade',
                    controller: _cityController,
                    placeholder: 'Digite sua cidade',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite sua cidade';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Estado
                  _buildStateDropdown(),
                  
                  const SizedBox(height: 20),
                  
                  // Telefone celular
                  _buildInputField(
                    label: 'Telefone celular',
                    controller: _phoneController,
                    placeholder: '+55 (11)',
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _PhoneInputFormatter(),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite seu telefone';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // E-mail
                  _buildInputField(
                    label: 'E-mail',
                    controller: _emailController,
                    placeholder: 'digite seu e-mail',
                    keyboardType: TextInputType.emailAddress,
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Por favor, digite seu e-mail';
                    //   }
                    //   if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    //     return 'Por favor, digite um e-mail válido';
                    //   }
                    //   return null;
                    // }, // Validação desabilitada
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Botão Próximo
                  Container(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navegar para a tela de formação e experiência (validação desabilitada)
                        Navigator.pushNamed(context, '/formation-experience');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4D64C8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Próximo',
                            style: AppDesignSystem.buttonStyle,
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 17,
                            height: 17,
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppDesignSystem.labelStyle,
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: AppDesignSystem.surfaceColor,
            borderRadius: BorderRadius.circular(AppDesignSystem.spaceS),
            border: Border.all(color: AppDesignSystem.borderColor),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            validator: validator,
            style: AppDesignSystem.bodySmallStyle,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: AppDesignSystem.placeholderStyle,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppDesignSystem.spaceM,
                vertical: AppDesignSystem.spaceM,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStateDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estado',
          style: AppDesignSystem.labelStyle,
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: AppDesignSystem.surfaceColor,
            borderRadius: BorderRadius.circular(AppDesignSystem.spaceS),
            border: Border.all(color: AppDesignSystem.borderColor),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedState,
            hint: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceM),
              child: Text(
                'Selecione o estado',
                style: AppDesignSystem.placeholderStyle,
              ),
            ),
            items: _brazilianStates.map((String state) {
              return DropdownMenuItem<String>(
                value: state,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceM),
                  child: Text(
                    state,
                    style: AppDesignSystem.bodySmallStyle,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedState = newValue;
              });
            },
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Por favor, selecione o estado';
            //   }
            //   return null;
            // }, // Validação desabilitada
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            icon: const Padding(
              padding: EdgeInsets.only(right: 14),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
                size: 16,
              ),
            ),
            isExpanded: true,
            dropdownColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildGenderOption(String gender) {
    bool isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        width: 109,
        height: 30,
        decoration: BoxDecoration(
          color: isSelected 
            ? const Color(0xFF4D64C8) 
            : const Color.fromRGBO(208, 208, 208, 0.54),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            gender,
            style: AppDesignSystem.captionStyle.copyWith(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }
}

// Formatador para CPF
class _CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.length <= 11) {
      String formatted = '';
      for (int i = 0; i < text.length; i++) {
        if (i == 3 || i == 6) {
          formatted += '.';
        } else if (i == 9) {
          formatted += '-';
        }
        formatted += text[i];
      }
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    return oldValue;
  }
}

// Formatador para telefone
class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.length <= 11) {
      String formatted = '+55 ';
      if (text.length >= 2) {
        formatted += '(${text.substring(0, 2)})';
        if (text.length > 2) {
          formatted += ' ${text.substring(2)}';
        }
      } else if (text.isNotEmpty) {
        formatted += '(${text}';
      }
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    return oldValue;
  }
}

// Formatador para data
class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.length <= 8) {
      String formatted = '';
      for (int i = 0; i < text.length; i++) {
        if (i == 2 || i == 4) {
          formatted += '/';
        }
        formatted += text[i];
      }
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    return oldValue;
  }
}
