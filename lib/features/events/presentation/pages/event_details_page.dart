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
                  )
                else
                  Image.network(
                    'https://images.unsplash.com/photo-1540575467063-178a50c2df87?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
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
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.calendar_today, size: 20, color: Color(0xFF700000)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${event.date} • ${event.time}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on_outlined, size: 20, color: Color(0xFF700000)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              event.location,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'About the Event',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        event.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildAttendeesCard(event.rsvpCount),
                      const SizedBox(height: 16),
                      _buildLocationCard(event.location),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFDEAEA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF700000),
        ),
      ),
    );
  }

  Widget _buildAttendeesCard(int rsvpCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            children: [
              const Text(
                'Attendees',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF700000),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$rsvpCount Attending',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildAvatarOverlapped('https://i.pravatar.cc/150?img=5'),
              _buildAvatarOverlapped('https://i.pravatar.cc/150?img=6'),
              _buildAvatarOverlapped('https://i.pravatar.cc/150?img=7'),
              _buildAvatarOverlapped('https://i.pravatar.cc/150?img=8'),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    '+${rsvpCount > 4 ? rsvpCount - 4 : 0}',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Including 5 connections from your cohort.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarOverlapped(String url) {
    return Align(
      widthFactor: 0.7,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: CircleAvatar(
          radius: 16,
          backgroundImage: NetworkImage(url),
        ),
      ),
    );
  }

  Widget _buildLocationCard(String location) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          const Text(
            'Location',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(Icons.location_on, color: Color(0xFF700000), size: 32),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              location,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
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
        backgroundColor: isRsvped ? Colors.green : const Color(0xFF700000),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 10,
        shadowColor: const Color(0xFF700000).withOpacity(0.3),
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
          if (!isRsvped)
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
