// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParticipantDetailImpl _$$ParticipantDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$ParticipantDetailImpl(
      fullName: json['fullName'] as String,
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$$ParticipantDetailImplToJson(
        _$ParticipantDetailImpl instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'photoUrl': instance.photoUrl,
    };

_$ConversationModelImpl _$$ConversationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationModelImpl(
      conversationId: json['conversationId'] as String,
      participantIds: (json['participantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      participantDetails:
          (json['participantDetails'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, ParticipantDetail.fromJson(e as Map<String, dynamic>)),
      ),
      lastMessage: json['lastMessage'] as String? ?? '',
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
      lastMessageSenderId: json['lastMessageSenderId'] as String? ?? '',
      unreadCount: (json['unreadCount'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      isGroup: json['isGroup'] as bool? ?? false,
      groupName: json['groupName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ConversationModelImplToJson(
        _$ConversationModelImpl instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'participantIds': instance.participantIds,
      'participantDetails': instance.participantDetails,
      'lastMessage': instance.lastMessage,
      'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
      'lastMessageSenderId': instance.lastMessageSenderId,
      'unreadCount': instance.unreadCount,
      'isGroup': instance.isGroup,
      'groupName': instance.groupName,
      'createdAt': instance.createdAt.toIso8601String(),
    };
