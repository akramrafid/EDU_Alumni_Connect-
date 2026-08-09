import 'package:freezed_annotation/freezed_annotation.dart';

part 'alumni_directory_model.freezed.dart';
part 'alumni_directory_model.g.dart';

@freezed
class AlumniDirectoryModel with _$AlumniDirectoryModel {
  const factory AlumniDirectoryModel({
    required String uid,
    required String fullName,
    required String department,
    required int batchYear,
    String? currentCompany,
    String? jobTitle,
    @Default([]) List<String> skills,
    String? location,
    String? photoUrl,
    String? bio,
    @Default(false) bool openToMentorship,
  }) = _AlumniDirectoryModel;

  const AlumniDirectoryModel._();

  factory AlumniDirectoryModel.fromJson(Map<String, dynamic> json) =>
      _$AlumniDirectoryModelFromJson(json);

  factory AlumniDirectoryModel.fromFirestore(
      Map<String, dynamic> data, String id) {
    return AlumniDirectoryModel.fromJson({
      ...data,
      'uid': id,
      'skills': List<String>.from(data['skills'] ?? []),
    });
  }

  /// Display role string (e.g., "Senior Software Engineer at Google")
  String get displayRole {
    final parts = <String>[];
    if (jobTitle != null && jobTitle!.isNotEmpty) parts.add(jobTitle!);
    if (currentCompany != null && currentCompany!.isNotEmpty) {
      parts.add('at $currentCompany');
    }
    return parts.isEmpty ? 'Alumni' : parts.join(' ');
  }

  /// Display class year (e.g., "Class of '18")
  String get classYear => "Class of '${batchYear.toString().substring(2)}";
}
