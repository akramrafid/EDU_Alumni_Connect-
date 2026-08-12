import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/event_model.dart';
import '../../data/models/mock_event.dart';
import '../providers/events_provider.dart';

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({super.key});

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Computer Club',
    'Networking',
    'Webinars',
    'Workshops',
    'Career Fairs',
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
    final eventsAsync = ref.watch(upcomingEventsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Brand Hero Header & Analytics Deck
            _buildHeroHeaderAndMetrics(),
            const SizedBox(height: 20),

            // 2. Featured Campus Event Hero Spotlight Banner
            _buildFeaturedEventSpotlight(),
            const SizedBox(height: 24),

            // 3. Search Bar & Filter Controls
            _buildSearchBar(),
            const SizedBox(height: 12),
            _buildFilterChips(),
            const SizedBox(height: 16),

            // 4. Events List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: eventsAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(color: AppColors.mulledWine),
                  ),
                ),
                error: (err, stack) => _buildList(_mockFallbackEvents(), currentUid),
                data: (events) {
                  final displayList = events.isNotEmpty ? events : _mockFallbackEvents();
                  return _buildList(displayList, currentUid);
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
                        'Campus & Alumni Events',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Hackathons, galas, networking & workshops',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                      onPressed: () => context.push(AppRoutes.notifications),
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
                  title: 'UPCOMING',
                  value: '12',
                  trend: 'Events',
                ),
                Container(height: 36, width: 1, color: Colors.grey.shade200),
                _buildStatItem(
                  title: 'MY RSVPS',
                  value: '3',
                  trend: 'Registered',
                ),
                Container(height: 36, width: 1, color: Colors.grey.shade200),
                _buildStatItem(
                  title: 'ATTENDING',
                  value: '140+',
                  trend: 'Peers',
                ),
                Container(height: 36, width: 1, color: Colors.grey.shade200),
                _buildStatItem(
                  title: 'MY CLUBS',
                  value: '4',
                  trend: 'Active',
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mulledWine,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            trend,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedEventSpotlight() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2C0000), AppColors.mulledWine],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.mulledWine.withOpacity(0.3),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.stars, color: Colors.amber, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'FEATURED SPOTLIGHT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'OCT 25 • 5:00 PM',
                  style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Annual EDU Alumni Gala & Tech Summit 2026',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Join 500+ distinguished East Delta University alumni, faculty, and industry leaders at the Grand Ballroom.',
              style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Colors.white70, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Radisson Blu, Chittagong',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => context.push('${AppRoutes.events}/event_gala_2026'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.mulledWine,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: const Text('RSVP Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
          ],
        ),
      ),
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
            hintText: 'Search events, hackathons, or clubs...',
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
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat;

          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
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
                cat,
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

  Widget _buildList(List<EventModel> events, String currentUid) {
    final query = _searchController.text.trim().toLowerCase();

    List<EventModel> filtered = events.where((e) {
      final matchesSearch = query.isEmpty ||
          e.title.toLowerCase().contains(query) ||
          e.location.toLowerCase().contains(query) ||
          e.tag.toLowerCase().contains(query);

      final matchesCategory = _selectedCategory == 'All' ||
          e.tag.toLowerCase().contains(_selectedCategory.toLowerCase());

      return matchesSearch && matchesCategory;
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.event_busy, size: 64, color: Colors.black26),
              const SizedBox(height: 16),
              const Text(
                'No events found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              const Text(
                'Try clearing your search or selecting a different category filter.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _selectedCategory = 'All';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mulledWine,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Reset Filters', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: filtered.map((event) {
        final bool isRsvp = event.isUserRsvped(currentUid);
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildEventCard(
            event: event,
            isRsvp: isRsvp,
            currentUid: currentUid,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEventCard({
    required EventModel event,
    required bool isRsvp,
    required String currentUid,
  }) {
    final int attendees = event.rsvpCount;
    final int maxAttendees = event.maxAttendees;
    final double progress = maxAttendees > 0 ? attendees / maxAttendees : 0.0;
    final bool isAlmostFull = progress > 0.8 && attendees < maxAttendees;
    final bool isWaitlist = attendees >= maxAttendees && maxAttendees > 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: AppColors.mulledWine),
                  const SizedBox(width: 6),
                  Text(
                    '${event.date} • ${event.time}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mulledWine,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isWaitlist
                      ? Colors.grey.shade200
                      : AppColors.mulledWine.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  event.tag.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isWaitlist ? Colors.black54 : AppColors.mulledWine,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            event.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Colors.black54),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  event.location,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Capacity',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                  children: [
                    TextSpan(
                      text: '$attendees ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isAlmostFull ? Colors.red : AppColors.mulledWine,
                      ),
                    ),
                    TextSpan(text: '/ $maxAttendees'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
                isWaitlist ? Colors.grey : (isAlmostFull ? Colors.red : AppColors.mulledWine)),
            borderRadius: BorderRadius.circular(4),
            minHeight: 6,
          ),
          if (isAlmostFull)
            const Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Almost Full!',
                  style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Overlapping Avatar Stack
              Row(
                children: [
                  _buildAvatarOverlapped('https://i.pravatar.cc/150?img=1'),
                  _buildAvatarOverlapped('https://i.pravatar.cc/150?img=2'),
                  _buildAvatarOverlapped('https://i.pravatar.cc/150?img=3'),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: AppColors.mulledWine.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        '+${attendees > 3 ? attendees - 3 : 0}',
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.mulledWine),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () => context.push('${AppRoutes.events}/${event.eventId}'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.mulledWine),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Details', style: TextStyle(color: AppColors.mulledWine, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final success = await ref
                          .read(rsvpNotifierProvider.notifier)
                          .toggleRsvp(eventId: event.eventId, currentRsvpStatus: isRsvp);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? (isRsvp ? 'RSVP Cancelled' : 'RSVP Successful!')
                                  : 'Failed to update RSVP',
                            ),
                            backgroundColor: success ? Colors.green : AppColors.error,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRsvp ? Colors.green : (isWaitlist ? Colors.grey.shade300 : AppColors.mulledWine),
                      foregroundColor: isWaitlist && !isRsvp ? Colors.black54 : Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isRsvp ? 'Going ✓' : (isWaitlist ? 'Waitlist' : 'RSVP'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarOverlapped(String url) {
    return Align(
      widthFactor: 0.6,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: CircleAvatar(
          radius: 13,
          backgroundImage: NetworkImage(url),
        ),
      ),
    );
  }

  List<EventModel> _mockFallbackEvents() {
    return mockEvents
        .map(
          (m) => EventModel(
            eventId: m.id,
            title: m.title,
            description: m.description,
            tag: m.tag,
            dateTime: DateTime.now().add(const Duration(days: 3)),
            date: m.date,
            time: m.time,
            location: m.location,
            bannerUrl: m.image,
            maxAttendees: m.maxAttendees,
            rsvpCount: m.attendees,
            postedByAdminId: 'admin_1',
            createdAt: DateTime.now(),
          ),
        )
        .toList();
  }
}
