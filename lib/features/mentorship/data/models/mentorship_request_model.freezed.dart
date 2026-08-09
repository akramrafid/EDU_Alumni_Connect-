// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mentorship_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MentorshipRequestModel _$MentorshipRequestModelFromJson(
    Map<String, dynamic> json) {
  return _MentorshipRequestModel.fromJson(json);
}

/// @nodoc
mixin _$MentorshipRequestModel {
  String get requestId => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  String get alumniId => throw _privateConstructorUsedError;
  String get studentName => throw _privateConstructorUsedError;
  String? get studentPhotoUrl => throw _privateConstructorUsedError;
  String get alumniName => throw _privateConstructorUsedError;
  String? get alumniPhotoUrl => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get declineReason => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MentorshipRequestModelCopyWith<MentorshipRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MentorshipRequestModelCopyWith<$Res> {
  factory $MentorshipRequestModelCopyWith(MentorshipRequestModel value,
          $Res Function(MentorshipRequestModel) then) =
      _$MentorshipRequestModelCopyWithImpl<$Res, MentorshipRequestModel>;
  @useResult
  $Res call(
      {String requestId,
      String studentId,
      String alumniId,
      String studentName,
      String? studentPhotoUrl,
      String alumniName,
      String? alumniPhotoUrl,
      String status,
      String message,
      String? declineReason,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$MentorshipRequestModelCopyWithImpl<$Res,
        $Val extends MentorshipRequestModel>
    implements $MentorshipRequestModelCopyWith<$Res> {
  _$MentorshipRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestId = null,
    Object? studentId = null,
    Object? alumniId = null,
    Object? studentName = null,
    Object? studentPhotoUrl = freezed,
    Object? alumniName = null,
    Object? alumniPhotoUrl = freezed,
    Object? status = null,
    Object? message = null,
    Object? declineReason = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      requestId: null == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      alumniId: null == alumniId
          ? _value.alumniId
          : alumniId // ignore: cast_nullable_to_non_nullable
              as String,
      studentName: null == studentName
          ? _value.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String,
      studentPhotoUrl: freezed == studentPhotoUrl
          ? _value.studentPhotoUrl
          : studentPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      alumniName: null == alumniName
          ? _value.alumniName
          : alumniName // ignore: cast_nullable_to_non_nullable
              as String,
      alumniPhotoUrl: freezed == alumniPhotoUrl
          ? _value.alumniPhotoUrl
          : alumniPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      declineReason: freezed == declineReason
          ? _value.declineReason
          : declineReason // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MentorshipRequestModelImplCopyWith<$Res>
    implements $MentorshipRequestModelCopyWith<$Res> {
  factory _$$MentorshipRequestModelImplCopyWith(
          _$MentorshipRequestModelImpl value,
          $Res Function(_$MentorshipRequestModelImpl) then) =
      __$$MentorshipRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String requestId,
      String studentId,
      String alumniId,
      String studentName,
      String? studentPhotoUrl,
      String alumniName,
      String? alumniPhotoUrl,
      String status,
      String message,
      String? declineReason,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$MentorshipRequestModelImplCopyWithImpl<$Res>
    extends _$MentorshipRequestModelCopyWithImpl<$Res,
        _$MentorshipRequestModelImpl>
    implements _$$MentorshipRequestModelImplCopyWith<$Res> {
  __$$MentorshipRequestModelImplCopyWithImpl(
      _$MentorshipRequestModelImpl _value,
      $Res Function(_$MentorshipRequestModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestId = null,
    Object? studentId = null,
    Object? alumniId = null,
    Object? studentName = null,
    Object? studentPhotoUrl = freezed,
    Object? alumniName = null,
    Object? alumniPhotoUrl = freezed,
    Object? status = null,
    Object? message = null,
    Object? declineReason = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$MentorshipRequestModelImpl(
      requestId: null == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      alumniId: null == alumniId
          ? _value.alumniId
          : alumniId // ignore: cast_nullable_to_non_nullable
              as String,
      studentName: null == studentName
          ? _value.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String,
      studentPhotoUrl: freezed == studentPhotoUrl
          ? _value.studentPhotoUrl
          : studentPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      alumniName: null == alumniName
          ? _value.alumniName
          : alumniName // ignore: cast_nullable_to_non_nullable
              as String,
      alumniPhotoUrl: freezed == alumniPhotoUrl
          ? _value.alumniPhotoUrl
          : alumniPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      declineReason: freezed == declineReason
          ? _value.declineReason
          : declineReason // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MentorshipRequestModelImpl extends _MentorshipRequestModel {
  const _$MentorshipRequestModelImpl(
      {required this.requestId,
      required this.studentId,
      required this.alumniId,
      required this.studentName,
      this.studentPhotoUrl,
      required this.alumniName,
      this.alumniPhotoUrl,
      required this.status,
      required this.message,
      this.declineReason,
      required this.createdAt,
      required this.updatedAt})
      : super._();

  factory _$MentorshipRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MentorshipRequestModelImplFromJson(json);

  @override
  final String requestId;
  @override
  final String studentId;
  @override
  final String alumniId;
  @override
  final String studentName;
  @override
  final String? studentPhotoUrl;
  @override
  final String alumniName;
  @override
  final String? alumniPhotoUrl;
  @override
  final String status;
  @override
  final String message;
  @override
  final String? declineReason;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'MentorshipRequestModel(requestId: $requestId, studentId: $studentId, alumniId: $alumniId, studentName: $studentName, studentPhotoUrl: $studentPhotoUrl, alumniName: $alumniName, alumniPhotoUrl: $alumniPhotoUrl, status: $status, message: $message, declineReason: $declineReason, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MentorshipRequestModelImpl &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.alumniId, alumniId) ||
                other.alumniId == alumniId) &&
            (identical(other.studentName, studentName) ||
                other.studentName == studentName) &&
            (identical(other.studentPhotoUrl, studentPhotoUrl) ||
                other.studentPhotoUrl == studentPhotoUrl) &&
            (identical(other.alumniName, alumniName) ||
                other.alumniName == alumniName) &&
            (identical(other.alumniPhotoUrl, alumniPhotoUrl) ||
                other.alumniPhotoUrl == alumniPhotoUrl) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.declineReason, declineReason) ||
                other.declineReason == declineReason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      requestId,
      studentId,
      alumniId,
      studentName,
      studentPhotoUrl,
      alumniName,
      alumniPhotoUrl,
      status,
      message,
      declineReason,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MentorshipRequestModelImplCopyWith<_$MentorshipRequestModelImpl>
      get copyWith => __$$MentorshipRequestModelImplCopyWithImpl<
          _$MentorshipRequestModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MentorshipRequestModelImplToJson(
      this,
    );
  }
}

abstract class _MentorshipRequestModel extends MentorshipRequestModel {
  const factory _MentorshipRequestModel(
      {required final String requestId,
      required final String studentId,
      required final String alumniId,
      required final String studentName,
      final String? studentPhotoUrl,
      required final String alumniName,
      final String? alumniPhotoUrl,
      required final String status,
      required final String message,
      final String? declineReason,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$MentorshipRequestModelImpl;
  const _MentorshipRequestModel._() : super._();

  factory _MentorshipRequestModel.fromJson(Map<String, dynamic> json) =
      _$MentorshipRequestModelImpl.fromJson;

  @override
  String get requestId;
  @override
  String get studentId;
  @override
  String get alumniId;
  @override
  String get studentName;
  @override
  String? get studentPhotoUrl;
  @override
  String get alumniName;
  @override
  String? get alumniPhotoUrl;
  @override
  String get status;
  @override
  String get message;
  @override
  String? get declineReason;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$MentorshipRequestModelImplCopyWith<_$MentorshipRequestModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
