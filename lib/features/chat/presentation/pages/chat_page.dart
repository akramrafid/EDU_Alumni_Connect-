import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFF700000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: const Icon(Icons.edit, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                itemCount: 4,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildChatThreadCard(
                      name: 'Saima Rahman',
                      message: 'Are we still on for the mentorship call tomorrow?',
                      time: '10:42 AM',
                      unreadCount: 2,
                      isOnline: true,
                      avatarUrl: 'https://i.pravatar.cc/150?img=5',
                    );
                  } else if (index == 1) {
                    return _buildChatThreadCard(
                      name: 'Tousif Ahmed',
                      message: 'Thanks for sharing that job posting. I applied this morning.',
                      time: 'Yesterday',
                      unreadCount: 0,
                      isOnline: false,
                      avatarUrl: 'https://i.pravatar.cc/150?img=12',
                    );
                  } else if (index == 2) {
                    return _buildChatThreadCard(
                      name: 'Alumni Engineering Group',
                      message: 'Mahir: I think the new framework is worth discussing at the meetup.',
                      time: 'Mon',
                      unreadCount: 0,
                      isOnline: false,
                      initials: 'AE',
                    );
                  } else {
                    return _buildChatThreadCard(
                      name: 'Ananya Chowdhury',
                      message: 'Sounds good. Let\'s catch up next week then.',
                      time: 'Oct 12',
                      unreadCount: 0,
                      isOnline: false,
                      avatarUrl: 'https://i.pravatar.cc/150?img=9',
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Messages',
            style: TextStyle(
              color: Color(0xFF700000),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () => context.push('${AppRoutes.directory}/akram_rafid'),
            child: const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100, 
          borderRadius: BorderRadius.circular(16),
        ),
        child: const TextField(
          decoration: InputDecoration(
            icon: Icon(Icons.search, color: Colors.black54),
            hintText: 'Search messages...',
            hintStyle: TextStyle(color: Colors.black54, fontSize: 16),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildChatThreadCard({
    required String name,
    required String message,
    required String time,
    required int unreadCount,
    required bool isOnline,
    String? avatarUrl,
    String? initials,
  }) {
    return GestureDetector(
      onTap: () => context.go('${AppRoutes.chat}/eleanor-vance'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFFDEAEA),
                backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                child: initials != null
                    ? Text(
                        initials,
                        style: const TextStyle(
                          color: Color(0xFF700000),
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              if (isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                        color: unreadCount > 0 ? const Color(0xFF700000) : Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        message,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                          color: unreadCount > 0 ? Colors.black87 : Colors.black54,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (unreadCount > 0)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF700000),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
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
}
