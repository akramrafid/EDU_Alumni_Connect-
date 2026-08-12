import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isBioExpanded = false;
  bool _isOpenToWork = true;

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final user = userAsync.value;

    if (user == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF3F2EF),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.mulledWine),
        ),
      );
    }

    final isStudent = user.role.name.toLowerCase() == 'student';
    const userDepartment = 'Computer Science & Engineering';
    const userBatch = '2024';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F2EF), // LinkedIn light gray background
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          children: [
            // 1. Cover Photo & Profile Header Card
            _buildProfileHeaderCard(
              fullName: user.fullName.isNotEmpty ? user.fullName : 'Akram Rafid',
              role: user.role.name.toUpperCase(),
              email: user.email,
              isStudent: isStudent,
              department: userDepartment,
              batchYear: userBatch,
            ),
            const SizedBox(height: 12),

            // 2. Open To Work / Mentorship Banner
            _buildOpenToStatusCard(isStudent),
            const SizedBox(height: 12),

            // 3. Analytics & Insights Card (LinkedIn style)
            _buildAnalyticsCard(),
            const SizedBox(height: 12),

            // 4. About / Bio Section
            _buildAboutCard(user.fullName),
            const SizedBox(height: 12),

            // 5. Experience & Internships Section
            _buildExperienceCard(isStudent),
            const SizedBox(height: 12),

            // 6. Education Section
            _buildEducationCard(userDepartment, userBatch),
            const SizedBox(height: 12),

            // 7. Skills & Endorsements Section
            _buildSkillsCard(),
            const SizedBox(height: 12),

            // 8. Account Settings & Sign Out Section
            _buildAccountSettingsCard(user.verificationStatus.name.toUpperCase()),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeaderCard({
    required String fullName,
    required String role,
    required String email,
    required bool isStudent,
    required String department,
    required String batchYear,
  }) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Image Container
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 130,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.mulledWine,
                      Color(0xFF500000),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 16,
                      top: 40,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt_outlined, color: Colors.white70, size: 22),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cover photo update coming soon!')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Avatar overlapping banner
              Positioned(
                bottom: -44,
                left: 24,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 44,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified,
                          color: Color(0xFF0A66C2), // LinkedIn blue verified tick
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 52), // Space for overlapping avatar

          // Name & Details Body
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
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.mulledWine.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        role,
                        style: const TextStyle(
                          color: AppColors.mulledWine,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  isStudent
                      ? 'BSc in $department Student @ East Delta University | Tech & Mobile App Enthusiast'
                      : 'Software Engineer | East Delta University Alumni ($department)',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.school_outlined, size: 16, color: Colors.black54),
                    const SizedBox(width: 6),
                    Text(
                      'East Delta University • Batch $batchYear',
                      style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: Colors.black54),
                    const SizedBox(width: 6),
                    const Text(
                      'Chittagong, Bangladesh',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.email_outlined, size: 16, color: Colors.black54),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        email,
                        style: const TextStyle(fontSize: 13, color: AppColors.mulledWine, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Action Buttons Row (Edit Profile & Share)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context.push('${AppRoutes.profile}/edit'),
                        icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.white),
                        label: const Text(
                          'Edit Profile',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mulledWine,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        _showShareProfileModal(fullName);
                      },
                      icon: const Icon(Icons.qr_code_scanner, size: 18, color: AppColors.mulledWine),
                      label: const Text(
                        'Share',
                        style: TextStyle(color: AppColors.mulledWine, fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.mulledWine),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpenToStatusCard(bool isStudent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F6F8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFDCE6F1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF0A66C2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.work_outline, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isStudent ? 'Open to Internships & Mentorship' : 'Open to Mentoring Students',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isStudent
                        ? 'Recruiters & alumni can see you are seeking opportunities.'
                        : 'Students can reach out to you for guidance and referral advice.',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Switch(
              value: _isOpenToWork,
              activeColor: AppColors.mulledWine,
              onChanged: (val) {
                setState(() => _isOpenToWork = val);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Analytics & Insights',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.lock_outline, size: 14, color: Colors.black45),
                  SizedBox(width: 4),
                  Text(
                    'Private to you',
                    style: TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildAnalyticsMetric(
                icon: Icons.remove_red_eye_outlined,
                value: '142',
                label: 'Profile views',
              ),
              Container(height: 36, width: 1, color: Colors.grey.shade200),
              _buildAnalyticsMetric(
                icon: Icons.people_outline,
                value: '48',
                label: 'Connections',
              ),
              Container(height: 36, width: 1, color: Colors.grey.shade200),
              _buildAnalyticsMetric(
                icon: Icons.search_outlined,
                value: '29',
                label: 'Search appearances',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsMetric({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.mulledWine, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(String fullName) {
    const defaultBio =
        'Passionate computer science student dedicated to building scalable mobile apps and exploring cloud architectures. Always eager to connect with East Delta University alumni and industry professionals.';

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      width: double.infinity,
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
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.black54),
                onPressed: () => context.push('${AppRoutes.profile}/edit'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            defaultBio,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
            maxLines: _isBioExpanded ? null : 3,
            overflow: _isBioExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () {
              setState(() => _isBioExpanded = !_isBioExpanded);
            },
            child: Text(
              _isBioExpanded ? 'Show less' : 'see more',
              style: const TextStyle(
                color: AppColors.mulledWine,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(bool isStudent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      width: double.infinity,
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
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 22, color: Colors.black54),
                onPressed: () => context.push('${AppRoutes.profile}/edit'),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.mulledWine.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.business_center_outlined, color: AppColors.mulledWine, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$company • $employmentType',
                style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                dates,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 2),
              Text(
                location,
                style: const TextStyle(fontSize: 12, color: Colors.black45),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEducationCard(String department, String batchYear) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      width: double.infinity,
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
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.black54),
                onPressed: () => context.push('${AppRoutes.profile}/edit'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.mulledWine.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.account_balance_outlined, color: AppColors.mulledWine, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'East Delta University',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Bachelor of Science - BSc, $department',
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '2020 - $batchYear',
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
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

  Widget _buildSkillsCard() {
    final skills = ['Flutter', 'Dart', 'Firebase', 'Mobile App Dev', 'Git', 'UI/UX Design', 'REST API'];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      width: double.infinity,
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
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 22, color: Colors.black54),
                onPressed: () => context.push('${AppRoutes.profile}/edit'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F6F8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFDCE6F1)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_outlined, size: 14, color: AppColors.mulledWine),
                    const SizedBox(width: 6),
                    Text(
                      skill,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettingsCard(String verificationStatus) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account & Security',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsRow(
            icon: Icons.verified_user_outlined,
            label: 'Verification Status',
            value: verificationStatus,
            valueColor: verificationStatus == 'VERIFIED' ? Colors.green : Colors.orange,
          ),
          const Divider(height: 24),
          _buildSettingsRow(
            icon: Icons.lock_outline,
            label: 'Privacy & Data Protection',
            value: 'Protected',
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _showSignOutConfirmation();
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
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
            Icon(icon, color: AppColors.mulledWine, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.black54,
          ),
        ),
      ],
    );
  }

  void _showShareProfileModal(String fullName) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.qr_code_2, size: 100, color: AppColors.mulledWine),
            const SizedBox(height: 16),
            Text(
              fullName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'East Delta University Professional Profile',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile link copied to clipboard!')),
                );
              },
              icon: const Icon(Icons.copy, color: Colors.white, size: 18),
              label: const Text('Copy Profile Link', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mulledWine,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to sign out of EDU Alumni Connect?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(signOutUseCaseProvider).call();
              context.go(AppRoutes.login);
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
