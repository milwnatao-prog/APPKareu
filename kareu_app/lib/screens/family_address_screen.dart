import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';

class FamilyAddressScreen extends StatefulWidget {
  const FamilyAddressScreen({super.key});

  @override
  State<FamilyAddressScreen> createState() => _FamilyAddressScreenState();
}

class _FamilyAddressScreenState extends State<FamilyAddressScreen> {
  final _cepController = TextEditingController();
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _cidadeController = TextEditingController();

  @override
  void dispose() {
    _cepController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _cidadeController.dispose();
    super.dispose();
  }

  void _useCurrentLocation() {
    // TODO: Implementar funcionalidade de localização atual
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade de localização será implementada'),
        backgroundColor: AppDesignSystem.primaryColor,
      ),
    );
  }

  void _onNextPressed() {
    // TODO: Validar campos e navegar para próxima tela
    if (_cepController.text.isEmpty || 
        _ruaController.text.isEmpty || 
        _numeroController.text.isEmpty || 
        _cidadeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Navegar para tela de adicionar familiar
    Navigator.pushNamed(context, '/add-family-member');
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
            // Header com botão voltar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDesignSystem.spaceLG,
                vertical: AppDesignSystem.spaceMD,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 24,
                      height: 24,
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDesignSystem.space3XL,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppDesignSystem.spaceXL),

                    // Título principal
                    const Center(
                      child: Text(
                        'Onde você mora?',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDesignSystem.space4XL),

                    // Texto explicativo
                    const Text(
                      'Assim poderemos mostrar opções na sua região',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: AppDesignSystem.space2XL),

                    // Campo CEP
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CEP',
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
                          child: TextField(
                            controller: _cepController,
                            decoration: const InputDecoration(
                              hintText: 'digite seu cep',
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                                color: Color(0xFFA8A2A2),
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

                    const SizedBox(height: AppDesignSystem.spaceXL),

                    // Campos Rua e Número
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Campo Rua
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Rua',
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
                                child: TextField(
                                  controller: _ruaController,
                                  decoration: const InputDecoration(
                                    hintText: 'digite seu endereçõ',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xFFA8A2A2),
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

                        const SizedBox(width: AppDesignSystem.spaceLG),

                        // Campo Número
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Nº',
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
                                child: TextField(
                                  controller: _numeroController,
                                  decoration: const InputDecoration(
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
                      ],
                    ),

                    const SizedBox(height: AppDesignSystem.spaceXL),

                    // Campo Cidade
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cidade ',
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
                          child: TextField(
                            controller: _cidadeController,
                            decoration: const InputDecoration(
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

                    const SizedBox(height: AppDesignSystem.space4XL),

                    // Texto "ou"
                    const Center(
                      child: Text(
                        'ou',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDesignSystem.space4XL),

                    // Botão usar localização atual
                    GestureDetector(
                      onTap: _useCurrentLocation,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 23,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F8F8),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              child: const Icon(
                                Icons.location_on_outlined,
                                size: 15,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: AppDesignSystem.spaceSM),
                            const Text(
                              'Usar minha localização atual',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDesignSystem.space6XL),

                    // Aviso de privacidade
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(13, 15, 4, 9),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7A4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFAD00),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.warning_outlined,
                              size: 14,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 11),
                          const Expanded(
                            child: Text(
                              'Não compartilharemos seu endereço com ninguém',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF4E4E4E),
                              ),
                            ),
                          ),
                        ],
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
                  onPressed: _onNextPressed,
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
