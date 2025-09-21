import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';
import 'terms_confirmation_screen.dart';

class PreferencesSpecialtiesScreen extends StatefulWidget {
  const PreferencesSpecialtiesScreen({super.key});

  @override
  State<PreferencesSpecialtiesScreen> createState() => _PreferencesSpecialtiesScreenState();
}

class _PreferencesSpecialtiesScreenState extends State<PreferencesSpecialtiesScreen> {
  Set<String> selectedSpecialties = {};
  
  // Valores como double para os sliders
  double hourlyValue = 20.0;
  double shiftValue = 120.0;
  double dailyValue = 200.0;

  final List<String> specialties = [
    'Cuidado de idosos com limitações físicas',
    'Cuidado de idosos com Alzheimer/demência',
    'Acompanhamento em consultas/exames',
    'Acompanhamento hospitalar',
    'Cuidados pós-operatórios',
    'Apoio em higiene e mobilidade',
    'Apoio em administração de medicamentos',
  ];

  @override
  void initState() {
    super.initState();
    // Valores iniciais já definidos nas variáveis
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppDesignSystem.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppDesignSystem.textColor,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Preferências e Especialidades',
          style: AppDesignSystem.h3Style,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildSpecialtiesSection(),
                const SizedBox(height: 20),
                _buildValuesSection(),
                const SizedBox(height: 32),
                _buildNextButton(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialtiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferências e Especialidades',
          style: AppDesignSystem.labelStyle,
        ),
        const SizedBox(height: 8),
        ...specialties.map((specialty) => _buildSpecialtyItem(specialty)),
      ],
    );
  }

  Widget _buildSpecialtyItem(String specialty) {
    final bool isSelected = selectedSpecialties.contains(specialty);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              selectedSpecialties.remove(specialty);
            } else {
              selectedSpecialties.add(specialty);
            }
          });
        },
        child: Container(
          height: 48,
          padding: EdgeInsets.symmetric(
            horizontal: AppDesignSystem.spaceM,
            vertical: AppDesignSystem.spaceS,
          ),
          decoration: BoxDecoration(
            color: isSelected 
              ? AppDesignSystem.primaryColor.withOpacity(0.1)
              : AppDesignSystem.surfaceColor,
            borderRadius: BorderRadius.circular(AppDesignSystem.spaceS),
            border: Border.all(
              color: isSelected 
                ? AppDesignSystem.primaryColor
                : AppDesignSystem.borderColor,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isSelected 
                    ? AppDesignSystem.primaryColor 
                    : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isSelected 
                      ? AppDesignSystem.primaryColor
                      : AppDesignSystem.borderColor,
                  ),
                ),
                child: isSelected 
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
              ),
              SizedBox(width: AppDesignSystem.spaceS),
              Expanded(
                child: Text(
                  specialty,
                  style: AppDesignSystem.bodySmallStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValuesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Valores',
          style: AppDesignSystem.labelStyle,
        ),
        const SizedBox(height: 8),
        _buildValueSlider('Valor por horas', hourlyValue, 10.0, 100.0, (value) {
          setState(() => hourlyValue = value);
        }),
        const SizedBox(height: 12),
        _buildValueSlider('Valor por turno', shiftValue, 50.0, 500.0, (value) {
          setState(() => shiftValue = value);
        }),
        const SizedBox(height: 12),
        _buildValueSlider('Valor por diária', dailyValue, 100.0, 1000.0, (value) {
          setState(() => dailyValue = value);
        }),
      ],
    );
  }

  Widget _buildValueSlider(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppDesignSystem.labelStyle,
        ),
        const SizedBox(height: 4),
        Container(
          padding: EdgeInsets.all(AppDesignSystem.spaceM),
          decoration: BoxDecoration(
            color: AppDesignSystem.surfaceColor,
            borderRadius: BorderRadius.circular(AppDesignSystem.spaceS),
            border: Border.all(color: AppDesignSystem.borderColor),
          ),
          child: Column(
            children: [
              // Display do valor atual
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'R\$ ',
                    style: AppDesignSystem.bodyStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppDesignSystem.primaryColor,
                    ),
                  ),
                  Text(
                    value.toStringAsFixed(0).replaceAll('.', ','),
                    style: AppDesignSystem.bodyStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: AppDesignSystem.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppDesignSystem.primaryColor,
                  inactiveTrackColor: AppDesignSystem.borderColor,
                  thumbColor: AppDesignSystem.primaryColor,
                  overlayColor: AppDesignSystem.primaryColor.withOpacity(0.2),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  divisions: ((max - min) / 5).round(), // Incrementos de 5 em 5
                  onChanged: onChanged,
                ),
              ),
              // Labels min/max
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'R\$ ${min.toStringAsFixed(0)}',
                    style: AppDesignSystem.captionStyle,
                  ),
                  Text(
                    'R\$ ${max.toStringAsFixed(0)}',
                    style: AppDesignSystem.captionStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _handleNext,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppDesignSystem.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignSystem.spaceS),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Próximo',
              style: AppDesignSystem.buttonStyle,
            ),
            SizedBox(width: AppDesignSystem.spaceS),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _handleNext() {
    if (selectedSpecialties.isEmpty) {
      _showSnackBar('Por favor, selecione pelo menos uma especialidade', Colors.red);
      return;
    }

    _showConfirmationDialog();
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppDesignSystem.backgroundColor,
          title: Text(
            'Preferências Configuradas',
            style: AppDesignSystem.h3Style,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Especialidades selecionadas:',
                  style: AppDesignSystem.labelStyle,
                ),
                const SizedBox(height: 4),
                Text(
                  selectedSpecialties.join(', '),
                  style: AppDesignSystem.bodySmallStyle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Text(
                  'Valores configurados:',
                  style: AppDesignSystem.labelStyle,
                ),
                const SizedBox(height: 4),
                Text('Por hora: R\$ ${hourlyValue.toStringAsFixed(0)}', style: AppDesignSystem.bodySmallStyle),
                Text('Por turno: R\$ ${shiftValue.toStringAsFixed(0)}', style: AppDesignSystem.bodySmallStyle),
                Text('Por diária: R\$ ${dailyValue.toStringAsFixed(0)}', style: AppDesignSystem.bodySmallStyle),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Editar', style: AppDesignSystem.linkStyle),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSnackBar('Preferências salvas com sucesso!', AppDesignSystem.primaryColor);
                
                // Navegar para a tela de termos e confirmação
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsConfirmationScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppDesignSystem.primaryColor,
              ),
              child: Text('Confirmar', style: AppDesignSystem.buttonStyle),
            ),
          ],
        );
      },
    );
  }
}