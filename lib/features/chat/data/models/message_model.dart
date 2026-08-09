import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String messageId,
    required String senderId,
    required String text,
    @Default('text') String type,
    String? mediaUrl,
    String? fileName,
    String? fileSize,
    String? duration,
    required DateTime sentAt,
    @Default([]) List<String> readBy,
  }) = _MessageModel;

  const MessageModel._();

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  factory MessageModel.fromFirestore(Map<String, dynamic> data, String id) {
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

    return MessageModel(
      messageId: id,
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      type: data['type'] ?? 'text',
      mediaUrl: data['mediaUrl'],
      fileName: data['fileName'],
      fileSize: data['fileSize'],
      duration: data['duration'],
      sentAt: parseDateTime(data['sentAt']),
      readBy: List<String>.from(data['readBy'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'text': text,
      'type': type,
      if (mediaUrl != null) 'mediaUrl': mediaUrl,
      if (fileName != null) 'fileName': fileName,
      if (fileSize != null) 'fileSize': fileSize,
      if (duration != null) 'duration': duration,
      'sentAt': sentAt,
      'readBy': readBy,
    };
  }

  bool get isImage => type == 'image';
  bool get isDocument => type == 'document';
  bool get isVoice => type == 'voice';
  bool get isText => type == 'text';
}
