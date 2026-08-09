// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ParticipantDetail _$ParticipantDetailFromJson(Map<String, dynamic> json) {
  return _ParticipantDetail.fromJson(json);
}

/// @nodoc
mixin _$ParticipantDetail {
  String get fullName => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ParticipantDetailCopyWith<ParticipantDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParticipantDetailCopyWith<$Res> {
  factory $ParticipantDetailCopyWith(
          ParticipantDetail value, $Res Function(ParticipantDetail) then) =
      _$ParticipantDetailCopyWithImpl<$Res, ParticipantDetail>;
  @useResult
  $Res call({String fullName, String? photoUrl});
}

/// @nodoc
class _$ParticipantDetailCopyWithImpl<$Res, $Val extends ParticipantDetail>
    implements $ParticipantDetailCopyWith<$Res> {
  _$ParticipantDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? photoUrl = freezed,
  }) {
    return _then(_value.copyWith(
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ParticipantDetailImplCopyWith<$Res>
    implements $ParticipantDetailCopyWith<$Res> {
  factory _$$ParticipantDetailImplCopyWith(_$ParticipantDetailImpl value,
          $Res Function(_$ParticipantDetailImpl) then) =
      __$$ParticipantDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String fullName, String? photoUrl});
}

/// @nodoc
class __$$ParticipantDetailImplCopyWithImpl<$Res>
    extends _$ParticipantDetailCopyWithImpl<$Res, _$ParticipantDetailImpl>
    implements _$$ParticipantDetailImplCopyWith<$Res> {
  __$$ParticipantDetailImplCopyWithImpl(_$ParticipantDetailImpl _value,
      $Res Function(_$ParticipantDetailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? photoUrl = freezed,
  }) {
    return _then(_$ParticipantDetailImpl(
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ParticipantDetailImpl implements _ParticipantDetail {
  const _$ParticipantDetailImpl({required this.fullName, this.photoUrl});

  factory _$ParticipantDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParticipantDetailImplFromJson(json);

  @override
  final String fullName;
  @override
  final String? photoUrl;

  @override
  String toString() {
    return 'ParticipantDetail(fullName: $fullName, photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParticipantDetailImpl &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, fullName, photoUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ParticipantDetailImplCopyWith<_$ParticipantDetailImpl> get copyWith =>
      __$$ParticipantDetailImplCopyWithImpl<_$ParticipantDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParticipantDetailImplToJson(
      this,
    );
  }
}

abstract class _ParticipantDetail implements ParticipantDetail {
  const factory _ParticipantDetail(
      {required final String fullName,
      final String? photoUrl}) = _$ParticipantDetailImpl;

  factory _ParticipantDetail.fromJson(Map<String, dynamic> json) =
      _$ParticipantDetailImpl.fromJson;

  @override
  String get fullName;
  @override
  String? get photoUrl;
  @override
  @JsonKey(ignore: true)
  _$$ParticipantDetailImplCopyWith<_$ParticipantDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) {
  return _ConversationModel.fromJson(json);
}

/// @nodoc
mixin _$ConversationModel {
  String get conversationId => throw _privateConstructorUsedError;
  List<String> get participantIds => throw _privateConstructorUsedError;
  Map<String, ParticipantDetail> get participantDetails =>
      throw _privateConstructorUsedError;
  String get lastMessage => throw _privateConstructorUsedError;
  DateTime? get lastMessageAt => throw _privateConstructorUsedError;
  String get lastMessageSenderId => throw _privateConstructorUsedError;
  Map<String, int> get unreadCount => throw _privateConstructorUsedError;
  bool get isGroup => throw _privateConstructorUsedError;
  String? get groupName => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConversationModelCopyWith<ConversationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationModelCopyWith<$Res> {
  factory $ConversationModelCopyWith(
          ConversationModel value, $Res Function(ConversationModel) then) =
      _$ConversationModelCopyWithImpl<$Res, ConversationModel>;
  @useResult
  $Res call(
      {String conversationId,
      List<String> participantIds,
      Map<String, ParticipantDetail> participantDetails,
      String lastMessage,
      DateTime? lastMessageAt,
      String lastMessageSenderId,
      Map<String, int> unreadCount,
      bool isGroup,
      String? groupName,
      DateTime createdAt});
}

/// @nodoc
class _$ConversationModelCopyWithImpl<$Res, $Val extends ConversationModel>
    implements $ConversationModelCopyWith<$Res> {
  _$ConversationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationId = null,
    Object? participantIds = null,
    Object? participantDetails = null,
    Object? lastMessage = null,
    Object? lastMessageAt = freezed,
    Object? lastMessageSenderId = null,
    Object? unreadCount = null,
    Object? isGroup = null,
    Object? groupName = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      participantIds: null == participantIds
          ? _value.participantIds
          : participantIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      participantDetails: null == participantDetails
          ? _value.participantDetails
          : participantDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, ParticipantDetail>,
      lastMessage: null == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastMessageSenderId: null == lastMessageSenderId
          ? _value.lastMessageSenderId
          : lastMessageSenderId // ignore: cast_nullable_to_non_nullable
              as String,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      isGroup: null == isGroup
          ? _value.isGroup
          : isGroup // ignore: cast_nullable_to_non_nullable
              as bool,
      groupName: freezed == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationModelImplCopyWith<$Res>
    implements $ConversationModelCopyWith<$Res> {
  factory _$$ConversationModelImplCopyWith(_$ConversationModelImpl value,
          $Res Function(_$ConversationModelImpl) then) =
      __$$ConversationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String conversationId,
      List<String> participantIds,
      Map<String, ParticipantDetail> participantDetails,
      String lastMessage,
      DateTime? lastMessageAt,
      String lastMessageSenderId,
      Map<String, int> unreadCount,
      bool isGroup,
      String? groupName,
      DateTime createdAt});
}

/// @nodoc
class __$$ConversationModelImplCopyWithImpl<$Res>
    extends _$ConversationModelCopyWithImpl<$Res, _$ConversationModelImpl>
    implements _$$ConversationModelImplCopyWith<$Res> {
  __$$ConversationModelImplCopyWithImpl(_$ConversationModelImpl _value,
      $Res Function(_$ConversationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationId = null,
    Object? participantIds = null,
    Object? participantDetails = null,
    Object? lastMessage = null,
    Object? lastMessageAt = freezed,
    Object? lastMessageSenderId = null,
    Object? unreadCount = null,
    Object? isGroup = null,
    Object? groupName = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$ConversationModelImpl(
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      participantIds: null == participantIds
          ? _value._participantIds
          : participantIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      participantDetails: null == participantDetails
          ? _value._participantDetails
          : participantDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, ParticipantDetail>,
      lastMessage: null == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastMessageSenderId: null == lastMessageSenderId
          ? _value.lastMessageSenderId
          : lastMessageSenderId // ignore: cast_nullable_to_non_nullable
              as String,
      unreadCount: null == unreadCount
          ? _value._unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      isGroup: null == isGroup
          ? _value.isGroup
          : isGroup // ignore: cast_nullable_to_non_nullable
              as bool,
      groupName: freezed == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationModelImpl extends _ConversationModel {
  const _$ConversationModelImpl(
      {required this.conversationId,
      required final List<String> participantIds,
      required final Map<String, ParticipantDetail> participantDetails,
      this.lastMessage = '',
      this.lastMessageAt,
      this.lastMessageSenderId = '',
      final Map<String, int> unreadCount = const {},
      this.isGroup = false,
      this.groupName,
      required this.createdAt})
      : _participantIds = participantIds,
        _participantDetails = participantDetails,
        _unreadCount = unreadCount,
        super._();

  factory _$ConversationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationModelImplFromJson(json);

  @override
  final String conversationId;
  final List<String> _participantIds;
  @override
  List<String> get participantIds {
    if (_participantIds is EqualUnmodifiableListView) return _participantIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participantIds);
  }

  final Map<String, ParticipantDetail> _participantDetails;
  @override
  Map<String, ParticipantDetail> get participantDetails {
    if (_participantDetails is EqualUnmodifiableMapView)
      return _participantDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_participantDetails);
  }

  @override
  @JsonKey()
  final String lastMessage;
  @override
  final DateTime? lastMessageAt;
  @override
  @JsonKey()
  final String lastMessageSenderId;
  final Map<String, int> _unreadCount;
  @override
  @JsonKey()
  Map<String, int> get unreadCount {
    if (_unreadCount is EqualUnmodifiableMapView) return _unreadCount;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_unreadCount);
  }

  @override
  @JsonKey()
  final bool isGroup;
  @override
  final String? groupName;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ConversationModel(conversationId: $conversationId, participantIds: $participantIds, participantDetails: $participantDetails, lastMessage: $lastMessage, lastMessageAt: $lastMessageAt, lastMessageSenderId: $lastMessageSenderId, unreadCount: $unreadCount, isGroup: $isGroup, groupName: $groupName, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationModelImpl &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            const DeepCollectionEquality()
                .equals(other._participantIds, _participantIds) &&
            const DeepCollectionEquality()
                .equals(other._participantDetails, _participantDetails) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.lastMessageSenderId, lastMessageSenderId) ||
                other.lastMessageSenderId == lastMessageSenderId) &&
            const DeepCollectionEquality()
                .equals(other._unreadCount, _unreadCount) &&
            (identical(other.isGroup, isGroup) || other.isGroup == isGroup) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      conversationId,
      const DeepCollectionEquality().hash(_participantIds),
      const DeepCollectionEquality().hash(_participantDetails),
      lastMessage,
      lastMessageAt,
      lastMessageSenderId,
      const DeepCollectionEquality().hash(_unreadCount),
      isGroup,
      groupName,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationModelImplCopyWith<_$ConversationModelImpl> get copyWith =>
      __$$ConversationModelImplCopyWithImpl<_$ConversationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationModelImplToJson(
      this,
    );
  }
}

abstract class _ConversationModel extends ConversationModel {
  const factory _ConversationModel(
      {required final String conversationId,
      required final List<String> participantIds,
      required final Map<String, ParticipantDetail> participantDetails,
      final String lastMessage,
      final DateTime? lastMessageAt,
      final String lastMessageSenderId,
      final Map<String, int> unreadCount,
      final bool isGroup,
      final String? groupName,
      required final DateTime createdAt}) = _$ConversationModelImpl;
  const _ConversationModel._() : super._();

  factory _ConversationModel.fromJson(Map<String, dynamic> json) =
      _$ConversationModelImpl.fromJson;

  @override
  String get conversationId;
  @override
  List<String> get participantIds;
  @override
  Map<String, ParticipantDetail> get participantDetails;
  @override
  String get lastMessage;
  @override
  DateTime? get lastMessageAt;
  @override
  String get lastMessageSenderId;
  @override
  Map<String, int> get unreadCount;
  @override
  bool get isGroup;
  @override
  String? get groupName;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ConversationModelImplCopyWith<_$ConversationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
