import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String notificationId,
    required String type,
    required String title,
    required String body,
    @Default(false) bool read,
    required DateTime createdAt,
    @Default(NotificationPayload()) NotificationPayload payload,
  }) = _NotificationModel;

  const NotificationModel._();

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  factory NotificationModel.fromFirestore(
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

    final rawPayload = data['payload'] as Map<String, dynamic>? ?? {};

    return NotificationModel(
      notificationId: id,
      type: data['type'] ?? 'system',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      read: data['read'] ?? false,
      createdAt: parseDateTime(data['createdAt']),
      payload: NotificationPayload(
        route: rawPayload['route'] ?? '',
        entityId: rawPayload['entityId'] ?? '',
      ),
    );
  }
}

@freezed
class NotificationPayload with _$NotificationPayload {
  const factory NotificationPayload({
    @Default('') String route,
    @Default('') String entityId,
  }) = _NotificationPayload;

  factory NotificationPayload.fromJson(Map<String, dynamic> json) =>
      _$NotificationPayloadFromJson(json);
}
