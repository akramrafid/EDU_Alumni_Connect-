// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) {
  return _MessageModel.fromJson(json);
}

/// @nodoc
mixin _$MessageModel {
  String get messageId => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get mediaUrl => throw _privateConstructorUsedError;
  String? get fileName => throw _privateConstructorUsedError;
  String? get fileSize => throw _privateConstructorUsedError;
  String? get duration => throw _privateConstructorUsedError;
  DateTime get sentAt => throw _privateConstructorUsedError;
  List<String> get readBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageModelCopyWith<MessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageModelCopyWith<$Res> {
  factory $MessageModelCopyWith(
          MessageModel value, $Res Function(MessageModel) then) =
      _$MessageModelCopyWithImpl<$Res, MessageModel>;
  @useResult
  $Res call(
      {String messageId,
      String senderId,
      String text,
      String type,
      String? mediaUrl,
      String? fileName,
      String? fileSize,
      String? duration,
      DateTime sentAt,
      List<String> readBy});
}

/// @nodoc
class _$MessageModelCopyWithImpl<$Res, $Val extends MessageModel>
    implements $MessageModelCopyWith<$Res> {
  _$MessageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageId = null,
    Object? senderId = null,
    Object? text = null,
    Object? type = null,
    Object? mediaUrl = freezed,
    Object? fileName = freezed,
    Object? fileSize = freezed,
    Object? duration = freezed,
    Object? sentAt = null,
    Object? readBy = null,
  }) {
    return _then(_value.copyWith(
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      mediaUrl: freezed == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSize: freezed == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String?,
      sentAt: null == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      readBy: null == readBy
          ? _value.readBy
          : readBy // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageModelImplCopyWith<$Res>
    implements $MessageModelCopyWith<$Res> {
  factory _$$MessageModelImplCopyWith(
          _$MessageModelImpl value, $Res Function(_$MessageModelImpl) then) =
      __$$MessageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String messageId,
      String senderId,
      String text,
      String type,
      String? mediaUrl,
      String? fileName,
      String? fileSize,
      String? duration,
      DateTime sentAt,
      List<String> readBy});
}

/// @nodoc
class __$$MessageModelImplCopyWithImpl<$Res>
    extends _$MessageModelCopyWithImpl<$Res, _$MessageModelImpl>
    implements _$$MessageModelImplCopyWith<$Res> {
  __$$MessageModelImplCopyWithImpl(
      _$MessageModelImpl _value, $Res Function(_$MessageModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageId = null,
    Object? senderId = null,
    Object? text = null,
    Object? type = null,
    Object? mediaUrl = freezed,
    Object? fileName = freezed,
    Object? fileSize = freezed,
    Object? duration = freezed,
    Object? sentAt = null,
    Object? readBy = null,
  }) {
    return _then(_$MessageModelImpl(
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      mediaUrl: freezed == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSize: freezed == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String?,
      sentAt: null == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      readBy: null == readBy
          ? _value._readBy
          : readBy // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageModelImpl extends _MessageModel {
  const _$MessageModelImpl(
      {required this.messageId,
      required this.senderId,
      required this.text,
      this.type = 'text',
      this.mediaUrl,
      this.fileName,
      this.fileSize,
      this.duration,
      required this.sentAt,
      final List<String> readBy = const []})
      : _readBy = readBy,
        super._();

  factory _$MessageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageModelImplFromJson(json);

  @override
  final String messageId;
  @override
  final String senderId;
  @override
  final String text;
  @override
  @JsonKey()
  final String type;
  @override
  final String? mediaUrl;
  @override
  final String? fileName;
  @override
  final String? fileSize;
  @override
  final String? duration;
  @override
  final DateTime sentAt;
  final List<String> _readBy;
  @override
  @JsonKey()
  List<String> get readBy {
    if (_readBy is EqualUnmodifiableListView) return _readBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_readBy);
  }

  @override
  String toString() {
    return 'MessageModel(messageId: $messageId, senderId: $senderId, text: $text, type: $type, mediaUrl: $mediaUrl, fileName: $fileName, fileSize: $fileSize, duration: $duration, sentAt: $sentAt, readBy: $readBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageModelImpl &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            const DeepCollectionEquality().equals(other._readBy, _readBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      messageId,
      senderId,
      text,
      type,
      mediaUrl,
      fileName,
      fileSize,
      duration,
      sentAt,
      const DeepCollectionEquality().hash(_readBy));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      __$$MessageModelImplCopyWithImpl<_$MessageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageModelImplToJson(
      this,
    );
  }
}

abstract class _MessageModel extends MessageModel {
  const factory _MessageModel(
      {required final String messageId,
      required final String senderId,
      required final String text,
      final String type,
      final String? mediaUrl,
      final String? fileName,
      final String? fileSize,
      final String? duration,
      required final DateTime sentAt,
      final List<String> readBy}) = _$MessageModelImpl;
  const _MessageModel._() : super._();

  factory _MessageModel.fromJson(Map<String, dynamic> json) =
      _$MessageModelImpl.fromJson;

  @override
  String get messageId;
  @override
  String get senderId;
  @override
  String get text;
  @override
  String get type;
  @override
  String? get mediaUrl;
  @override
  String? get fileName;
  @override
  String? get fileSize;
  @override
  String? get duration;
  @override
  DateTime get sentAt;
  @override
  List<String> get readBy;
  @override
  @JsonKey(ignore: true)
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
