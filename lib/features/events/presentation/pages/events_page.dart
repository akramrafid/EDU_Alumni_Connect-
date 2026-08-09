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
  String _selectedTag = 'All';

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final currentUid = user?.uid ?? '';
    final eventsAsync = ref.watch(upcomingEventsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterChips(),
          Expanded(
            child: eventsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (events) {
                final displayList = events.isNotEmpty
                    ? events
                    : _mockFallbackEvents();

                final filtered = _selectedTag == 'All'
                    ? displayList
                    : displayList
                        .where((e) =>
                            e.tag.toLowerCase() ==
                            _selectedTag.toLowerCase())
                        .toList();

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final event = filtered[index];
                    return _buildEventCard(event, currentUid);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
        color: AppColors.mulledWine,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.push(AppRoutes.profile),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundImage:
                      NetworkImage('https://i.pravatar.cc/150?img=11'),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Events',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () => context.push(AppRoutes.notifications),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          _buildChip('All'),
          const SizedBox(width: 8),
          _buildChip('COMPUTER CLUB'),
          const SizedBox(width: 8),
          _buildChip('NETWORKING'),
          const SizedBox(width: 8),
          _buildChip('WEBINAR'),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    final isSelected = _selectedTag == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedTag = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mulledWine : const Color(0xFFFDEAEA),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.mulledWine,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(EventModel event, String currentUid) {
    final progress = event.maxAttendees > 0
        ? event.rsvpCount / event.maxAttendees
        : 0.0;
    final isFull = event.isFull;
    final isAlmostFull = event.isAlmostFull;
    final isRsvped = event.isUserRsvped(currentUid);

    return GestureDetector(
      onTap: () => context.push('${AppRoutes.events}/${event.eventId}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
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
                    Icon(Icons.calendar_today,
                        size: 14,
                        color: isFull ? Colors.grey : AppColors.mulledWine),
                    const SizedBox(width: 4),
                    Text(
                      '${event.date} • ${event.time}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isFull ? Colors.grey : AppColors.mulledWine,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isFull
                        ? Colors.grey.shade200
                        : const Color(0xFFFDEAEA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    event.tag,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isFull ? Colors.grey : AppColors.mulledWine,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              event.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isFull ? Colors.grey : Colors.black87,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 16, color: isFull ? Colors.grey : Colors.black54),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    event.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: isFull ? Colors.grey : Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Capacity',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isFull ? Colors.grey : Colors.black54,
                  ),
                ),
                Text(
                  '${event.rsvpCount} / ${event.maxAttendees}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isFull
                        ? Colors.grey
                        : (isAlmostFull ? Colors.red : AppColors.mulledWine),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                isFull
                    ? Colors.grey
                    : (isAlmostFull ? Colors.red : AppColors.mulledWine),
              ),
              borderRadius: BorderRadius.circular(4),
              minHeight: 6,
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundImage:
                          NetworkImage('https://i.pravatar.cc/150?img=1'),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Attending',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    final success = await ref
                        .read(rsvpNotifierProvider.notifier)
                        .toggleRsvp(
                          eventId: event.eventId,
                          currentRsvpStatus: isRsvped,
                        );

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? (isRsvped ? 'RSVP Cancelled' : 'RSVP Successful!')
                                : 'Failed to update RSVP',
                          ),
                          backgroundColor:
                              success ? Colors.green : AppColors.error,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRsvped
                        ? Colors.green
                        : (isFull
                            ? Colors.grey.shade300
                            : AppColors.mulledWine),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isRsvped ? 'Going ✓' : (isFull ? 'Waitlist' : 'RSVP'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
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
