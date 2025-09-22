import 'package:flutter/material.dart';

class ProfessionalChatScreen extends StatefulWidget {
  const ProfessionalChatScreen({super.key});

  @override
  State<ProfessionalChatScreen> createState() => _ProfessionalChatScreenState();
}

class _ProfessionalChatScreenState extends State<ProfessionalChatScreen> {
  int _selectedTabIndex = 1; // Chat está selecionado
  final List<ChatItem> _chats = [
    ChatItem(
      name: 'Maria Souza',
      lastMessage: 'Confirmado, estarei às 14h',
      time: '08:40',
      hasProfileImage: true,
      profileImagePath: 'assets/images/Login.jpg',
    ),
    ChatItem(
      name: 'Fernanda',
      lastMessage: 'Onde fica a localização',
      time: '07:24',
      hasProfileImage: false,
    ),
    ChatItem(
      name: 'Flávio',
      lastMessage: 'Podemos negociar 12h de plantão...',
      time: '05:13',
      hasProfileImage: false,
    ),
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
            
            // Header with back button and title
            _buildHeader(),
            
            // Chat List
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Chat items
                  ..._chats.asMap().entries.map((entry) {
                    int index = entry.key;
                    ChatItem chat = entry.value;
                    return Column(
                      children: [
                        _buildChatItem(chat),
                        if (index < _chats.length - 1) _buildDivider(),
                      ],
                    );
                  }).toList(),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xFF1D1B20),
                size: 20,
              ),
            ),
          ),
          
          const SizedBox(width: 10),
          
          // Title with chat icon
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 39,
                  height: 39,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    color: Color(0xFF49454F),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Chats',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 0.75,
                    letterSpacing: -0.86,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 56), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildChatItem(ChatItem chat) {
    return GestureDetector(
      onTap: () => _onChatTapped(chat),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            // Profile Image
            Container(
              width: chat.hasProfileImage ? 54 : 66,
              height: chat.hasProfileImage ? 56 : 66,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(chat.hasProfileImage ? 250 : 33),
                color: chat.hasProfileImage ? null : const Color(0xFFF5F5F5),
              ),
              child: chat.hasProfileImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(250),
                      child: Image.asset(
                        chat.profileImagePath!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.account_circle_outlined,
                      color: Color(0xFF1D1B20),
                      size: 55,
                    ),
            ),
            
            const SizedBox(width: 19),
            
            // Chat Content
            Expanded(
              child: SizedBox(
                height: 65,
                child: Stack(
                  children: [
                    // Name and Message
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          chat.name,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15.69,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          chat.lastMessage,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15.69,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            height: 1.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    
                    // Time
                    Positioned(
                      top: 11,
                      right: 0,
                      child: Text(
                        chat.time,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15.69,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: const Color(0xFFD9D9D9).withValues(alpha: 0.5),
      margin: const EdgeInsets.symmetric(horizontal: 20),
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

  void _onChatTapped(ChatItem chat) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chat com ${chat.name}'),
          content: Text('Abrindo conversa com ${chat.name}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
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
        // Já estamos na tela de chat
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
    
    if (section.isNotEmpty && index != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navegando para $section'),
          duration: const Duration(seconds: 1),
          backgroundColor: const Color(0xFF4D64C8),
        ),
      );
    }
  }
}

class ChatItem {
  final String name;
  final String lastMessage;
  final String time;
  final bool hasProfileImage;
  final String? profileImagePath;

  ChatItem({
    required this.name,
    required this.lastMessage,
    required this.time,
    this.hasProfileImage = false,
    this.profileImagePath,
  });
}
