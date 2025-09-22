import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';

class CareNeedsScreen extends StatefulWidget {
  const CareNeedsScreen({super.key});

  @override
  State<CareNeedsScreen> createState() => _CareNeedsScreenState();
}

class _CareNeedsScreenState extends State<CareNeedsScreen> {
  final Set<String> _cuidadosSelecionados = <String>{};

  final List<String> _tiposCuidados = [
    'Acompanhamento em consultas e exames',
    'Administração de medicamentos',
    'Higiene pessoal',
    'Alimentação',
    'Mobilidade',
    'Cuidados noturnos / companhia à noite',
    'Companhia e estímulo social',
    'Monitoramento de sinais vitais',
    'Troca de curativos e cuidados pós-cirúrgicos',
    'Apoio em atividades diárias',
    'Cuidados paliativos / suporte especializado',
    'Supervisão para segurança',
  ];

  void _toggleCuidado(String cuidado) {
    setState(() {
      if (_cuidadosSelecionados.contains(cuidado)) {
        _cuidadosSelecionados.remove(cuidado);
      } else {
        _cuidadosSelecionados.add(cuidado);
      }
    });
  }

  void _onSavePressed() {
    if (_cuidadosSelecionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione pelo menos um tipo de cuidado'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Salvar dados dos cuidados necessários e navegar para próxima tela
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_cuidadosSelecionados.length} tipos de cuidado selecionados!'),
        backgroundColor: AppDesignSystem.primaryColor,
      ),
    );
    
    // Navegar para tela de agendamento
    Navigator.pushNamed(context, '/care-schedule');
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppDesignSystem.space4XL),

                    // Título principal
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 10, 46, 10),
                      child: SizedBox(
                        width: 367,
                        child: const Text(
                          'Selecione os tipos de cuidado necessários (pode escolher mais de um)',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDesignSystem.space6XL),

                    // Lista de cuidados organizados em duas colunas
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: _tiposCuidados.map((cuidado) => _buildCareButton(cuidado)).toList(),
                      ),
                    ),

                    const SizedBox(height: AppDesignSystem.space6XL),
                  ],
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

  Widget _buildCareButton(String cuidado) {
    bool isSelected = _cuidadosSelecionados.contains(cuidado);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => _toggleCuidado(cuidado),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4D64C8).withValues(alpha: 0.1) : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF4D64C8) : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? const Color(0xFF4D64C8) : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF4D64C8) : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  cuidado,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? const Color(0xFF4D64C8) : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
