import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../directory/data/models/alumni_directory_model.dart';
import '../../../directory/presentation/providers/directory_provider.dart';
import '../providers/mentorship_provider.dart';

class MentorsPage extends ConsumerStatefulWidget {
  const MentorsPage({super.key});

  @override
  ConsumerState<MentorsPage> createState() => _MentorsPageState();
}

class _MentorsPageState extends ConsumerState<MentorsPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showRequestDialog(AlumniDirectoryModel mentor) {
    final messageController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Request Mentorship from ${mentor.fullName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Introduce yourself and state what goals you hope to achieve:',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Hi ${mentor.fullName}, I would love your guidance on...',
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final text = messageController.text.trim();
              if (text.length < 10) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter at least 10 characters.'),
                  ),
                );
                return;
              }
              Navigator.pop(context);
              final success = await ref
                  .read(mentorshipActionNotifierProvider.notifier)
                  .sendRequest(alumniId: mentor.uid, message: text);

              if (mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mentorship request sent successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to send request.'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mulledWine,
            ),
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mentorsAsync = ref.watch(mentorsListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          Expanded(
            child: mentorsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (mentors) {
                final displayMentors = mentors.isNotEmpty
                    ? mentors
                    : _mockFallbackMentors();

                final filtered = _searchController.text.trim().isEmpty
                    ? displayMentors
                    : displayMentors
                        .where((m) =>
                            m.fullName.toLowerCase().contains(
                                _searchController.text.trim().toLowerCase()) ||
                            m.displayRole.toLowerCase().contains(
                                _searchController.text.trim().toLowerCase()))
                        .toList();

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final mentor = filtered[index];
                    return _buildMentorCard(
                      mentor: mentor,
                      onRequest: () => _showRequestDialog(mentor),
                    );
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
                'Mentors',
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                icon: Icon(Icons.search, color: Colors.black54),
                hintText: 'Search by name, industry, or company...',
                hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentorCard({
    required AlumniDirectoryModel mentor,
    required VoidCallback onRequest,
  }) {
    final tags = [
      mentor.department,
      mentor.classYear,
      if (mentor.skills.isNotEmpty) mentor.skills.first,
    ];

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(
                  mentor.photoUrl ?? 'https://i.pravatar.cc/150?img=5',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mentor.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      mentor.displayRole,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) => _buildTag(tag)).toList(),
          ),
          if (mentor.bio != null && mentor.bio!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              mentor.bio!,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onRequest,
              icon: const Icon(Icons.handshake_outlined,
                  color: Colors.white, size: 18),
              label: const Text(
                'Request Mentorship',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mulledWine,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
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
        borderRadius: BorderRadius.circular(12),
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

  List<AlumniDirectoryModel> _mockFallbackMentors() {
    return [
      AlumniDirectoryModel(
        uid: 'saima_rahman',
        fullName: 'Saima Rahman',
        department: 'CSE',
        batchYear: 2014,
        currentCompany: 'TechFlow',
        jobTitle: 'Product Director',
        skills: ['Technology', 'Product Mgmt'],
        photoUrl: 'https://i.pravatar.cc/150?img=5',
        bio:
            'Passionate about building scalable B2B SaaS products. Happy to review resumes, prep for interviews.',
        openToMentorship: true,
      ),
      AlumniDirectoryModel(
        uid: 'mahir_chowdhury',
        fullName: 'Mahir Chowdhury',
        department: 'BBA',
        batchYear: 2008,
        currentCompany: 'Apex Cap',
        jobTitle: 'VP Finance',
        skills: ['Finance', 'Inv. Banking'],
        photoUrl: 'https://i.pravatar.cc/150?img=11',
        bio:
            'Over 15 years in M&A and corporate finance. Looking to mentor driven recent grads.',
        openToMentorship: true,
      ),
      AlumniDirectoryModel(
        uid: 'ananya_chowdhury',
        fullName: 'Dr. Ananya Chowdhury',
        department: 'CSE',
        batchYear: 2018,
        currentCompany: 'AI Dynamics',
        jobTitle: 'Senior Data Scientist',
        skills: ['Data Science', 'Machine Learning'],
        photoUrl: 'https://i.pravatar.cc/150?img=9',
        bio:
            'Specializing in NLP and predictive modeling. Can help with portfolio reviews.',
        openToMentorship: true,
      ),
    ];
  }
}
