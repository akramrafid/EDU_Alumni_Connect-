import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/auth_user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String email,
    required String fullName,
    required UserRole role,
    required VerificationStatus verificationStatus,
    String? photoUrl,
    required String department,
    required int batchYear,
    String? currentCompany,
    String? jobTitle,
    String? certificateUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  // Convert from Firestore document
  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    DateTime parseDateTime(dynamic val) {
      if (val == null) return DateTime.now();
      // Firestore Timestamp returns a native DateTime via toDate()
      try {
        return (val as dynamic).toDate();
      } catch (_) {
        try {
          return DateTime.parse(val.toString());
        } catch (_) {
          return DateTime.now();
        }
      }
    }

    return UserModel.fromJson({
      ...data,
      'uid': id,
      'role': data['role'] ?? 'student',
      'verificationStatus': data['verificationStatus'] ?? 'pending',
      'createdAt': parseDateTime(data['createdAt']).toIso8601String(),
      'updatedAt': parseDateTime(data['updatedAt']).toIso8601String(),
    });
  }

  // Convert to Firestore document (omitting uid)
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('uid');
    return {
      ...json,
      'createdAt': createdAt, // Firebase SDK natively accepts DateTime
      'updatedAt': updatedAt,
    };
  }

  // Map to domain entity AuthUser
  AuthUser toEntity({bool isEmailVerified = false}) {
    return AuthUser(
      uid: uid,
      email: email,
      role: role,
      verificationStatus: verificationStatus,
      fullName: fullName,
      isEmailVerified: isEmailVerified,
    );
  }
}
