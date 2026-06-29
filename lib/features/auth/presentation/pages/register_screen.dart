import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _batchController = TextEditingController();
  final _companyController = TextEditingController();
  final _jobTitleController = TextEditingController();

  // ValueNotifiers to manage widget states cleanly without using setState()
  final ValueNotifier<String> _roleNotifier = ValueNotifier<String>('student');
  final ValueNotifier<String> _departmentNotifier = ValueNotifier<String>('CSE');
  final ValueNotifier<String?> _certificatePathNotifier = ValueNotifier<String?>(null);

  final List<String> _departments = ['CSE', 'EEE', 'BBA', 'English', 'CIVIL', 'LAW'];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _batchController.dispose();
    _companyController.dispose();
    _jobTitleController.dispose();
    _roleNotifier.dispose();
    _departmentNotifier.dispose();
    _certificatePathNotifier.dispose();
    super.dispose();
  }

  Future<void> _pickCertificate() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file != null) {
      _certificatePathNotifier.value = file.path;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final role = _roleNotifier.value;
    final email = _emailController.text;
    final password = _passwordController.text;
    final fullName = _fullNameController.text;
    final department = _departmentNotifier.value;
    final batchYear = int.tryParse(_batchController.text) ?? DateTime.now().year;

    bool success = false;

    if (role == 'student') {
      success = await ref.read(registerNotifierProvider.notifier).registerStudent(
            email: email,
            password: password,
            fullName: fullName,
            department: department,
            batchYear: batchYear,
          );
      if (success && mounted) {
        context.go(AppRoutes.verifyEmail);
      }
    } else {
      final certificatePath = _certificatePathNotifier.value;
      if (certificatePath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please upload a degree certificate or student ID for verification.'), // TODO: l10n
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      success = await ref.read(registerNotifierProvider.notifier).registerAlumni(
            email: email,
            password: password,
            fullName: fullName,
            department: department,
            batchYear: batchYear,
            currentCompany: _companyController.text.trim().isEmpty ? null : _companyController.text,
            jobTitle: _jobTitleController.text.trim().isEmpty ? null : _jobTitleController.text,
            certificatePath: certificatePath,
          );

      if (success && mounted) {
        _showSuccessBottomSheet();
      }
    }
  }

  void _showSuccessBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  color: AppColors.matcha,
                  size: 64,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Verification Pending', // TODO: l10n
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryLight,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                const Text(
                  'Your alumni registration was submitted successfully. An administrator will review your degree certificate or ID card within 24 to 48 hours to grant full directory access.', // TODO: l10n
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondaryLight,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  label: 'Proceed', // TODO: l10n
                  isFullWidth: true,
                  onPressed: () {
                    Navigator.of(context).pop(); // Dismiss bottom sheet
                    context.go('/pending');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(
      registerNotifierProvider,
      (previous, next) {
        next.whenOrNull(
          error: (error, _) {
            final errorMessage = error.toString().replaceFirst('Exception: ', '');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: AppColors.error,
              ),
            );
          },
        );
      },
    );

    final registerState = ref.watch(registerNotifierProvider);
    final isLoading = registerState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Create Account'), // TODO: l10n
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Role selection button
                ValueListenableBuilder<String>(
                  valueListenable: _roleNotifier,
                  builder: (context, selectedRole, child) {
                    return SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'student',
                          label: Text('Student'), // TODO: l10n
                          icon: Icon(Icons.school_outlined),
                        ),
                        ButtonSegment(
                          value: 'alumni',
                          label: Text('Alumni'), // TODO: l10n
                          icon: Icon(Icons.workspace_premium_outlined),
                        ),
                      ],
                      selected: {selectedRole},
                      onSelectionChanged: (value) {
                        _roleNotifier.value = value.first;
                      },
                      style: SegmentedButton.styleFrom(
                        selectedBackgroundColor: AppColors.mulledWine,
                        selectedForegroundColor: Colors.white,
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),

                // Register Form Card
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Full Name
                      AppTextField(
                        controller: _fullNameController,
                        label: 'Full Name', // TODO: l10n
                        hint: 'John Doe', // TODO: l10n
                        prefixIcon: const Icon(Icons.person_outline),
                        enabled: !isLoading,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name'; // TODO: l10n
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Email (reactive domain check)
                      ValueListenableBuilder<String>(
                        valueListenable: _roleNotifier,
                        builder: (context, selectedRole, child) {
                          final isStudent = selectedRole == 'student';
                          return AppTextField(
                            controller: _emailController,
                            label: isStudent ? 'University Email' : 'Email Address', // TODO: l10n
                            hint: isStudent ? 'username@eastdelta.edu.bd' : 'username@gmail.com', // TODO: l10n
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(Icons.email_outlined),
                            enabled: !isLoading,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email'; // TODO: l10n
                              }
                              final email = value.trim();
                              if (!email.contains('@')) {
                                return 'Please enter a valid email'; // TODO: l10n
                              }
                              if (isStudent && !email.toLowerCase().endsWith('@eastdelta.edu.bd')) {
                                return 'Must be a university email (@eastdelta.edu.bd)'; // TODO: l10n
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Password
                      AppTextField(
                        controller: _passwordController,
                        label: 'Password', // TODO: l10n
                        hint: '••••••••', // TODO: l10n
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock_outlined),
                        enabled: !isLoading,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password'; // TODO: l10n
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters'; // TODO: l10n
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Department selection dropdown
                      ValueListenableBuilder<String>(
                        valueListenable: _departmentNotifier,
                        builder: (context, selectedDept, child) {
                          return DropdownButtonFormField<String>(
                            value: selectedDept,
                            decoration: const InputDecoration(
                              labelText: 'Department', // TODO: l10n
                              prefixIcon: Icon(Icons.business_outlined),
                            ),
                            items: _departments
                                .map((dept) => DropdownMenuItem(
                                      value: dept,
                                      child: Text(dept),
                                    ))
                                .toList(),
                            onChanged: isLoading
                                ? null
                                : (val) {
                                    if (val != null) {
                                      _departmentNotifier.value = val;
                                    }
                                  },
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Graduation/Batch Year
                      AppTextField(
                        controller: _batchController,
                        label: 'Batch Year (e.g. 2024)', // TODO: l10n
                        hint: '2024', // TODO: l10n
                        keyboardType: TextInputType.number,
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                        enabled: !isLoading,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your graduation/batch year'; // TODO: l10n
                          }
                          final year = int.tryParse(value.trim());
                          if (year == null || value.trim().length != 4) {
                            return 'Please enter a valid 4-digit year'; // TODO: l10n
                          }
                          return null;
                        },
                      ),

                      // Alumni only additional fields
                      ValueListenableBuilder<String>(
                        valueListenable: _roleNotifier,
                        builder: (context, selectedRole, child) {
                          if (selectedRole != 'alumni') return const SizedBox.shrink();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: AppSpacing.md),
                              AppTextField(
                                controller: _companyController,
                                label: 'Current Company (Optional)', // TODO: l10n
                                hint: 'Google', // TODO: l10n
                                prefixIcon: const Icon(Icons.work_outline),
                                enabled: !isLoading,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              AppTextField(
                                controller: _jobTitleController,
                                label: 'Job Title (Optional)', // TODO: l10n
                                hint: 'Software Engineer', // TODO: l10n
                                prefixIcon: const Icon(Icons.badge_outlined),
                                enabled: !isLoading,
                              ),
                              const SizedBox(height: AppSpacing.lg),

                              // Certificate upload container
                              Text(
                                'Verification Document *', // TODO: l10n
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimaryLight,
                                    ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              ValueListenableBuilder<String?>(
                                valueListenable: _certificatePathNotifier,
                                builder: (context, certificatePath, child) {
                                  final hasFile = certificatePath != null;
                                  return InkWell(
                                    onTap: isLoading ? null : _pickCertificate,
                                    borderRadius: BorderRadius.circular(AppRadius.md),
                                    child: Container(
                                      padding: const EdgeInsets.all(AppSpacing.lg),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceLight,
                                        borderRadius: BorderRadius.circular(AppRadius.md),
                                        border: Border.all(
                                          color: hasFile
                                              ? AppColors.matcha
                                              : AppColors.mulledWine.withOpacity(0.3),
                                          style: BorderStyle.solid,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: hasFile
                                          ? Row(
                                              children: [
                                                const Icon(
                                                  Icons.check_circle,
                                                  color: AppColors.matcha,
                                                ),
                                                const SizedBox(width: AppSpacing.md),
                                                Expanded(
                                                  child: Text(
                                                    certificatePath.split('/').last,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      color: AppColors.textPrimaryLight,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete_outline,
                                                    color: AppColors.error,
                                                  ),
                                                  onPressed: () {
                                                    _certificatePathNotifier.value = null;
                                                  },
                                                ),
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                Icon(
                                                  Icons.cloud_upload_outlined,
                                                  color: AppColors.mulledWine.withOpacity(0.7),
                                                  size: 32,
                                                ),
                                                const SizedBox(height: AppSpacing.sm),
                                                const Text(
                                                  'Upload Degree Certificate or Student ID', // TODO: l10n
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.textPrimaryLight,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: AppSpacing.xs),
                                                const Text(
                                                  'Supported formats: JPG, PNG (Max 10MB)', // TODO: l10n
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors.textSecondaryLight,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Submit button
                      AppButton(
                        label: 'Create Account', // TODO: l10n
                        onPressed: _submit,
                        isLoading: isLoading,
                        isFullWidth: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
