import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Premium Profile Screen — Bold, Modern, Feature-Rich
// ──────────────────────────────────────────────────────────────────────────────
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  bool _isBioExpanded = false;
  bool _isOpenToWork = true;
  late AnimationController _animController;
  late Animation<double> _counterAnim;
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  // Profile completion data
  final double _profileCompletion = 0.75;
  final List<String> _completionTips = [
    'Add a profile photo',
    'Write a headline',
    'Add 3+ skills',
  ];

  // Achievement badges
  final List<Map<String, dynamic>> _badges = [
    {'icon': Icons.rocket_launch, 'label': 'Early Adopter', 'color': const Color(0xFFFF6B35)},
    {'icon': Icons.military_tech, 'label': 'Top Contributor', 'color': const Color(0xFFFFD700)},
    {'icon': Icons.diversity_3, 'label': 'Mentor Star', 'color': const Color(0xFF00C9A7)},
    {'icon': Icons.emoji_events, 'label': 'Event Champion', 'color': const Color(0xFF845EC2)},
    {'icon': Icons.code, 'label': 'Code Ninja', 'color': const Color(0xFF0089BA)},
  ];

  // Skills with endorsements
  final List<Map<String, dynamic>> _skills = [
    {'name': 'Flutter', 'endorsements': 24, 'isTop': true},
    {'name': 'Dart', 'endorsements': 19, 'isTop': true},
    {'name': 'Firebase', 'endorsements': 16, 'isTop': true},
    {'name': 'Mobile App Dev', 'endorsements': 12, 'isTop': false},
    {'name': 'Git & GitHub', 'endorsements': 9, 'isTop': false},
    {'name': 'UI/UX Design', 'endorsements': 7, 'isTop': false},
    {'name': 'REST API', 'endorsements': 5, 'isTop': false},
    {'name': 'Cloud Architecture', 'endorsements': 3, 'isTop': false},
  ];

  // Certifications
  final List<Map<String, String>> _certifications = [
    {
      'title': 'Google Associate Android Developer',
      'issuer': 'Google',
      'date': 'Aug 2024',
      'credential': 'GCP-AAD-2024',
    },
    {
      'title': 'Firebase Cloud Fundamentals',
      'issuer': 'Google Cloud',
      'date': 'May 2024',
      'credential': 'FCF-2024-BQ',
    },
  ];

  // Projects
  final List<Map<String, dynamic>> _projects = [
    {
      'title': 'EDU Connect Mobile',
      'description': 'Alumni networking app with real-time chat & event management.',
      'tech': ['Flutter', 'Firebase', 'Riverpod'],
      'color': const Color(0xFF670627),
    },
    {
      'title': 'Smart Campus IoT',
      'description': 'IoT dashboard for campus facility management and monitoring.',
      'tech': ['React', 'Node.js', 'MQTT'],
      'color': const Color(0xFF0089BA),
    },
    {
      'title': 'HealthTrack AI',
      'description': 'AI-powered health monitoring with predictive analytics.',
      'tech': ['Python', 'TensorFlow', 'Flutter'],
      'color': const Color(0xFF00C9A7),
    },
  ];

  // Recent activity
  final List<Map<String, dynamic>> _recentActivity = [
    {
      'action': 'Commented on',
      'target': '"Best practices for Flutter state management"',
      'time': '2h ago',
      'icon': Icons.chat_bubble_outline,
    },
    {
      'action': 'Liked',
      'target': 'Annual Alumni Meetup 2024 post',
      'time': '5h ago',
      'icon': Icons.favorite_border,
    },
    {
      'action': 'Shared',
      'target': '"My journey from student to SDE at Google"',
      'time': '1d ago',
      'icon': Icons.share_outlined,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _counterAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _scrollController.addListener(() {
      setState(() => _scrollOffset = _scrollController.offset);
    });
    // Start counter animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final user = userAsync.value;

    if (user == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F3F0),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.mulledWine),
        ),
      );
    }

    final isStudent = user.role.name.toLowerCase() == 'student';
    const userDepartment = 'Computer Science & Engineering';
    const userBatch = '2024';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F0),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Parallax Cover + Avatar Header
          SliverToBoxAdapter(
            child: _buildHeroHeader(
              fullName: user.fullName.isNotEmpty ? user.fullName : 'Akram Rafid',
              role: user.role.name.toUpperCase(),
              email: user.email,
              isStudent: isStudent,
              department: userDepartment,
              batchYear: userBatch,
            ),
          ),
          // Content cards
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 12),
                _buildProfileCompletionCard(),
                const SizedBox(height: 12),
                _buildAchievementBadgesCard(),
                const SizedBox(height: 12),
                _buildOpenToStatusCard(isStudent),
                const SizedBox(height: 12),
                _buildAnimatedAnalyticsCard(),
                const SizedBox(height: 12),
                _buildProfileStrengthMeter(),
                const SizedBox(height: 12),
                _buildAboutCard(user.fullName),
                const SizedBox(height: 12),
                _buildRecentActivityCard(),
                const SizedBox(height: 12),
                _buildExperienceCard(isStudent),
                const SizedBox(height: 12),
                _buildEducationCard(userDepartment, userBatch),
                const SizedBox(height: 12),
                _buildCertificationsCard(),
                const SizedBox(height: 12),
                _buildProjectsCard(),
                const SizedBox(height: 12),
                _buildSkillsCard(),
                const SizedBox(height: 12),
                _buildQuickConnectActions(),
                const SizedBox(height: 12),
                _buildAccountSettingsCard(
                  user.verificationStatus.name.toUpperCase(),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 1. HERO HEADER — Tall gradient + mesh overlay + parallax avatar
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildHeroHeader({
    required String fullName,
    required String role,
    required String email,
    required bool isStudent,
    required String department,
    required String batchYear,
  }) {
    final parallax = (_scrollOffset * 0.4).clamp(0.0, 60.0);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Cover banner with mesh pattern ──
          Stack(
            clipBehavior: Clip.none,
            children: [
              Transform.translate(
                offset: Offset(0, -parallax),
                child: Container(
                  height: 170,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF670627),
                        Color(0xFF3D0018),
                        Color(0xFF1A000B),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Mesh pattern overlay
                      CustomPaint(
                        size: const Size(double.infinity, 170),
                        painter: _MeshPatternPainter(),
                      ),
                      // Camera icon
                      Positioned(
                        right: 16,
                        top: 48,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Cover photo update coming soon!'),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white70,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ── Avatar with gradient glow ring ──
              Positioned(
                bottom: -50,
                left: 24,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF670627).withOpacity(0.35),
                        blurRadius: 24,
                        spreadRadius: 4,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Gradient glow ring
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF670627),
                              Color(0xFFFF6B35),
                              Color(0xFFFFD700),
                              Color(0xFF670627),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const CircleAvatar(
                            radius: 46,
                            backgroundImage: NetworkImage(
                              'https://i.pravatar.cc/150?img=11',
                            ),
                          ),
                        ),
                      ),
                      // Verified badge
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.verified,
                            color: Color(0xFF0A66C2),
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 58),

          // ── Name, headline, details ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        fullName,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1A0A0E),
                          letterSpacing: -0.8,
                          height: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF670627), Color(0xFF8B0A3A)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF670627).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        role,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  isStudent
                      ? 'BSc in $department Student @ East Delta University | Tech & Mobile App Enthusiast'
                      : 'Software Engineer | East Delta University Alumni ($department)',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A3040),
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                // Info chips
                Wrap(
                  spacing: 6,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(Icons.school_outlined, 'EDU • Batch $batchYear'),
                    _buildInfoChip(Icons.location_on_outlined, 'Chittagong, BD'),
                    _buildInfoChip(Icons.email_outlined, email, isAccent: true),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Action buttons ──
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF670627), Color(0xFF8B0A3A)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF670627).withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => context.push('${AppRoutes.profile}/edit'),
                          icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.white),
                          label: const Text(
                            'Edit Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF670627).withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _showShareProfileModal(fullName),
                          borderRadius: BorderRadius.circular(16),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 13,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.qr_code_scanner,
                                  size: 18,
                                  color: Color(0xFF670627),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Share',
                                  style: TextStyle(
                                    color: Color(0xFF670627),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, {bool isAccent = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isAccent
            ? const Color(0xFF670627).withOpacity(0.08)
            : const Color(0xFFF5F3F0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isAccent ? const Color(0xFF670627) : const Color(0xFF6B4A52),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isAccent ? const Color(0xFF670627) : const Color(0xFF6B4A52),
                fontWeight: isAccent ? FontWeight.w600 : FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 2. PROFILE COMPLETION PROGRESS RING
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildProfileCompletionCard() {
    return _buildCard(
      child: Row(
        children: [
          // Animated circular progress
          AnimatedBuilder(
            animation: _counterAnim,
            builder: (context, child) {
              return SizedBox(
                width: 72,
                height: 72,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 72,
                      height: 72,
                      child: CircularProgressIndicator(
                        value: _profileCompletion * _counterAnim.value,
                        strokeWidth: 6,
                        backgroundColor: const Color(0xFFEDE7E3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF670627),
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Text(
                      '${(_profileCompletion * 100 * _counterAnim.value).toInt()}%',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF670627),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile Strength',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A0A0E),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Complete your profile to boost visibility',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B4A52),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: _completionTips.map((tip) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.add_circle_outline,
                            size: 12,
                            color: Color(0xFFB8860B),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            tip,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFFB8860B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 3. ACHIEVEMENT BADGES — Horizontal scroll
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildAchievementBadgesCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.workspace_premium, color: Color(0xFFFFD700), size: 22),
              SizedBox(width: 8),
              Text(
                'Achievements',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A0A0E),
                ),
              ),
              Spacer(),
              Text(
                '5 earned',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B4A52),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _badges.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final badge = _badges[index];
                return Container(
                  width: 85,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (badge['color'] as Color).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (badge['color'] as Color).withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (badge['color'] as Color).withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          badge['icon'] as IconData,
                          color: badge['color'] as Color,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        badge['label'] as String,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: badge['color'] as Color,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
  // 4. OPEN-TO STATUS TOGGLE
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildOpenToStatusCard(bool isStudent) {
    return _buildCard(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF670627).withOpacity(0.06),
              const Color(0xFF670627).withOpacity(0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF670627).withOpacity(0.12),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF670627), Color(0xFF8B0A3A)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF670627).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.work_outline, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isStudent
                        ? 'Open to Internships & Mentorship'
                        : 'Open to Mentoring Students',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A0A0E),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    isStudent
                        ? 'Recruiters & alumni can see you are seeking opportunities.'
                        : 'Students can reach out to you for guidance.',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF6B4A52)),
                  ),
                ],
              ),
            ),
            Transform.scale(
              scale: 0.9,
              child: Switch(
                value: _isOpenToWork,
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF670627),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFCCC5C0),
                onChanged: (val) => setState(() => _isOpenToWork = val),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 5. ANIMATED ANALYTICS — Individual frosted-glass cards with trends
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildAnimatedAnalyticsCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Analytics & Insights',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A0A0E),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3F0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_outline, size: 12, color: Color(0xFF6B4A52)),
                    SizedBox(width: 4),
                    Text(
                      'Private to you',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B4A52),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _counterAnim,
            builder: (context, child) {
              return Row(
                children: [
                  Expanded(
                    child: _buildAnalyticMetricCard(
                      icon: Icons.remove_red_eye_outlined,
                      value: (142 * _counterAnim.value).toInt(),
                      label: 'Profile Views',
                      trend: '+12%',
                      trendUp: true,
                      color: const Color(0xFF670627),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildAnalyticMetricCard(
                      icon: Icons.people_outline,
                      value: (48 * _counterAnim.value).toInt(),
                      label: 'Connections',
                      trend: '+5',
                      trendUp: true,
                      color: const Color(0xFF0089BA),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildAnalyticMetricCard(
                      icon: Icons.search_outlined,
                      value: (29 * _counterAnim.value).toInt(),
                      label: 'Searches',
                      trend: '+8%',
                      trendUp: true,
                      color: const Color(0xFF00C9A7),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticMetricCard({
    required IconData icon,
    required int value,
    required String label,
    required String trend,
    required bool trendUp,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.12)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF6B4A52),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: trendUp
                  ? const Color(0xFF00C9A7).withOpacity(0.12)
                  : const Color(0xFFD32F2F).withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  trendUp ? Icons.trending_up : Icons.trending_down,
                  size: 10,
                  color: trendUp ? const Color(0xFF00C9A7) : const Color(0xFFD32F2F),
                ),
                const SizedBox(width: 2),
                Text(
                  trend,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: trendUp ? const Color(0xFF00C9A7) : const Color(0xFFD32F2F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 6. PROFILE STRENGTH METER — Segmented bar
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildProfileStrengthMeter() {
    const levels = ['Beginner', 'Intermediate', 'Advanced', 'Expert', 'All-Star'];
    final currentLevel = (_profileCompletion * 5).floor().clamp(0, 4);

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Profile Level',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A0A0E),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  levels[currentLevel],
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: List.generate(5, (index) {
              final isActive = index <= currentLevel;
              final colors = [
                const Color(0xFFD32F2F),
                const Color(0xFFFF6B35),
                const Color(0xFFFFD700),
                const Color(0xFF00C9A7),
                const Color(0xFF0089BA),
              ];
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  height: 8,
                  margin: EdgeInsets.only(right: index < 4 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: isActive ? colors[index] : const Color(0xFFEDE7E3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: levels.map((l) {
              return Text(
                l,
                style: const TextStyle(fontSize: 8, color: Color(0xFF6B4A52)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 7. ABOUT / BIO
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildAboutCard(String fullName) {
    const defaultBio =
        'Passionate computer science student dedicated to building scalable mobile apps and exploring cloud architectures. Always eager to connect with East Delta University alumni and industry professionals. Currently focused on Flutter development, Firebase ecosystem, and machine learning applications.';

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'About',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A0A0E),
                ),
              ),
              _buildEditButton(() => context.push('${AppRoutes.profile}/edit')),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            defaultBio,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4A3040),
              height: 1.6,
            ),
            maxLines: _isBioExpanded ? null : 3,
            overflow: _isBioExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => _isBioExpanded = !_isBioExpanded),
            child: Text(
              _isBioExpanded ? 'Show less' : 'See more',
              style: const TextStyle(
                color: Color(0xFF670627),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 8. RECENT ACTIVITY FEED
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildRecentActivityCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bolt, color: Color(0xFFFF6B35), size: 22),
              SizedBox(width: 8),
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A0A0E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...List.generate(_recentActivity.length, (index) {
            final activity = _recentActivity[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < _recentActivity.length - 1 ? 12 : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F3F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      activity['icon'] as IconData,
                      size: 16,
                      color: const Color(0xFF670627),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1A0A0E),
                              height: 1.3,
                            ),
                            children: [
                              TextSpan(
                                text: '${activity['action']} ',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              TextSpan(
                                text: activity['target'] as String,
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          activity['time'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF6B4A52),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 9. EXPERIENCE
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildExperienceCard(bool isStudent) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Experience',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A0A0E),
                ),
              ),
              _buildAddButton(() => context.push('${AppRoutes.profile}/edit')),
            ],
          ),
          const SizedBox(height: 16),
          _buildExperienceItem(
            title: isStudent ? 'Software Engineering Intern' : 'Senior Software Engineer',
            company: 'Tech Solutions Ltd.',
            employmentType: 'Full-time',
            dates: 'Jan 2024 - Present • 8 mos',
            location: 'Chittagong, Bangladesh',
            description:
                'Developing cross-platform Flutter applications, optimizing Firebase queries, and collaborating with cross-functional teams.',
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceItem({
    required String title,
    required String company,
    required String employmentType,
    required String dates,
    required String location,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF670627).withOpacity(0.12),
                const Color(0xFF670627).withOpacity(0.06),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.business_center_outlined,
            color: Color(0xFF670627),
            size: 22,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A0A0E),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '$company • $employmentType',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF4A3040),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dates,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B4A52)),
              ),
              const SizedBox(height: 2),
              Text(
                location,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B4A52)),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF4A3040),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 10. EDUCATION
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildEducationCard(String department, String batchYear) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Education',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A0A0E),
                ),
              ),
              _buildEditButton(() => context.push('${AppRoutes.profile}/edit')),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF0089BA).withOpacity(0.12),
                      const Color(0xFF0089BA).withOpacity(0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.account_balance_outlined,
                  color: Color(0xFF0089BA),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'East Delta University',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A0A0E),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Bachelor of Science — BSc, $department',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF4A3040),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '2020 - $batchYear',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B4A52),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 11. CERTIFICATIONS & COURSES
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildCertificationsCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.card_membership, color: Color(0xFF845EC2), size: 22),
              const SizedBox(width: 8),
              const Text(
                'Licenses & Certifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A0A0E),
                ),
              ),
              const Spacer(),
              _buildAddButton(() => context.push('${AppRoutes.profile}/edit')),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(_certifications.length, (index) {
            final cert = _certifications[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < _certifications.length - 1 ? 16 : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF845EC2).withOpacity(0.12),
                          const Color(0xFF845EC2).withOpacity(0.06),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.workspace_premium,
                      color: Color(0xFF845EC2),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cert['title']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A0A0E),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          cert['issuer']!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF4A3040),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Issued ${cert['date']!} • ID: ${cert['credential']!}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF6B4A52),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.open_in_new,
                      size: 16,
                      color: Color(0xFF670627),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Credential verification coming soon!')),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 12. PROJECTS & PORTFOLIO
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildProjectsCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.code_outlined, color: Color(0xFF0089BA), size: 22),
              const SizedBox(width: 8),
              const Text(
                'Projects & Portfolio',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A0A0E),
                ),
              ),
              const Spacer(),
              _buildAddButton(() => context.push('${AppRoutes.profile}/edit')),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 155,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _projects.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final project = _projects[index];
                return Container(
                  width: 220,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (project['color'] as Color).withOpacity(0.06),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: (project['color'] as Color).withOpacity(0.15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: (project['color'] as Color).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.folder_outlined,
                              color: project['color'] as Color,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              project['title'] as String,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: project['color'] as Color,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        project['description'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4A3040),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Wrap(
                        spacing: 4,
                        children: (project['tech'] as List<String>).map((t) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: (project['color'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              t,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: project['color'] as Color,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
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
  // 13. SKILLS WITH ENDORSEMENT COUNTS
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildSkillsCard() {
    final maxEndorsement = _skills.map((s) => s['endorsements'] as int).reduce(max);

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Skills & Endorsements',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A0A0E),
                ),
              ),
              _buildAddButton(() => context.push('${AppRoutes.profile}/edit')),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(_skills.length, (index) {
            final skill = _skills[index];
            final progress = (skill['endorsements'] as int) / maxEndorsement;
            final isTop = skill['isTop'] as bool;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < _skills.length - 1 ? 12 : 0,
              ),
              child: Row(
                children: [
                  if (isTop)
                    const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(
                        Icons.emoji_events,
                        size: 14,
                        color: Color(0xFFFFD700),
                      ),
                    ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      skill['name'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isTop ? FontWeight.w700 : FontWeight.w500,
                        color: const Color(0xFF1A0A0E),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: AnimatedBuilder(
                      animation: _counterAnim,
                      builder: (context, child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress * _counterAnim.value,
                            backgroundColor: const Color(0xFFEDE7E3),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isTop
                                  ? const Color(0xFF670627)
                                  : const Color(0xFF670627).withOpacity(0.5),
                            ),
                            minHeight: 6,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '${skill['endorsements']}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isTop
                            ? const Color(0xFF670627)
                            : const Color(0xFF6B4A52),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 14. QUICK CONNECT ACTIONS
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildQuickConnectActions() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Connect',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A0A0E),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildQuickAction(
                  icon: Icons.link,
                  label: 'LinkedIn',
                  color: const Color(0xFF0A66C2),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('LinkedIn integration coming soon!')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildQuickAction(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  color: const Color(0xFF670627),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening email client...')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildQuickAction(
                  icon: Icons.contact_page_outlined,
                  label: 'vCard',
                  color: const Color(0xFF00C9A7),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('vCard download coming soon!')),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 15. ACCOUNT & SECURITY
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildAccountSettingsCard(String verificationStatus) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account & Security',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A0A0E),
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsRow(
            icon: Icons.verified_user_outlined,
            label: 'Verification Status',
            value: verificationStatus,
            valueColor: verificationStatus == 'VERIFIED'
                ? const Color(0xFF00C9A7)
                : const Color(0xFFFF6B35),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: const Color(0xFF6B4A52).withOpacity(0.12), height: 1),
          ),
          _buildSettingsRow(
            icon: Icons.shield_outlined,
            label: 'Privacy & Data Protection',
            value: 'Protected',
            valueColor: const Color(0xFF00C9A7),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: const Color(0xFF6B4A52).withOpacity(0.12), height: 1),
          ),
          _buildSettingsRow(
            icon: Icons.notifications_outlined,
            label: 'Notification Preferences',
            value: 'On',
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFD32F2F).withOpacity(0.3),
                ),
              ),
              child: Material(
                color: const Color(0xFFD32F2F).withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: _showSignOutConfirmation,
                  borderRadius: BorderRadius.circular(16),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: Color(0xFFD32F2F), size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Sign Out',
                          style: TextStyle(
                            color: Color(0xFFD32F2F),
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF670627), size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1A0A0E),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: (valueColor ?? const Color(0xFF6B4A52)).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: valueColor ?? const Color(0xFF6B4A52),
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // MODALS
  // ════════════════════════════════════════════════════════════════════════════
  void _showShareProfileModal(String fullName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFEDE7E3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF670627).withOpacity(0.06),
                    const Color(0xFF670627).withOpacity(0.02),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF670627).withOpacity(0.1),
                ),
              ),
              child: const Icon(
                Icons.qr_code_2,
                size: 120,
                color: Color(0xFF670627),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              fullName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1A0A0E),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'East Delta University Professional Profile',
              style: TextStyle(
                color: Color(0xFF6B4A52),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),
            // Share options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                  icon: Icons.copy,
                  label: 'Copy Link',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile link copied to clipboard!'),
                      ),
                    );
                  },
                ),
                _buildShareOption(
                  icon: Icons.chat_outlined,
                  label: 'WhatsApp',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('WhatsApp share coming soon!')),
                    );
                  },
                ),
                _buildShareOption(
                  icon: Icons.work_outline,
                  label: 'LinkedIn',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('LinkedIn share coming soon!')),
                    );
                  },
                ),
                _buildShareOption(
                  icon: Icons.share_outlined,
                  label: 'More',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Share options coming soon!')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F3F0),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF670627).withOpacity(0.1),
              ),
            ),
            child: Icon(icon, color: const Color(0xFF670627), size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A3040),
            ),
          ),
        ],
      ),
    );
  }

  void _showSignOutConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFD32F2F).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout,
                  color: Color(0xFFD32F2F),
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A0A0E),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Are you sure you want to sign out of EDU Alumni Connect?',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B4A52),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFEDE7E3)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFF6B4A52),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFD32F2F).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          ref.read(signOutUseCaseProvider).call();
                          context.go(AppRoutes.login);
                        },
                        child: const Text(
                          'Sign Out',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
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

  // ════════════════════════════════════════════════════════════════════════════
  // SHARED HELPERS
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildEditButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F3F0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.edit_outlined,
          size: 16,
          color: Color(0xFF670627),
        ),
      ),
    );
  }

  Widget _buildAddButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF670627).withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.add,
          size: 16,
          color: Color(0xFF670627),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// MESH PATTERN PAINTER — Decorative cover overlay
// ════════════════════════════════════════════════════════════════════════════════
class _MeshPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    const spacing = 24.0;
    // Diagonal lines
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing * 1.5) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Subtle glow circles
    final glowPaint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.3),
      60,
      glowPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.7),
      40,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
