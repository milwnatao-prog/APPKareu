import 'package:flutter/material.dart';

class EngagementPlansScreen extends StatefulWidget {
  const EngagementPlansScreen({super.key});

  @override
  State<EngagementPlansScreen> createState() => _EngagementPlansScreenState();
}

class _EngagementPlansScreenState extends State<EngagementPlansScreen> {
  int _selectedTabIndex = 0;
  String? _selectedPlan;

  final List<Map<String, dynamic>> _plans = [
    {
      'title': 'Plano Básico',
      'price': 'R\$ 19',
      'description': 'Destaque na região por 7 dias',
      'id': 'basic'
    },
    {
      'title': 'Plano Plus',
      'price': 'R\$ 49',
      'description': 'Destaque + recomendado por 30 dias',
      'id': 'plus'
    },
    {
      'title': 'Plano Pro',
      'price': 'R\$ 79',
      'description': 'Destaque na região por 7 dias',
      'id': 'pro'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Status Bar Space
            const SizedBox(height: 8),
            
            // Header
            _buildHeader(),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    
                    // Title
                    _buildTitle(),
                    
                    const SizedBox(height: 8),
                    
                    // Yellow Banner
                    _buildYellowBanner(),
                    
                    const SizedBox(height: 12),
                    
                    // Statistics Section
                    _buildStatisticsSection(),
                    
                    const SizedBox(height: 16),
                    
                    // Destaque Kareu Badge
                    _buildDestaqueKareuBadge(),
                    
                    const SizedBox(height: 12),
                    
                    // Plans Section
                    _buildPlansSection(),
                    
                    const SizedBox(height: 16),
                    
                    // Highlight Button
                    _buildHighlightButton(),
                    
                    const SizedBox(height: 16),
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
      width: double.infinity,
      height: 117,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            const Text(
              'Kareu',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4D64C8),
                height: 0.37,
                letterSpacing: -0.43,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 52),
      child: Text(
        'Seja visto por mais famílias',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color(0xFFFF8C1A),
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildYellowBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 28),
      width: 333,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF47E),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            offset: const Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '   Visualizações nesta semana',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('12', 'Visualizações', 0.7),
              _buildStatItem('80%', 'Aumento potencial', 1.0),
              _buildStatItem('30%', 'Aumento nas buscas', 0.7),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String number, String label, double opacity) {
    return Opacity(
      opacity: opacity,
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDestaqueKareuBadge() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF4D64C8),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            offset: const Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(
              Icons.star,
              color: Color(0xFFFFBB00),
              size: 24,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Destaque Kareu',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlansSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 29),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _plans.map((plan) => _buildPlanCard(plan)).toList(),
      ),
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    final bool isSelected = _selectedPlan == plan['id'];
    final bool isPlus = plan['id'] == 'plus';
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlan = plan['id'];
        });
      },
      child: Container(
        width: 107,
        height: 107,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
          border: isSelected 
              ? Border.all(color: const Color(0xFF4D64C8), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              offset: const Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  plan['title'],
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: isPlus ? 14 : 10,
                    fontWeight: isPlus ? FontWeight.w800 : FontWeight.w500,
                    color: Colors.black,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  plan['price'],
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: isPlus ? 14 : 12,
                    fontWeight: isPlus ? FontWeight.w800 : FontWeight.w600,
                    color: Colors.black,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  plan['description'],
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: isPlus ? 10 : 8,
                    fontWeight: isPlus ? FontWeight.w600 : FontWeight.w400,
                    color: Colors.black,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 71),
      width: 246,
      height: 39,
      child: ElevatedButton(
        onPressed: _selectedPlan != null ? _onHighlightPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFF47E),
          foregroundColor: const Color(0xFFFF8000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide.none,
          ),
          elevation: 0,
        ),
        child: const Text(
          'Destacar meu perfil agora',
          style: TextStyle(
            fontFamily: 'SF Pro',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            height: 1.19,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 73,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Início', 0),
          _buildNavItem(Icons.chat_bubble_outline, 'Chat', 1),
          _buildNavItem(Icons.people_outline, 'Clientes', 2),
          _buildNavItem(Icons.calendar_today, 'Agenda', 3),
          _buildNavItem(Icons.account_circle_outlined, 'Perfil', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF4D64C8) : const Color(0xFF49454F),
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: isSelected ? const Color(0xFF4D64C8) : const Color(0xFF49454F),
                height: 1.5,
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
        section = 'Início';
        Navigator.pushReplacementNamed(context, '/home-professional');
        break;
      case 1:
        section = 'Chat';
        Navigator.pushReplacementNamed(context, '/chat');
        break;
      case 2:
        section = 'Clientes';
        break;
      case 3:
        section = 'Agenda';
        break;
      case 4:
        section = 'Perfil';
        break;
    }
    
    if (section.isNotEmpty && index != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navegando para $section'),
          duration: const Duration(seconds: 1),
          backgroundColor: const Color(0xFF4D64C8),
        ),
      );
    }
  }

  void _onHighlightPressed() {
    if (_selectedPlan == null) return;
    
    final selectedPlanData = _plans.firstWhere((plan) => plan['id'] == _selectedPlan);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirmar Compra',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4D64C8),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Plano selecionado: ${selectedPlanData['title']}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Valor: ${selectedPlanData['price']}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF8000),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                selectedPlanData['description'],
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Deseja prosseguir com a compra?',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _processPurchase(selectedPlanData);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4D64C8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Confirmar',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _processPurchase(Map<String, dynamic> plan) {
    // Simular processamento de compra
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Compra do ${plan['title']} processada com sucesso!\nSeu perfil será destacado em breve.',
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xFF4CAF50),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
    
    // Reset selection
    setState(() {
      _selectedPlan = null;
    });
  }
}
