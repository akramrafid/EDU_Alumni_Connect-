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
        child: FloatingActionButton(
          onPressed: () => context.push(AppRoutes.directory),
          backgroundColor: AppColors.mulledWine,
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
              child: conversationsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
                data: (conversations) {
                  final displayList = conversations.isNotEmpty
                      ? conversations
                      : _mockFallbackConversations(currentUid);

                  final filtered = _searchController.text.trim().isEmpty
                      ? displayList
                      : displayList
                          .where((c) => c
                              .displayName(currentUid)
                              .toLowerCase()
                              .contains(
                                  _searchController.text.trim().toLowerCase()))
                          .toList();

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
              color: AppColors.mulledWine,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () => context.push(AppRoutes.profile),
            child: const CircleAvatar(
              radius: 18,
              backgroundImage:
                  NetworkImage('https://i.pravatar.cc/150?img=11'),
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
        child: TextField(
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
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
    required String conversationId,
    required String name,
    required String message,
    required String time,
    required int unreadCount,
    required bool isOnline,
    String? avatarUrl,
    String? initials,
  }) {
    return GestureDetector(
      onTap: () => context.push('${AppRoutes.chat}/$conversationId'),
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
                  backgroundImage:
                      avatarUrl != null ? NetworkImage(avatarUrl) : null,
                  child: initials != null
                      ? Text(
                          initials,
                          style: const TextStyle(
                            color: AppColors.mulledWine,
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
                          fontWeight: unreadCount > 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: unreadCount > 0
                              ? AppColors.mulledWine
                              : Colors.black54,
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
                            fontWeight: unreadCount > 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color:
                                unreadCount > 0 ? Colors.black87 : Colors.black54,
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
                            color: AppColors.mulledWine,
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

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    if (now.day == dateTime.day &&
        now.month == dateTime.month &&
        now.year == dateTime.year) {
      final hour =
          dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour);
      final amPm = dateTime.hour >= 12 ? 'PM' : 'AM';
      final min = dateTime.minute.toString().padLeft(2, '0');
      return '$hour:$min $amPm';
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
    ];
  }
}
