import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';
import '../services/user_service.dart';

class CaregiverProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? caregiverData;
  
  const CaregiverProfileScreen({
    super.key,
    this.caregiverData,
  });

  @override
  State<CaregiverProfileScreen> createState() => _CaregiverProfileScreenState();
}

class _CaregiverProfileScreenState extends State<CaregiverProfileScreen> {
  late Map<String, dynamic> caregiver;
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    caregiver = widget.caregiverData ?? _getDefaultCaregiverData();
    // Definir tipo de usuário como cuidador (perfil do próprio cuidador)
    UserService.setUserType(UserType.caregiver);
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Receber argumentos da navegação se não foram passados no construtor
    if (widget.caregiverData == null) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments != null && arguments is Map<String, dynamic>) {
        caregiver = arguments;
      }
    }
  }

  Map<String, dynamic> _getDefaultCaregiverData() {
    return {
      'name': 'Maria Souza',
      'profession': 'Técnica de enfermagem',
      'registration': 'COREN 123456',
      'verified': true,
      'rating': 4.8,
      'totalReviews': 127,
      'profileImage': null,
      'description': 'Sou técnica de enfermagem com experiência em acompanhamento hospitalar, oferecendo apoio humano e profissional para pacientes internados. Auxilio em cuidados básicos, monitoramento do bem-estar, medicações conforme prescrição e, principalmente, na presença acolhedora para dar tranquilidade aos familiares. Meu objetivo é garantir segurança, atenção e companhia ao paciente durante a internação, permitindo que a família tenha mais confiança e serenidade nesse momento.',
      'services': [
        'Higiene pessoal',
        'Administração de medicamentos',
        'Mobilidade',
        'Alimentação',
        'Companhia',
        'Medicação',
      ],
      'experiences': [
        '5 anos em casa de repouso Vila Serena',
        '3 anos no Hospital dos Pescadores',
        '2 anos como cuidadora domiciliar',
        'Curso de primeiros socorros',
      ],
      'reviews': [
        {
          'rating': 5,
          'comment': 'Muito atenciosa e pontual. Recomendo!',
          'reviewer': 'Ana Silva',
          'date': '15/08/2024',
        },
        {
          'rating': 5,
          'comment': 'Paciente e profissional, minha mãe foi muito bem cuidada.',
          'reviewer': 'João Santos',
          'date': '20/07/2024',
        },
        {
          'rating': 4,
          'comment': 'Prestativa e cuidadosa. Recomendo!',
          'reviewer': 'Maria Oliveira',
          'date': '10/06/2024',
        },
      ],
      'hourlyRate': 25.0,
      'availability': 'Disponível',
    };
  }

  void _toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorited 
            ? '${caregiver['name']} adicionado aos favoritos'
            : '${caregiver['name']} removido dos favoritos',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppDesignSystem.primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _startChat() {
    Navigator.pushNamed(
      context,
      '/caregiver-chat',
      arguments: {
        'patientName': 'Maria Silva', // Simular nome do paciente
        'patientId': 'patient_001',
      },
    );
  }

  void _hireCaregiverDialog() {
    // Navegar diretamente para a tela de contratação e pagamento
    Navigator.pushNamed(
      context,
      '/hire-caregiver',
      arguments: {
        'name': caregiver['name'],
        'specialty': caregiver['profession'],
        'rating': caregiver['rating'],
        'hourlyRate': caregiver['hourlyRate']?.toDouble() ?? 25.0,
        'image': caregiver['profileImage'],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header moderno
            _buildModernHeader(),
            
            // Conteúdo principal
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Hero section com foto e informações principais
                    _buildHeroSection(),
                    
                    const SizedBox(height: 32),
                    
                    // Cards de informações
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          _buildStatsCards(),
                          const SizedBox(height: 24),
                          _buildAboutSection(),
                          const SizedBox(height: 24),
                          _buildServicesSection(),
                          const SizedBox(height: 24),
                          _buildExperienceSection(),
                          const SizedBox(height: 24),
                          _buildReviewsSection(),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom navigation bar
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF6B7280),
                size: 20,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Perfil do Cuidador',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          GestureDetector(
            onTap: _toggleFavorite,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isFavorited 
                  ? const Color(0xFFEF4444).withValues(alpha: 0.1)
                  : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isFavorited ? Icons.favorite : Icons.favorite_border,
                color: isFavorited ? const Color(0xFFEF4444) : const Color(0xFF6B7280),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4D64C8), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          
          // Foto do perfil
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 56,
              backgroundColor: Colors.white,
              child: Text(
                caregiver['name']?[0] ?? 'C',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4D64C8),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Nome
          Text(
            caregiver['name'] ?? 'Cuidador',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Profissão
          Text(
            caregiver['profession'] ?? 'Profissional de Saúde',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Registro
          Text(
            caregiver['registration'] ?? 'Registro Profissional',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Badge verificado
          if (caregiver['verified'] == true)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Perfil Verificado',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 32),
          
          // Botões de ação principais
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _hireCaregiverDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4D64C8),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Contratar',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _startChat,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Conversar',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Avaliação',
            '${caregiver['rating'] ?? 4.8}⭐',
            Icons.star,
            const Color(0xFFFBBF24),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Avaliações',
            '${caregiver['totalReviews'] ?? 127}',
            Icons.rate_review,
            const Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Valor/hora',
            'R\$ ${caregiver['hourlyRate'] ?? 25}',
            Icons.attach_money,
            const Color(0xFF4D64C8),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.person_outline,
                color: Color(0xFF4D64C8),
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Sobre o Profissional',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            caregiver['description'] ?? 'Descrição não disponível.',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6B7280),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    final services = caregiver['services'] as List<String>? ?? [];
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.medical_services_outlined,
                color: Color(0xFF10B981),
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Serviços Oferecidos',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: services.map((service) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  service,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF10B981),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceSection() {
    final experiences = caregiver['experiences'] as List<String>? ?? [];
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.work_outline,
                color: Color(0xFF8B5CF6),
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Experiência Profissional',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...experiences.map((experience) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF8B5CF6),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      experience,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    final reviews = caregiver['reviews'] as List<Map<String, dynamic>>? ?? [];
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.rate_review_outlined,
                color: Color(0xFFFBBF24),
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Avaliações dos Clientes',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...reviews.take(3).map((review) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: const Color(0xFF4D64C8).withValues(alpha: 0.1),
                        child: Text(
                          review['reviewer']?[0] ?? 'U',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4D64C8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review['reviewer'] ?? 'Cliente',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < (review['rating'] ?? 5)
                                    ? Icons.star
                                    : Icons.star_border,
                                  color: const Color(0xFFFBBF24),
                                  size: 14,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        review['date'] ?? '',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    review['comment'] ?? '',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          if (reviews.length > 3)
            Center(
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ver todas as avaliações será implementado em breve'),
                    ),
                  );
                },
                child: const Text(
                  'Ver todas as avaliações',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4D64C8),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesignSystem.spaceMD,
          vertical: AppDesignSystem.spaceSM,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected 
                ? AppDesignSystem.primaryColor 
                : AppDesignSystem.textSecondaryColor,
              size: 24,
            ),
            const SizedBox(height: AppDesignSystem.spaceXS),
            Text(
              label,
              style: AppDesignSystem.captionStyle.copyWith(
                color: isSelected 
                  ? AppDesignSystem.primaryColor 
                  : AppDesignSystem.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTabSelected(int index) {
    switch (index) {
      case 0:
        // Navegar para Home
        Navigator.pushReplacementNamed(context, '/home-patient');
        break;
      case 1:
        // Navegar para Chat
        Navigator.pushNamed(context, '/patient-chat');
        break;
      case 2:
        // Navegar para Contratos
        Navigator.pushNamed(context, '/contracts');
        break;
      case 3:
        // Navegar para Agenda
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tela de agenda será implementada em breve'),
            backgroundColor: AppDesignSystem.infoColor,
          ),
        );
        break;
      case 4:
        // Navegar para Perfil
        Navigator.pushNamed(context, UserService.getAccountRoute());
        break;
    }
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
      decoration: BoxDecoration(
        color: AppDesignSystem.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, 'Início', 0),
          _buildNavItem(Icons.chat_bubble_outline, 'Chat', 1),
          _buildNavItem(Icons.assignment, 'Contratos', 2),
          _buildNavItem(Icons.calendar_today, 'Agenda', 3),
          _buildNavItem(Icons.account_circle_outlined, 'Perfil', 4),
        ],
      ),
    );
  }
}