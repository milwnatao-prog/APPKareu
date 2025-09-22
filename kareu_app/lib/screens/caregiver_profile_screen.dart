import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';

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
      ],
      'experiences': [
        'Casa de repouso',
        'Hospital dos pescadores',
        'Cuidador domiciliar',
      ],
      'reviews': [
        {
          'rating': 5,
          'comment': 'Muito atenciosa, pontual. Recomendo',
          'reviewer': 'Ana Silva',
          'date': '2024-08-15',
        },
        {
          'rating': 5,
          'comment': 'Paciente e profissional, minha mãe foi muito bem cuidada',
          'reviewer': 'João Santos',
          'date': '2024-07-20',
        },
        {
          'rating': 5,
          'comment': 'Prestativa, recomendo',
          'reviewer': 'Maria Oliveira',
          'date': '2024-06-10',
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
          style: AppDesignSystem.bodySmallStyle.copyWith(color: Colors.white),
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppDesignSystem.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
          ),
          title: Text('Contratar Cuidador', style: AppDesignSystem.h3Style),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Você deseja contratar ${caregiver['name']}?',
                style: AppDesignSystem.bodyStyle,
              ),
              AppDesignSystem.verticalSpace(1),
              Container(
                padding: const EdgeInsets.all(AppDesignSystem.spaceMD),
                decoration: BoxDecoration(
                  color: AppDesignSystem.surfaceColor,
                  borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 20,
                          color: AppDesignSystem.primaryColor,
                        ),
                        const SizedBox(width: AppDesignSystem.spaceXS),
                        Text(
                          caregiver['name'],
                          style: AppDesignSystem.bodySmallStyle.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    AppDesignSystem.verticalSpace(0.5),
                    Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          size: 20,
                          color: AppDesignSystem.primaryColor,
                        ),
                        const SizedBox(width: AppDesignSystem.spaceXS),
                        Text(
                          'R\$ ${caregiver['hourlyRate']?.toStringAsFixed(2) ?? '25,00'}/hora',
                          style: AppDesignSystem.bodySmallStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppDesignSystem.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            AppDesignSystem.secondaryButton(
              text: 'Cancelar',
              onPressed: () => Navigator.of(context).pop(),
              height: 40,
            ),
            AppDesignSystem.primaryButton(
              text: 'Confirmar',
              onPressed: () {
                Navigator.of(context).pop();
                _confirmHiring();
              },
              height: 40,
            ),
          ],
        );
      },
    );
  }

  void _confirmHiring() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Solicitação de contratação enviada para ${caregiver['name']}!',
          style: AppDesignSystem.bodySmallStyle.copyWith(color: Colors.white),
        ),
        backgroundColor: AppDesignSystem.successColor,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Ver Status',
          textColor: Colors.white,
          onPressed: () {
            // Navegar para tela de status da contratação
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Funcionalidade de acompanhamento será implementada em breve',
                  style: AppDesignSystem.bodySmallStyle.copyWith(color: Colors.white),
                ),
                backgroundColor: AppDesignSystem.infoColor,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() 
            ? Icons.star 
            : (index < rating ? Icons.star_half : Icons.star_border),
          color: AppDesignSystem.accentColor,
          size: 16,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header com botão de voltar
            Padding(
              padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(AppDesignSystem.spaceSM),
                      decoration: BoxDecoration(
                        color: AppDesignSystem.surfaceColor,
                        borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppDesignSystem.textPrimaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Perfil',
                    style: AppDesignSystem.h2Style,
                  ),
                  const Spacer(),
                  const SizedBox(width: 40), // Para balancear o layout
                ],
              ),
            ),

            // Conteúdo principal
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceLG),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card principal do perfil
                    _buildProfileCard(),
                    
                    AppDesignSystem.verticalSpace(2),
                    
                    // Informações detalhadas
                    _buildDetailedInfo(),
                    
                    AppDesignSystem.verticalSpace(2),
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

  Widget _buildProfileCard() {
    return AppDesignSystem.styledCard(
      child: Column(
        children: [
          // Foto do perfil
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppDesignSystem.surfaceColor,
              borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
              border: Border.all(
                color: AppDesignSystem.borderColor,
                width: 1,
              ),
            ),
            child: caregiver['profileImage'] != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
                  child: Image.network(
                    caregiver['profileImage'],
                    fit: BoxFit.cover,
                  ),
                )
              : Icon(
                  Icons.person,
                  size: 60,
                  color: AppDesignSystem.textSecondaryColor,
                ),
          ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          // Nome e informações básicas
          Text(
            caregiver['name'],
            style: AppDesignSystem.h2Style,
            textAlign: TextAlign.center,
          ),
          
          AppDesignSystem.verticalSpace(0.5),
          
          Text(
            caregiver['profession'],
            style: AppDesignSystem.bodyStyle.copyWith(
              color: AppDesignSystem.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          
          AppDesignSystem.verticalSpace(0.25),
          
          Text(
            caregiver['registration'],
            style: AppDesignSystem.captionStyle,
            textAlign: TextAlign.center,
          ),
          
          AppDesignSystem.verticalSpace(0.5),
          
          // Badge de verificado
          if (caregiver['verified'] == true)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDesignSystem.spaceMD,
                vertical: AppDesignSystem.spaceXS,
              ),
              decoration: BoxDecoration(
                color: AppDesignSystem.successColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified,
                    size: 16,
                    color: AppDesignSystem.successColor,
                  ),
                  const SizedBox(width: AppDesignSystem.spaceXS),
                  Text(
                    'Verificado',
                    style: AppDesignSystem.captionStyle.copyWith(
                      color: AppDesignSystem.successColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          
          AppDesignSystem.verticalSpace(1.5),
          
          // Botões de ação
          Row(
            children: [
              Expanded(
                child: AppDesignSystem.primaryButton(
                  text: 'Contratar',
                  onPressed: _hireCaregiverDialog,
                  height: 44,
                ),
              ),
              const SizedBox(width: AppDesignSystem.spaceMD),
              Expanded(
                child: AppDesignSystem.secondaryButton(
                  text: 'Chat',
                  onPressed: _startChat,
                  height: 44,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedInfo() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Descrição
          Text(
            'Descrição',
            style: AppDesignSystem.h3Style,
          ),
          AppDesignSystem.verticalSpace(0.75),
          Text(
            caregiver['description'],
            style: AppDesignSystem.bodySmallStyle,
            textAlign: TextAlign.justify,
          ),
          
          AppDesignSystem.verticalSpace(2),
          
          // Serviços oferecidos
          Text(
            'Serviços oferecidos',
            style: AppDesignSystem.h3Style,
          ),
          AppDesignSystem.verticalSpace(0.75),
          ...caregiver['services'].map<Widget>((service) => Padding(
            padding: const EdgeInsets.only(bottom: AppDesignSystem.spaceXS),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: AppDesignSystem.successColor,
                ),
                const SizedBox(width: AppDesignSystem.spaceSM),
                Text(
                  service,
                  style: AppDesignSystem.bodySmallStyle,
                ),
              ],
            ),
          )).toList(),
          
          AppDesignSystem.verticalSpace(2),
          
          // Experiências
          Text(
            'Experiências',
            style: AppDesignSystem.h3Style,
          ),
          AppDesignSystem.verticalSpace(0.75),
          ...caregiver['experiences'].map<Widget>((experience) => Padding(
            padding: const EdgeInsets.only(bottom: AppDesignSystem.spaceXS),
            child: Row(
              children: [
                Icon(
                  Icons.work_outline,
                  size: 16,
                  color: AppDesignSystem.primaryColor,
                ),
                const SizedBox(width: AppDesignSystem.spaceSM),
                Text(
                  experience,
                  style: AppDesignSystem.bodySmallStyle,
                ),
              ],
            ),
          )).toList(),
          
          AppDesignSystem.verticalSpace(2),
          
          // Avaliações
          Row(
            children: [
              Text(
                'Avaliações',
                style: AppDesignSystem.h3Style,
              ),
              const Spacer(),
              _buildRatingStars(caregiver['rating']),
              const SizedBox(width: AppDesignSystem.spaceXS),
              Text(
                '${caregiver['rating']} (${caregiver['totalReviews']})',
                style: AppDesignSystem.captionStyle,
              ),
            ],
          ),
          AppDesignSystem.verticalSpace(0.75),
          ...caregiver['reviews'].take(3).map<Widget>((review) => Container(
            margin: const EdgeInsets.only(bottom: AppDesignSystem.spaceMD),
            padding: const EdgeInsets.all(AppDesignSystem.spaceMD),
            decoration: BoxDecoration(
              color: AppDesignSystem.surfaceColor,
              borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildRatingStars(review['rating'].toDouble()),
                    const Spacer(),
                    Text(
                      review['reviewer'],
                      style: AppDesignSystem.captionStyle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                AppDesignSystem.verticalSpace(0.5),
                Text(
                  review['comment'],
                  style: AppDesignSystem.bodySmallStyle,
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
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
          _buildBottomNavItem(Icons.search, 'Buscar', () {
            Navigator.pop(context);
          }),
          _buildBottomNavItem(Icons.chat_bubble_outline, 'Chat', _startChat),
          _buildBottomNavItem(
            isFavorited ? Icons.favorite : Icons.favorite_border, 
            'Favorito', 
            _toggleFavorite,
            isActive: isFavorited,
          ),
          _buildBottomNavItem(Icons.person_outline, 'Perfil', () {
            Navigator.pushNamed(context, '/account-settings');
          }),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, VoidCallback onTap, {bool isActive = false}) {
    return GestureDetector(
      onTap: onTap,
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
              color: isActive 
                ? AppDesignSystem.primaryColor 
                : AppDesignSystem.textSecondaryColor,
              size: 24,
            ),
            const SizedBox(height: AppDesignSystem.spaceXS),
            Text(
              label,
              style: AppDesignSystem.captionStyle.copyWith(
                color: isActive 
                  ? AppDesignSystem.primaryColor 
                  : AppDesignSystem.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
