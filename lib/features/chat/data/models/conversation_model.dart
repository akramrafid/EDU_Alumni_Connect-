import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_model.freezed.dart';
part 'conversation_model.g.dart';

@freezed
class ParticipantDetail with _$ParticipantDetail {
  const factory ParticipantDetail({
    required String fullName,
    String? photoUrl,
  }) = _ParticipantDetail;

  factory ParticipantDetail.fromJson(Map<String, dynamic> json) =>
      _$ParticipantDetailFromJson(json);
}

@freezed
class ConversationModel with _$ConversationModel {
  const factory ConversationModel({
    required String conversationId,
    required List<String> participantIds,
    required Map<String, ParticipantDetail> participantDetails,
    @Default('') String lastMessage,
    DateTime? lastMessageAt,
    @Default('') String lastMessageSenderId,
    @Default({}) Map<String, int> unreadCount,
    @Default(false) bool isGroup,
    String? groupName,
    required DateTime createdAt,
  }) = _ConversationModel;

  const ConversationModel._();

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);

  factory ConversationModel.fromFirestore(
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

    // Parse participantDetails map
    final rawDetails =
        data['participantDetails'] as Map<String, dynamic>? ?? {};
    final parsedDetails = rawDetails.map(
      (key, value) => MapEntry(
        key,
        ParticipantDetail.fromJson(value as Map<String, dynamic>),
      ),
    );

    // Parse unreadCount map
    final rawUnread = data['unreadCount'] as Map<String, dynamic>? ?? {};
    final parsedUnread = rawUnread.map(
      (key, value) => MapEntry(key, (value as num?)?.toInt() ?? 0),
    );

    return ConversationModel(
      conversationId: id,
      participantIds: List<String>.from(data['participantIds'] ?? []),
      participantDetails: parsedDetails,
      lastMessage: data['lastMessage'] ?? '',
      lastMessageAt: parseDateTime(data['lastMessageAt']),
      lastMessageSenderId: data['lastMessageSenderId'] ?? '',
      unreadCount: parsedUnread,
      isGroup: data['isGroup'] ?? false,
      groupName: data['groupName'],
      createdAt: parseDateTime(data['createdAt']),
    );
  }

  /// Get the unread count for a specific user
  int unreadCountForUser(String uid) => unreadCount[uid] ?? 0;

  /// Get the other participant's details in a 1:1 conversation
  ParticipantDetail? otherParticipant(String currentUid) {
    final otherId = participantIds.firstWhere(
      (id) => id != currentUid,
      orElse: () => '',
    );
    return otherId.isNotEmpty ? participantDetails[otherId] : null;
  }

  /// Display name for the conversation
  String displayName(String currentUid) {
    if (isGroup) return groupName ?? 'Group';
    final other = otherParticipant(currentUid);
    return other?.fullName ?? 'Unknown';
  }
}
