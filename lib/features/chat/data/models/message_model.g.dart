// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageModelImpl _$$MessageModelImplFromJson(Map<String, dynamic> json) =>
    _$MessageModelImpl(
      messageId: json['messageId'] as String,
      senderId: json['senderId'] as String,
      text: json['text'] as String,
      type: json['type'] as String? ?? 'text',
      mediaUrl: json['mediaUrl'] as String?,
      fileName: json['fileName'] as String?,
      fileSize: json['fileSize'] as String?,
      duration: json['duration'] as String?,
      sentAt: DateTime.parse(json['sentAt'] as String),
      readBy: (json['readBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$MessageModelImplToJson(_$MessageModelImpl instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'senderId': instance.senderId,
      'text': instance.text,
      'type': instance.type,
      'mediaUrl': instance.mediaUrl,
      'fileName': instance.fileName,
      'fileSize': instance.fileSize,
      'duration': instance.duration,
      'sentAt': instance.sentAt.toIso8601String(),
      'readBy': instance.readBy,
    };
