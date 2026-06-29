// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      uid: json['uid'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      verificationStatus:
          $enumDecode(_$VerificationStatusEnumMap, json['verificationStatus']),
      photoUrl: json['photoUrl'] as String?,
      department: json['department'] as String,
      batchYear: (json['batchYear'] as num).toInt(),
      currentCompany: json['currentCompany'] as String?,
      jobTitle: json['jobTitle'] as String?,
      certificateUrl: json['certificateUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'fullName': instance.fullName,
      'role': _$UserRoleEnumMap[instance.role]!,
      'verificationStatus':
          _$VerificationStatusEnumMap[instance.verificationStatus]!,
      'photoUrl': instance.photoUrl,
      'department': instance.department,
      'batchYear': instance.batchYear,
      'currentCompany': instance.currentCompany,
      'jobTitle': instance.jobTitle,
      'certificateUrl': instance.certificateUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.student: 'student',
  UserRole.alumni: 'alumni',
  UserRole.admin: 'admin',
};

const _$VerificationStatusEnumMap = {
  VerificationStatus.pending: 'pending',
  VerificationStatus.verified: 'verified',
  VerificationStatus.rejected: 'rejected',
};
