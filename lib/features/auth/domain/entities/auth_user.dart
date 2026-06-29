enum UserRole { student, alumni, admin }

enum VerificationStatus { pending, verified, rejected }

class AuthUser {
  final String uid;
  final String email;
  final UserRole role;
  final VerificationStatus verificationStatus;
  final String fullName;
  final bool isEmailVerified;

  const AuthUser({
    required this.uid,
    required this.email,
    required this.role,
    required this.verificationStatus,
    required this.fullName,
    required this.isEmailVerified,
  });

  bool get isVerifiedAlumni =>
      role == UserRole.alumni && verificationStatus == VerificationStatus.verified;

  bool get isAdmin => role == UserRole.admin;
}
