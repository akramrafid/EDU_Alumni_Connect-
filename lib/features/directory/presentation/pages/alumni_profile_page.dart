import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../data/data_sources/alumni_mock_data.dart';
import '../../data/models/alumni_directory_model.dart';

class AlumniProfilePage extends ConsumerWidget {
  final String? alumniId;

  const AlumniProfilePage({super.key, this.alumniId});

  AlumniDirectoryModel _findAlumni(String? id) {
    if (id == null || id.isEmpty) return allMockAlumni.first;
    final q = id.trim().toLowerCase();
    return allMockAlumni.where((a) {
      final uidLower = a.uid.toLowerCase();
      final nameLower = a.fullName.toLowerCase();
      final slug = a.fullName.toLowerCase().replaceAll(' ', '_');
      return uidLower == q ||
          nameLower == q ||
          slug == q ||
          uidLower.contains(q) ||
          q.contains(uidLower);
    }).firstOrNull ?? allMockAlumni.first;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetId = alumniId ?? 'saima_rahman';
    final fallbackAlumni = _findAlumni(targetId);

    return FutureBuilder(
      future: ref.read(directoryRepositoryProvider).getAlumniProfile(targetId),
      builder: (context, snapshot) {
        final alumni = snapshot.data?.fold((l) => null, (r) => r) ?? fallbackAlumni;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Hero Cover Banner & Avatar Header
                    _buildHeroHeader(context, alumni),
                    const SizedBox(height: 16),

                    // 2. Stats Deck
                    _buildQuickStatsDeck(),
                    const SizedBox(height: 20),

                    // 3. About & Bio Card
                    _buildAboutCard(alumni),
                    const SizedBox(height: 16),

                    // 4. Skills & Expertise Card
                    _buildSkillsCard(alumni),
                    const SizedBox(height: 16),

                    // 5. Professional Timeline & Education
                    _buildExperienceCard(alumni),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // 6. Floating Action Dock at Bottom
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: _buildFloatingActionDock(context, ref, alumni),
              ),
            ],
          ),
        );
      },
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 1. HERO COVER & PROFILE HEADER
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildHeroHeader(BuildContext context, AlumniDirectoryModel alumni) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Brand Mesh Gradient Cover Banner
        Container(
          height: 180,
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
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(28),
            ),
          ),
          child: Stack(
            children: [
              // Subtle background circle light
              Positioned(
                right: -40,
                top: -40,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              // App Bar Action Buttons
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.3),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                          onPressed: () => context.pop(),
                        ),
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black.withValues(alpha: 0.3),
                            child: IconButton(
                              icon: const Icon(Icons.bookmark_border_rounded, color: Colors.white, size: 20),
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Bookmarked ${alumni.fullName}!'),
                                    backgroundColor: const Color(0xFF00C9A7),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: Colors.black.withValues(alpha: 0.3),
                            child: IconButton(
                              icon: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Shared ${alumni.fullName}\'s profile!'),
                                    backgroundColor: AppColors.mulledWine,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Profile Avatar & Main Identity Info
        Padding(
          padding: const EdgeInsets.only(top: 120, left: 24, right: 24),
          child: Column(
            children: [
              // Avatar with 3D Ring & Verified Badge
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: UserAvatar(
                      photoUrl: alumni.photoUrl,
                      fullName: alumni.fullName,
                      radius: 48,
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Color(0xFF00C9A7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Full Name
              Text(
                alumni.fullName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A0A0E),
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),

              // Role & Company Pill
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    alumni.jobTitle ?? 'Alumni',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF670627),
                    ),
                  ),
                  if (alumni.currentCompany != null) ...[
                    const Text(' at ', style: TextStyle(fontSize: 14, color: Color(0xFF8C7A82))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF670627).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        alumni.currentCompany!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF670627),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),

              // Sub-info: Dept, Batch, Location
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school_rounded, size: 14, color: Color(0xFF8C7A82)),
                  const SizedBox(width: 4),
                  Text(
                    '${alumni.department} \'${alumni.batchYear}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B4A52),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.location_on_rounded, size: 14, color: Color(0xFF8C7A82)),
                  const SizedBox(width: 2),
                  Text(
                    alumni.location ?? 'Worldwide',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B4A52),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Mentorship Availability Tag
              if (alumni.openToMentorship == true)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C9A7).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF00C9A7).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 8, color: Color(0xFF00C9A7)),
                      SizedBox(width: 6),
                      Text(
                        'Open for Mentorship & Career Guidance',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF00897B),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 2. QUICK STATS COUNTER DECK
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildQuickStatsDeck() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEAE7E2)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('14+', 'Mentored'),
            _buildStatDivider(),
            _buildStatItem('4.9 ★', 'Rating'),
            _buildStatDivider(),
            _buildStatItem('2.4k', 'Network'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String val, String label) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color(0xFF670627),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF8C7A82),
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 24,
      color: const Color(0xFFEAE7E2),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 3. ABOUT CARD
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildAboutCard(AlumniDirectoryModel alumni) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEAE7E2)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.person_outline_rounded, color: Color(0xFF670627), size: 20),
                SizedBox(width: 8),
                Text(
                  'About',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A0A0E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              alumni.bio ?? 'No biography provided.',
              style: const TextStyle(
                fontSize: 13.5,
                color: Color(0xFF5A4A52),
                height: 1.55,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 4. SKILLS & EXPERTISE CARD
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildSkillsCard(AlumniDirectoryModel alumni) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEAE7E2)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.psychology_outlined, color: Color(0xFF670627), size: 20),
                SizedBox(width: 8),
                Text(
                  'Skills & Expertise',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A0A0E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 10,
              children: alumni.skills.map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF670627).withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF670627).withValues(alpha: 0.12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt_rounded, size: 14, color: Color(0xFF670627)),
                      const SizedBox(width: 4),
                      Text(
                        skill,
                        style: const TextStyle(
                          color: Color(0xFF670627),
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
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
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 5. EXPERIENCE & EDUCATION TIMELINE
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildExperienceCard(AlumniDirectoryModel alumni) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEAE7E2)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.work_outline_rounded, color: Color(0xFF670627), size: 20),
                SizedBox(width: 8),
                Text(
                  'Career & Education',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A0A0E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Current Role
            _buildTimelineItem(
              icon: Icons.business_center_rounded,
              title: alumni.jobTitle ?? 'Senior Software Engineer',
              subtitle: '${alumni.currentCompany ?? "Google"} • Full-time',
              date: '2022 - Present',
              isLast: false,
            ),

            // Education
            _buildTimelineItem(
              icon: Icons.school_rounded,
              title: 'B.Sc. in ${alumni.department}',
              subtitle: 'East Delta University (Batch of ${alumni.batchYear})',
              date: 'Graduated ${alumni.batchYear}',
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String date,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF670627).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: const Color(0xFF670627)),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 32,
                color: const Color(0xFFEAE7E2),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A0A0E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B4A52),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF8C7A82),
                ),
              ),
              if (!isLast) const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 6. FLOATING DOCK ACTION BUTTONS
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildFloatingActionDock(
      BuildContext context, WidgetRef ref, AlumniDirectoryModel alumni) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF670627).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Primary Message Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () async {
                HapticFeedback.mediumImpact();
                final chatRepo = ref.read(chatRepositoryProvider);
                final result = await chatRepo.getOrCreateConversation(alumni.uid);
                result.fold(
                  (failure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(failure.message)),
                    );
                  },
                  (convId) {
                    context.push('${AppRoutes.chat}/$convId');
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF670627),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 20),
              label: Text(
                'Message ${alumni.fullName.split(" ").first}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

