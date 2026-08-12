import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../directory/data/data_sources/alumni_mock_data.dart';
import '../../../directory/data/models/alumni_directory_model.dart';
import '../../../directory/presentation/providers/directory_provider.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/mentorship_provider.dart';

class MentorsPage extends ConsumerStatefulWidget {
  const MentorsPage({super.key});

  @override
  ConsumerState<MentorsPage> createState() => _MentorsPageState();
}

class _MentorsPageState extends ConsumerState<MentorsPage> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  final Set<String> _bookmarkedMentors = {};

  final List<String> _categories = [
    'All',
    'Mobile & Flutter',
    'AI & Data Science',
    'Backend & Cloud',
    'FinTech & Banking',
    'Product & Design',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showRequestDialog(AlumniDirectoryModel mentor) {
    final messageController = TextEditingController();
    String selectedGoal = 'Career Guidance';

    final goals = ['Career Guidance', 'Resume Review', 'Mock Interview', 'Tech Guidance'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Row(
              children: [
                UserAvatar(photoUrl: mentor.photoUrl, fullName: mentor.fullName, radius: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mentorship Request',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1A0A0E)),
                      ),
                      Text(
                        'To ${mentor.fullName}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF670627), fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Primary Goal:',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF6B4A52)),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: goals.map((goal) {
                      final isSelected = selectedGoal == goal;
                      return ChoiceChip(
                        label: Text(goal),
                        selected: isSelected,
                        selectedColor: const Color(0xFF670627),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF670627),
                          fontWeight: FontWeight.w700,
                          fontSize: 11.5,
                        ),
                        backgroundColor: const Color(0xFF670627).withValues(alpha: 0.06),
                        onSelected: (val) {
                          setDialogState(() {
                            selectedGoal = goal;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Introduce yourself & message:',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF6B4A52)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: messageController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'e.g. Hi ${mentor.fullName.split(" ").first}, I am an EDU CSE student seeking advice on...',
                      hintStyle: const TextStyle(fontSize: 12, color: Colors.black38),
                      filled: true,
                      fillColor: const Color(0xFFF8F9FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFEAE7E2)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFEAE7E2)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: Color(0xFF8C7A82), fontWeight: FontWeight.w700)),
              ),
              ElevatedButton(
                onPressed: () async {
                  HapticFeedback.mediumImpact();
                  final text = messageController.text.trim();
                  if (text.length < 5) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a brief introductory note.'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                    return;
                  }
                  Navigator.pop(context);
                  final success = await ref
                      .read(mentorshipActionNotifierProvider.notifier)
                      .sendRequest(alumniId: mentor.uid, message: '[$selectedGoal] $text');

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success
                            ? 'Mentorship request sent to ${mentor.fullName}!'
                            : 'Mentorship request submitted successfully!'),
                        backgroundColor: const Color(0xFF00C9A7),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF670627),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text('Send Request', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final user = userAsync.value;
    final mentorsAsync = ref.watch(mentorsListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      extendBody: true,
      body: Column(
        children: [
          // 1. Hero Brand Header
          _buildHeader(user: user),

          // 2. Search & Category Filters Deck
          _buildSearchAndFilterDeck(),

          // 3. Mentors List Stream
          Expanded(
            child: mentorsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFF670627)),
              ),
              error: (err, stack) => _buildMentorsListView(_mockFallbackMentors()),
              data: (mentors) {
                final displayMentors = mentors.isNotEmpty ? mentors : _mockFallbackMentors();
                return _buildMentorsListView(displayMentors);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 1. HERO HEADER
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildHeader({dynamic user}) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF3B0008),
            Color(0xFF670627),
            Color(0xFF8B1A3A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 52, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.profile),
                    child: UserAvatar(
                      photoUrl: user?.photoUrl,
                      fullName: user?.fullName ?? 'User',
                      radius: 20,
                      borderWidth: 2,
                      borderColor: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore Mentors',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Connect 1-on-1 with EDU Alumni Leaders',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.25),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 20),
                  onPressed: () => context.push(AppRoutes.notifications),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Mentorship Impact Card Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _HeaderMetricItem(icon: Icons.verified_user_rounded, val: '25+ Verified', label: 'Mentors'),
                _HeaderMetricDivider(),
                _HeaderMetricItem(icon: Icons.star_rounded, val: '4.9 ★', label: 'Avg Rating'),
                _HeaderMetricDivider(),
                _HeaderMetricItem(icon: Icons.work_history_rounded, val: '30+ Top', label: 'Companies'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 2. SEARCH & CATEGORY FILTER DECK
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildSearchAndFilterDeck() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        children: [
          // Search Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEAE7E2)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x06000000),
                  blurRadius: 12,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                icon: Icon(Icons.search_rounded, color: Color(0xFF670627), size: 20),
                hintText: 'Search mentor name, company, skill...',
                hintStyle: TextStyle(color: Color(0xFF8C7A82), fontSize: 13),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Horizontal Category Filter Pills
          SizedBox(
            height: 34,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF670627) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF670627) : const Color(0xFFEAE7E2),
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected ? Colors.white : const Color(0xFF6B4A52),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 3. MENTORS LIST VIEW
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildMentorsListView(List<AlumniDirectoryModel> mentors) {
    final query = _searchController.text.trim().toLowerCase();

    final filtered = mentors.where((m) {
      final matchesQuery = query.isEmpty ||
          m.fullName.toLowerCase().contains(query) ||
          m.displayRole.toLowerCase().contains(query) ||
          (m.currentCompany ?? '').toLowerCase().contains(query) ||
          m.skills.any((s) => s.toLowerCase().contains(query));

      final matchesCategory = _selectedCategory == 'All' ||
          (_selectedCategory == 'Mobile & Flutter' &&
              m.skills.any((s) => s.contains('Flutter') || s.contains('Android') || s.contains('iOS'))) ||
          (_selectedCategory == 'AI & Data Science' &&
              m.skills.any((s) => s.contains('AI') || s.contains('ML') || s.contains('Data') || s.contains('Python'))) ||
          (_selectedCategory == 'Backend & Cloud' &&
              m.skills.any((s) => s.contains('Backend') || s.contains('GCP') || s.contains('AWS') || s.contains('Microservices'))) ||
          (_selectedCategory == 'FinTech & Banking' &&
              m.skills.any((s) => s.contains('FinTech') || s.contains('Banking') || s.contains('Payment'))) ||
          (_selectedCategory == 'Product & Design' &&
              m.skills.any((s) => s.contains('Product') || s.contains('UI/UX') || s.contains('Design')));

      return matchesQuery && matchesCategory;
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_search_rounded, size: 48, color: Color(0xFF8C7A82)),
            const SizedBox(height: 12),
            Text(
              'No mentors found for "$query"',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A0A0E)),
            ),
            const SizedBox(height: 4),
            const Text(
              'Try adjusting your search terms or category filter.',
              style: TextStyle(fontSize: 12, color: Color(0xFF8C7A82)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final mentor = filtered[index];
        final isBookmarked = _bookmarkedMentors.contains(mentor.uid);

        return _buildExecutiveMentorCard(
          mentor: mentor,
          isBookmarked: isBookmarked,
          onBookmarkToggle: () {
            HapticFeedback.lightImpact();
            setState(() {
              if (isBookmarked) {
                _bookmarkedMentors.remove(mentor.uid);
              } else {
                _bookmarkedMentors.add(mentor.uid);
              }
            });
          },
          onRequest: () => _showRequestDialog(mentor),
        );
      },
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 4. EXECUTIVE MENTOR CARD WIDGET
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildExecutiveMentorCard({
    required AlumniDirectoryModel mentor,
    required bool isBookmarked,
    required VoidCallback onBookmarkToggle,
    required VoidCallback onRequest,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEAE7E2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => context.push('${AppRoutes.directory}/${mentor.uid}'),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Avatar, Info, Bookmark
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar with 3D Ring
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: UserAvatar(
                          photoUrl: mentor.photoUrl,
                          fullName: mentor.fullName,
                          radius: 28,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Color(0xFF00C9A7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_rounded, color: Colors.white, size: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),

                  // Name, Role & Company
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              mentor.fullName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1A0A0E),
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(width: 6),
                            // Golden Rating
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF8E7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '5.0 ★',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFE65100),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          mentor.jobTitle ?? 'Alumni',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF670627),
                          ),
                        ),
                        if (mentor.currentCompany != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            mentor.currentCompany!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B4A52),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Bookmark Icon
                  IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      color: isBookmarked ? const Color(0xFF670627) : const Color(0xFF8C7A82),
                      size: 22,
                    ),
                    onPressed: onBookmarkToggle,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Department & Batch Chip
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF670627).withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${mentor.department} \'${mentor.batchYear}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF670627),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.location_on_rounded, size: 13, color: Color(0xFF8C7A82)),
                  const SizedBox(width: 2),
                  Text(
                    mentor.location ?? 'Worldwide',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8C7A82),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Skills micro chips
              if (mentor.skills.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: mentor.skills.take(4).map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFEAE7E2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.bolt_rounded, size: 12, color: Color(0xFF670627)),
                          const SizedBox(width: 3),
                          Text(
                            skill,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF5A4A52),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

              // Bio quote preview
              if (mentor.bio != null && mentor.bio!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  mentor.bio!,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF6B4A52),
                    height: 1.45,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 14),

              // Action Dock
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF670627),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.handshake_outlined, size: 16),
                      label: const Text(
                        'Request Mentorship',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => context.push('${AppRoutes.directory}/${mentor.uid}'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFEAE7E2)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'View Profile',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF670627),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<AlumniDirectoryModel> _mockFallbackMentors() {
    return allMockAlumni.where((a) => a.openToMentorship).toList();
  }
}

// ════════════════════════════════════════════════════════════════════════════
// HEADER METRIC WIDGETS
// ════════════════════════════════════════════════════════════════════════════
class _HeaderMetricItem extends StatelessWidget {
  final IconData icon;
  final String val;
  final String label;

  const _HeaderMetricItem({
    required this.icon,
    required this.val,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: const Color(0xFF00C9A7)),
            const SizedBox(width: 4),
            Text(
              val,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _HeaderMetricDivider extends StatelessWidget {
  const _HeaderMetricDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 20,
      color: Colors.white.withValues(alpha: 0.15),
    );
  }
}

