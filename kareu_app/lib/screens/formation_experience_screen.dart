import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';

class FormationExperienceScreen extends StatefulWidget {
  const FormationExperienceScreen({super.key});

  @override
  State<FormationExperienceScreen> createState() => _FormationExperienceScreenState();
}

class _FormationExperienceScreenState extends State<FormationExperienceScreen> {
  String? selectedEducation;
  String? selectedExperienceYears;
  Set<String> selectedAreas = {};
  final TextEditingController referenceNameController = TextEditingController();
  final TextEditingController referencePhoneController = TextEditingController();

  final List<String> educationOptions = [
    'Ensino Fundamental',
    'Ensino Médio',
    'Ensino Superior',
    'Pós-graduação',
    'Mestrado',
    'Doutorado'
  ];

  final List<String> experienceYearsOptions = [
    'Menos de 1 ano',
    '1-2 anos',
    '3-5 anos',
    '6-10 anos',
    'Mais de 10 anos'
  ];

  final List<Map<String, dynamic>> careAreas = [
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
      'id': 'outros',
      'title': 'Outros',
      'icon': Icons.more_horiz,
    },
  ];

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
          'Formação e Experiência',
          style: AppDesignSystem.h3Style,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildEducationSection(),
                const SizedBox(height: 20),
                _buildExperienceYearsSection(),
                const SizedBox(height: 20),
                _buildCareAreasSection(),
                const SizedBox(height: 20),
                _buildProfessionalReferencesSection(),
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

  Widget _buildEducationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Escolaridade',
          style: AppDesignSystem.labelStyle,
        ),
        const SizedBox(height: 4),
        _buildDropdown(
          value: selectedEducation,
          items: educationOptions,
          onChanged: (value) => setState(() => selectedEducation = value),
        ),
      ],
    );
  }

  Widget _buildExperienceYearsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Experiência prévia como cuidador (em anos)',
          style: AppDesignSystem.labelStyle,
        ),
        const SizedBox(height: 4),
        _buildDropdown(
          value: selectedExperienceYears,
          items: experienceYearsOptions,
          onChanged: (value) => setState(() => selectedExperienceYears = value),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: AppDesignSystem.surfaceColor,
        borderRadius: BorderRadius.circular(AppDesignSystem.spaceS),
        border: Border.all(color: AppDesignSystem.borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceM),
            child: Text(
              'Selecione',
              style: AppDesignSystem.placeholderStyle,
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceM),
                child: Text(
                  item,
                  style: AppDesignSystem.bodySmallStyle,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          icon: Padding(
            padding: EdgeInsets.only(right: AppDesignSystem.spaceM),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: AppDesignSystem.textColor,
              size: 20,
            ),
          ),
          isExpanded: true,
        ),
      ),
    );
  }

  Widget _buildCareAreasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Áreas de experiência',
          style: AppDesignSystem.labelStyle,
        ),
        const SizedBox(height: 8),
        ...careAreas.map((area) => _buildCareAreaItem(area)),
      ],
    );
  }

  Widget _buildCareAreaItem(Map<String, dynamic> area) {
    final bool isSelected = selectedAreas.contains(area['id']);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              selectedAreas.remove(area['id']);
            } else {
              selectedAreas.add(area['id']);
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
              Icon(
                area['icon'],
                color: AppDesignSystem.secondaryColor,
                size: 20,
              ),
              SizedBox(width: AppDesignSystem.spaceS),
              Expanded(
                child: Text(
                  area['title'],
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

  Widget _buildProfessionalReferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Referências profissionais',
          style: AppDesignSystem.labelStyle,
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: referenceNameController,
          hintText: 'Nome',
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: referencePhoneController,
          hintText: 'Telefone celular',
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: AppDesignSystem.surfaceColor,
        borderRadius: BorderRadius.circular(AppDesignSystem.spaceS),
        border: Border.all(color: AppDesignSystem.borderColor),
      ),
      child: TextField(
        controller: controller,
        style: AppDesignSystem.bodySmallStyle,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppDesignSystem.placeholderStyle,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppDesignSystem.spaceM,
            vertical: AppDesignSystem.spaceM,
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/availability');
        },
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

  @override
  void dispose() {
    referenceNameController.dispose();
    referencePhoneController.dispose();
    super.dispose();
  }
}