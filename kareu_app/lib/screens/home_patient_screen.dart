import 'package:flutter/material.dart';
import 'package:kareu_app/constants/app_design_system.dart';

class HomePatientScreen extends StatefulWidget {
  const HomePatientScreen({super.key});

  @override
  State<HomePatientScreen> createState() => _HomePatientScreenState();
}

class _HomePatientScreenState extends State<HomePatientScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    
                    // Search Bar
                    _buildSearchBar(),
                    
                    const SizedBox(height: 24),
                    
                    // Filters
                    _buildFilters(),
                    
                    const SizedBox(height: 16),
                    
                    // Cities Section
                    _buildCitiesSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Services Section
                    _buildServicesSection(),
                    
                    const SizedBox(height: 24),
                    
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/search');
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE1E5E9),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                child: const Icon(
                  Icons.search,
                  size: 20,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Encontre cuidadores em sua região',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/filters');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFE1E5E9),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                offset: const Offset(0, 1),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CustomPaint(
                  painter: FilterIconPainter(),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'FILTROS',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                  height: 1.5,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCitiesSection() {
    final cities = [
      {'name': 'Natal', 'image': 'assets/images/natal.jpg'},
      {'name': 'João Pessoa', 'image': 'assets/images/joao_pessoa.jpg'},
      {'name': 'São Paulo', 'image': 'assets/images/sao_paulo.jpg'},
      {'name': 'Curitiba', 'image': 'assets/images/curitiba.jpg'},
      {'name': 'Recife', 'image': 'assets/images/recife.jpg'},
      {'name': 'Fortaleza', 'image': 'assets/images/fortaleza.jpg'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Cidades',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: cities.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: index == cities.length - 1 ? 0 : 16),
                child: _buildCityCard(cities[index]['name']!, cities[index]['image']!),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCityCard(String cityName, String imagePath) {
    // Paleta de cores personalizada: #4D64C8, #FFAD00, #8FB2FF, #8A63D2, #FFFFFF
    final List<Color> colorPalette = [
      const Color(0xFF4D64C8), // Azul principal
      const Color(0xFFFFAD00), // Amarelo/laranja
      const Color(0xFF8FB2FF), // Azul claro
      const Color(0xFF8A63D2), // Roxo/violeta
    ];
    
    Color cityColor;
    switch (cityName) {
      case 'Natal':
        cityColor = colorPalette[0]; // #4D64C8
        break;
      case 'João Pessoa':
        cityColor = colorPalette[1]; // #FFAD00
        break;
      case 'São Paulo':
        cityColor = colorPalette[2]; // #8FB2FF
        break;
      case 'Curitiba':
        cityColor = colorPalette[3]; // #8A63D2
        break;
      case 'Recife':
        cityColor = colorPalette[0]; // #4D64C8
        break;
      case 'Fortaleza':
        cityColor = colorPalette[1]; // #FFAD00
        break;
      default:
        cityColor = colorPalette[0]; // #4D64C8 como padrão
    }

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Buscando cuidadores em $cityName...'),
            backgroundColor: cityColor,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 160,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: cityColor,
          boxShadow: [
            BoxShadow(
              color: cityColor.withValues(alpha: 0.3),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
            // City name
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  cityName,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 8,
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Decorative icon
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.location_city,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesSection() {
    final services = [
      {'name': 'Cuidadores', 'image': 'assets/images/cuidadores.jpg', 'icon': Icons.favorite},
      {'name': 'Acompanhantes hospitalar', 'image': 'assets/images/acompanhantes_hospitalar.jpg', 'icon': Icons.local_hospital},
      {'name': 'Técnicos de enfermagem', 'image': 'assets/images/tecnicos_enfermagem.jpg', 'icon': Icons.medical_services},
      {'name': 'Acompanhante domiciliar', 'image': 'assets/images/acompanhante_domiciliar.jpg', 'icon': Icons.home},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Do que você precisa?',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              return _buildServiceCard(
                services[index]['name'] as String,
                services[index]['image'] as String,
                services[index]['icon'] as IconData,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(String serviceName, String imagePath, IconData icon) {
    // Paleta de cores personalizada: #4D64C8, #FFAD00, #8FB2FF, #8A63D2, #FFFFFF
    final List<Color> colorPalette = [
      const Color(0xFF4D64C8), // Azul principal
      const Color(0xFFFFAD00), // Amarelo/laranja
      const Color(0xFF8FB2FF), // Azul claro
      const Color(0xFF8A63D2), // Roxo/violeta
    ];
    
    Color serviceColor;
    switch (serviceName) {
      case 'Cuidadores':
        serviceColor = colorPalette[0]; // #4D64C8
        break;
      case 'Acompanhantes hospitalar':
        serviceColor = colorPalette[1]; // #FFAD00
        break;
      case 'Técnicos de enfermagem':
        serviceColor = colorPalette[2]; // #8FB2FF
        break;
      case 'Acompanhante domiciliar':
        serviceColor = colorPalette[3]; // #8A63D2
        break;
      default:
        serviceColor = colorPalette[0]; // #4D64C8 como padrão
    }

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Buscando $serviceName...'),
            backgroundColor: serviceColor,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: serviceColor,
          boxShadow: [
            BoxShadow(
              color: serviceColor.withValues(alpha: 0.3),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
            // Icon
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            // Service name
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Text(
                serviceName,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.2,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 8,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Funcionalidade de publicar anúncio em desenvolvimento'),
              backgroundColor: Color(0xFF353B7E),
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF353B7E), Color(0xFF4D64C8)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF353B7E).withValues(alpha: 0.3),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Publicar um anúncio',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 72,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.search, 'Buscar', 0),
          _buildNavItem(Icons.chat_bubble_outline, 'Chat', 1),
          _buildNavItem(Icons.favorite_border, 'Favoritos', 2),
          _buildNavItem(Icons.account_circle_outlined, 'Perfil', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppDesignSystem.primaryColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppDesignSystem.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFF6B7280),
                size: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppDesignSystem.primaryColor : const Color(0xFF6B7280),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });

    String section = '';
    switch (index) {
      case 0:
        section = 'Busca';
        break;
      case 1:
        section = 'Chat';
        Navigator.pushNamed(context, '/patient-chat');
        break;
      case 2:
        section = 'Favoritos';
        break;
      case 3:
        section = 'Perfil';
        Navigator.pushNamed(context, '/patient-profile');
        break;
    }

    if (section.isNotEmpty && index != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navegando para $section'),
          duration: const Duration(seconds: 1),
          backgroundColor: AppDesignSystem.primaryColor,
        ),
      );
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
