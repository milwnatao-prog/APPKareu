import 'package:flutter/material.dart';
import 'package:kareu_app/constants/app_design_system.dart';
import '../services/user_service.dart';

class ContractsScreen extends StatefulWidget {
  const ContractsScreen({super.key});

  @override
  State<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Tabs
            _buildTabs(),
            
            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildActiveContracts(),
                  _buildPendingContracts(),
                  _buildCompletedContracts(),
                ],
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meus Contratos',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Gerencie seus contratos de cuidado',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6B7280),
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
              Icons.filter_list,
              color: Color(0xFF6B7280),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF4D64C8),
        unselectedLabelColor: const Color(0xFF6B7280),
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        indicatorColor: const Color(0xFF4D64C8),
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'Ativos'),
          Tab(text: 'Pendentes'),
          Tab(text: 'Finalizados'),
        ],
      ),
    );
  }

  Widget _buildActiveContracts() {
    final activeContracts = [
      {
        'caregiverName': 'Maria Silva',
        'caregiverImage': 'assets/images/caregiver1.jpg',
        'patientName': 'João Santos',
        'startDate': '15/09/2024',
        'endDate': '15/12/2024',
        'status': 'Em andamento',
        'rating': 4.8,
        'price': 'R\$ 2.500/mês',
        'specialty': 'Cuidados com idosos',
        'nextVisit': 'Hoje, 14:00',
      },
      {
        'caregiverName': 'Ana Costa',
        'caregiverImage': 'assets/images/caregiver2.jpg',
        'patientName': 'Maria Oliveira',
        'startDate': '01/10/2024',
        'endDate': '01/01/2025',
        'status': 'Em andamento',
        'rating': 4.9,
        'price': 'R\$ 3.200/mês',
        'specialty': 'Enfermagem',
        'nextVisit': 'Amanhã, 09:00',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: activeContracts.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: index == activeContracts.length - 1 ? 0 : 16),
          child: _buildContractCard(activeContracts[index], true),
        );
      },
    );
  }

  Widget _buildPendingContracts() {
    final pendingContracts = [
      {
        'caregiverName': 'Carlos Mendes',
        'caregiverImage': 'assets/images/caregiver3.jpg',
        'patientName': 'Pedro Silva',
        'startDate': '20/11/2024',
        'endDate': '20/02/2025',
        'status': 'Aguardando confirmação',
        'rating': 4.7,
        'price': 'R\$ 2.800/mês',
        'specialty': 'Fisioterapia',
        'nextVisit': 'A definir',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: pendingContracts.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: index == pendingContracts.length - 1 ? 0 : 16),
          child: _buildContractCard(pendingContracts[index], false),
        );
      },
    );
  }

  Widget _buildCompletedContracts() {
    final completedContracts = [
      {
        'caregiverName': 'Lucia Fernandes',
        'caregiverImage': 'assets/images/caregiver4.jpg',
        'patientName': 'Rosa Santos',
        'startDate': '01/06/2024',
        'endDate': '31/08/2024',
        'status': 'Finalizado',
        'rating': 4.9,
        'price': 'R\$ 2.200/mês',
        'specialty': 'Acompanhante',
        'nextVisit': 'Concluído',
      },
      {
        'caregiverName': 'Roberto Lima',
        'caregiverImage': 'assets/images/caregiver5.jpg',
        'patientName': 'José Costa',
        'startDate': '15/03/2024',
        'endDate': '15/05/2024',
        'status': 'Finalizado',
        'rating': 4.6,
        'price': 'R\$ 2.900/mês',
        'specialty': 'Técnico em enfermagem',
        'nextVisit': 'Concluído',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: completedContracts.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: index == completedContracts.length - 1 ? 0 : 16),
          child: _buildContractCard(completedContracts[index], false),
        );
      },
    );
  }

  Widget _buildContractCard(Map<String, dynamic> contract, bool isActive) {
    Color statusColor;
    Color statusBgColor;
    
    switch (contract['status']) {
      case 'Em andamento':
        statusColor = const Color(0xFF10B981);
        statusBgColor = const Color(0xFF10B981).withValues(alpha: 0.1);
        break;
      case 'Aguardando confirmação':
        statusColor = const Color(0xFFF59E0B);
        statusBgColor = const Color(0xFFF59E0B).withValues(alpha: 0.1);
        break;
      case 'Finalizado':
        statusColor = const Color(0xFF6B7280);
        statusBgColor = const Color(0xFF6B7280).withValues(alpha: 0.1);
        break;
      default:
        statusColor = const Color(0xFF6B7280);
        statusBgColor = const Color(0xFF6B7280).withValues(alpha: 0.1);
    }

    return Container(
      padding: const EdgeInsets.all(20),
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
          // Header do card
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF4D64C8).withValues(alpha: 0.1),
                child: Text(
                  contract['caregiverName']![0],
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
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
                      contract['caregiverName']!,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      contract['specialty']!,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B7280),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  contract['status']!,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Informações do contrato
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildInfoRow('Paciente:', contract['patientName']!),
                const SizedBox(height: 8),
                _buildInfoRow('Período:', '${contract['startDate']} - ${contract['endDate']}'),
                const SizedBox(height: 8),
                _buildInfoRow('Valor:', contract['price']!),
                const SizedBox(height: 8),
                _buildInfoRow('Próxima visita:', contract['nextVisit']!),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Rating e ações
          Row(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Color(0xFFFBBF24),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    contract['rating'].toString(),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (isActive) ...[
                _buildActionButton(
                  'Chat',
                  Icons.chat_bubble_outline,
                  const Color(0xFF4D64C8),
                  () => _openChat(contract['caregiverName']!),
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  'Detalhes',
                  Icons.info_outline,
                  const Color(0xFF10B981),
                  () => _viewDetails(contract),
                ),
              ] else ...[
                _buildActionButton(
                  'Ver Detalhes',
                  Icons.visibility_outlined,
                  const Color(0xFF6B7280),
                  () => _viewDetails(contract),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openChat(String caregiverName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abrindo chat com $caregiverName...'),
        backgroundColor: const Color(0xFF4D64C8),
      ),
    );
  }

  void _viewDetails(Map<String, dynamic> contract) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildContractDetailsModal(contract),
    );
  }

  Widget _buildContractDetailsModal(Map<String, dynamic> contract) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Detalhes do Contrato',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFF6B7280),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informações do cuidador
                  _buildDetailSection(
                    'Cuidador',
                    [
                      _buildDetailItem('Nome', contract['caregiverName']!),
                      _buildDetailItem('Especialidade', contract['specialty']!),
                      _buildDetailItem('Avaliação', '${contract['rating']} ⭐'),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Informações do contrato
                  _buildDetailSection(
                    'Contrato',
                    [
                      _buildDetailItem('Paciente', contract['patientName']!),
                      _buildDetailItem('Data de início', contract['startDate']!),
                      _buildDetailItem('Data de término', contract['endDate']!),
                      _buildDetailItem('Valor mensal', contract['price']!),
                      _buildDetailItem('Status', contract['status']!),
                      _buildDetailItem('Próxima visita', contract['nextVisit']!),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ],
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
          _buildNavItem(Icons.home, 'Início', 0),
          _buildNavItem(Icons.chat_bubble_outline, 'Chat', 1),
          _buildNavItem(Icons.assignment, 'Contratos', 2, isSelected: true),
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
        // Navegar para Home
        Navigator.pushReplacementNamed(context, '/home-patient');
        break;
      case 1:
        // Navegar para Chat
        Navigator.pushNamed(context, '/patient-chat');
        break;
      case 2:
        // Já estamos na tela de contratos
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Você já está na tela de contratos'),
            duration: Duration(seconds: 1),
          ),
        );
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
}
