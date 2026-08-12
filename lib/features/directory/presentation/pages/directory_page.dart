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
  bool _onlyOpenToMentorship = false;
  String _selectedRoleFilter = 'All';

  // Connected state tracker for interactive feedback
  final Set<String> _connectedUids = {'saima_rahman'};

  final List<String> _departments = [
    'All',
    'CSE',
    'EEE',
    'BBA',
    'English',
    'Economics',
    'Open to Mentorship',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final directoryAsync = ref.watch(
      alumniDirectoryProvider(
        department: (_selectedDept.isNotEmpty && _selectedDept != 'All' && _selectedDept != 'Open to Mentorship')
            ? _selectedDept
            : null,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildDepartmentFilterBar(),
            const SizedBox(height: 8),
            Expanded(
              child: directoryAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.mulledWine),
                ),
                error: (err, stack) {
                  final fallbackList = _mockFallbackAlumni();
                  return _buildDirectoryListView(fallbackList);
                },
                data: (alumniList) {
                  final displayList = alumniList.isNotEmpty
                      ? alumniList
                      : _mockFallbackAlumni();

                  return _buildDirectoryListView(displayList);
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
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Directory',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mulledWine,
                  letterSpacing: -0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.mulledWine.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.public, color: AppColors.mulledWine, size: 14),
                    SizedBox(width: 4),
                    Text(
                      '1,250+ Members',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mulledWine,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Connect with East Delta University students, alumni & faculty globally.',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  icon: const Icon(Icons.search, color: Colors.black45, size: 22),
                  hintText: 'Search by name, company, or skills...',
                  hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
                  border: InputBorder.none,
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18, color: Colors.black45),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _showAdvancedFilterModal,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: (_selectedDept.isNotEmpty || _onlyOpenToMentorship || _selectedRoleFilter != 'All')
                    ? AppColors.mulledWine
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.tune,
                color: (_selectedDept.isNotEmpty || _onlyOpenToMentorship || _selectedRoleFilter != 'All')
                    ? Colors.white
                    : Colors.black87,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentFilterBar() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _departments.length,
        itemBuilder: (context, index) {
          final dept = _departments[index];
          final bool isSelected = (_selectedDept == dept) ||
              (dept == 'All' && _selectedDept.isEmpty && !_onlyOpenToMentorship) ||
              (dept == 'Open to Mentorship' && _onlyOpenToMentorship);

          return GestureDetector(
            onTap: () {
              setState(() {
                if (dept == 'All') {
                  _selectedDept = '';
                  _onlyOpenToMentorship = false;
                } else if (dept == 'Open to Mentorship') {
                  _onlyOpenToMentorship = !_onlyOpenToMentorship;
                } else {
                  _selectedDept = isSelected ? '' : dept;
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.mulledWine : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.mulledWine : Colors.grey.shade300,
                ),
              ),
              child: Text(
                dept,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDirectoryListView(List<AlumniDirectoryModel> alumniList) {
    final query = _searchController.text.trim().toLowerCase();
    
    final filtered = alumniList.where((person) {
      // 1. Text Search Filter
      final matchesSearch = query.isEmpty ||
          person.fullName.toLowerCase().contains(query) ||
          (person.currentCompany?.toLowerCase().contains(query) ?? false) ||
          (person.jobTitle?.toLowerCase().contains(query) ?? false) ||
          (person.department.toLowerCase().contains(query)) ||
          person.skills.any((s) => s.toLowerCase().contains(query));

      // 2. Department Filter
      final matchesDept = _selectedDept.isEmpty ||
          _selectedDept == 'All' ||
          _selectedDept == 'Open to Mentorship' ||
          person.department.toUpperCase() == _selectedDept.toUpperCase();

      // 3. Mentorship Filter
      final matchesMentorship = !_onlyOpenToMentorship || person.openToMentorship;

      return matchesSearch && matchesDept && matchesMentorship;
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_search_outlined,
                size: 64,
                color: Colors.black26,
              ),
              const SizedBox(height: 16),
              const Text(
                'No members found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Try broadening your search or clearing active filters.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _selectedDept = '';
                    _onlyOpenToMentorship = false;
                    _selectedRoleFilter = 'All';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mulledWine,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Reset Filters', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final person = filtered[index];
        final isConnected = _connectedUids.contains(person.uid);

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _AlumniCard(
            alumni: person,
            isConnected: isConnected,
            onTap: () => context.push('${AppRoutes.directory}/${person.uid}'),
            onToggleConnect: () {
              setState(() {
                if (isConnected) {
                  _connectedUids.remove(person.uid);
                } else {
                  _connectedUids.add(person.uid);
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isConnected
                      ? 'Disconnected from ${person.fullName}'
                      : 'Connection request sent to ${person.fullName}!'),
                  backgroundColor: isConnected ? Colors.black87 : Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            onMessage: () async {
              final chatRepo = ref.read(chatRepositoryProvider);
              final result = await chatRepo.getOrCreateConversation(person.uid);
              result.fold(
                (failure) {
                  // Fallback to chat room route if cloud function fails
                  context.push('${AppRoutes.chat}/conv_${person.uid}');
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
  }

  void _showAdvancedFilterModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Directory',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedDept = '';
                            _onlyOpenToMentorship = false;
                            _selectedRoleFilter = 'All';
                          });
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Reset All', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Member Role', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['All', 'Student', 'Alumni', 'Faculty'].map((role) {
                      final isSelected = _selectedRoleFilter == role;
                      return ChoiceChip(
                        label: Text(role),
                        selected: isSelected,
                        selectedColor: AppColors.mulledWine,
                        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                        onSelected: (val) {
                          setModalState(() => _selectedRoleFilter = role);
                          setState(() => _selectedRoleFilter = role);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Open to Mentorship Only', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: const Text('Show members available for career guidance'),
                    value: _onlyOpenToMentorship,
                    activeColor: AppColors.mulledWine,
                    onChanged: (val) {
                      setModalState(() => _onlyOpenToMentorship = val);
                      setState(() => _onlyOpenToMentorship = val);
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mulledWine,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Apply Filters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        );
      },
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
  final bool isConnected;
  final VoidCallback onTap;
  final VoidCallback onToggleConnect;
  final VoidCallback onMessage;

  const _AlumniCard({
    required this.alumni,
    required this.isConnected,
    required this.onTap,
    required this.onToggleConnect,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.mulledWine.withOpacity(0.3), width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            alumni.photoUrl ?? 'https://i.pravatar.cc/150?img=11',
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified,
                            color: Color(0xFF0A66C2),
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                alumni.fullName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  letterSpacing: -0.3,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (alumni.openToMentorship)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Mentor',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          alumni.displayRole,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.school_outlined, size: 14, color: Colors.black45),
                            const SizedBox(width: 4),
                            Text(
                              '${alumni.department} • Class of \'${alumni.batchYear.toString().substring(2)}',
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                            if (alumni.location != null) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.location_on_outlined, size: 14, color: Colors.black45),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  alumni.location!,
                                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (alumni.skills.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: alumni.skills.take(3).map((skill) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F6F8),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  skill,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons Row (Connect & Message)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              border: Border(top: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onToggleConnect,
                    icon: Icon(
                      isConnected ? Icons.check_circle_outline : Icons.person_add_alt_1_outlined,
                      color: isConnected ? AppColors.mulledWine : Colors.white,
                      size: 18,
                    ),
                    label: Text(
                      isConnected ? 'Connected' : 'Connect',
                      style: TextStyle(
                        color: isConnected ? AppColors.mulledWine : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isConnected ? AppColors.mulledWine.withOpacity(0.1) : AppColors.mulledWine,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: onMessage,
                  icon: const Icon(Icons.chat_bubble_outline, color: AppColors.mulledWine, size: 18),
                  label: const Text(
                    'Message',
                    style: TextStyle(
                      color: AppColors.mulledWine,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.mulledWine),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
