import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/event_model.dart';
import '../../data/models/mock_event.dart';
import '../providers/events_provider.dart';

class EventDetailsPage extends ConsumerWidget {
  final String? eventId;
  const EventDetailsPage({super.key, this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final currentUid = user?.uid ?? '';
    final eventsAsync = ref.watch(upcomingEventsProvider);

    final event = eventsAsync.value?.firstWhere(
          (e) => e.eventId == eventId,
          orElse: () => _fallbackEvent(eventId),
        ) ??
        _fallbackEvent(eventId);

    final isRsvped = event.isUserRsvped(currentUid);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Event Details',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (event.bannerUrl != null && event.bannerUrl!.isNotEmpty)
                  Image.network(
                    event.bannerUrl!,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildTag(event.tag),
                          const SizedBox(width: 8),
                          _buildTag('Alumni'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        icon: Icons.calendar_today,
                        title: '${event.date} • ${event.time}',
                        subtitle: 'Date and Time',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        icon: Icons.location_on_outlined,
                        title: event.location,
                        subtitle: 'Location',
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'About Event',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: _buildRsvpButton(context, ref, event, isRsvped),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFDEAEA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.mulledWine,
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.mulledWine, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRsvpButton(
      BuildContext context, WidgetRef ref, EventModel event, bool isRsvped) {
    return ElevatedButton(
      onPressed: () async {
        final success = await ref
            .read(rsvpNotifierProvider.notifier)
            .toggleRsvp(eventId: event.eventId, currentRsvpStatus: isRsvped);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success
                    ? (isRsvped ? 'RSVP Cancelled' : 'RSVP Successful!')
                    : 'Failed to update RSVP',
              ),
              backgroundColor: success ? Colors.green : AppColors.error,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isRsvped ? Colors.green : AppColors.mulledWine,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isRsvped ? 'Going ✓' : 'RSVP Now',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
        ],
      ),
    );
  }

  EventModel _fallbackEvent(String? id) {
    final mock = mockEvents.firstWhere(
      (e) => e.id == id,
      orElse: () => mockEvents.first,
    );
    return EventModel(
      eventId: mock.id,
      title: mock.title,
      description: mock.description,
      tag: mock.tag,
      dateTime: DateTime.now().add(const Duration(days: 3)),
      date: mock.date,
      time: mock.time,
      location: mock.location,
      bannerUrl: mock.image,
      maxAttendees: mock.maxAttendees,
      rsvpCount: mock.attendees,
      postedByAdminId: 'admin_1',
      createdAt: DateTime.now(),
    );
  }
}
