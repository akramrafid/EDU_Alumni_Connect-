import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../data/models/alumni_directory_model.dart';

class AlumniProfilePage extends ConsumerWidget {
  final String? alumniId;

  const AlumniProfilePage({super.key, this.alumniId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetId = alumniId ?? 'saima_rahman';

    return FutureBuilder(
      future: ref.read(directoryRepositoryProvider).getAlumniProfile(targetId),
      builder: (context, snapshot) {
        final alumni = snapshot.data?.fold((l) => null, (r) => r) ??
            AlumniDirectoryModel(
              uid: targetId,
              fullName: 'Saima Rahman',
              department: 'CSE',
              batchYear: 2018,
              currentCompany: 'Google',
              jobTitle: 'Senior Software Engineer',
              skills: const ['Flutter', 'System Architecture', 'GCP'],
              location: 'San Francisco, CA',
              photoUrl: 'https://i.pravatar.cc/150?img=5',
              bio:
                  'Building next-gen Android and cross-platform mobile apps. Excited to connect with EDU students!',
              openToMentorship: true,
            );

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeaderAndStats(context, alumni),
                    const SizedBox(height: 24),
                    _buildAboutSection(alumni),
                    const SizedBox(height: 16),
                    _buildExpertiseSection(alumni),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              Positioned(
                bottom: 32,
                left: 24,
                right: 24,
                child: _buildMessageButton(context, ref, alumni),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderAndStats(BuildContext context, AlumniDirectoryModel alumni) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        const SizedBox(height: 360),
        Container(
          height: 320,
          decoration: const BoxDecoration(
            color: AppColors.mulledWine,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 8),
              UserAvatar(
                photoUrl: alumni.photoUrl,
                fullName: alumni.fullName,
                radius: 46,
              ),
              const SizedBox(height: 12),
              Text(
                alumni.fullName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                alumni.displayRole,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(AlumniDirectoryModel alumni) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            alumni.bio ?? 'No bio provided.',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpertiseSection(AlumniDirectoryModel alumni) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Skills & Expertise',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: alumni.skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDEAEA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  skill,
                  style: const TextStyle(
                    color: AppColors.mulledWine,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageButton(
      BuildContext context, WidgetRef ref, AlumniDirectoryModel alumni) {
    return ElevatedButton(
      onPressed: () async {
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
        backgroundColor: AppColors.mulledWine,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        elevation: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            'Message ${alumni.fullName}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
