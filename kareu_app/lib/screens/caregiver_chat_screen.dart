import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';
import '../services/user_service.dart';

class CaregiverChatScreen extends StatefulWidget {
  const CaregiverChatScreen({super.key});

  @override
  State<CaregiverChatScreen> createState() => _CaregiverChatScreenState();
}

class _CaregiverChatScreenState extends State<CaregiverChatScreen> 
    with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true; // Otimização: manter estado vivo

  @override
  void initState() {
    super.initState();
    // Definir tipo de usuário como cuidador
    UserService.setUserType(UserType.caregiver);
  }
  
  // Lista de conversas para cuidadores (com pacientes/famílias)
  final List<CaregiverChatItem> _chats = [
    CaregiverChatItem(
      patientName: 'Família Silva',
      patientInfo: 'Dona Maria, 78 anos',
      lastMessage: 'Obrigada pelo cuidado de hoje. A mãe ficou muito bem!',
      time: '14:30',
      hasProfileImage: false,
      isOnline: true,
      unreadCount: 1,
      chatType: 'family',
    ),
    CaregiverChatItem(
      patientName: 'João Santos',
      patientInfo: '65 anos - Acompanhamento',
      lastMessage: 'Pode confirmar o horário de amanhã?',
      time: '12:15',
      hasProfileImage: true,
      profileImagePath: 'assets/images/Login.jpg',
      isOnline: true,
      unreadCount: 2,
      chatType: 'patient',
    ),
    CaregiverChatItem(
      patientName: 'Família Costa',
      patientInfo: 'Sr. Pedro, 82 anos',
      lastMessage: 'Perfeito! Nos vemos na segunda-feira então.',
      time: '10:45',
      hasProfileImage: false,
      isOnline: false,
      unreadCount: 0,
      chatType: 'family',
    ),
    CaregiverChatItem(
      patientName: 'Ana Oliveira',
      patientInfo: '70 anos - Fisioterapia',
      lastMessage: 'Muito obrigada pelos exercícios. Me sinto melhor!',
      time: '09:20',
      hasProfileImage: false,
      isOnline: false,
      unreadCount: 0,
      chatType: 'patient',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context); // Chamada obrigatória para AutomaticKeepAliveClientMixin
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Search Bar
            _buildSearchBar(),
            
            // Online Patients
            _buildOnlinePatients(),
            
            // Chat List
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
                    child: Row(
                      children: [
                        Text(
                          'Conversas',
                          style: AppDesignSystem.h3Style,
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDesignSystem.spaceSM,
                            vertical: AppDesignSystem.spaceXS,
                          ),
                          decoration: BoxDecoration(
                            color: AppDesignSystem.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_chats.where((chat) => chat.unreadCount > 0).length} não lidas',
                            style: AppDesignSystem.captionStyle.copyWith(
                              color: AppDesignSystem.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Chat items
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceLG),
                      itemCount: _chats.length,
                      itemBuilder: (context, index) {
                        return _buildChatItem(_chats[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Bottom Navigation for Professional
            _buildProfessionalBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
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
          
          const SizedBox(width: AppDesignSystem.spaceLG),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mensagens',
                  style: AppDesignSystem.h2Style,
                ),
                Text(
                  'Converse com seus pacientes e famílias',
                  style: AppDesignSystem.captionStyle.copyWith(
                    color: AppDesignSystem.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // New message button
          GestureDetector(
            onTap: _showNewChatDialog,
            child: Container(
              padding: const EdgeInsets.all(AppDesignSystem.spaceSM),
              decoration: BoxDecoration(
                color: AppDesignSystem.primaryColor,
                borderRadius: BorderRadius.circular(AppDesignSystem.borderRadius),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceLG),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppDesignSystem.surfaceColor,
          borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
          border: Border.all(
            color: AppDesignSystem.borderColor,
            width: 1,
          ),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Buscar conversas...',
            hintStyle: AppDesignSystem.placeholderStyle,
            prefixIcon: Icon(
              Icons.search,
              color: AppDesignSystem.textSecondaryColor,
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDesignSystem.spaceLG, 
              vertical: AppDesignSystem.spaceMD,
            ),
          ),
          style: AppDesignSystem.bodySmallStyle,
        ),
      ),
    );
  }

  Widget _buildOnlinePatients() {
    final onlinePatients = _chats.where((chat) => chat.isOnline).toList();
    
    if (onlinePatients.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppDesignSystem.successColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppDesignSystem.spaceXS),
              Text(
                'Online agora (${onlinePatients.length})',
                style: AppDesignSystem.bodySmallStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppDesignSystem.successColor,
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceLG),
            itemCount: onlinePatients.length,
            itemBuilder: (context, index) {
              final patient = onlinePatients[index];
              return _buildOnlinePatientAvatar(patient);
            },
          ),
        ),
        
        AppDesignSystem.verticalSpace(1),
      ],
    );
  }

  Widget _buildOnlinePatientAvatar(CaregiverChatItem patient) {
    return GestureDetector(
      onTap: () => _openChat(patient),
      child: Container(
        margin: const EdgeInsets.only(right: AppDesignSystem.spaceMD),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: patient.chatType == 'family' 
                      ? AppDesignSystem.warningColor.withValues(alpha: 0.1)
                      : AppDesignSystem.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: patient.chatType == 'family' 
                        ? AppDesignSystem.warningColor.withValues(alpha: 0.2)
                        : AppDesignSystem.primaryColor.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: patient.hasProfileImage
                    ? ClipOval(
                        child: Image.asset(
                          patient.profileImagePath!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        patient.chatType == 'family' ? Icons.family_restroom : Icons.person,
                        color: patient.chatType == 'family' 
                          ? AppDesignSystem.warningColor
                          : AppDesignSystem.primaryColor,
                        size: 24,
                      ),
                ),
                
                // Online indicator
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppDesignSystem.successColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDesignSystem.spaceXS),
            
            SizedBox(
              width: 60,
              child: Text(
                patient.patientName.split(' ').first,
                style: AppDesignSystem.captionStyle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatItem(CaregiverChatItem chat) {
    return GestureDetector(
      onTap: () => _openChat(chat),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDesignSystem.spaceSM),
        child: AppDesignSystem.styledCard(
          padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
          child: Row(
            children: [
              // Profile Avatar with online status
              Stack(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: chat.chatType == 'family' 
                        ? AppDesignSystem.warningColor.withValues(alpha: 0.1)
                        : AppDesignSystem.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: chat.hasProfileImage
                      ? ClipOval(
                          child: Image.asset(
                            chat.profileImagePath!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          chat.chatType == 'family' ? Icons.family_restroom : Icons.person,
                          color: chat.chatType == 'family' 
                            ? AppDesignSystem.warningColor
                            : AppDesignSystem.primaryColor,
                          size: 28,
                        ),
                  ),
                  
                  // Online status indicator
                  if (chat.isOnline)
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppDesignSystem.successColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(width: AppDesignSystem.spaceLG),
              
              // Chat content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chat.patientName,
                            style: AppDesignSystem.cardTitleStyle,
                          ),
                        ),
                        Text(
                          chat.time,
                          style: AppDesignSystem.captionStyle.copyWith(
                            color: AppDesignSystem.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppDesignSystem.spaceXS),
                    
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDesignSystem.spaceXS,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: chat.chatType == 'family' 
                              ? AppDesignSystem.warningColor.withValues(alpha: 0.1)
                              : AppDesignSystem.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            chat.chatType == 'family' ? 'FAMÍLIA' : 'PACIENTE',
                            style: AppDesignSystem.captionStyle.copyWith(
                              color: chat.chatType == 'family' 
                                ? AppDesignSystem.warningColor
                                : AppDesignSystem.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 9,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDesignSystem.spaceXS),
                        Expanded(
                          child: Text(
                            chat.patientInfo,
                            style: AppDesignSystem.captionStyle.copyWith(
                              color: AppDesignSystem.textSecondaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppDesignSystem.spaceXS),
                    
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chat.lastMessage,
                            style: AppDesignSystem.bodySmallStyle.copyWith(
                              color: chat.unreadCount > 0 
                                ? AppDesignSystem.textPrimaryColor
                                : AppDesignSystem.textSecondaryColor,
                              fontWeight: chat.unreadCount > 0 
                                ? FontWeight.w500 
                                : FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        
                        // Unread count badge
                        if (chat.unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDesignSystem.spaceXS,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppDesignSystem.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              chat.unreadCount.toString(),
                              style: AppDesignSystem.captionStyle.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
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
      ),
    );
  }

  Widget _buildProfessionalBottomNavigation() {
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
          _buildNavItem(Icons.home_outlined, 'Início', 0),
          _buildNavItem(Icons.chat_bubble_outline, 'Chat', 1, isSelected: true),
          _buildNavItem(Icons.people_outline, 'Clientes', 2),
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

  void _openChat(CaregiverChatItem chat) {
    // Marcar mensagens como lidas
    setState(() {
      chat.unreadCount = 0;
    });
    
    // Navegar para conversa individual
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CaregiverConversationScreen(patient: chat),
      ),
    );
  }

  void _showNewChatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppDesignSystem.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
          ),
          title: Text('Nova Conversa', style: AppDesignSystem.h3Style),
          content: Text(
            'Para iniciar uma nova conversa, aguarde que um paciente ou família entre em contato através do seu perfil.',
            style: AppDesignSystem.bodyStyle,
          ),
          actions: [
            AppDesignSystem.primaryButton(
              text: 'Entendi',
              onPressed: () => Navigator.of(context).pop(),
              height: 40,
            ),
          ],
        );
      },
    );
  }

  void _onTabSelected(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home-professional');
        break;
      case 1:
        // Já estamos na tela de chat
        break;
      case 2:
        Navigator.pushNamed(context, '/patients-list');
        break;
      case 3:
        Navigator.pushNamed(context, '/caregiver-schedule');
        break;
      case 4:
        Navigator.pushNamed(context, '/caregiver-account');
        break;
    }
  }

}

class CaregiverChatItem {
  final String patientName;
  final String patientInfo;
  final String lastMessage;
  final String time;
  final bool hasProfileImage;
  final String? profileImagePath;
  final bool isOnline;
  int unreadCount;
  final String chatType; // 'patient' or 'family'

  CaregiverChatItem({
    required this.patientName,
    required this.patientInfo,
    required this.lastMessage,
    required this.time,
    this.hasProfileImage = false,
    this.profileImagePath,
    this.isOnline = false,
    this.unreadCount = 0,
    required this.chatType,
  });
}

// Tela de conversa individual
class CaregiverConversationScreen extends StatefulWidget {
  final CaregiverChatItem patient;

  const CaregiverConversationScreen({
    super.key,
    required this.patient,
  });

  @override
  State<CaregiverConversationScreen> createState() => _CaregiverConversationScreenState();
}

class _CaregiverConversationScreenState extends State<CaregiverConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
  }

  void _loadInitialMessages() {
    _messages.addAll([
      ChatMessage(
        text: widget.patient.lastMessage,
        isFromCaregiver: false,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ChatMessage(
        text: 'Obrigado pela mensagem! Estou aqui para ajudar.',
        isFromCaregiver: true,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      ChatMessage(
        text: 'Perfeito! Quando podemos conversar melhor sobre os cuidados?',
        isFromCaregiver: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppDesignSystem.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppDesignSystem.textPrimaryColor,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.patient.patientName,
              style: AppDesignSystem.h3Style,
            ),
            Text(
              widget.patient.isOnline ? 'Online agora' : 'Visto por último hoje',
              style: AppDesignSystem.captionStyle.copyWith(
                color: widget.patient.isOnline 
                  ? AppDesignSystem.successColor 
                  : AppDesignSystem.textSecondaryColor,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _startVideoCall,
            icon: Icon(
              Icons.videocam_outlined,
              color: AppDesignSystem.primaryColor,
            ),
          ),
          IconButton(
            onPressed: _startCall,
            icon: Icon(
              Icons.call_outlined,
              color: AppDesignSystem.primaryColor,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          
          // Message input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDesignSystem.spaceMD),
      child: Row(
        mainAxisAlignment: message.isFromCaregiver 
          ? MainAxisAlignment.end 
          : MainAxisAlignment.start,
        children: [
          if (!message.isFromCaregiver) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: widget.patient.chatType == 'family' 
                ? AppDesignSystem.warningColor.withValues(alpha: 0.1)
                : AppDesignSystem.primaryColor.withValues(alpha: 0.1),
              child: Icon(
                widget.patient.chatType == 'family' ? Icons.family_restroom : Icons.person,
                size: 16,
                color: widget.patient.chatType == 'family' 
                  ? AppDesignSystem.warningColor
                  : AppDesignSystem.primaryColor,
              ),
            ),
            const SizedBox(width: AppDesignSystem.spaceXS),
          ],
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(AppDesignSystem.spaceMD),
              decoration: BoxDecoration(
                color: message.isFromCaregiver 
                  ? AppDesignSystem.primaryColor
                  : AppDesignSystem.surfaceColor,
                borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
              ),
              child: Text(
                message.text,
                style: AppDesignSystem.bodySmallStyle.copyWith(
                  color: message.isFromCaregiver 
                    ? Colors.white
                    : AppDesignSystem.textPrimaryColor,
                ),
              ),
            ),
          ),
          
          if (message.isFromCaregiver)
            const SizedBox(width: AppDesignSystem.spaceXL),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLG),
      decoration: BoxDecoration(
        color: AppDesignSystem.surfaceColor,
        border: Border(
          top: BorderSide(
            color: AppDesignSystem.borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Digite sua mensagem...',
                hintStyle: AppDesignSystem.placeholderStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
                  borderSide: BorderSide(color: AppDesignSystem.borderColor),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDesignSystem.spaceLG,
                  vertical: AppDesignSystem.spaceMD,
                ),
              ),
              style: AppDesignSystem.bodySmallStyle,
            ),
          ),
          
          const SizedBox(width: AppDesignSystem.spaceMD),
          
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(AppDesignSystem.spaceMD),
              decoration: BoxDecoration(
                color: AppDesignSystem.primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: _messageController.text.trim(),
            isFromCaregiver: true,
            timestamp: DateTime.now(),
          ),
        );
      });
      _messageController.clear();
    }
  }

  void _startCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Iniciando chamada com ${widget.patient.patientName}...',
          style: AppDesignSystem.bodySmallStyle.copyWith(color: Colors.white),
        ),
        backgroundColor: AppDesignSystem.primaryColor,
      ),
    );
  }

  void _startVideoCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Iniciando videochamada com ${widget.patient.patientName}...',
          style: AppDesignSystem.bodySmallStyle.copyWith(color: Colors.white),
        ),
        backgroundColor: AppDesignSystem.primaryColor,
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isFromCaregiver;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isFromCaregiver,
    required this.timestamp,
  });
}
