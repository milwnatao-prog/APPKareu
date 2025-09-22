import 'package:flutter/material.dart';
import 'dart:ui';
import 'professional_register_screen.dart';
import '../constants/app_design_system.dart';

enum UserType { needCaregiver, amCaregiver }

class UserTypeSelectionScreen extends StatefulWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  State<UserTypeSelectionScreen> createState() => _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Efeito blur circular azul no topo - responsivo
          Positioned(
            left: -screenWidth * 0.1,
            top: -screenHeight * 0.55,
            child: Container(
              width: screenWidth * 1.2,
              height: screenHeight * 0.9,
              decoration: BoxDecoration(
                color: const Color(0xFF4D64C8),
                borderRadius: BorderRadius.all(Radius.circular(screenWidth * 1.3)),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 46.6, sigmaY: 46.6),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF4D64C8),
                    borderRadius: BorderRadius.all(Radius.circular(screenWidth * 1.3)),
                  ),
                ),
              ),
            ),
          ),
          
          // Gradiente inferior - responsivo
          Positioned(
            left: 0,
            top: screenHeight * 0.14,
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.36,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00D9D9D9), // Transparente
                    Color(0xFFFFFFFF), // Branco
                  ],
                ),
              ),
            ),
          ),

          // Conteúdo principal
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.08), // Espaço responsivo
                  
                  // Logo "Kareu"
                  Container(
                    width: 156,
                    height: 101,
                    alignment: Alignment.center,
                    child: Text(
                      'Kareu',
                      style: AppDesignSystem.logoStyle,
                    ),
                  ),
                  
                  AppDesignSystem.verticalSpace(5.5), // Espaçamento até o título
                  
                  // Título "Novo usuário"
                  Container(
                    padding: EdgeInsets.all(AppDesignSystem.spaceMD),
                    child: Text(
                      'Novo usuário',
                      style: AppDesignSystem.bodyStyle,
                    ),
                  ),
                  
                  AppDesignSystem.verticalSpace(4.75), // Espaçamento até os botões
                  
                  // Botão "Preciso de um cuidador"
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
                    width: screenWidth * 0.82,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navegar para o fluxo de cadastro do paciente
                        Navigator.pushNamed(context, '/family-address');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4D64C8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      ),
                      child: Row(
                        children: [
                          // Ícone user-plus
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CustomPaint(
                              painter: UserPlusIconPainter(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Preciso de um cuidador',
                            style: AppDesignSystem.buttonStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 28), // Espaçamento entre botões
                  
                  // Botão "Sou cuidador"
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
                    width: screenWidth * 0.82,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navegar para tela de cadastro profissional
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfessionalRegisterScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFAD00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      ),
                      child: Row(
                        children: [
                          // Ícone user-check
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CustomPaint(
                              painter: UserCheckIconPainter(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Sou cuidador',
                            style: AppDesignSystem.buttonStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 68), // Espaçamento até o link
                  
                  // Link "Já possui uma conta? Faça o login"
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Volta para a tela de login
                      },
                      child: Text(
                        'Já possui uma conta? Faça o login',
                        style: AppDesignSystem.linkStyle.copyWith(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter para o ícone user-plus
class UserPlusIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Círculo da cabeça do usuário
    canvas.drawCircle(
      Offset(size.width * 0.375, size.height * 0.375), // (9, 9) em 24x24
      size.width * 0.167, // raio de 4
      paint,
    );

    // Corpo do usuário (arco)
    final path = Path();
    path.moveTo(size.width * 0.083, size.height * 0.875); // (2, 21)
    path.quadraticBezierTo(
      size.width * 0.083, size.height * 0.708, // (2, 17)
      size.width * 0.375, size.height * 0.708, // (9, 17)
    );
    path.quadraticBezierTo(
      size.width * 0.667, size.height * 0.708, // (16, 17)
      size.width * 0.667, size.height * 0.875, // (16, 21)
    );
    canvas.drawPath(path, paint);

    // Sinal de mais
    // Linha vertical
    canvas.drawLine(
      Offset(size.width * 0.833, size.height * 0.333), // (20, 8)
      Offset(size.width * 0.833, size.height * 0.583), // (20, 14)
      paint,
    );
    // Linha horizontal
    canvas.drawLine(
      Offset(size.width * 0.708, size.height * 0.458), // (17, 11)
      Offset(size.width * 0.958, size.height * 0.458), // (23, 11)
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter para o ícone user-check
class UserCheckIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Círculo da cabeça do usuário
    canvas.drawCircle(
      Offset(size.width * 0.375, size.height * 0.375), // (9, 9) em 24x24
      size.width * 0.167, // raio de 4
      paint,
    );

    // Corpo do usuário (arco)
    final path = Path();
    path.moveTo(size.width * 0.083, size.height * 0.875); // (2, 21)
    path.quadraticBezierTo(
      size.width * 0.083, size.height * 0.708, // (2, 17)
      size.width * 0.375, size.height * 0.708, // (9, 17)
    );
    path.quadraticBezierTo(
      size.width * 0.667, size.height * 0.708, // (16, 17)
      size.width * 0.667, size.height * 0.875, // (16, 21)
    );
    canvas.drawPath(path, paint);

    // Check mark
    final checkPath = Path();
    checkPath.moveTo(size.width * 0.708, size.height * 0.458); // (17, 11)
    checkPath.lineTo(size.width * 0.833, size.height * 0.583); // (20, 14)
    checkPath.lineTo(size.width * 0.958, size.height * 0.375); // (23, 9)
    canvas.drawPath(checkPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
