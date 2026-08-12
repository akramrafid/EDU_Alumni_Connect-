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
  String _selectedFilter = 'All Messages';

  final List<String> _filters = [
    'All Messages',
    'Unread',
    'Mentors',
    'Alumni',
  ];

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
            borderRadius: BorderRadius.circular(18),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Dynamic Hero Header & Chat Analytics Deck
            _buildHeroHeaderAndMetrics(),
            const SizedBox(height: 20),

            // 2. Active Now Stories Bar
            _buildActiveStoriesBar(),
            const SizedBox(height: 16),

            // 3. Search Bar & Category Filter Tabs
            _buildSearchBar(),
            const SizedBox(height: 12),
            _buildFilterChips(),
            const SizedBox(height: 16),

            // 4. Conversation Threads List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: conversationsAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(color: AppColors.mulledWine),
                  ),
                ),
                error: (err, stack) {
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

  Widget _buildHeroHeaderAndMetrics() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        const SizedBox(height: 235),
        
        // Brand Multi-Stop Gradient Top Header
        Container(
          height: 190,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4A0000),
                AppColors.mulledWine,
                Color(0xFF8B1A1A),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(24, 52, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Messages & Chat',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Direct messaging with alumni & mentors',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.profile),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Metrics Deck Overlapping Header
        Positioned(
          top: 125,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildStatItem(
                  title: 'UNREAD',
                  value: '2',
                  trend: 'New',
                  highlight: true,
                ),
                Container(height: 36, width: 1, color: Colors.grey.shade200),
                _buildStatItem(
                  title: 'ACTIVE NOW',
                  value: '14',
                  trend: 'Online',
                  highlight: false,
                ),
                Container(height: 36, width: 1, color: Colors.grey.shade200),
                _buildStatItem(
                  title: 'CHATS',
                  value: '8',
                  trend: 'Total',
                  highlight: false,
                ),
                Container(height: 36, width: 1, color: Colors.grey.shade200),
                _buildStatItem(
                  title: 'MENTORS',
                  value: '3',
                  trend: 'Connected',
                  highlight: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required String trend,
    required bool highlight,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.black45,
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: highlight ? const Color(0xFFFF5252) : AppColors.mulledWine,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            trend,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: highlight ? const Color(0xFFFF5252) : const Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveStoriesBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 8),
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
                            color: AppColors.mulledWine.withOpacity(0.08),
                            border: Border.all(color: AppColors.mulledWine.withOpacity(0.2)),
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
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF4A0000),
                                  AppColors.mulledWine,
                                ],
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 25,
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
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
            icon: const Icon(Icons.search, color: AppColors.mulledWine, size: 22),
            hintText: 'Search chats, alumni, or messages...',
            hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
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

  Widget _buildFilterChips() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;

          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.mulledWine : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.mulledWine : Colors.grey.shade300,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.mulledWine.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildConversationListView(
      List<ConversationModel> conversations, String currentUid) {
    final query = _searchController.text.trim().toLowerCase();

    final filtered = conversations.where((c) {
      final matchesQuery = query.isEmpty ||
          c.displayName(currentUid).toLowerCase().contains(query) ||
          c.lastMessage.toLowerCase().contains(query);

      final unread = c.unreadCountForUser(currentUid);
      final matchesFilter = _selectedFilter == 'All Messages' ||
          (_selectedFilter == 'Unread' && unread > 0) ||
          (_selectedFilter == 'Mentors' && c.displayName(currentUid).contains('Saima')) ||
          (_selectedFilter == 'Alumni');

      return matchesQuery && matchesFilter;
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.black26),
              const SizedBox(height: 16),
              const Text(
                'No conversations found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
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

    return Column(
      children: filtered.map((conv) {
        final other = conv.otherParticipant(currentUid);
        final unread = conv.unreadCountForUser(currentUid);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildChatThreadCard(
            conversationId: conv.conversationId,
            name: conv.displayName(currentUid),
            message: conv.lastMessage,
            time: _formatTime(conv.lastMessageAt),
            unreadCount: unread,
            isOnline: true,
            avatarUrl: other?.photoUrl ?? 'https://i.pravatar.cc/150?img=5',
          ),
        );
      }).toList(),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: hasUnread ? AppColors.mulledWine.withOpacity(0.3) : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: () => context.push('${AppRoutes.chat}/$conversationId'),
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.mulledWine.withOpacity(0.2), width: 1.5),
                      ),
                      child: CircleAvatar(
                        radius: 26,
                        backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
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
                    ),
                    if (isOnline)
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
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.verified, color: Color(0xFF0A66C2), size: 16),
                              ],
                            ),
                          ),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                              color: hasUnread ? AppColors.mulledWine : Colors.black45,
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
                                fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                                color: hasUnread ? Colors.black87 : Colors.black54,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (hasUnread)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
