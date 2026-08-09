import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_model.freezed.dart';
part 'job_model.g.dart';

@freezed
class JobModel with _$JobModel {
  const factory JobModel({
    required String jobId,
    required String postedByAlumniId,
    required String posterName,
    String? posterPhotoUrl,
    required String title,
    required String company,
    required String location,
    required String jobType,
    required String description,
    required String applyLink,
    @Default('active') String status,
    required DateTime postedAt,
  }) = _JobModel;

  const JobModel._();

  factory JobModel.fromJson(Map<String, dynamic> json) =>
      _$JobModelFromJson(json);

  factory JobModel.fromFirestore(Map<String, dynamic> data, String id) {
    DateTime parseDateTime(dynamic val) {
      if (val == null) return DateTime.now();
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

    return JobModel.fromJson({
      ...data,
      'jobId': id,
      'postedAt': parseDateTime(data['postedAt']).toIso8601String(),
    });
  }

  bool get isActive => status == 'active';
  bool get isPostedByAlumni => postedByAlumniId.isNotEmpty;
}
