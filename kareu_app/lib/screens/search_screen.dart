import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../constants/app_design_system.dart';
import '../models/user_model.dart';
import '../services/reputation_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  // Variáveis para controle de localização e busca
  String _locationError = '';
  bool _isLoadingLocation = false;
  double _searchRadius = 10.0;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // Dados simulados de cuidadores com informações de assinatura
  final List<Map<String, dynamic>> _allCaregivers = [
    {
      'id': 'caregiver_001',
      'name': 'Maria Silva',
      'specialty': 'Cuidadora',
      'experience': '5 anos',
      'rating': 4.8,
      'price': 'R\$ 25/hora',
      'location': 'Natal, RN',
      'image': 'assets/images/caregiver1.jpg',
      'verified': true,
      'subscriptionTier': SubscriptionTier.premium, // Premium - aparece primeiro
      'reputationLevel': ReputationLevel.expert,
    },
    {
      'id': 'caregiver_002',
      'name': 'João Santos',
      'specialty': 'Técnico de Enfermagem',
      'experience': '8 anos',
      'rating': 4.9,
      'price': 'R\$ 35/hora',
      'location': 'João Pessoa, PB',
      'image': 'assets/images/caregiver2.jpg',
      'verified': true,
      'subscriptionTier': SubscriptionTier.plus, // Plus - segunda prioridade
      'reputationLevel': ReputationLevel.elite,
    },
    {
      'id': 'caregiver_003',
      'name': 'Ana Costa',
      'specialty': 'Acompanhante Hospitalar',
      'experience': '3 anos',
      'rating': 4.7,
      'price': 'R\$ 30/hora',
      'location': 'São Paulo, SP',
      'image': 'assets/images/caregiver3.jpg',
      'verified': false,
      'subscriptionTier': SubscriptionTier.free, // Gratuito - última prioridade
      'reputationLevel': ReputationLevel.developing,
    },
    {
      'id': 'caregiver_004',
      'name': 'Carlos Oliveira',
      'specialty': 'Acompanhante Domiciliar',
      'experience': '6 anos',
      'rating': 4.6,
      'price': 'R\$ 28/hora',
      'location': 'Curitiba, PR',
      'image': 'assets/images/caregiver4.jpg',
      'verified': true,
      'subscriptionTier': SubscriptionTier.basic, // Básico - terceira prioridade
      'reputationLevel': ReputationLevel.trusted,
    },
    {
      'id': 'caregiver_005',
      'name': 'Lucia Ferreira',
      'specialty': 'Cuidadora',
      'experience': '4 anos',
      'rating': 4.8,
      'price': 'R\$ 26/hora',
      'location': 'Recife, PE',
      'image': 'assets/images/caregiver5.jpg',
      'verified': true,
      'subscriptionTier': SubscriptionTier.plus, // Plus - segunda prioridade
      'reputationLevel': ReputationLevel.trusted,
    },
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _searchResults = _allCaregivers;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = true;
    });

    // Simular delay de busca
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        if (query.isEmpty) {
          _searchResults = _allCaregivers;
        } else {
          _searchResults = _allCaregivers.where((caregiver) {
            return caregiver['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
                   caregiver['specialty'].toString().toLowerCase().contains(query.toLowerCase()) ||
                   caregiver['location'].toString().toLowerCase().contains(query.toLowerCase());
          }).toList();
        }
        _isSearching = false;
      });
    });
  }

  Widget _buildLocationLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppDesignSystem.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Obtendo sua localização...',
            style: AppDesignSystem.bodyStyle.copyWith(
              color: AppDesignSystem.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationError() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppDesignSystem.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_off,
            color: AppDesignSystem.errorColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _locationError,
              style: AppDesignSystem.bodyStyle.copyWith(
                color: AppDesignSystem.errorColor,
              ),
            ),
          ),
          TextButton(
            onPressed: _retryLocationSearch,
            child: Text(
              'Tentar novamente',
              style: AppDesignSystem.linkStyle.copyWith(
                color: AppDesignSystem.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Raio de busca',
                  style: AppDesignSystem.captionStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${_searchRadius.toInt()} km',
                  style: AppDesignSystem.bodyStyle.copyWith(
                    color: AppDesignSystem.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Slider(
                  value: _searchRadius,
                  min: 1,
                  max: 50,
                  divisions: 49,
                  activeColor: AppDesignSystem.primaryColor,
                  onChanged: (value) => _updateSearchRadius(value),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Encontrados',
                style: AppDesignSystem.captionStyle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${_searchResults.length}',
                style: AppDesignSystem.h3Style.copyWith(
                  color: AppDesignSystem.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Ordena cuidadores por prioridade de assinatura e reputação
  List<Map<String, dynamic>> _sortCaregiversByPriority(List<Map<String, dynamic>> caregivers) {
    return caregivers..sort((a, b) {
      final aTier = a['subscriptionTier'] as SubscriptionTier;
      final bTier = b['subscriptionTier'] as SubscriptionTier;
      
      // Definir ordem de prioridade das assinaturas
      final priorityOrder = {
        SubscriptionTier.premium: 0,  // Primeira prioridade
        SubscriptionTier.plus: 1,     // Segunda prioridade
        SubscriptionTier.basic: 2,    // Terceira prioridade
        SubscriptionTier.free: 3,     // Última prioridade
      };
      
      final aPriority = priorityOrder[aTier]!;
      final bPriority = priorityOrder[bTier]!;
      
      // Se têm a mesma assinatura, ordenar por avaliação
      if (aPriority == bPriority) {
        final aRating = a['rating'] as double;
        final bRating = b['rating'] as double;
        return bRating.compareTo(aRating); // Maior avaliação primeiro
      }
      
      return aPriority.compareTo(bPriority);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      appBar: AppDesignSystem.styledAppBar(
        title: 'Buscar Cuidadores',
        context: context,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Barra de busca
          _buildSearchInput(),

          const SizedBox(height: 16),

          // Controles de distância e filtros
          if (_isLoadingLocation)
            _buildLocationLoadingIndicator()
          else if (_locationError.isNotEmpty)
            _buildLocationError()
          else
            _buildLocationControls(),

          const SizedBox(height: 16),

          // Resultados
          Expanded(
            child: _isSearching
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppDesignSystem.primaryColor,
                    ),
                  )
                : _searchResults.isEmpty
                    ? _buildEmptyState()
                    : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInput() {
    return Padding(
      padding: const EdgeInsets.all(AppDesignSystem.space2XL),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppDesignSystem.surfaceColor,
          borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
          border: Border.all(
            color: AppDesignSystem.borderColor,
            width: 1,
          ),
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          onChanged: _performSearch,
          decoration: InputDecoration(
            hintText: 'Digite o nome, especialidade ou cidade...',
            hintStyle: AppDesignSystem.placeholderStyle,
            prefixIcon: Icon(
              Icons.search,
              color: AppDesignSystem.textSecondaryColor,
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDesignSystem.spaceLG, 
              vertical: AppDesignSystem.spaceLG,
            ),
          ),
          style: AppDesignSystem.bodySmallStyle,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppDesignSystem.textTertiaryColor,
          ),
          AppDesignSystem.verticalSpace(1),
          Text(
            'Nenhum cuidador encontrado',
            style: AppDesignSystem.h3Style.copyWith(
              color: AppDesignSystem.textSecondaryColor,
            ),
          ),
          AppDesignSystem.verticalSpace(0.5),
          Text(
            'Tente buscar por outro termo',
            style: AppDesignSystem.bodySmallStyle.copyWith(
              color: AppDesignSystem.textTertiaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.space2XL),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return _buildCaregiverCard(_searchResults[index]);
      },
    );
  }

  Widget _buildCaregiverCard(Map<String, dynamic> caregiver) {
    return GestureDetector(
      onTap: () => _navigateToCaregiverProfile(caregiver),
      child: AppDesignSystem.styledCard(
        margin: const EdgeInsets.only(bottom: AppDesignSystem.spaceLG),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppDesignSystem.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
              ),
              child: const Icon(
                Icons.person,
                color: AppDesignSystem.primaryColor,
                size: 30,
              ),
            ),
            
            const SizedBox(width: AppDesignSystem.spaceLG),
            
            // Informações
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          caregiver['name'],
                          style: AppDesignSystem.cardTitleStyle,
                        ),
                      ),
                      // Badges de assinatura e verificação
                      ..._buildCaregiverBadges(caregiver),
                    ],
                  ),
                  
                  const SizedBox(height: AppDesignSystem.spaceXS),
                  
                  Text(
                    caregiver['specialty'],
                    style: AppDesignSystem.cardSubtitleStyle,
                  ),
                  
                  const SizedBox(height: AppDesignSystem.spaceSM),
                  
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber[600],
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        caregiver['rating']?.toStringAsFixed(1) ?? 'N/A',
                        style: AppDesignSystem.infoStyle,
                      ),
                      const SizedBox(width: AppDesignSystem.spaceLG),
                      Icon(
                        Icons.work_outline,
                        color: AppDesignSystem.textSecondaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: AppDesignSystem.spaceXS),
                      Text(
                        caregiver['experience'],
                        style: AppDesignSystem.infoStyle,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppDesignSystem.spaceXS),
                  
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: AppDesignSystem.textSecondaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: AppDesignSystem.spaceXS),
                      Text(
                        caregiver['location'],
                        style: AppDesignSystem.infoStyle,
                      ),
                      const Spacer(),
                      Text(
                        'R\$ ${caregiver['hourlyRate']?.toStringAsFixed(0) ?? 'N/A'}/hora',
                        style: AppDesignSystem.priceStyle,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppDesignSystem.spaceMD),
                  
                  // Botão de contratação rápida
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _navigateToCaregiverProfile(caregiver),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppDesignSystem.primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Ver Perfil',
                            style: AppDesignSystem.captionStyle.copyWith(
                              color: AppDesignSystem.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDesignSystem.spaceMD),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _navigateToImprovedHire(caregiver),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppDesignSystem.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Contratar',
                            style: AppDesignSystem.captionStyle.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói os badges de assinatura e verificação para um cuidador
  List<Widget> _buildCaregiverBadges(Map<String, dynamic> caregiver) {
    final List<Widget> badges = [];
    final SubscriptionTier subscriptionTier = caregiver['subscriptionTier'] as SubscriptionTier;
    final ReputationLevel reputationLevel = caregiver['reputationLevel'] as ReputationLevel;

    // Badge de assinatura Premium
    if (subscriptionTier == SubscriptionTier.premium) {
      badges.add(_buildSubscriptionBadge(
        'PREMIUM',
        Icons.workspace_premium,
        const Color(0xFFFFD700), // Dourado
      ));
      badges.add(const SizedBox(width: 4));
    }
    // Badge de assinatura Plus
    else if (subscriptionTier == SubscriptionTier.plus) {
      badges.add(_buildSubscriptionBadge(
        'PLUS',
        Icons.star,
        AppDesignSystem.warningColor,
      ));
      badges.add(const SizedBox(width: 4));
    }

    // Badge de verificação (para assinantes)
    if (caregiver['verified'] && subscriptionTier != SubscriptionTier.free) {
      badges.add(Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppDesignSystem.successColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusSmall),
        ),
        child: const Icon(
          Icons.verified,
          color: AppDesignSystem.successColor,
          size: 16,
        ),
      ));
    }

    return badges;
  }

  /// Constrói um badge de assinatura
  Widget _buildSubscriptionBadge(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusSmall),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 12,
          ),
          const SizedBox(width: 2),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToImprovedHire(Map<String, dynamic> caregiverData) {
    Navigator.pushNamed(
      context,
      '/improved-hire',
      arguments: caregiverData,
    );
  }

  void _navigateToCaregiverProfile(Map<String, dynamic> caregiverData) {
    // Mapear os dados do cuidador para o formato esperado pela tela de perfil
    final profileData = {
      'id': caregiverData['name'].toLowerCase().replaceAll(' ', '_'),
      'name': caregiverData['name'],
      'profession': caregiverData['specialty'],
      'registration': _generateRegistration(caregiverData['specialty']),
      'verified': caregiverData['verified'],
      'rating': caregiverData['rating'],
      'totalReviews': _generateRandomReviews(),
      'profileImage': null,
      'description': _generateDescription(caregiverData),
      'services': _generateServices(caregiverData['specialty']),
      'experiences': _generateExperiences(),
      'reviews': _generateReviewsList(),
      'hourlyRate': _extractHourlyRate(caregiverData['price']),
      'availability': 'Disponível',
      'location': caregiverData['location'],
    };

    Navigator.pushNamed(
      context,
      '/caregiver-profile',
      arguments: profileData,
    );
  }

  String _generateRegistration(String specialty) {
    switch (specialty.toLowerCase()) {
      case 'técnico de enfermagem':
        return 'COREN ${(100000 + (specialty.hashCode % 900000)).toString()}';
      case 'acompanhante hospitalar':
        return 'CRA ${(10000 + (specialty.hashCode % 90000)).toString()}';
      default:
        return 'REG ${(1000 + (specialty.hashCode % 9000)).toString()}';
    }
  }

  int _generateRandomReviews() {
    return 50 + (DateTime.now().millisecondsSinceEpoch % 200);
  }

  String _generateDescription(Map<String, dynamic> caregiver) {
    final templates = [
      'Profissional ${caregiver['specialty'].toLowerCase()} com ${caregiver['experience']} de experiência. Comprometido(a) em oferecer cuidados de qualidade e atenção personalizada. Atua com dedicação e responsabilidade, priorizando sempre o bem-estar e conforto dos pacientes.',
      'Especialista em ${caregiver['specialty'].toLowerCase()} com sólida formação e ${caregiver['experience']} de prática. Focado(a) em proporcionar cuidados humanizados e seguros, sempre respeitando as necessidades individuais de cada paciente e familiares.',
      'Cuidador(a) experiente com ${caregiver['experience']} na área de ${caregiver['specialty'].toLowerCase()}. Oferece serviços de qualidade com atenção aos detalhes, empatia e profissionalismo, garantindo tranquilidade para pacientes e famílias.',
    ];
    return templates[caregiver['name'].hashCode % templates.length];
  }

  List<String> _generateServices(String specialty) {
    final baseServices = ['Higiene pessoal', 'Acompanhamento', 'Suporte emocional'];
    
    switch (specialty.toLowerCase()) {
      case 'técnico de enfermagem':
        return [...baseServices, 'Administração de medicamentos', 'Cuidados clínicos', 'Monitoramento vital'];
      case 'acompanhante hospitalar':
        return [...baseServices, 'Acompanhamento em consultas', 'Suporte durante internações', 'Comunicação com equipe médica'];
      default:
        return [...baseServices, 'Mobilidade', 'Alimentação', 'Atividades diárias'];
    }
  }

  List<String> _generateExperiences() {
    final experiences = [
      ['Casa de repouso', 'Clínica particular', 'Cuidados domiciliares'],
      ['Hospital regional', 'Centro de saúde', 'Atendimento domiciliar'],
      ['Clínica geriátrica', 'Hospital universitário', 'Cuidados paliativos'],
    ];
    return experiences[DateTime.now().millisecondsSinceEpoch % experiences.length];
  }

  List<Map<String, dynamic>> _generateReviewsList() {
    final reviews = [
      {
        'rating': 5,
        'comment': 'Profissional excelente, muito atencioso e cuidadoso.',
        'reviewer': 'Ana Silva',
        'date': '2024-08-15',
      },
      {
        'rating': 5,
        'comment': 'Recomendo! Muito responsável e carinhoso no atendimento.',
        'reviewer': 'João Santos',
        'date': '2024-07-28',
      },
      {
        'rating': 4,
        'comment': 'Bom profissional, pontual e dedicado.',
        'reviewer': 'Maria Oliveira',
        'date': '2024-07-10',
      },
    ];
    return reviews;
  }

  double _extractHourlyRate(String priceString) {
    final regex = RegExp(r'R\$ (\d+)');
    final match = regex.firstMatch(priceString);
    return match != null ? double.parse(match.group(1)!) : 25.0;
  }

  // Métodos para controle de localização e busca
  void _retryLocationSearch() {
    setState(() {
      _locationError = '';
      _isLoadingLocation = true;
    });

    // Simula busca de localização
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoadingLocation = false;
        // Simula erro de localização (pode ser removido quando implementar localização real)
        _locationError = 'Não foi possível obter localização. Verifique permissões.';
      });
    });
  }

  void _updateSearchRadius(double value) {
    setState(() {
      _searchRadius = value;
    });
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    // Retorna eventos vazios (pode ser implementado quando necessário)
    return [];
  }
}
