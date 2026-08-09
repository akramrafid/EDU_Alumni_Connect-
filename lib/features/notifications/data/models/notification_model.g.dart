// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationModelImpl(
      notificationId: json['notificationId'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      read: json['read'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      payload: json['payload'] == null
          ? const NotificationPayload()
          : NotificationPayload.fromJson(
              json['payload'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$NotificationModelImplToJson(
        _$NotificationModelImpl instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'type': instance.type,
      'title': instance.title,
      'body': instance.body,
      'read': instance.read,
      'createdAt': instance.createdAt.toIso8601String(),
      'payload': instance.payload,
    };

_$NotificationPayloadImpl _$$NotificationPayloadImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationPayloadImpl(
      route: json['route'] as String? ?? '',
      entityId: json['entityId'] as String? ?? '',
    );

Map<String, dynamic> _$$NotificationPayloadImplToJson(
        _$NotificationPayloadImpl instance) =>
    <String, dynamic>{
      'route': instance.route,
      'entityId': instance.entityId,
    };
