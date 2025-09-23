import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';
import '../services/session_service.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  Map<String, dynamic>? patientData;
  bool isEditable = true; // Por padrão é editável (versão familiar/paciente)

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Receber dados do paciente via argumentos da rota ou usar dados padrão
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (args != null) {
      patientData = args['patientData'] ?? _getDefaultPatientData();
      isEditable = args['isEditable'] ?? true; // Se não especificado, é editável
    } else {
      patientData = _getDefaultPatientData();
      isEditable = true; // Modo padrão é editável
    }
  }

  Map<String, dynamic> _getDefaultPatientData() {
    return {
      'id': 'patient_001',
      'name': 'Maria Silva',
      'age': 78,
      'gender': 'Feminino',
      'photo': null,
      'description': 'Senhora Maria é uma pessoa muito carinhosa e independente. Gosta de conversar sobre suas memórias e tem um grande amor por plantas. Precisa de acompanhamento para medicamentos e atividades diárias.',
      'medicalConditions': [
        'Hipertensão arterial',
        'Diabetes tipo 2',
        'Artrite nas mãos',
        'Dificuldade de mobilidade'
      ],
      'medications': [
        {
          'name': 'Losartana 50mg',
          'frequency': '1x ao dia (manhã)',
          'instructions': 'Tomar com água, antes do café'
        },
        {
          'name': 'Metformina 850mg',
          'frequency': '2x ao dia',
          'instructions': 'Após as refeições principais'
        },
        {
          'name': 'Cálcio + Vitamina D',
          'frequency': '1x ao dia',
          'instructions': 'Preferencialmente à noite'
        }
      ],
      'careNeeds': [
        'Administração de medicamentos',
        'Acompanhamento às consultas médicas',
        'Auxílio na higiene pessoal',
        'Preparo de refeições',
        'Companhia e conversação',
        'Exercícios leves e fisioterapia'
      ],
      'characteristics': [
        'Comunicativa e sociável',
        'Gosta de música clássica',
        'Adora plantas e jardinagem',
        'Prefere rotinas organizadas',
        'Tem boa memória para histórias antigas',
        'Dorme bem à noite'
      ],
      'preferences': [
        'Horário das refeições: 8h, 12h, 18h',
        'Gosta de assistir novelas à tarde',
        'Prefere banho pela manhã',
        'Não gosta de lugares muito barulhentos',
        'Adora receber visitas da família'
      ],
      'address': 'Rua das Flores, 123 - Vila Madalena, São Paulo - SP',
      'familyMember': 'Ana Silva',
      'familyPhone': '(11) 99999-1234'
    };
  }

  @override
  Widget build(BuildContext context) {
    if (patientData == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      appBar: AppDesignSystem.styledAppBar(
        title: 'Perfil do Paciente',
        context: context,
        actions: isEditable ? [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: _goToSettings,
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: _editProfile,
          ),
        ] : [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com foto e informações básicas
            _buildProfileHeader(),
            
            const SizedBox(height: AppDesignSystem.space2XL),
            
            // Descrição
            _buildDescriptionSection(),
            
            const SizedBox(height: AppDesignSystem.space2XL),
            
            // Condições médicas
            _buildMedicalConditionsSection(),
            
            const SizedBox(height: AppDesignSystem.space2XL),
            
            // Medicamentos
            _buildMedicationsSection(),
            
            const SizedBox(height: AppDesignSystem.space2XL),
            
            // Cuidados necessários
            _buildCareNeedsSection(),
            
            const SizedBox(height: AppDesignSystem.space2XL),
            
            // Características pessoais
            _buildCharacteristicsSection(),
            
            const SizedBox(height: AppDesignSystem.space2XL),
            
            // Preferências
            _buildPreferencesSection(),
            
            const SizedBox(height: AppDesignSystem.space2XL),
            
            // Botões de ação
            _buildActionButtons(),
            
            const SizedBox(height: AppDesignSystem.space4XL),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return AppDesignSystem.styledCard(
      child: Column(
        children: [
          // Foto do perfil
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppDesignSystem.primaryColor.withValues(alpha: 0.1),
                  child: patientData!['photo'] != null
                    ? ClipOval(
                        child: Image.asset(
                          patientData!['photo'],
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 60,
                        color: AppDesignSystem.primaryColor,
                      ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppDesignSystem.primaryColor,
                      borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      onPressed: _changeProfilePhoto,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppDesignSystem.spaceLG),
          
          // Nome e informações básicas
          Text(
            patientData!['name'],
            style: AppDesignSystem.h1Style,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppDesignSystem.spaceXS),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoChip(
                icon: Icons.cake,
                label: '${patientData!['age']} anos',
              ),
              const SizedBox(width: AppDesignSystem.spaceSM),
              _buildInfoChip(
                icon: patientData!['gender'] == 'Feminino' ? Icons.female : Icons.male,
                label: patientData!['gender'],
              ),
            ],
          ),
          
          const SizedBox(height: AppDesignSystem.spaceLG),
          
          // Endereço
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppDesignSystem.textSecondaryColor,
                size: 16,
              ),
              const SizedBox(width: AppDesignSystem.spaceXS),
              Expanded(
                child: Text(
                  patientData!['address'],
                  style: AppDesignSystem.bodySmallStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignSystem.spaceSM,
        vertical: AppDesignSystem.spaceXS,
      ),
      decoration: BoxDecoration(
        color: AppDesignSystem.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppDesignSystem.primaryColor,
          ),
          const SizedBox(width: AppDesignSystem.spaceXS),
          Text(
            label,
            style: AppDesignSystem.captionStyle.copyWith(
              color: AppDesignSystem.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return _buildSection(
      title: 'Sobre o Paciente',
      icon: Icons.person_outline,
      child: Text(
        patientData!['description'],
        style: AppDesignSystem.bodyStyle,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildMedicalConditionsSection() {
    return _buildSection(
      title: 'Condições Médicas',
      icon: Icons.medical_services_outlined,
      child: Column(
        children: (patientData!['medicalConditions'] as List<String>)
            .map((condition) => _buildListItem(condition, Icons.health_and_safety))
            .toList(),
      ),
    );
  }

  Widget _buildMedicationsSection() {
    return _buildSection(
      title: 'Medicamentos',
      icon: Icons.medication_outlined,
      child: Column(
        children: (patientData!['medications'] as List<Map<String, dynamic>>)
            .map((medication) => _buildMedicationItem(medication))
            .toList(),
      ),
    );
  }

  Widget _buildMedicationItem(Map<String, dynamic> medication) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDesignSystem.spaceSM),
      padding: const EdgeInsets.all(AppDesignSystem.spaceMD),
      decoration: BoxDecoration(
        color: AppDesignSystem.successColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
        border: Border.all(
          color: AppDesignSystem.successColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.medication,
                color: AppDesignSystem.successColor,
                size: 20,
              ),
              const SizedBox(width: AppDesignSystem.spaceXS),
              Expanded(
                child: Text(
                  medication['name'],
                  style: AppDesignSystem.cardTitleStyle.copyWith(
                    color: AppDesignSystem.successColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesignSystem.spaceXS),
          Text(
            'Frequência: ${medication['frequency']}',
            style: AppDesignSystem.bodySmallStyle,
          ),
          const SizedBox(height: AppDesignSystem.spaceXS),
          Text(
            medication['instructions'],
            style: AppDesignSystem.captionStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildCareNeedsSection() {
    return _buildSection(
      title: 'Cuidados Necessários',
      icon: Icons.favorite_outline,
      child: Column(
        children: (patientData!['careNeeds'] as List<String>)
            .map((need) => _buildListItem(need, Icons.check_circle_outline))
            .toList(),
      ),
    );
  }

  Widget _buildCharacteristicsSection() {
    return _buildSection(
      title: 'Características Pessoais',
      icon: Icons.psychology_outlined,
      child: Column(
        children: (patientData!['characteristics'] as List<String>)
            .map((characteristic) => _buildListItem(characteristic, Icons.star_outline))
            .toList(),
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return _buildSection(
      title: 'Preferências e Rotina',
      icon: Icons.schedule_outlined,
      child: Column(
        children: (patientData!['preferences'] as List<String>)
            .map((preference) => _buildListItem(preference, Icons.thumb_up_outlined))
            .toList(),
      ),
    );
  }


  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppDesignSystem.primaryColor,
                size: 24,
              ),
              const SizedBox(width: AppDesignSystem.spaceSM),
              Text(
                title,
                style: AppDesignSystem.sectionTitleStyle,
              ),
            ],
          ),
          const SizedBox(height: AppDesignSystem.spaceLG),
          child,
        ],
      ),
    );
  }

  Widget _buildListItem(String text, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDesignSystem.spaceXS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppDesignSystem.primaryColor,
            size: 16,
          ),
          const SizedBox(width: AppDesignSystem.spaceSM),
          Expanded(
            child: Text(
              text,
              style: AppDesignSystem.bodyStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    // Para versão familiar/paciente: mostrar botão de sair da conta
    if (isEditable) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _logout,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppDesignSystem.errorColor),
                padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.spaceMD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: AppDesignSystem.errorColor),
                  const SizedBox(width: AppDesignSystem.spaceXS),
                  Text(
                    'Sair da Conta',
                    style: AppDesignSystem.buttonStyle.copyWith(
                      color: AppDesignSystem.errorColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
    
    return Column(
      children: [
        // Botão principal - Iniciar cuidados
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _startCare,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppDesignSystem.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.spaceLG),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_arrow, color: Colors.white),
                const SizedBox(width: AppDesignSystem.spaceXS),
                Text(
                  'Iniciar Cuidados',
                  style: AppDesignSystem.buttonStyle,
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: AppDesignSystem.spaceMD),
        
        // Botões secundários
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _contactFamily,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppDesignSystem.primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.spaceMD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.family_restroom, color: AppDesignSystem.primaryColor),
                    const SizedBox(width: AppDesignSystem.spaceXS),
                    Text(
                      'Contatar Família',
                      style: AppDesignSystem.buttonSmallStyle.copyWith(
                        color: AppDesignSystem.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(width: AppDesignSystem.spaceMD),
            
            Expanded(
              child: OutlinedButton(
                onPressed: _viewMedicalHistory,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppDesignSystem.primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.spaceMD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, color: AppDesignSystem.primaryColor),
                    const SizedBox(width: AppDesignSystem.spaceXS),
                    Text(
                      'Histórico',
                      style: AppDesignSystem.buttonSmallStyle.copyWith(
                        color: AppDesignSystem.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _editProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Função de edição será implementada em breve'),
        backgroundColor: AppDesignSystem.primaryColor,
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sair da Conta'),
          content: const Text('Tem certeza que deseja sair da sua conta?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Fazer logout
                SessionService.instance.logout();
                
                // Fechar o dialog
                Navigator.of(context).pop();
                
                // Navegar para tela de login e remover todas as rotas anteriores
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppDesignSystem.errorColor,
              ),
              child: const Text(
                'Sair',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _changeProfilePhoto() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppDesignSystem.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDesignSystem.borderRadius),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Alterar foto do perfil',
              style: AppDesignSystem.h2Style,
            ),
            const SizedBox(height: AppDesignSystem.spaceLG),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPhotoOption(Icons.camera_alt, 'Câmera', () {}),
                _buildPhotoOption(Icons.photo_library, 'Galeria', () {}),
                _buildPhotoOption(Icons.delete, 'Remover', () {}),
              ],
            ),
            const SizedBox(height: AppDesignSystem.spaceLG),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppDesignSystem.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
            ),
            child: Icon(
              icon,
              color: AppDesignSystem.primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(height: AppDesignSystem.spaceXS),
          Text(
            label,
            style: AppDesignSystem.captionStyle,
          ),
        ],
      ),
    );
  }

  void _startCare() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppDesignSystem.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
        ),
        title: Text(
          'Iniciar Cuidados',
          style: AppDesignSystem.h2Style,
        ),
        content: Text(
          'Deseja iniciar o acompanhamento de ${patientData!['name']}?',
          style: AppDesignSystem.bodyStyle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: AppDesignSystem.linkStyle,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cuidados iniciados com sucesso!'),
                  backgroundColor: AppDesignSystem.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppDesignSystem.primaryColor,
            ),
            child: Text(
              'Confirmar',
              style: AppDesignSystem.buttonStyle,
            ),
          ),
        ],
      ),
    );
  }

  void _contactFamily() {
    _callContact(patientData!['familyPhone']);
  }

  void _callContact(String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ligando para $phone...'),
        backgroundColor: AppDesignSystem.primaryColor,
      ),
    );
  }

  void _viewMedicalHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Histórico médico será implementado em breve'),
        backgroundColor: AppDesignSystem.primaryColor,
      ),
    );
  }

  void _goToSettings() {
    Navigator.pushNamed(context, '/account-settings');
  }
}
