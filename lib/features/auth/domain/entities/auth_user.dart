enum UserRole { student, alumni, admin }

enum VerificationStatus { pending, verified, rejected }

class AuthUser {
  final String uid;
  final String email;
  final UserRole role;
  final VerificationStatus verificationStatus;
  final String fullName;
  final bool isEmailVerified;
  final String? photoUrl;
  final String? coverPhotoUrl;

  const AuthUser({
    required this.uid,
    required this.email,
    required this.role,
    required this.verificationStatus,
    required this.fullName,
    required this.isEmailVerified,
    this.photoUrl,
    this.coverPhotoUrl,
  });

  bool get isVerifiedAlumni =>
      role == UserRole.alumni && verificationStatus == VerificationStatus.verified;

  bool get isAdmin => role == UserRole.admin;

  AuthUser copyWith({
    String? uid,
    String? email,
    UserRole? role,
    VerificationStatus? verificationStatus,
    String? fullName,
    bool? isEmailVerified,
    String? photoUrl,
    String? coverPhotoUrl,
  }) {
    return AuthUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      role: role ?? this.role,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      fullName: fullName ?? this.fullName,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      photoUrl: photoUrl ?? this.photoUrl,
      coverPhotoUrl: coverPhotoUrl ?? this.coverPhotoUrl,
    );
  }
}
