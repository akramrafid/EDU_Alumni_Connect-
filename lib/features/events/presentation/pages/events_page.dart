import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_bottom_nav.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  int _currentIndex = 2; // 2 = Calendar/Events tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      extendBody: true,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterChips(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
              itemCount: 3,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildEventCard(
                    date: 'OCT 15 • 6:00 PM EST',
                    tag: 'FINANCE CLUB',
                    title: 'Annual FinTech Summit',
                    location: 'Virtual Hub',
                    attendees: 142,
                    maxAttendees: 200,
                    isRsvp: true,
                  );
                } else if (index == 1) {
                  return _buildEventCard(
                    date: 'OCT 18 • 7:30 PM LOCAL',
                    tag: 'ENTREPRENEURS',
                    title: 'Founders Networking Mixer',
                    location: 'Downtown Club, NY',
                    attendees: 48,
                    maxAttendees: 50,
                    isRsvp: true,
                    isAlmostFull: true,
                  );
                } else {
                  return _buildEventCard(
                    date: 'OCT 20 • 12:00 PM EST',
                    tag: 'GENERAL',
                    title: 'Alumni Mentorship Kickoff',
                    location: 'Zoom',
                    attendees: 500,
                    maxAttendees: 500,
                    isRsvp: false,
                    isWaitlist: true,
                  );
                }
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
        color: Color(0xFF700000),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
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
            onPressed: () {},
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
          _buildChip('All', isSelected: true),
          const SizedBox(width: 8),
          _buildChip('This Week', isSelected: false),
          const SizedBox(width: 8),
          _buildChip('My Club', isSelected: false),
          const SizedBox(width: 8),
          _buildChip('Webinars', isSelected: false),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF700000) : const Color(0xFFFDEAEA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF700000),
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildEventCard({
    required String date,
    required String tag,
    required String title,
    required String location,
    required int attendees,
    required int maxAttendees,
    required bool isRsvp,
    bool isAlmostFull = false,
    bool isWaitlist = false,
  }) {
    double progress = attendees / maxAttendees;
    bool isFull = attendees >= maxAttendees;

    return Container(
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
                  Icon(Icons.calendar_today, size: 14, color: isFull ? Colors.grey : const Color(0xFF700000)),
                  const SizedBox(width: 4),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isFull ? Colors.grey : const Color(0xFF700000),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isFull ? Colors.grey.shade200 : const Color(0xFFFDEAEA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isFull ? Colors.grey : const Color(0xFF700000),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
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
              Icon(Icons.location_on_outlined, size: 16, color: isFull ? Colors.grey : Colors.black54),
              const SizedBox(width: 4),
              Text(
                location,
                style: TextStyle(
                  fontSize: 13,
                  color: isFull ? Colors.grey : Colors.black54,
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
                '$attendees / $maxAttendees',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isFull ? Colors.grey : (isAlmostFull ? Colors.red : const Color(0xFF700000)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
                isFull ? Colors.grey : (isAlmostFull ? Colors.red : const Color(0xFF700000))),
            borderRadius: BorderRadius.circular(4),
            minHeight: 6,
          ),
          if (isAlmostFull)
            const Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Almost Full',
                  style: TextStyle(fontSize: 10, color: Colors.red),
                ),
              ),
            ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildAvatarOverlapped('https://i.pravatar.cc/150?img=1'),
                  _buildAvatarOverlapped('https://i.pravatar.cc/150?img=2'),
                  _buildAvatarOverlapped('https://i.pravatar.cc/150?img=3'),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        isWaitlist ? '+498' : '+139',
                        style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: wire to event details navigation
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isWaitlist ? Colors.grey.shade200 : const Color(0xFF700000),
                  foregroundColor: isWaitlist ? Colors.black54 : Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isWaitlist ? 'Waitlist' : 'RSVP',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
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
          radius: 12,
          backgroundImage: NetworkImage(url),
        ),
      ),
    );
  }
}
