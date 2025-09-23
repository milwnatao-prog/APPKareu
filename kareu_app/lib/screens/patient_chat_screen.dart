import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';
import '../services/user_service.dart';

class PatientChatScreen extends StatefulWidget {
  const PatientChatScreen({super.key});

  @override
  State<PatientChatScreen> createState() => _PatientChatScreenState();
}

class _PatientChatScreenState extends State<PatientChatScreen> {
  
  // Lista de conversas para pacientes (com cuidadores)
  final List<PatientChatItem> _chats = [
    PatientChatItem(
      caregiverName: 'Maria Souza',
      specialty: 'Técnica de enfermagem',
      lastMessage: 'Olá! Confirmo presença às 14h para o acompanhamento.',
      time: '08:40',
      hasProfileImage: true,
      profileImagePath: 'assets/images/Login.jpg',
      isOnline: true,
      unreadCount: 2,
    ),
    PatientChatItem(
      caregiverName: 'João Santos',
      specialty: 'Enfermeiro',
      lastMessage: 'Pode me mandar o endereço completo, por favor?',
      time: '07:24',
      hasProfileImage: false,
      isOnline: true,
      unreadCount: 1,
    ),
    PatientChatItem(
      caregiverName: 'Ana Costa',
      specialty: 'Acompanhante Hospitalar',
      lastMessage: 'Perfeito! Nos vemos amanhã então.',
      time: '19:30',
      hasProfileImage: false,
      isOnline: false,
      unreadCount: 0,
    ),
    PatientChatItem(
      caregiverName: 'Carlos Oliveira',
      specialty: 'Acompanhante Domiciliar',
      lastMessage: 'Obrigado pela oportunidade. Vou preparar tudo.',
      time: '16:15',
      hasProfileImage: false,
      isOnline: false,
      unreadCount: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Search Bar
            _buildSearchBar(),
            
            // Online Caregivers
            _buildOnlineCaregivers(),
            
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
            
            // Bottom Navigation for Patient
            _buildPatientBottomNavigation(),
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
                  'Converse com seus cuidadores',
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

  Widget _buildOnlineCaregivers() {
    final onlineCaregivers = _chats.where((chat) => chat.isOnline).toList();
    
    if (onlineCaregivers.isEmpty) {
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
                'Online agora (${onlineCaregivers.length})',
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
            itemCount: onlineCaregivers.length,
            itemBuilder: (context, index) {
              final caregiver = onlineCaregivers[index];
              return _buildOnlineCaregiverAvatar(caregiver);
            },
          ),
        ),
        
        AppDesignSystem.verticalSpace(1),
      ],
    );
  }

  Widget _buildOnlineCaregiverAvatar(PatientChatItem caregiver) {
    return GestureDetector(
      onTap: () => _openChat(caregiver),
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
                    color: AppDesignSystem.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppDesignSystem.primaryColor.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: caregiver.hasProfileImage
                    ? ClipOval(
                        child: Image.asset(
                          caregiver.profileImagePath!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: AppDesignSystem.primaryColor,
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
                caregiver.caregiverName.split(' ').first,
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

  Widget _buildChatItem(PatientChatItem chat) {
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
                      color: AppDesignSystem.primaryColor.withValues(alpha: 0.1),
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
                          Icons.person,
                          color: AppDesignSystem.primaryColor,
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
                            chat.caregiverName,
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
                    
                    Text(
                      chat.specialty,
                      style: AppDesignSystem.captionStyle.copyWith(
                        color: AppDesignSystem.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _buildPatientBottomNavigation() {
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
          _buildNavItem(Icons.chat_bubble_outline, 'Chat', 1, isSelected: true),
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

  void _openChat(PatientChatItem chat) {
    // Marcar mensagens como lidas
    setState(() {
      chat.unreadCount = 0;
    });
    
    // Navegar para conversa individual
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientConversationScreen(caregiver: chat),
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
            'Para iniciar uma nova conversa, contrate um cuidador através da busca.',
            style: AppDesignSystem.bodyStyle,
          ),
          actions: [
            AppDesignSystem.secondaryButton(
              text: 'Cancelar',
              onPressed: () => Navigator.of(context).pop(),
              height: 40,
            ),
            AppDesignSystem.primaryButton(
              text: 'Buscar Cuidadores',
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/search');
              },
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
        // Navegar para Home
        Navigator.pushReplacementNamed(context, '/home-patient');
        break;
      case 1:
        // Já estamos na tela de chat
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Você já está na tela de chat'),
            duration: Duration(seconds: 1),
          ),
        );
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
}

class PatientChatItem {
  final String caregiverName;
  final String specialty;
  final String lastMessage;
  final String time;
  final bool hasProfileImage;
  final String? profileImagePath;
  final bool isOnline;
  int unreadCount;

  PatientChatItem({
    required this.caregiverName,
    required this.specialty,
    required this.lastMessage,
    required this.time,
    this.hasProfileImage = false,
    this.profileImagePath,
    this.isOnline = false,
    this.unreadCount = 0,
  });
}

// Tela de conversa individual
class PatientConversationScreen extends StatefulWidget {
  final PatientChatItem caregiver;

  const PatientConversationScreen({
    super.key,
    required this.caregiver,
  });

  @override
  State<PatientConversationScreen> createState() => _PatientConversationScreenState();
}

class _PatientConversationScreenState extends State<PatientConversationScreen> {
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
        text: 'Olá! Confirmo presença às 14h para o acompanhamento.',
        isFromCaregiver: true,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ChatMessage(
        text: 'Perfeito! Obrigado pela confirmação.',
        isFromCaregiver: false,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      ChatMessage(
        text: 'Posso levar algum material específico?',
        isFromCaregiver: true,
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
              widget.caregiver.caregiverName,
              style: AppDesignSystem.h3Style,
            ),
            Text(
              widget.caregiver.isOnline ? 'Online agora' : 'Visto por último hoje',
              style: AppDesignSystem.captionStyle.copyWith(
                color: widget.caregiver.isOnline 
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
          ? MainAxisAlignment.start 
          : MainAxisAlignment.end,
        children: [
          if (message.isFromCaregiver) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppDesignSystem.primaryColor.withValues(alpha: 0.1),
              child: Icon(
                Icons.person,
                size: 16,
                color: AppDesignSystem.primaryColor,
              ),
            ),
            const SizedBox(width: AppDesignSystem.spaceXS),
          ],
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(AppDesignSystem.spaceMD),
              decoration: BoxDecoration(
                color: message.isFromCaregiver 
                  ? AppDesignSystem.surfaceColor
                  : AppDesignSystem.primaryColor,
                borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
              ),
              child: Text(
                message.text,
                style: AppDesignSystem.bodySmallStyle.copyWith(
                  color: message.isFromCaregiver 
                    ? AppDesignSystem.textPrimaryColor
                    : Colors.white,
                ),
              ),
            ),
          ),
          
          if (!message.isFromCaregiver)
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
            isFromCaregiver: false,
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
          'Iniciando chamada com ${widget.caregiver.caregiverName}...',
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
          'Iniciando videochamada com ${widget.caregiver.caregiverName}...',
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
