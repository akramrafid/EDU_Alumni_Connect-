// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobModelImpl _$$JobModelImplFromJson(Map<String, dynamic> json) =>
    _$JobModelImpl(
      jobId: json['jobId'] as String,
      postedByAlumniId: json['postedByAlumniId'] as String,
      posterName: json['posterName'] as String,
      posterPhotoUrl: json['posterPhotoUrl'] as String?,
      title: json['title'] as String,
      company: json['company'] as String,
      location: json['location'] as String,
      jobType: json['jobType'] as String,
      description: json['description'] as String,
      applyLink: json['applyLink'] as String,
      status: json['status'] as String? ?? 'active',
      postedAt: DateTime.parse(json['postedAt'] as String),
    );

Map<String, dynamic> _$$JobModelImplToJson(_$JobModelImpl instance) =>
    <String, dynamic>{
      'jobId': instance.jobId,
      'postedByAlumniId': instance.postedByAlumniId,
      'posterName': instance.posterName,
      'posterPhotoUrl': instance.posterPhotoUrl,
      'title': instance.title,
      'company': instance.company,
      'location': instance.location,
      'jobType': instance.jobType,
      'description': instance.description,
      'applyLink': instance.applyLink,
      'status': instance.status,
      'postedAt': instance.postedAt.toIso8601String(),
    };
