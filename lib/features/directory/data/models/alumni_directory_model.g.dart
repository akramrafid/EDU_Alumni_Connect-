// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alumni_directory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlumniDirectoryModelImpl _$$AlumniDirectoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AlumniDirectoryModelImpl(
      uid: json['uid'] as String,
      fullName: json['fullName'] as String,
      department: json['department'] as String,
      batchYear: (json['batchYear'] as num).toInt(),
      currentCompany: json['currentCompany'] as String?,
      jobTitle: json['jobTitle'] as String?,
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      location: json['location'] as String?,
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String?,
      openToMentorship: json['openToMentorship'] as bool? ?? false,
    );

Map<String, dynamic> _$$AlumniDirectoryModelImplToJson(
        _$AlumniDirectoryModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'fullName': instance.fullName,
      'department': instance.department,
      'batchYear': instance.batchYear,
      'currentCompany': instance.currentCompany,
      'jobTitle': instance.jobTitle,
      'skills': instance.skills,
      'location': instance.location,
      'photoUrl': instance.photoUrl,
      'bio': instance.bio,
      'openToMentorship': instance.openToMentorship,
    };
