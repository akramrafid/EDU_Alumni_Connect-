import 'package:freezed_annotation/freezed_annotation.dart';

part 'mentorship_request_model.freezed.dart';
part 'mentorship_request_model.g.dart';

enum MentorshipStatus { pending, accepted, declined, completed }

@freezed
class MentorshipRequestModel with _$MentorshipRequestModel {
  const factory MentorshipRequestModel({
    required String requestId,
    required String studentId,
    required String alumniId,
    required String studentName,
    String? studentPhotoUrl,
    required String alumniName,
    String? alumniPhotoUrl,
    required String status,
    required String message,
    String? declineReason,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MentorshipRequestModel;

  const MentorshipRequestModel._();

  factory MentorshipRequestModel.fromJson(Map<String, dynamic> json) =>
      _$MentorshipRequestModelFromJson(json);

  factory MentorshipRequestModel.fromFirestore(
      Map<String, dynamic> data, String id) {
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

    return MentorshipRequestModel.fromJson({
      ...data,
      'requestId': id,
      'createdAt': parseDateTime(data['createdAt']).toIso8601String(),
      'updatedAt': parseDateTime(data['updatedAt']).toIso8601String(),
    });
  }

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isDeclined => status == 'declined';
}
