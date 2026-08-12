import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/conversation_model.dart';
import '../providers/chat_provider.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _searchController = TextEditingController();

  // Active online users mock list for Messenger-style story bar
  final List<Map<String, String>> _activeUsers = [
    {
      'id': 'saima_rahman',
      'name': 'Saima R.',
      'avatar': 'https://i.pravatar.cc/150?img=5',
      'role': 'Alumni'
    },
    {
      'id': 'tousif_ahmed',
      'name': 'Tousif A.',
      'avatar': 'https://i.pravatar.cc/150?img=12',
      'role': 'Student'
    },
    {
      'id': 'dr_vance',
      'name': 'Dr. Vance',
      'avatar': 'https://i.pravatar.cc/150?img=33',
      'role': 'Faculty'
    },
    {
      'id': 'nabil_hasan',
      'name': 'Nabil H.',
      'avatar': 'https://i.pravatar.cc/150?img=15',
      'role': 'Alumni'
    },
    {
      'id': 'farhana_akter',
      'name': 'Farhana A.',
      'avatar': 'https://i.pravatar.cc/150?img=9',
      'role': 'Student'
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final currentUid = user?.uid ?? '';
    final conversationsAsync = ref.watch(userConversationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: FloatingActionButton.extended(
          onPressed: () => context.push(AppRoutes.directory),
          backgroundColor: AppColors.mulledWine,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
          icon: const Icon(Icons.edit_outlined, color: Colors.white),
          label: const Text(
            'New Chat',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(user?.fullName ?? 'User'),
            _buildSearchBar(),
            _buildActiveStoriesBar(),
            const SizedBox(height: 12),
            Expanded(
              child: conversationsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.mulledWine),
                ),
                error: (err, stack) {
                  // Gracefully use fallback list if any network error occurs
                  final fallbackList = _mockFallbackConversations(currentUid);
                  return _buildConversationListView(fallbackList, currentUid);
                },
                data: (conversations) {
                  final displayList = conversations.isNotEmpty
                      ? conversations
                      : _mockFallbackConversations(currentUid);

                  return _buildConversationListView(displayList, currentUid);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String userName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Messages',
            style: TextStyle(
              color: AppColors.mulledWine,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          GestureDetector(
            onTap: () => context.push(AppRoutes.profile),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.mulledWine, width: 2),
              ),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.mulledWine.withOpacity(0.1),
                backgroundImage:
                    const NetworkImage('https://i.pravatar.cc/150?img=11'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            icon: const Icon(Icons.search, color: Colors.black45, size: 22),
            hintText: 'Search chats or alumni...',
            hintStyle: const TextStyle(color: Colors.black38, fontSize: 15),
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18, color: Colors.black45),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildActiveStoriesBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 12, 24, 8),
          child: Text(
            'ACTIVE NOW',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black45,
              letterSpacing: 1.0,
            ),
          ),
        ),
        SizedBox(
          height: 84,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            itemCount: _activeUsers.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                // "Your Story" or Quick New Chat button
                return GestureDetector(
                  onTap: () => context.push(AppRoutes.directory),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.mulledWine.withOpacity(0.1),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: AppColors.mulledWine,
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'New Chat',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final user = _activeUsers[index - 1];
              return GestureDetector(
                onTap: () => context.push('${AppRoutes.chat}/conv_${user['id']}'),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.mulledWine,
                                  AppColors.mulledWine.withOpacity(0.5),
                                ],
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 26,
                              backgroundImage: NetworkImage(user['avatar']!),
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        user['name']!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildConversationListView(
      List<ConversationModel> conversations, String currentUid) {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = query.isEmpty
        ? conversations
        : conversations
            .where((c) =>
                c.displayName(currentUid).toLowerCase().contains(query) ||
                c.lastMessage.toLowerCase().contains(query))
            .toList();

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 64,
                color: Colors.black26,
              ),
              const SizedBox(height: 16),
              const Text(
                'No conversations found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Connect with alumni or students from the directory to start a chat.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.push(AppRoutes.directory),
                icon: const Icon(Icons.people_outline, color: Colors.white),
                label: const Text('Find Members', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mulledWine,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final conv = filtered[index];
        final other = conv.otherParticipant(currentUid);
        final unread = conv.unreadCountForUser(currentUid);

        return _buildChatThreadCard(
          conversationId: conv.conversationId,
          name: conv.displayName(currentUid),
          message: conv.lastMessage,
          time: _formatTime(conv.lastMessageAt),
          unreadCount: unread,
          isOnline: true,
          avatarUrl: other?.photoUrl ??
              'https://i.pravatar.cc/150?img=${index + 5}',
        );
      },
    );
  }

  Widget _buildChatThreadCard({
    required String conversationId,
    required String name,
    required String message,
    required String time,
    required int unreadCount,
    required bool isOnline,
    String? avatarUrl,
  }) {
    final bool hasUnread = unreadCount > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 0,
        child: InkWell(
          onTap: () => context.push('${AppRoutes.chat}/$conversationId'),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: hasUnread
                    ? AppColors.mulledWine.withOpacity(0.2)
                    : Colors.black.withOpacity(0.04),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.mulledWine.withOpacity(0.1),
                      backgroundImage: avatarUrl != null
                          ? NetworkImage(avatarUrl)
                          : null,
                      child: avatarUrl == null
                          ? Text(
                              name.isNotEmpty ? name[0].toUpperCase() : 'U',
                              style: const TextStyle(
                                color: AppColors.mulledWine,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
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
                            color: const Color(0xFF4CAF50),
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
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: hasUnread
                                    ? FontWeight.bold
                                    : FontWeight.w600,
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
                              fontWeight: hasUnread
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: hasUnread
                                  ? AppColors.mulledWine
                                  : Colors.black45,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              message,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: hasUnread
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: hasUnread
                                    ? Colors.black87
                                    : Colors.black54,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (hasUnread)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.mulledWine,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
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
        ),
      ),
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24 && now.day == dateTime.day) {
      final hour = dateTime.hour > 12
          ? dateTime.hour - 12
          : (dateTime.hour == 0 ? 12 : dateTime.hour);
      final amPm = dateTime.hour >= 12 ? 'PM' : 'AM';
      final min = dateTime.minute.toString().padLeft(2, '0');
      return '$hour:$min $amPm';
    } else if (difference.inDays < 7) {
      final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[dateTime.weekday - 1];
    }
    return '${dateTime.month}/${dateTime.day}';
  }

  List<ConversationModel> _mockFallbackConversations(String currentUid) {
    return [
      ConversationModel(
        conversationId: 'conv_1',
        participantIds: [currentUid, 'saima_rahman'],
        participantDetails: {
          'saima_rahman': ParticipantDetail(
            fullName: 'Saima Rahman',
            photoUrl: 'https://i.pravatar.cc/150?img=5',
          ),
        },
        lastMessage: 'Are we still on for the mentorship call tomorrow?',
        lastMessageAt: DateTime.now().subtract(const Duration(minutes: 15)),
        lastMessageSenderId: 'saima_rahman',
        unreadCount: {currentUid: 2},
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ConversationModel(
        conversationId: 'conv_2',
        participantIds: [currentUid, 'tousif_ahmed'],
        participantDetails: {
          'tousif_ahmed': ParticipantDetail(
            fullName: 'Tousif Ahmed',
            photoUrl: 'https://i.pravatar.cc/150?img=12',
          ),
        },
        lastMessage:
            'Thanks for sharing that job posting. I applied this morning.',
        lastMessageAt: DateTime.now().subtract(const Duration(hours: 24)),
        lastMessageSenderId: 'tousif_ahmed',
        unreadCount: {currentUid: 0},
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      ConversationModel(
        conversationId: 'conv_3',
        participantIds: [currentUid, 'dr_vance'],
        participantDetails: {
          'dr_vance': ParticipantDetail(
            fullName: 'Dr. Vance',
            photoUrl: 'https://i.pravatar.cc/150?img=33',
          ),
        },
        lastMessage: 'Let us catch up during the networking lunch at the summit.',
        lastMessageAt: DateTime.now().subtract(const Duration(days: 2)),
        lastMessageSenderId: 'dr_vance',
        unreadCount: {currentUid: 0},
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];
  }
}
