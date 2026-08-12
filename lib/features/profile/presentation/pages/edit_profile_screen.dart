import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _headlineController;
  late final TextEditingController _bioController;
  late final TextEditingController _companyController;
  late final TextEditingController _jobTitleController;
  late final TextEditingController _skillsController;
  late final TextEditingController _locationController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider).value;
    final isStudent = user?.role.name == 'student';
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _headlineController = TextEditingController(
      text: isStudent
          ? 'BSc in CSE Student @ East Delta University'
          : 'Software Engineer | EDU Alumni',
    );
    _bioController = TextEditingController(
      text: 'Passionate software engineering student dedicated to building scalable applications and exploring cloud architectures.',
    );
    _companyController = TextEditingController(text: 'Tech Solutions Ltd.');
    _jobTitleController = TextEditingController(text: 'Software Engineer');
    _skillsController = TextEditingController(text: 'Flutter, Dart, Firebase, Mobile App Dev, Git, UI/UX');
    _locationController = TextEditingController(text: 'Chittagong, Bangladesh');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _headlineController.dispose();
    _bioController.dispose();
    _companyController.dispose();
    _jobTitleController.dispose();
    _skillsController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      final firestore = ref.read(firebaseFirestoreProvider);
      final skillsList = _skillsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final updates = <String, dynamic>{
        'fullName': _nameController.text.trim(),
        'headline': _headlineController.text.trim(),
        'location': _locationController.text.trim(),
        'updatedAt': DateTime.now(),
      };

      if (_bioController.text.trim().isNotEmpty) {
        updates['bio'] = _bioController.text.trim();
      }
      if (_companyController.text.trim().isNotEmpty) {
        updates['currentCompany'] = _companyController.text.trim();
      }
      if (_jobTitleController.text.trim().isNotEmpty) {
        updates['jobTitle'] = _jobTitleController.text.trim();
      }
      if (skillsList.isNotEmpty) {
        updates['skills'] = skillsList;
      }

      await firestore.collection('users').doc(user.uid).update(updates);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('LinkedIn profile details updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F2EF),
      appBar: AppBar(
        backgroundColor: AppColors.mulledWine,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Edit Intro & Experience',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.mulledWine))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormSection(
                    title: 'Basic Info',
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _headlineController,
                        label: 'Headline',
                        hint: 'e.g. Student @ EDU | Flutter Developer',
                        icon: Icons.subtitles_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _locationController,
                        label: 'Location',
                        icon: Icons.location_on_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildFormSection(
                    title: 'Current Role & Company',
                    children: [
                      _buildTextField(
                        controller: _jobTitleController,
                        label: 'Job Title / Position',
                        hint: 'e.g. Software Engineering Intern',
                        icon: Icons.badge_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _companyController,
                        label: 'Company / Organization',
                        hint: 'e.g. Tech Solutions Ltd.',
                        icon: Icons.business_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildFormSection(
                    title: 'About Summary & Skills',
                    children: [
                      _buildTextField(
                        controller: _skillsController,
                        label: 'Top Skills (comma-separated)',
                        hint: 'Flutter, Dart, Firebase, Git, Python',
                        icon: Icons.star_outline,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _bioController,
                        label: 'About Summary',
                        icon: Icons.description_outlined,
                        maxLines: 4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mulledWine,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Save Profile Changes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFormSection({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.mulledWine,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, color: AppColors.mulledWine, size: 20) : null,
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
