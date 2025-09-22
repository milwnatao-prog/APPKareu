import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';

class CaregiverChatScreen extends StatefulWidget {
  const CaregiverChatScreen({super.key});

  @override
  State<CaregiverChatScreen> createState() => _CaregiverChatScreenState();
}

class _CaregiverChatScreenState extends State<CaregiverChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  Map<String, dynamic>? patientData;
  List<Map<String, dynamic>> messages = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Receber dados do paciente via argumentos da rota
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      patientData = args;
      _loadMessages();
    }
  }

  void _loadMessages() {
    // Simular mensagens do chat
    messages = [
      {
        'id': '1',
        'text': 'Olá! Gostaria de saber mais sobre os cuidados necessários.',
        'isFromMe': false,
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'senderName': patientData?['patientName'] ?? 'Paciente',
      },
      {
        'id': '2',
        'text': 'Olá! Claro, ficarei feliz em ajudar. Pode me contar um pouco sobre as necessidades específicas?',
        'isFromMe': true,
        'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        'senderName': 'Você',
      },
      {
        'id': '3',
        'text': 'Preciso de alguém para cuidar da minha mãe durante o dia. Ela tem 78 anos e precisa de ajuda com medicamentos.',
        'isFromMe': false,
        'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        'senderName': patientData?['patientName'] ?? 'Paciente',
      },
      {
        'id': '4',
        'text': 'Entendo perfeitamente. Tenho experiência com cuidados de idosos e administração de medicamentos. Podemos agendar uma conversa para discutir os detalhes?',
        'isFromMe': true,
        'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
        'senderName': 'Você',
      },
    ];
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
      appBar: AppBar(
        backgroundColor: AppDesignSystem.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              child: Text(
                (patientData!['patientName'] ?? 'P')[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppDesignSystem.spaceSM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    patientData!['patientName'] ?? 'Paciente',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Online agora',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: _startVideoCall,
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: _startVoiceCall,
          ),
          const SizedBox(width: AppDesignSystem.spaceXS),
        ],
      ),
      body: Column(
        children: [
          // Lista de mensagens
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppDesignSystem.spaceMD),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(messages[index]);
              },
            ),
          ),
          
          // Campo de entrada de mensagem
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    final isFromMe = message['isFromMe'] as bool;
    final timestamp = message['timestamp'] as DateTime;
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppDesignSystem.spaceSM),
      child: Row(
        mainAxisAlignment: isFromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isFromMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppDesignSystem.primaryColor.withValues(alpha: 0.1),
              child: Text(
                (message['senderName'] as String)[0].toUpperCase(),
                style: TextStyle(
                  color: AppDesignSystem.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppDesignSystem.spaceXS),
          ],
          
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDesignSystem.spaceMD,
                vertical: AppDesignSystem.spaceSM,
              ),
              decoration: BoxDecoration(
                color: isFromMe 
                  ? AppDesignSystem.primaryColor 
                  : AppDesignSystem.cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(AppDesignSystem.borderRadius),
                  topRight: const Radius.circular(AppDesignSystem.borderRadius),
                  bottomLeft: Radius.circular(isFromMe ? AppDesignSystem.borderRadius : 4),
                  bottomRight: Radius.circular(isFromMe ? 4 : AppDesignSystem.borderRadius),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['text'],
                    style: TextStyle(
                      color: isFromMe ? Colors.white : AppDesignSystem.textPrimaryColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: AppDesignSystem.spaceXS),
                  Text(
                    _formatTime(timestamp),
                    style: TextStyle(
                      color: isFromMe 
                        ? Colors.white.withValues(alpha: 0.7)
                        : AppDesignSystem.textSecondaryColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (isFromMe) ...[
            const SizedBox(width: AppDesignSystem.spaceXS),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppDesignSystem.successColor.withValues(alpha: 0.1),
              child: const Icon(
                Icons.person,
                color: AppDesignSystem.successColor,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(AppDesignSystem.spaceMD),
      decoration: BoxDecoration(
        color: AppDesignSystem.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Botão de anexo
          Container(
            decoration: BoxDecoration(
              color: AppDesignSystem.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
            ),
            child: IconButton(
              icon: Icon(
                Icons.attach_file,
                color: AppDesignSystem.primaryColor,
                size: 20,
              ),
              onPressed: _showAttachmentOptions,
            ),
          ),
          
          const SizedBox(width: AppDesignSystem.spaceSM),
          
          // Campo de texto
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppDesignSystem.backgroundColor,
                borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
                border: Border.all(
                  color: AppDesignSystem.borderColor,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Digite sua mensagem...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppDesignSystem.spaceMD,
                    vertical: AppDesignSystem.spaceSM,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          
          const SizedBox(width: AppDesignSystem.spaceSM),
          
          // Botão de enviar
          Container(
            decoration: BoxDecoration(
              color: AppDesignSystem.primaryColor,
              borderRadius: BorderRadius.circular(AppDesignSystem.borderRadiusLarge),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'text': _messageController.text.trim(),
      'isFromMe': true,
      'timestamp': DateTime.now(),
      'senderName': 'Você',
    };

    setState(() {
      messages.add(newMessage);
      _messageController.clear();
    });

    // Auto scroll para a última mensagem
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Simular resposta automática após 2 segundos
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final responses = [
          'Obrigado pela mensagem! Vou analisar e responder em breve.',
          'Perfeito! Podemos agendar uma conversa para discutir melhor.',
          'Entendi. Vou verificar minha agenda e te retorno.',
          'Ótima pergunta! Deixe-me explicar melhor...',
        ];
        
        final randomResponse = responses[DateTime.now().millisecond % responses.length];
        
        setState(() {
          messages.add({
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'text': randomResponse,
            'isFromMe': false,
            'timestamp': DateTime.now(),
            'senderName': patientData!['patientName'] ?? 'Paciente',
          });
        });

        // Auto scroll para a última mensagem
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  void _startVideoCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Iniciando videochamada com ${patientData!['patientName']}...'),
        backgroundColor: AppDesignSystem.primaryColor,
      ),
    );
  }

  void _startVoiceCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Iniciando chamada de voz com ${patientData!['patientName']}...'),
        backgroundColor: AppDesignSystem.primaryColor,
      ),
    );
  }

  void _showAttachmentOptions() {
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
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppDesignSystem.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            Text(
              'Anexar arquivo',
              style: AppDesignSystem.h1Style,
            ),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  Icons.photo_library,
                  'Galeria',
                  () => Navigator.pop(context),
                ),
                _buildAttachmentOption(
                  Icons.camera_alt,
                  'Câmera',
                  () => Navigator.pop(context),
                ),
                _buildAttachmentOption(
                  Icons.insert_drive_file,
                  'Documento',
                  () => Navigator.pop(context),
                ),
              ],
            ),
            
            const SizedBox(height: AppDesignSystem.spaceLG),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
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

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Agora';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}min';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
