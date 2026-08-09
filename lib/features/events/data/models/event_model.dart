import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@freezed
class EventModel with _$EventModel {
  const factory EventModel({
    required String eventId,
    required String title,
    required String description,
    required String tag,
    required DateTime dateTime,
    required String date,
    required String time,
    required String location,
    String? bannerUrl,
    @Default(false) bool isOnline,
    required int maxAttendees,
    @Default(0) int rsvpCount,
    @Default([]) List<String> rsvpUserIds,
    required String postedByAdminId,
    @Default(false) bool reminderSent,
    required DateTime createdAt,
  }) = _EventModel;

  const EventModel._();

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  factory EventModel.fromFirestore(Map<String, dynamic> data, String id) {
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

    return EventModel.fromJson({
      ...data,
      'eventId': id,
      'dateTime': parseDateTime(data['dateTime']).toIso8601String(),
      'createdAt': parseDateTime(data['createdAt']).toIso8601String(),
      'rsvpUserIds': List<String>.from(data['rsvpUserIds'] ?? []),
    });
  }

  bool get isFull => rsvpCount >= maxAttendees;
  bool get isAlmostFull => !isFull && (maxAttendees - rsvpCount <= 15);

  bool isUserRsvped(String uid) => rsvpUserIds.contains(uid);
}
