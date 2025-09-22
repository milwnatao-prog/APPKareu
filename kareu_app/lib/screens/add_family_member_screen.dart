import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';

class AddFamilyMemberScreen extends StatefulWidget {
  const AddFamilyMemberScreen({super.key});

  @override
  State<AddFamilyMemberScreen> createState() => _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen> {
  void _addFamilyMember() {
    // Navegar para tela de formulário de dados do familiar
    Navigator.pushNamed(context, '/family-member-form');
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

            const SizedBox(height: AppDesignSystem.spaceXL),

            // Título principal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceXL),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Conte-nos sobre seu Familiar',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDesignSystem.space6XL),

            // Card para adicionar familiar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: GestureDetector(
                onTap: _addFamilyMember,
                child: Container(
                  width: 322,
                  height: 61,
                  padding: const EdgeInsets.fromLTRB(13, 15, 4, 9),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E5FB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Ícone de adicionar
                      Container(
                        width: 31,
                        height: 31,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4D64C8),
                          borderRadius: BorderRadius.circular(15.5),
                        ),
                        child: Stack(
                          children: [
                            // Linha vertical do "+"
                            Positioned(
                              left: 13.25,
                              top: 5,
                              child: Container(
                                width: 4.5,
                                height: 18,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // Linha horizontal do "+"
                            Positioned(
                              left: 6,
                              top: 12,
                              child: Container(
                                width: 18,
                                height: 4.5,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 11),

                      // Texto
                      const Expanded(
                        child: Text(
                          'Adicionar um familiar/Paciente',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF4E4E4E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppDesignSystem.space4XL),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
