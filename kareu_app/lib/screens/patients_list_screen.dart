import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';

class PatientsListScreen extends StatefulWidget {
  const PatientsListScreen({super.key});

  @override
  State<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> {
  List<Map<String, dynamic>> patients = [];

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  void _loadPatients() {
    // Dados simulados de pacientes
    patients = [
      {
        'id': 'patient_001',
        'name': 'Maria Silva',
        'age': 78,
        'gender': 'Feminino',
        'photo': null,
        'condition': 'Hipertensão, Diabetes',
        'family': 'Ana Silva (Filha)',
        'lastContact': '2 dias atrás',
        'status': 'active', // active, pending, completed
        'address': 'Vila Madalena, SP',
        'priority': 'high', // high, medium, low
      },
      {
        'id': 'patient_002',
        'name': 'João Santos',
        'age': 82,
        'gender': 'Masculino',
        'photo': null,
        'condition': 'Alzheimer inicial',
        'family': 'Carlos Santos (Filho)',
        'lastContact': '1 semana atrás',
        'status': 'pending',
        'address': 'Ipanema, RJ',
        'priority': 'medium',
      },
      {
        'id': 'patient_003',
        'name': 'Rosa Oliveira',
        'age': 75,
        'gender': 'Feminino',
        'photo': null,
        'condition': 'Mobilidade reduzida',
        'family': 'Miguel Oliveira (Neto)',
        'lastContact': '3 dias atrás',
        'status': 'active',
        'address': 'Centro, BH',
        'priority': 'high',
      },
      {
        'id': 'patient_004',
        'name': 'Antônio Costa',
        'age': 79,
        'gender': 'Masculino',
        'photo': null,
        'condition': 'Cardiopatia',
        'family': 'Luiza Costa (Filha)',
        'lastContact': '5 dias atrás',
        'status': 'completed',
        'address': 'Boa Viagem, PE',
        'priority': 'low',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      appBar: AppDesignSystem.styledAppBar(
        title: 'Meus Pacientes',
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: _showSearchFilter,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          // Estatísticas rápidas
          _buildQuickStats(),
          
          // Lista de pacientes
          Expanded(
            child: _buildPatientsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final activePatients = patients.where((p) => p['status'] == 'active').length;
    final pendingPatients = patients.where((p) => p['status'] == 'pending').length;
    final highPriorityPatients = patients.where((p) => p['priority'] == 'high').length;

    return Container(
      margin: const EdgeInsets.all(AppDesignSystem.spaceLG),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Ativos',
              activePatients.toString(),
              AppDesignSystem.successColor,
              Icons.favorite,
            ),
          ),
          const SizedBox(width: AppDesignSystem.spaceMD),
          Expanded(
            child: _buildStatCard(
              'Pendentes',
              pendingPatients.toString(),
              AppDesignSystem.warningColor,
              Icons.schedule,
            ),
          ),
          const SizedBox(width: AppDesignSystem.spaceMD),
          Expanded(
            child: _buildStatCard(
              'Prioridade',
              highPriorityPatients.toString(),
              AppDesignSystem.errorColor,
              Icons.priority_high,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppDesignSystem.spaceMD),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
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
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: AppDesignSystem.spaceXS),
              Text(
                value,
                style: AppDesignSystem.h2Style.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: AppDesignSystem.spaceXS),
          Text(
            title,
            style: AppDesignSystem.captionStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildPatientsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceLG),
      itemCount: patients.length,
      itemBuilder: (context, index) {
        final patient = patients[index];
        return _buildPatientCard(patient);
      },
    );
  }

  Widget _buildPatientCard(Map<String, dynamic> patient) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (patient['status']) {
      case 'active':
        statusColor = AppDesignSystem.successColor;
        statusText = 'Ativo';
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        statusColor = AppDesignSystem.warningColor;
        statusText = 'Pendente';
        statusIcon = Icons.schedule;
        break;
      case 'completed':
        statusColor = AppDesignSystem.textSecondaryColor;
        statusText = 'Concluído';
        statusIcon = Icons.done_all;
        break;
      default:
        statusColor = AppDesignSystem.textSecondaryColor;
        statusText = 'Desconhecido';
        statusIcon = Icons.help;
    }

    Color priorityColor;
    switch (patient['priority']) {
      case 'high':
        priorityColor = AppDesignSystem.errorColor;
        break;
      case 'medium':
        priorityColor = AppDesignSystem.warningColor;
        break;
      case 'low':
        priorityColor = AppDesignSystem.successColor;
        break;
      default:
        priorityColor = AppDesignSystem.textSecondaryColor;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppDesignSystem.spaceMD),
      child: GestureDetector(
        onTap: () => _viewPatientProfile(patient),
        child: AppDesignSystem.styledCard(
          child: Column(
            children: [
              Row(
                children: [
                  // Foto do paciente
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppDesignSystem.primaryColor.withValues(alpha: 0.1),
                        child: patient['photo'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.asset(
                                  patient['photo'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 30,
                                color: AppDesignSystem.primaryColor,
                              ),
                      ),
                      // Indicador de prioridade
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: priorityColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(width: AppDesignSystem.spaceMD),
                  
                  // Informações do paciente
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                patient['name'],
                                style: AppDesignSystem.cardTitleStyle,
                              ),
                            ),
                            // Status
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDesignSystem.spaceXS,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(statusIcon, size: 12, color: statusColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    statusText,
                                    style: AppDesignSystem.captionStyle.copyWith(
                                      color: statusColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 4),
                        
                        Text(
                          '${patient['age']} anos • ${patient['gender']}',
                          style: AppDesignSystem.bodySmallStyle,
                        ),
                        
                        const SizedBox(height: 4),
                        
                        Text(
                          patient['condition'],
                          style: AppDesignSystem.captionStyle.copyWith(
                            color: AppDesignSystem.errorColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const SizedBox(height: 4),
                        
                        Text(
                          'Família: ${patient['family']}',
                          style: AppDesignSystem.captionStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppDesignSystem.spaceSM),
              
              // Informações adicionais
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: AppDesignSystem.textSecondaryColor),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      patient['address'],
                      style: AppDesignSystem.captionStyle,
                    ),
                  ),
                  Text(
                    'Último contato: ${patient['lastContact']}',
                    style: AppDesignSystem.captionStyle,
                  ),
                ],
              ),
              
              const SizedBox(height: AppDesignSystem.spaceSM),
              
              // Botões de ação
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _startChat(patient),
                      icon: const Icon(Icons.chat_bubble_outline, size: 16),
                      label: const Text('Chat'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDesignSystem.spaceXS),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _viewPatientProfile(patient),
                      icon: const Icon(Icons.person, size: 16),
                      label: const Text('Ver Perfil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppDesignSystem.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _viewPatientProfile(Map<String, dynamic> patient) {
    Navigator.pushNamed(
      context,
      '/patient-profile',
      arguments: {
        'patientData': _convertToFullPatientData(patient),
        'isEditable': false, // Não editável para cuidadores
      },
    );
  }

  Map<String, dynamic> _convertToFullPatientData(Map<String, dynamic> simplePatient) {
    // Converter dados simples em dados completos para o perfil
    return {
      'id': simplePatient['id'],
      'name': simplePatient['name'],
      'age': simplePatient['age'],
      'gender': simplePatient['gender'],
      'photo': simplePatient['photo'],
      'description': 'Paciente sob cuidados. ${simplePatient['condition']}',
      'medicalConditions': simplePatient['condition'].split(', '),
      'medications': [
        {
          'name': 'Medicamento conforme prescrição médica',
          'frequency': 'Conforme orientação',
          'instructions': 'Seguir orientações da família'
        }
      ],
      'careNeeds': [
        'Acompanhamento medicação',
        'Apoio nas atividades diárias',
        'Monitoramento de sinais vitais'
      ],
      'characteristics': [
        'Cooperativo com cuidados',
        'Comunica-se bem',
        'Família presente e colaborativa'
      ],
      'preferences': [
        'Informações disponíveis com a família',
        'Respeitar rotina estabelecida'
      ],
      'address': simplePatient['address'],
      'familyMember': simplePatient['family'],
      'familyPhone': '(11) 99999-9999'
    };
  }

  void _startChat(Map<String, dynamic> patient) {
    Navigator.pushNamed(
      context,
      '/caregiver-chat',
      arguments: {
        'patientName': patient['name'],
        'patientId': patient['id'],
      },
    );
  }

  void _showSearchFilter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buscar Paciente'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Digite o nome do paciente...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Buscar'),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filtrar por:',
              style: AppDesignSystem.h3Style,
            ),
            const SizedBox(height: AppDesignSystem.spaceMD),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Pacientes Ativos'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Pacientes Pendentes'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.priority_high),
              title: const Text('Alta Prioridade'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Por Localização'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
