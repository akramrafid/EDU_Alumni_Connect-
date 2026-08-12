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

class _EventsPageState extends ConsumerState<EventsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';

  // Local state tracker for user RSVPs
  final Set<String> _myRsvpedEventIds = {'evt_1'};

  final List<String> _categories = [
    'All',
    'Hackathons',
    'Networking',
    'Tech Workshops',
    'Career Fairs',
    'Alumni Talks',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            _buildSearchBar(),
            _buildCategoryChips(),
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Upcoming Events
                  _buildEventsList(eventsAsync, currentUid, type: 'upcoming'),
                  // Tab 2: My RSVPs
                  _buildEventsList(eventsAsync, currentUid, type: 'my_rsvps'),
                  // Tab 3: Past Seminars
                  _buildEventsList(eventsAsync, currentUid, type: 'past'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.push(AppRoutes.profile),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.mulledWine, width: 2),
                  ),
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Campus Events',
                style: TextStyle(
                  color: AppColors.mulledWine,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.mulledWine),
            onPressed: () => context.push(AppRoutes.notifications),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.mulledWine,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black54,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        tabs: const [
          Tab(height: 38, text: 'Upcoming'),
          Tab(height: 38, text: 'My RSVPs'),
          Tab(height: 38, text: 'Past Seminars'),
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
          borderRadius: BorderRadius.circular(20),
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
            hintText: 'Search events, hackathons, speakers...',
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

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final bool isSelected = _selectedCategory == cat;

          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.mulledWine : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.mulledWine : Colors.grey.shade300,
                ),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventsList(AsyncValue<List<EventModel>> eventsAsync, String currentUid, {required String type}) {
    return eventsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.mulledWine),
      ),
      error: (err, stack) {
        final fallbackList = _mockFallbackEvents();
        return _buildFilteredListView(fallbackList, currentUid, type);
      },
      data: (events) {
        final displayList = events.isNotEmpty ? events : _mockFallbackEvents();
        return _buildFilteredListView(displayList, currentUid, type);
      },
    );
  }

  Widget _buildFilteredListView(List<EventModel> events, String currentUid, String type) {
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

    if (type == 'my_rsvps') {
      filtered = filtered.where((e) => _myRsvpedEventIds.contains(e.eventId) || e.isUserRsvped(currentUid)).toList();
    } else if (type == 'past') {
      filtered = filtered.where((e) => e.dateTime.isBefore(DateTime.now())).toList();
      if (filtered.isEmpty) {
        // Mock past event for demonstration
        filtered = [_mockPastEvent()];
      }
    }

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.event_busy_outlined, size: 64, color: Colors.black26),
              const SizedBox(height: 16),
              Text(
                type == 'my_rsvps' ? 'No RSVPs yet' : 'No events found',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                type == 'my_rsvps'
                    ? 'Explore upcoming campus hackathons and seminars to register.'
                    : 'Try clearing your search query or selecting another category.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
              if (type == 'my_rsvps') ...[
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _tabController.animateTo(0),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mulledWine,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Browse Upcoming Events', style: TextStyle(color: Colors.white)),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 120),
      itemCount: filtered.length + (type == 'upcoming' ? 1 : 0),
      itemBuilder: (context, index) {
        if (type == 'upcoming' && index == 0) {
          return _buildFeaturedHeroSpotlight();
        }
        final event = filtered[type == 'upcoming' ? index - 1 : index];
        return _buildEventCard(event, currentUid);
      },
    );
  }

  Widget _buildFeaturedHeroSpotlight() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
            blurRadius: 12,
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
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                    ),
                  ],
                ),
              ),
              const Text('NOV 18 • 9:00 AM', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'EDU AI Engineering Hackathon – Season 01',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, height: 1.3),
          ),
          const SizedBox(height: 6),
          const Text(
            'Keynote Speaker: Dr. Saima Vance (Senior AI Researcher @ Google)',
            style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.white70, size: 16),
                  SizedBox(width: 4),
                  Text('Colosseum, EDU', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() => _myRsvpedEventIds.add('evt_1'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registered for AI Hackathon 2026!'), backgroundColor: Colors.green),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.mulledWine,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('RSVP Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(EventModel event, String currentUid) {
    final bool isRsvped = _myRsvpedEventIds.contains(event.eventId) || event.isUserRsvped(currentUid);
    final progress = event.maxAttendees > 0 ? (event.rsvpCount / event.maxAttendees).clamp(0.0, 1.0) : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.mulledWine.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.mulledWine),
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
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDEAEA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        event.tag,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mulledWine,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.3,
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
                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Capacity & Progress
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Registration Capacity',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black54),
                    ),
                    Text(
                      '${event.rsvpCount} / ${event.maxAttendees} Attending',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.mulledWine),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.mulledWine),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 6,
                ),
              ],
            ),
          ),

          // Bottom Action Bar (RSVP, Add to Calendar, Share)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              border: Border(top: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${event.rsvpCount} Going',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.event_note_outlined, color: AppColors.mulledWine, size: 20),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added event to your calendar!'), backgroundColor: Colors.green),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined, color: AppColors.mulledWine, size: 20),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Event share link copied to clipboard!')),
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (isRsvped) {
                            _myRsvpedEventIds.remove(event.eventId);
                          } else {
                            _myRsvpedEventIds.add(event.eventId);
                          }
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isRsvped ? 'RSVP Cancelled' : 'Registered for ${event.title}!'),
                            backgroundColor: isRsvped ? Colors.black87 : Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRsvped ? Colors.green : AppColors.mulledWine,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        isRsvped ? 'Going ✓' : 'RSVP',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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

  EventModel _mockPastEvent() {
    return EventModel(
      eventId: 'evt_past_1',
      title: 'NLP & Large Language Models Workshop',
      description: 'Hands-on session on fine-tuning LLMs with PyTorch.',
      tag: 'WEBINAR',
      dateTime: DateTime.now().subtract(const Duration(days: 10)),
      date: 'SEP 28',
      time: '3:00 PM',
      location: 'Online Zoom Webinar',
      bannerUrl: '',
      maxAttendees: 200,
      rsvpCount: 195,
      postedByAdminId: 'admin_1',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    );
  }
}
