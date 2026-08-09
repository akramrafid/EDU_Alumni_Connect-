import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/alumni_directory_model.dart';
import '../providers/directory_provider.dart';

class DirectoryPage extends ConsumerStatefulWidget {
  const DirectoryPage({super.key});

  @override
  ConsumerState<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends ConsumerState<DirectoryPage> {
  final _searchController = TextEditingController();
  String _selectedDept = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final directoryAsync = ref.watch(
      alumniDirectoryProvider(
        department: _selectedDept.isNotEmpty ? _selectedDept : null,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: directoryAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
                data: (alumniList) {
                  // Fallback to mock data if empty (e.g. dev mode without seeded Firestore data)
                  final displayList = alumniList.isNotEmpty
                      ? alumniList
                      : _mockFallbackAlumni();

                  final filteredList = _searchController.text.trim().isEmpty
                      ? displayList
                      : displayList
                          .where((a) => a.fullName
                              .toLowerCase()
                              .contains(_searchController.text.trim().toLowerCase()))
                          .toList();

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final person = filteredList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _AlumniCard(
                          alumni: person,
                          onTap: () => context
                              .push('${AppRoutes.directory}/${person.uid}'),
                          onConnect: () async {
                            final chatRepo = ref.read(chatRepositoryProvider);
                            final result = await chatRepo
                                .getOrCreateConversation(person.uid);
                            result.fold(
                              (failure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(failure.message),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              },
                              (convId) {
                                context.push('${AppRoutes.chat}/$convId');
                              },
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Directory',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() {}),
                    decoration: const InputDecoration(
                      icon: Icon(Icons.search, color: Colors.black54),
                      hintText: 'Search alumni, companies...',
                      hintStyle: TextStyle(color: Colors.black38),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              PopupMenuButton<String>(
                onSelected: (dept) => setState(() => _selectedDept = dept),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: '', child: Text('All Departments')),
                  const PopupMenuItem(value: 'CSE', child: Text('CSE')),
                  const PopupMenuItem(value: 'EEE', child: Text('EEE')),
                  const PopupMenuItem(value: 'BBA', child: Text('BBA')),
                  const PopupMenuItem(value: 'English', child: Text('English')),
                  const PopupMenuItem(
                      value: 'Economics', child: Text('Economics')),
                ],
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _selectedDept.isNotEmpty
                        ? AppColors.mulledWine
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.tune,
                    color: _selectedDept.isNotEmpty
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<AlumniDirectoryModel> _mockFallbackAlumni() {
    return [
      AlumniDirectoryModel(
        uid: 'saima_rahman',
        fullName: 'Saima Rahman',
        department: 'CSE',
        batchYear: 2018,
        currentCompany: 'Google',
        jobTitle: 'Senior Software Engineer',
        skills: ['Flutter', 'System Architecture', 'GCP'],
        location: 'San Francisco, CA',
        photoUrl: 'https://i.pravatar.cc/150?img=5',
        bio: 'Building next-gen Android and cross-platform mobile apps.',
        openToMentorship: true,
      ),
      AlumniDirectoryModel(
        uid: 'tousif_ahmed',
        fullName: 'Tousif Ahmed',
        department: 'BBA',
        batchYear: 2005,
        currentCompany: 'FinTech Solutions',
        jobTitle: 'Director of Product',
        skills: ['Product Strategy', 'FinTech', 'Leadership'],
        location: 'New York, NY',
        photoUrl: 'https://i.pravatar.cc/150?img=11',
        bio: 'Passionate about mobile banking and scaling digital products.',
        openToMentorship: true,
      ),
      AlumniDirectoryModel(
        uid: 'ananya_chowdhury',
        fullName: 'Dr. Ananya Chowdhury',
        department: 'CSE',
        batchYear: 2021,
        currentCompany: 'DesignCo',
        jobTitle: 'UX Researcher',
        skills: ['User Research', 'Design Systems', 'HCI'],
        location: 'Austin, TX',
        photoUrl: 'https://i.pravatar.cc/150?img=9',
        bio: 'Exploring human-centered design for social impact.',
        openToMentorship: true,
      ),
    ];
  }
}

class _AlumniCard extends StatelessWidget {
  final AlumniDirectoryModel alumni;
  final VoidCallback onTap;
  final VoidCallback onConnect;

  const _AlumniCard({
    required this.alumni,
    required this.onTap,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> tags = [
      alumni.classYear,
      if (alumni.location != null) alumni.location!,
    ];

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    alumni.photoUrl ?? 'https://i.pravatar.cc/150?img=11',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alumni.fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        alumni.displayRole,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            tags.map((tag) => _TagChip(label: tag)).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onConnect,
            icon: const Icon(Icons.person_add_alt_1,
                color: Colors.white, size: 18),
            label: const Text(
              'Connect',
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
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}
