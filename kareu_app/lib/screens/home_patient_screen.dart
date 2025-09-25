import 'package:flutter/material.dart';
import 'package:kareu_app/constants/app_design_system.dart';
import '../services/user_service.dart';

class HomePatientScreen extends StatefulWidget {
  const HomePatientScreen({super.key});

  @override
  State<HomePatientScreen> createState() => _HomePatientScreenState();
}

class _HomePatientScreenState extends State<HomePatientScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header com saudação
            _buildHeader(),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    
                    // Search Bar com filtro integrado
                    _buildEnhancedSearchBar(),
                    
                    const SizedBox(height: 32),
                    
                    // Quick Actions
                    _buildQuickActions(),
                    
                    const SizedBox(height: 32),
                    
                    // Cities Section
                    _buildCitiesSection(),
                    
                    const SizedBox(height: 32),
                    
                    // Services Section
                    _buildServicesSection(),
                    
                    const SizedBox(height: 32),
                    
                    // Publish Ad Button
                    _buildPublishAdButton(),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            
            // Bottom Navigation
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá! 👋',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Encontre o cuidador ideal para sua família',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF6B7280),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/search');
        },
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.search,
                size: 22,
                color: Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Buscar cuidadores, especialidades...',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF9CA3AF),
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/filters');
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4D64C8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.tune,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ações Rápidas',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  'Emergência',
                  'Encontrar agora',
                  Icons.emergency,
                  const Color(0xFFEF4444),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  'Favoritos',
                  'Seus salvos',
                  Icons.favorite_outline,
                  const Color(0xFF8B5CF6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  'Histórico',
                  'Suas buscas',
                  Icons.history,
                  const Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(String title, String subtitle, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title será implementado em breve'),
            backgroundColor: color,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              offset: const Offset(0, 1),
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Color(0xFF9CA3AF),
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildCitiesSection() {
    final cities = [
      {'name': 'Natal', 'professionals': '120+'},
      {'name': 'João Pessoa', 'professionals': '85+'},
      {'name': 'São Paulo', 'professionals': '300+'},
      {'name': 'Curitiba', 'professionals': '95+'},
      {'name': 'Recife', 'professionals': '110+'},
      {'name': 'Fortaleza', 'professionals': '75+'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Principais Cidades',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                  height: 1.3,
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ver todas as cidades será implementado em breve'),
                      backgroundColor: Color(0xFF4D64C8),
                    ),
                  );
                },
                child: const Text(
                  'Ver todas',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4D64C8),
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 85,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: cities.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: index == cities.length - 1 ? 0 : 16),
                child: _buildModernCityCard(
                  cities[index]['name']!, 
                  cities[index]['professionals']!,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModernCityCard(String cityName, String professionals) {
    final List<Color> colorPalette = [
      const Color(0xFF4D64C8), // Azul principal
      const Color(0xFF10B981), // Verde
      const Color(0xFF8B5CF6), // Roxo
      const Color(0xFFEF4444), // Vermelho
      const Color(0xFFF59E0B), // Amarelo
      const Color(0xFF06B6D4), // Ciano
    ];
    
    Color cityColor = colorPalette[cityName.hashCode % colorPalette.length];

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Buscando cuidadores em $cityName...'),
            backgroundColor: cityColor,
          ),
        );
      },
      child: Container(
        width: 110,
        height: 85,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: cityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.location_city,
                    color: cityColor,
                    size: 12,
                  ),
                ),
                Flexible(
                  child: Text(
                    professionals,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                      height: 1.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    cityName,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                      height: 1.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Text(
                    'profissionais',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 8,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF9CA3AF),
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildServicesSection() {
    final services = [
      {
        'name': 'Cuidadores',
        'description': 'Cuidado especializado',
        'icon': Icons.favorite,
        'available': '45+'
      },
      {
        'name': 'Acompanhantes',
        'description': 'Hospitalar e domiciliar',
        'icon': Icons.local_hospital,
        'available': '32+'
      },
      {
        'name': 'Enfermagem',
        'description': 'Técnicos qualificados',
        'icon': Icons.medical_services,
        'available': '28+'
      },
      {
        'name': 'Fisioterapia',
        'description': 'Reabilitação domiciliar',
        'icon': Icons.accessibility_new,
        'available': '15+'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Serviços Disponíveis',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                  height: 1.3,
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ver todos os serviços será implementado em breve'),
                      backgroundColor: Color(0xFF4D64C8),
                    ),
                  );
                },
                child: const Text(
                  'Ver todos',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4D64C8),
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              return _buildModernServiceCard(
                services[index]['name'] as String,
                services[index]['description'] as String,
                services[index]['icon'] as IconData,
                services[index]['available'] as String,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModernServiceCard(String serviceName, String description, IconData icon, String available) {
    final List<Color> colorPalette = [
      const Color(0xFF4D64C8), // Azul principal
      const Color(0xFF10B981), // Verde
      const Color(0xFF8B5CF6), // Roxo
      const Color(0xFFEF4444), // Vermelho
    ];
    
    Color serviceColor = colorPalette[serviceName.hashCode % colorPalette.length];

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Buscando $serviceName...'),
            backgroundColor: serviceColor,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: serviceColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: serviceColor,
                    size: 20,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    available,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              serviceName,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6B7280),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildPublishAdButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4D64C8), Color(0xFF8B5CF6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4D64C8).withValues(alpha: 0.3),
              offset: const Offset(0, 8),
              blurRadius: 24,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.campaign,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Precisa de um cuidador?',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Publique sua necessidade e receba propostas',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidade de publicar anúncio em desenvolvimento'),
                    backgroundColor: Color(0xFF4D64C8),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: Color(0xFF4D64C8),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Publicar Anúncio',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4D64C8),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
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
          _buildNavItem(Icons.home, 'Início', 0, isSelected: true),
          _buildNavItem(Icons.chat_bubble_outline, 'Chat', 1),
          _buildNavItem(Icons.assignment, 'Contratos', 2),
          _buildNavItem(Icons.calendar_today, 'Agenda', 3),
          _buildNavItem(Icons.account_circle_outlined, 'Perfil', 4),
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
        // Já estamos na tela inicial
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Você já está na tela inicial'),
            duration: Duration(seconds: 1),
          ),
        );
        break;
      case 1:
        // Navegar para Chat de Paciente
        Navigator.pushNamed(context, '/patient-chat');
        break;
      case 2:
        // Navegar para Contratos
        Navigator.pushNamed(context, '/contracts');
        break;
      case 3:
        // Navegar para Agenda do Paciente
        Navigator.pushNamed(context, '/patient-schedule');
        break;
      case 4:
        // Navegar para Perfil
        Navigator.pushNamed(context, UserService.getAccountRoute());
        break;
    }
  }
}

// Custom painter para o ícone de filtros
class FilterIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Desenhar as linhas do filtro
    canvas.drawLine(const Offset(3, 10.5), const Offset(3, 15.75), paint);
    canvas.drawLine(const Offset(3, 2.25), const Offset(3, 7.5), paint);
    canvas.drawLine(const Offset(9, 9), const Offset(9, 15.75), paint);
    canvas.drawLine(const Offset(9, 2.25), const Offset(9, 6), paint);
    canvas.drawLine(const Offset(15, 12), const Offset(15, 15.75), paint);
    canvas.drawLine(const Offset(15, 2.25), const Offset(15, 9), paint);
    
    // Desenhar as linhas horizontais
    canvas.drawLine(const Offset(0.75, 10.5), const Offset(5.25, 10.5), paint);
    canvas.drawLine(const Offset(6.75, 6), const Offset(11.25, 6), paint);
    canvas.drawLine(const Offset(12.75, 12), const Offset(17.25, 12), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter para o ícone de plus
class PlusIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.43
      ..style = PaintingStyle.stroke;

    // Desenhar o plus
    canvas.drawLine(const Offset(5, 0), const Offset(5, 10), paint);
    canvas.drawLine(const Offset(0, 5), const Offset(10, 5), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
