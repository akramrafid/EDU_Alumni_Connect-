// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventModelImpl _$$EventModelImplFromJson(Map<String, dynamic> json) =>
    _$EventModelImpl(
      eventId: json['eventId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      tag: json['tag'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      date: json['date'] as String,
      time: json['time'] as String,
      location: json['location'] as String,
      bannerUrl: json['bannerUrl'] as String?,
      isOnline: json['isOnline'] as bool? ?? false,
      maxAttendees: (json['maxAttendees'] as num).toInt(),
      rsvpCount: (json['rsvpCount'] as num?)?.toInt() ?? 0,
      rsvpUserIds: (json['rsvpUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      postedByAdminId: json['postedByAdminId'] as String,
      reminderSent: json['reminderSent'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$EventModelImplToJson(_$EventModelImpl instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'title': instance.title,
      'description': instance.description,
      'tag': instance.tag,
      'dateTime': instance.dateTime.toIso8601String(),
      'date': instance.date,
      'time': instance.time,
      'location': instance.location,
      'bannerUrl': instance.bannerUrl,
      'isOnline': instance.isOnline,
      'maxAttendees': instance.maxAttendees,
      'rsvpCount': instance.rsvpCount,
      'rsvpUserIds': instance.rsvpUserIds,
      'postedByAdminId': instance.postedByAdminId,
      'reminderSent': instance.reminderSent,
      'createdAt': instance.createdAt.toIso8601String(),
    };
