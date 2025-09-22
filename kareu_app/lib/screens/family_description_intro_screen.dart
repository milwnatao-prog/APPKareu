import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';

class FamilyDescriptionIntroScreen extends StatefulWidget {
  const FamilyDescriptionIntroScreen({super.key});

  @override
  State<FamilyDescriptionIntroScreen> createState() => _FamilyDescriptionIntroScreenState();
}

class _FamilyDescriptionIntroScreenState extends State<FamilyDescriptionIntroScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showPlaceholderText = true;
  bool _hasBeenFocused = false;

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(() {
      setState(() {
        _showPlaceholderText = _descriptionController.text.isEmpty && !_hasBeenFocused;
      });
    });
    
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && !_hasBeenFocused) {
        setState(() {
          _hasBeenFocused = true;
          _showPlaceholderText = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onNextPressed(BuildContext context) {
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, descreva seu familiar antes de continuar'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cadastro concluído com sucesso!'),
        backgroundColor: AppDesignSystem.primaryColor,
      ),
    );
    
    // Navegar para a tela principal do paciente após cadastro completo
    Navigator.pushNamedAndRemoveUntil(
      context, 
      '/home-patient', 
      (route) => false,
    );
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppDesignSystem.space4XL),

                    // Título principal
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                      child: Container(
                        width: 367,
                        child: const Text(
                          'Apresente seu Familiar',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDesignSystem.space6XL),

                    // Card principal com campo de texto editável
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 44),
                      child: Container(
                        width: 303,
                        height: 313,
                        padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Stack(
                          children: [
                            // Texto explicativo que desaparece quando usuário digita
                            if (_showPlaceholderText)
                              Container(
                                width: 274,
                                child: const Text(
                                  'Essa é uma ótima forma de explicar suas necessidades e ajudar a encontrar o cuidador ideal. Quanto mais informações você compartilhar, melhores serão as opções que poderemos sugerir para você.',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xFF999999),
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            // Campo de texto editável
                            TextFormField(
                              controller: _descriptionController,
                              focusNode: _focusNode,
                              maxLines: null,
                              expands: true,
                              textAlignVertical: TextAlignVertical.top,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                height: 1.5,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                hintText: '',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDesignSystem.space6XL),

                    // Card amarelo com instruções
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        width: 331,
                        height: 61,
                        padding: const EdgeInsets.fromLTRB(13, 15, 4, 9),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7A4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          width: 306,
                          child: const Text(
                            'Descreva a pessoa que receberá os cuidados\nExplique por que ela precisa de um cuidador',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDesignSystem.space4XL),
                  ],
                ),
              ),
            ),

            // Botão Próximo fixo na parte inferior
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 10, 26, 26),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () => _onNextPressed(context),
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
                      const Text(
                        'Próximo',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: AppDesignSystem.spaceSM),
                      Container(
                        width: 17,
                        height: 17,
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
