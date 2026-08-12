import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Premium Register Screen — Role Selection, Form Validation & Certificate Upload
// ──────────────────────────────────────────────────────────────────────────────
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

  final ValueNotifier<String> _roleNotifier = ValueNotifier<String>('student');
  final ValueNotifier<String> _departmentNotifier = ValueNotifier<String>('CSE');
  final ValueNotifier<String?> _certificatePathNotifier = ValueNotifier<String?>(null);
  bool _obscurePassword = true;

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
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final fullName = _fullNameController.text.trim();
    final department = _departmentNotifier.value;
    final batchYear = int.tryParse(_batchController.text.trim()) ?? DateTime.now().year;

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully! Please sign in.'),
            backgroundColor: Color(0xFF00C9A7),
            duration: Duration(seconds: 4),
          ),
        );
        context.go(AppRoutes.login);
      }
    } else {
      final certificatePath = _certificatePathNotifier.value;
      if (!AppConfig.useMock && certificatePath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please upload a degree certificate or student ID for verification.'),
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
            currentCompany: _companyController.text.trim().isEmpty ? null : _companyController.text.trim(),
            jobTitle: _jobTitleController.text.trim().isEmpty ? null : _jobTitleController.text.trim(),
            certificatePath: certificatePath ?? '',
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C9A7).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_user_rounded,
                    color: Color(0xFF00C9A7),
                    size: 56,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Verification Pending',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A0A0E),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your alumni registration was submitted successfully. Our team will verify your document shortly. Please log in with your credentials to check status.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF6B4A52),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF670627), Color(0xFF8B0A3A)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.go(AppRoutes.login);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Proceed to Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
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
      backgroundColor: const Color(0xFFF5F3F0),
      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: Color(0xFF1A0A0E),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Animated Role Selector Pill
                ValueListenableBuilder<String>(
                  valueListenable: _roleNotifier,
                  builder: (context, selectedRole, child) {
                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFEDE7E3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildRoleTab(
                              title: 'Student',
                              icon: Icons.school_rounded,
                              isSelected: selectedRole == 'student',
                              onTap: () => _roleNotifier.value = 'student',
                            ),
                          ),
                          Expanded(
                            child: _buildRoleTab(
                              title: 'Alumni',
                              icon: Icons.workspace_premium_rounded,
                              isSelected: selectedRole == 'alumni',
                              onTap: () => _roleNotifier.value = 'alumni',
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Form Container Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3D0014).withOpacity(0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Full Name
                      _buildInputField(
                        controller: _fullNameController,
                        label: 'Full Name *',
                        hint: 'John Doe',
                        icon: Icons.person_outline_rounded,
                        enabled: !isLoading,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email
                      ValueListenableBuilder<String>(
                        valueListenable: _roleNotifier,
                        builder: (context, selectedRole, child) {
                          final isStudent = selectedRole == 'student';
                          return _buildInputField(
                            controller: _emailController,
                            label: isStudent ? 'University Email *' : 'Email Address *',
                            hint: isStudent ? 'id@eastdelta.edu.bd' : 'user@domain.com',
                            icon: Icons.email_outlined,
                            enabled: !isLoading,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              final email = v.trim();
                              if (!email.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              if (!AppConfig.useMock &&
                                  isStudent &&
                                  !email.toLowerCase().endsWith('@eastdelta.edu.bd')) {
                                return 'Must be a university email (@eastdelta.edu.bd)';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password
                      _buildInputField(
                        controller: _passwordController,
                        label: 'Password *',
                        hint: 'At least 8 characters',
                        icon: Icons.lock_outline_rounded,
                        enabled: !isLoading,
                        isPassword: true,
                        obscureText: _obscurePassword,
                        toggleObscure: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (v.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Department Dropdown
                      ValueListenableBuilder<String>(
                        valueListenable: _departmentNotifier,
                        builder: (context, selectedDept, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Department *',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A0A0E),
                                ),
                              ),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: selectedDept,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.business_rounded,
                                    color: Color(0xFF670627),
                                    size: 20,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF5F3F0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 16,
                                  ),
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
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Batch Year
                      _buildInputField(
                        controller: _batchController,
                        label: 'Batch Year *',
                        hint: 'e.g. 2024',
                        icon: Icons.calendar_today_rounded,
                        enabled: !isLoading,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Please enter your batch year';
                          }
                          final year = int.tryParse(v.trim());
                          if (year == null || v.trim().length != 4) {
                            return 'Please enter a valid 4-digit year';
                          }
                          return null;
                        },
                      ),

                      // Alumni extra fields
                      ValueListenableBuilder<String>(
                        valueListenable: _roleNotifier,
                        builder: (context, selectedRole, child) {
                          if (selectedRole != 'alumni') return const SizedBox.shrink();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 16),
                              _buildInputField(
                                controller: _companyController,
                                label: 'Current Company (Optional)',
                                hint: 'Google',
                                icon: Icons.business_center_outlined,
                                enabled: !isLoading,
                              ),
                              const SizedBox(height: 16),
                              _buildInputField(
                                controller: _jobTitleController,
                                label: 'Job Title (Optional)',
                                hint: 'Senior Software Engineer',
                                icon: Icons.badge_outlined,
                                enabled: !isLoading,
                              ),
                              const SizedBox(height: 20),

                              // Certificate Upload Card
                              const Text(
                                'Degree Certificate or Student ID *',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A0A0E),
                                ),
                              ),
                              const SizedBox(height: 8),
                              ValueListenableBuilder<String?>(
                                valueListenable: _certificatePathNotifier,
                                builder: (context, certPath, child) {
                                  final hasFile = certPath != null;
                                  return GestureDetector(
                                    onTap: isLoading ? null : _pickCertificate,
                                    child: Container(
                                      padding: const EdgeInsets.all(18),
                                      decoration: BoxDecoration(
                                        color: hasFile
                                            ? const Color(0xFF00C9A7).withOpacity(0.06)
                                            : const Color(0xFFF5F3F0),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: hasFile
                                              ? const Color(0xFF00C9A7)
                                              : const Color(0xFF670627).withOpacity(0.2),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: hasFile
                                          ? Row(
                                              children: [
                                                const Icon(
                                                  Icons.check_circle_rounded,
                                                  color: Color(0xFF00C9A7),
                                                  size: 24,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    certPath.split('/').last,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 13,
                                                      color: Color(0xFF1A0A0E),
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete_outline_rounded,
                                                    color: Color(0xFFD32F2F),
                                                    size: 20,
                                                  ),
                                                  onPressed: () {
                                                    _certificatePathNotifier.value = null;
                                                  },
                                                ),
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                const Icon(
                                                  Icons.cloud_upload_outlined,
                                                  color: Color(0xFF670627),
                                                  size: 32,
                                                ),
                                                const SizedBox(height: 6),
                                                const Text(
                                                  'Upload Degree Certificate or Student ID',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 13,
                                                    color: Color(0xFF1A0A0E),
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                const Text(
                                                  'JPG, PNG format (Max 10MB)',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Color(0xFF6B4A52),
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
                      const SizedBox(height: 28),

                      // Submit CTA Button
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF670627), Color(0xFF8B0A3A)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF670627).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Create Account',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_rounded,
                                        color: Colors.white, size: 18),
                                  ],
                                ),
                        ),
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

  Widget _buildRoleTab({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF670627) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : const Color(0xFF6B4A52),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.white : const Color(0xFF6B4A52),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool enabled = true,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? toggleObscure,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A0A0E),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: enabled,
          obscureText: isPassword ? obscureText : false,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF9E8A90), fontSize: 13),
            prefixIcon: Icon(icon, color: const Color(0xFF670627), size: 20),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF6B4A52),
                      size: 20,
                    ),
                    onPressed: toggleObscure,
                  )
                : null,
            filled: true,
            fillColor: const Color(0xFFF5F3F0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
        ),
      ],
    );
  }
}
