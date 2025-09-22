import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';

class FamilyMemberFormScreen extends StatefulWidget {
  const FamilyMemberFormScreen({super.key});

  @override
  State<FamilyMemberFormScreen> createState() => _FamilyMemberFormScreenState();
}

class _FamilyMemberFormScreenState extends State<FamilyMemberFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _dataController = TextEditingController();

  String _genero = 'Homem';
  DateTime? _selectedDate;
  final Set<String> _caracteristicasSelecionadas = <String>{};

  final List<String> _caracteristicas = [
    'Calmo (a)',
    'Independente',
    'Ansioso (a)',
    'Reservado (a)',
    'Necessidades especias',
    'Em tratamento médico',
    'Alegre',
    'Acamado (a)',
    'Gosta de conversar',
    'Uso de medicação regular',
    'Prefere privacidade',
    'Mobilidade reduzida',
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dataController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  void _onSavePressed() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, selecione a data de nascimento'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // TODO: Salvar dados do familiar e navegar para próxima tela
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Familiar cadastrado com sucesso!'),
          backgroundColor: AppDesignSystem.primaryColor,
        ),
      );
      
      // Navegar para tela de cuidados necessários
      Navigator.pushNamed(context, '/care-needs');
    }
  }

  void _toggleCaracteristica(String caracteristica) {
    setState(() {
      if (_caracteristicasSelecionadas.contains(caracteristica)) {
        _caracteristicasSelecionadas.remove(caracteristica);
      } else {
        _caracteristicasSelecionadas.add(caracteristica);
      }
    });
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
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppDesignSystem.spaceXL),

                      // Título principal
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 92, vertical: 10),
                          child: Text(
                            'Adicionar familiar',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppDesignSystem.space4XL),

                      // Seção "Informações do familiar"
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 34),
                        child: Text(
                          'Informações do familiar',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppDesignSystem.spaceXL),

                      // Seletor de gênero
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 34),
                        child: Container(
                          width: 322,
                          height: 61,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              // Botão Homem
                              GestureDetector(
                                onTap: () => setState(() => _genero = 'Homem'),
                                child: Container(
                                  width: 167,
                                  height: 61,
                                  decoration: BoxDecoration(
                                    color: _genero == 'Homem' 
                                        ? const Color(0xFF252A3F) 
                                        : Colors.transparent,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Homem',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: _genero == 'Homem' ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Botão Mulher
                              GestureDetector(
                                onTap: () => setState(() => _genero = 'Mulher'),
                                child: Container(
                                  width: 155,
                                  height: 61,
                                  decoration: BoxDecoration(
                                    color: _genero == 'Mulher' 
                                        ? const Color(0xFF252A3F) 
                                        : Colors.transparent,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Mulher',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: _genero == 'Mulher' ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: AppDesignSystem.spaceXL),

                      // Campo Nome completo
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 34),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nome completo',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: AppDesignSystem.spaceXS),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFD0D0D0).withValues(alpha: 0.54),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextFormField(
                                controller: _nomeController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira o nome';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'digite seu nome',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xFFAAAAAA),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 11,
                                    vertical: 15,
                                  ),
                                ),
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppDesignSystem.spaceXL),

                      // Campo Data de nascimento
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 34),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Data de nascimento',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: AppDesignSystem.spaceXS),
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: Container(
                                width: double.infinity,
                                height: 56,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _dataController.text.isEmpty 
                                            ? 'Selecione a data de nascimento'
                                            : _dataController.text,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: _dataController.text.isEmpty 
                                              ? Colors.grey[500]
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.calendar_today,
                                      color: Colors.grey[600],
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppDesignSystem.space3XL),

                      // Seção "Descreva seu familiar"
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 34),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Descreva seu familiar',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Escolha as caracteristicas que melhor descrevem seu familiar',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppDesignSystem.space4XL),

                      // Tags de características
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 34),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 10,
                          children: _caracteristicas.map((caracteristica) {
                            final isSelected = _caracteristicasSelecionadas.contains(caracteristica);
                            return GestureDetector(
                              onTap: () => _toggleCaracteristica(caracteristica),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? const Color(0xFF4D64C8) 
                                      : const Color(0xFFD0D0D0).withValues(alpha: 0.54),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  caracteristica,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                    color: isSelected ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: AppDesignSystem.space6XL),
                    ],
                  ),
                ),
              ),
            ),

            // Botão Salvar fixo na parte inferior
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 10, 26, 26),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _onSavePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4D64C8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Salvar',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
