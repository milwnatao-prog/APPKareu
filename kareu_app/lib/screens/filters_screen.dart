import 'package:flutter/material.dart';
import 'package:kareu_app/constants/app_design_system.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  // Filtros selecionados
  String? _selectedSpecialty;
  RangeValues _priceRange = const RangeValues(20, 50);
  double _minExperience = 1;
  String? _selectedCity;
  double _minRating = 4.0;
  bool _verifiedOnly = false;
  String _availability = 'Qualquer horário';

  final List<String> _specialties = [
    'Cuidador',
    'Técnico de Enfermagem',
    'Acompanhante Hospitalar',
    'Acompanhante Domiciliar',
  ];

  final List<String> _cities = [
    'Natal, RN',
    'João Pessoa, PB',
    'São Paulo, SP',
    'Curitiba, PR',
    'Recife, PE',
    'Fortaleza, CE',
  ];

  final List<String> _availabilityOptions = [
    'Qualquer horário',
    'Manhã (6h-12h)',
    'Tarde (12h-18h)',
    'Noite (18h-24h)',
    'Madrugada (0h-6h)',
    '24 horas',
  ];

  void _clearFilters() {
    setState(() {
      _selectedSpecialty = null;
      _priceRange = const RangeValues(20, 50);
      _minExperience = 1;
      _selectedCity = null;
      _minRating = 4.0;
      _verifiedOnly = false;
      _availability = 'Qualquer horário';
    });
  }

  void _applyFilters() {
    // Aqui você aplicaria os filtros e retornaria os resultados
    Navigator.pop(context, {
      'specialty': _selectedSpecialty,
      'priceRange': _priceRange,
      'minExperience': _minExperience,
      'city': _selectedCity,
      'minRating': _minRating,
      'verifiedOnly': _verifiedOnly,
      'availability': _availability,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      appBar: AppDesignSystem.styledAppBar(
        title: 'Filtros',
        onBackPressed: () => Navigator.pop(context),
        actions: [
          TextButton(
            onPressed: _clearFilters,
            child: Text(
              'Limpar',
              style: AppDesignSystem.bodySmallStyle.copyWith(
                color: AppDesignSystem.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDesignSystem.space2XL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Especialidade
                  _buildSectionTitle('Especialidade'),
                  const SizedBox(height: 12),
                  _buildSpecialtyFilter(),
                  
                  const SizedBox(height: 32),
                  
                  // Faixa de preço
                  _buildSectionTitle('Faixa de Preço (por hora)'),
                  const SizedBox(height: 12),
                  _buildPriceRangeFilter(),
                  
                  const SizedBox(height: 32),
                  
                  // Experiência mínima
                  _buildSectionTitle('Experiência Mínima'),
                  const SizedBox(height: 12),
                  _buildExperienceFilter(),
                  
                  const SizedBox(height: 32),
                  
                  // Cidade
                  _buildSectionTitle('Cidade'),
                  const SizedBox(height: 12),
                  _buildCityFilter(),
                  
                  const SizedBox(height: 32),
                  
                  // Avaliação mínima
                  _buildSectionTitle('Avaliação Mínima'),
                  const SizedBox(height: 12),
                  _buildRatingFilter(),
                  
                  const SizedBox(height: 32),
                  
                  // Disponibilidade
                  _buildSectionTitle('Disponibilidade'),
                  const SizedBox(height: 12),
                  _buildAvailabilityFilter(),
                  
                  const SizedBox(height: 32),
                  
                  // Apenas verificados
                  _buildVerifiedFilter(),
                ],
              ),
            ),
          ),
          
          // Botão aplicar filtros
          _buildApplyButton(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppDesignSystem.labelStyle.copyWith(
        fontSize: AppDesignSystem.fontSizeBody,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSpecialtyFilter() {
    return Wrap(
      spacing: AppDesignSystem.spaceSM,
      runSpacing: AppDesignSystem.spaceSM,
      children: _specialties.map((specialty) {
        final isSelected = _selectedSpecialty == specialty;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedSpecialty = isSelected ? null : specialty;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDesignSystem.spaceLG, 
              vertical: AppDesignSystem.spaceSM,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppDesignSystem.primaryColor : AppDesignSystem.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppDesignSystem.primaryColor : AppDesignSystem.borderColor,
                width: 1,
              ),
            ),
            child: Text(
              specialty,
              style: AppDesignSystem.bodySmallStyle.copyWith(
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppDesignSystem.textSecondaryColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPriceRangeFilter() {
    return Column(
      children: [
        RangeSlider(
          values: _priceRange,
          min: 15,
          max: 80,
          divisions: 13,
          activeColor: AppDesignSystem.primaryColor,
          inactiveColor: AppDesignSystem.primaryColor.withValues(alpha: 0.2),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'R\$ ${_priceRange.start.round()}',
              style: AppDesignSystem.bodySmallStyle.copyWith(
                fontWeight: FontWeight.w500,
                color: AppDesignSystem.textSecondaryColor,
              ),
            ),
            Text(
              'R\$ ${_priceRange.end.round()}',
              style: AppDesignSystem.bodySmallStyle.copyWith(
                fontWeight: FontWeight.w500,
                color: AppDesignSystem.textSecondaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExperienceFilter() {
    return Column(
      children: [
        Slider(
          value: _minExperience,
          min: 1,
          max: 15,
          divisions: 14,
          activeColor: AppDesignSystem.primaryColor,
          inactiveColor: AppDesignSystem.primaryColor.withValues(alpha: 0.2),
          onChanged: (value) {
            setState(() {
              _minExperience = value;
            });
          },
        ),
        Text(
          '${_minExperience.round()} ${_minExperience.round() == 1 ? 'ano' : 'anos'}',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildCityFilter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE1E5E9)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCity,
          hint: const Text(
            'Selecione uma cidade',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6B7280),
            ),
          ),
          items: _cities.map((city) {
            return DropdownMenuItem(
              value: city,
              child: Text(
                city,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1F2937),
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCity = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildRatingFilter() {
    return Column(
      children: [
        Slider(
          value: _minRating,
          min: 1,
          max: 5,
          divisions: 8,
          activeColor: AppDesignSystem.primaryColor,
          inactiveColor: AppDesignSystem.primaryColor.withValues(alpha: 0.2),
          onChanged: (value) {
            setState(() {
              _minRating = value;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star,
              color: Colors.amber[600],
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              _minRating.toStringAsFixed(1),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
            const Text(
              ' ou mais',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAvailabilityFilter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE1E5E9)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _availability,
          items: _availabilityOptions.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(
                option,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1F2937),
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _availability = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildVerifiedFilter() {
    return Row(
      children: [
        Checkbox(
          value: _verifiedOnly,
          activeColor: AppDesignSystem.primaryColor,
          onChanged: (value) {
            setState(() {
              _verifiedOnly = value ?? false;
            });
          },
        ),
        const Expanded(
          child: Text(
            'Apenas cuidadores verificados',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
        Icon(
          Icons.verified,
          color: Colors.green[600],
          size: 20,
        ),
      ],
    );
  }

  Widget _buildApplyButton() {
    return Container(
      padding: const EdgeInsets.all(AppDesignSystem.space2XL),
      decoration: BoxDecoration(
        color: AppDesignSystem.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: AppDesignSystem.primaryButton(
        text: 'Aplicar Filtros',
        onPressed: _applyFilters,
        width: double.infinity,
      ),
    );
  }
}
