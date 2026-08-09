// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mentorship_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MentorshipRequestModelImpl _$$MentorshipRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MentorshipRequestModelImpl(
      requestId: json['requestId'] as String,
      studentId: json['studentId'] as String,
      alumniId: json['alumniId'] as String,
      studentName: json['studentName'] as String,
      studentPhotoUrl: json['studentPhotoUrl'] as String?,
      alumniName: json['alumniName'] as String,
      alumniPhotoUrl: json['alumniPhotoUrl'] as String?,
      status: json['status'] as String,
      message: json['message'] as String,
      declineReason: json['declineReason'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MentorshipRequestModelImplToJson(
        _$MentorshipRequestModelImpl instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'studentId': instance.studentId,
      'alumniId': instance.alumniId,
      'studentName': instance.studentName,
      'studentPhotoUrl': instance.studentPhotoUrl,
      'alumniName': instance.alumniName,
      'alumniPhotoUrl': instance.alumniPhotoUrl,
      'status': instance.status,
      'message': instance.message,
      'declineReason': instance.declineReason,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
