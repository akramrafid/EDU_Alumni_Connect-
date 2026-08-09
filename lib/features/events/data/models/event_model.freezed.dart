// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventModel _$EventModelFromJson(Map<String, dynamic> json) {
  return _EventModel.fromJson(json);
}

/// @nodoc
mixin _$EventModel {
  String get eventId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get tag => throw _privateConstructorUsedError;
  DateTime get dateTime => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String? get bannerUrl => throw _privateConstructorUsedError;
  bool get isOnline => throw _privateConstructorUsedError;
  int get maxAttendees => throw _privateConstructorUsedError;
  int get rsvpCount => throw _privateConstructorUsedError;
  List<String> get rsvpUserIds => throw _privateConstructorUsedError;
  String get postedByAdminId => throw _privateConstructorUsedError;
  bool get reminderSent => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventModelCopyWith<EventModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventModelCopyWith<$Res> {
  factory $EventModelCopyWith(
          EventModel value, $Res Function(EventModel) then) =
      _$EventModelCopyWithImpl<$Res, EventModel>;
  @useResult
  $Res call(
      {String eventId,
      String title,
      String description,
      String tag,
      DateTime dateTime,
      String date,
      String time,
      String location,
      String? bannerUrl,
      bool isOnline,
      int maxAttendees,
      int rsvpCount,
      List<String> rsvpUserIds,
      String postedByAdminId,
      bool reminderSent,
      DateTime createdAt});
}

/// @nodoc
class _$EventModelCopyWithImpl<$Res, $Val extends EventModel>
    implements $EventModelCopyWith<$Res> {
  _$EventModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? title = null,
    Object? description = null,
    Object? tag = null,
    Object? dateTime = null,
    Object? date = null,
    Object? time = null,
    Object? location = null,
    Object? bannerUrl = freezed,
    Object? isOnline = null,
    Object? maxAttendees = null,
    Object? rsvpCount = null,
    Object? rsvpUserIds = null,
    Object? postedByAdminId = null,
    Object? reminderSent = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      bannerUrl: freezed == bannerUrl
          ? _value.bannerUrl
          : bannerUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      maxAttendees: null == maxAttendees
          ? _value.maxAttendees
          : maxAttendees // ignore: cast_nullable_to_non_nullable
              as int,
      rsvpCount: null == rsvpCount
          ? _value.rsvpCount
          : rsvpCount // ignore: cast_nullable_to_non_nullable
              as int,
      rsvpUserIds: null == rsvpUserIds
          ? _value.rsvpUserIds
          : rsvpUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      postedByAdminId: null == postedByAdminId
          ? _value.postedByAdminId
          : postedByAdminId // ignore: cast_nullable_to_non_nullable
              as String,
      reminderSent: null == reminderSent
          ? _value.reminderSent
          : reminderSent // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventModelImplCopyWith<$Res>
    implements $EventModelCopyWith<$Res> {
  factory _$$EventModelImplCopyWith(
          _$EventModelImpl value, $Res Function(_$EventModelImpl) then) =
      __$$EventModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String eventId,
      String title,
      String description,
      String tag,
      DateTime dateTime,
      String date,
      String time,
      String location,
      String? bannerUrl,
      bool isOnline,
      int maxAttendees,
      int rsvpCount,
      List<String> rsvpUserIds,
      String postedByAdminId,
      bool reminderSent,
      DateTime createdAt});
}

/// @nodoc
class __$$EventModelImplCopyWithImpl<$Res>
    extends _$EventModelCopyWithImpl<$Res, _$EventModelImpl>
    implements _$$EventModelImplCopyWith<$Res> {
  __$$EventModelImplCopyWithImpl(
      _$EventModelImpl _value, $Res Function(_$EventModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? title = null,
    Object? description = null,
    Object? tag = null,
    Object? dateTime = null,
    Object? date = null,
    Object? time = null,
    Object? location = null,
    Object? bannerUrl = freezed,
    Object? isOnline = null,
    Object? maxAttendees = null,
    Object? rsvpCount = null,
    Object? rsvpUserIds = null,
    Object? postedByAdminId = null,
    Object? reminderSent = null,
    Object? createdAt = null,
  }) {
    return _then(_$EventModelImpl(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      bannerUrl: freezed == bannerUrl
          ? _value.bannerUrl
          : bannerUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      maxAttendees: null == maxAttendees
          ? _value.maxAttendees
          : maxAttendees // ignore: cast_nullable_to_non_nullable
              as int,
      rsvpCount: null == rsvpCount
          ? _value.rsvpCount
          : rsvpCount // ignore: cast_nullable_to_non_nullable
              as int,
      rsvpUserIds: null == rsvpUserIds
          ? _value._rsvpUserIds
          : rsvpUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      postedByAdminId: null == postedByAdminId
          ? _value.postedByAdminId
          : postedByAdminId // ignore: cast_nullable_to_non_nullable
              as String,
      reminderSent: null == reminderSent
          ? _value.reminderSent
          : reminderSent // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventModelImpl extends _EventModel {
  const _$EventModelImpl(
      {required this.eventId,
      required this.title,
      required this.description,
      required this.tag,
      required this.dateTime,
      required this.date,
      required this.time,
      required this.location,
      this.bannerUrl,
      this.isOnline = false,
      required this.maxAttendees,
      this.rsvpCount = 0,
      final List<String> rsvpUserIds = const [],
      required this.postedByAdminId,
      this.reminderSent = false,
      required this.createdAt})
      : _rsvpUserIds = rsvpUserIds,
        super._();

  factory _$EventModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventModelImplFromJson(json);

  @override
  final String eventId;
  @override
  final String title;
  @override
  final String description;
  @override
  final String tag;
  @override
  final DateTime dateTime;
  @override
  final String date;
  @override
  final String time;
  @override
  final String location;
  @override
  final String? bannerUrl;
  @override
  @JsonKey()
  final bool isOnline;
  @override
  final int maxAttendees;
  @override
  @JsonKey()
  final int rsvpCount;
  final List<String> _rsvpUserIds;
  @override
  @JsonKey()
  List<String> get rsvpUserIds {
    if (_rsvpUserIds is EqualUnmodifiableListView) return _rsvpUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rsvpUserIds);
  }

  @override
  final String postedByAdminId;
  @override
  @JsonKey()
  final bool reminderSent;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'EventModel(eventId: $eventId, title: $title, description: $description, tag: $tag, dateTime: $dateTime, date: $date, time: $time, location: $location, bannerUrl: $bannerUrl, isOnline: $isOnline, maxAttendees: $maxAttendees, rsvpCount: $rsvpCount, rsvpUserIds: $rsvpUserIds, postedByAdminId: $postedByAdminId, reminderSent: $reminderSent, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventModelImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.tag, tag) || other.tag == tag) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.bannerUrl, bannerUrl) ||
                other.bannerUrl == bannerUrl) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.maxAttendees, maxAttendees) ||
                other.maxAttendees == maxAttendees) &&
            (identical(other.rsvpCount, rsvpCount) ||
                other.rsvpCount == rsvpCount) &&
            const DeepCollectionEquality()
                .equals(other._rsvpUserIds, _rsvpUserIds) &&
            (identical(other.postedByAdminId, postedByAdminId) ||
                other.postedByAdminId == postedByAdminId) &&
            (identical(other.reminderSent, reminderSent) ||
                other.reminderSent == reminderSent) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      eventId,
      title,
      description,
      tag,
      dateTime,
      date,
      time,
      location,
      bannerUrl,
      isOnline,
      maxAttendees,
      rsvpCount,
      const DeepCollectionEquality().hash(_rsvpUserIds),
      postedByAdminId,
      reminderSent,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventModelImplCopyWith<_$EventModelImpl> get copyWith =>
      __$$EventModelImplCopyWithImpl<_$EventModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventModelImplToJson(
      this,
    );
  }
}

abstract class _EventModel extends EventModel {
  const factory _EventModel(
      {required final String eventId,
      required final String title,
      required final String description,
      required final String tag,
      required final DateTime dateTime,
      required final String date,
      required final String time,
      required final String location,
      final String? bannerUrl,
      final bool isOnline,
      required final int maxAttendees,
      final int rsvpCount,
      final List<String> rsvpUserIds,
      required final String postedByAdminId,
      final bool reminderSent,
      required final DateTime createdAt}) = _$EventModelImpl;
  const _EventModel._() : super._();

  factory _EventModel.fromJson(Map<String, dynamic> json) =
      _$EventModelImpl.fromJson;

  @override
  String get eventId;
  @override
  String get title;
  @override
  String get description;
  @override
  String get tag;
  @override
  DateTime get dateTime;
  @override
  String get date;
  @override
  String get time;
  @override
  String get location;
  @override
  String? get bannerUrl;
  @override
  bool get isOnline;
  @override
  int get maxAttendees;
  @override
  int get rsvpCount;
  @override
  List<String> get rsvpUserIds;
  @override
  String get postedByAdminId;
  @override
  bool get reminderSent;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$EventModelImplCopyWith<_$EventModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
