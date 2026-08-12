import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/job_model.dart';
import '../providers/jobs_provider.dart';

class OpportunitiesPage extends ConsumerStatefulWidget {
  const OpportunitiesPage({super.key});

  @override
  ConsumerState<OpportunitiesPage> createState() => _OpportunitiesPageState();
}

class _OpportunitiesPageState extends ConsumerState<OpportunitiesPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showPostJobDialog() {
    final titleController = TextEditingController();
    final companyController = TextEditingController();
    final locationController = TextEditingController();
    final descController = TextEditingController();
    final linkController = TextEditingController();
    String selectedType = 'full-time';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Post an Opportunity'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Job Title'),
              ),
              TextField(
                controller: companyController,
                decoration: const InputDecoration(labelText: 'Company'),
              ),
              TextField(
                controller: locationController,
                decoration:
                    const InputDecoration(labelText: 'Location (e.g. Remote)'),
              ),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: const [
                  DropdownMenuItem(
                      value: 'full-time', child: Text('Full-time')),
                  DropdownMenuItem(
                      value: 'part-time', child: Text('Part-time')),
                  DropdownMenuItem(
                      value: 'internship', child: Text('Internship')),
                  DropdownMenuItem(
                      value: 'contract', child: Text('Contract')),
                ],
                onChanged: (val) {
                  if (val != null) selectedType = val;
                },
                decoration: const InputDecoration(labelText: 'Job Type'),
              ),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: linkController,
                decoration:
                    const InputDecoration(labelText: 'Apply Link (URL)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isEmpty ||
                  companyController.text.isEmpty ||
                  linkController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all required fields.')),
                );
                return;
              }
              Navigator.pop(context);
              final success = await ref
                  .read(postJobNotifierProvider.notifier)
                  .post(
                    title: titleController.text.trim(),
                    company: companyController.text.trim(),
                    location: locationController.text.trim(),
                    jobType: selectedType,
                    description: descController.text.trim(),
                    applyLink: linkController.text.trim(),
                  );

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Job posted successfully!'
                          : 'Failed to post job.',
                    ),
                    backgroundColor:
                        success ? Colors.green : AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mulledWine,
            ),
            child: const Text('Post Job'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final isAlumniOrAdmin =
        user?.role.name == 'alumni' || user?.role.name == 'admin';
    final jobsAsync = ref.watch(activeJobsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      extendBody: true,
      floatingActionButton: isAlumniOrAdmin
          ? Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: FloatingActionButton.extended(
                onPressed: _showPostJobDialog,
                backgroundColor: AppColors.mulledWine,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Post Job',
                    style: TextStyle(color: Colors.white)),
              ),
            )
          : null,
      body: Column(
        children: [
          _buildHeader(user?.role.name),
          _buildSearchAndTitle(),
          Expanded(
            child: jobsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (jobs) {
                final displayJobs =
                    jobs.isNotEmpty ? jobs : _mockFallbackJobs();

                final filtered = _searchController.text.trim().isEmpty
                    ? displayJobs
                    : displayJobs
                        .where((j) =>
                            j.title.toLowerCase().contains(
                                _searchController.text.trim().toLowerCase()) ||
                            j.company.toLowerCase().contains(
                                _searchController.text.trim().toLowerCase()))
                        .toList();

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final job = filtered[index];
                    return _buildJobCard(job);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String? roleName) {
    final welcomeRole = roleName == 'alumni' ? 'Alumni' : 'Student';

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
              Text(
                'Welcome, $welcomeRole',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
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

  Widget _buildSearchAndTitle() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 5)),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.black54),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Search jobs, internships, co...',
                      hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDEAEA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.tune, size: 14, color: Color(0xFF700000)),
                      SizedBox(width: 4),
                      Text(
                        'Filter',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF700000),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Opportunities',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Curated roles from our alumni network.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(JobModel job) {
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
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconForCompany(job.company), 
                  color: _getColorForCompany(job.company)
                ),
              ),
              if (job.isPostedByAlumni)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDEAEA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.school, size: 12, color: AppColors.mulledWine),
                      SizedBox(width: 4),
                      Text(
                        'Posted by Alumni',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mulledWine,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            job.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            job.company,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildLocationTag(Icons.location_on_outlined, job.location),
              const SizedBox(width: 8),
              _buildLocationTag(Icons.work_outline, job.jobType),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opening: ${job.applyLink}')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: job.isPostedByAlumni ? const Color(0xFF700000) : const Color(0xFFFDEAEA),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                job.isPostedByAlumni ? 'Apply Now' : 'View Details',
                style: TextStyle(
                  color: job.isPostedByAlumni ? Colors.white : const Color(0xFF700000),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.black54),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  List<JobModel> _mockFallbackJobs() {
    return [
      JobModel(
        jobId: 'job_1',
        postedByAlumniId: 'alumni_1',
        posterName: 'Saima Rahman',
        title: 'Senior Product Designer',
        company: 'TechFlow Innovations',
        location: 'San Francisco, CA (Hybrid)',
        jobType: 'Full-time',
        description: 'Lead design team for next-gen B2B products.',
        applyLink: 'https://careers.google.com',
        postedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      JobModel(
        jobId: 'job_2',
        postedByAlumniId: 'alumni_2',
        posterName: 'Tousif Ahmed',
        title: 'Financial Analyst Internship',
        company: 'Apex Capital Partners',
        location: 'New York, NY',
        jobType: 'Summer 2024',
        description: 'Summer internship for finance and economics students.',
        applyLink: 'https://apexcapital.com',
        postedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      JobModel(
        jobId: 'job_3',
        postedByAlumniId: 'alumni_3',
        posterName: 'Elena Rostova',
        title: 'Data Engineering Lead',
        company: 'Nexus Health Tech',
        location: 'Remote',
        jobType: 'Full-time',
        description: 'Lead data engineering for our health platform.',
        applyLink: 'https://nexushealth.com',
        postedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      JobModel(
        jobId: 'job_4',
        postedByAlumniId: 'system',
        posterName: 'System',
        title: 'Marketing Associate',
        company: 'Global Reach Media',
        location: 'Chicago, IL',
        jobType: 'Contract',
        description: 'Looking for a driven marketing associate.',
        applyLink: 'https://globalreach.com',
        postedAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];
  }

  IconData _getIconForCompany(String company) {
    if (company.contains('TechFlow')) return Icons.water_drop;
    if (company.contains('Apex')) return Icons.public;
    if (company.contains('Nexus')) return Icons.analytics;
    if (company.contains('Global')) return Icons.campaign;
    return Icons.work;
  }

  Color _getColorForCompany(String company) {
    if (company.contains('TechFlow')) return Colors.blue;
    if (company.contains('Apex')) return Colors.blue;
    if (company.contains('Nexus')) return Colors.black87;
    if (company.contains('Global')) return Colors.teal;
    return AppColors.mulledWine;
  }
}
