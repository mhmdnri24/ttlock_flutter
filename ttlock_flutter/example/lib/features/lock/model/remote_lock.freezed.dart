// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_lock.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RemoteLock {
  @JsonKey(name: 'lockId')
  int get lockId;
  @JsonKey(name: 'lockAlias')
  String? get alias;
  @JsonKey(name: 'lockName')
  String get name;
  @JsonKey(name: 'lockMac')
  String get mac;
  @JsonKey(name: 'lockData', includeToJson: false)
  String get lockData;
  @JsonKey(name: 'electricQuantity')
  int? get battery;
  @JsonKey(name: 'hasGateway')
  int? get hasGateway;
  @JsonKey(name: 'groupName')
  String? get groupName;
  @JsonKey(name: 'lockVersion')
  Map<String, dynamic> get lockVersion;

  /// Create a copy of RemoteLock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RemoteLockCopyWith<RemoteLock> get copyWith =>
      _$RemoteLockCopyWithImpl<RemoteLock>(this as RemoteLock, _$identity);

  /// Serializes this RemoteLock to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RemoteLock &&
            (identical(other.lockId, lockId) || other.lockId == lockId) &&
            (identical(other.alias, alias) || other.alias == alias) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.mac, mac) || other.mac == mac) &&
            (identical(other.lockData, lockData) ||
                other.lockData == lockData) &&
            (identical(other.battery, battery) || other.battery == battery) &&
            (identical(other.hasGateway, hasGateway) ||
                other.hasGateway == hasGateway) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            const DeepCollectionEquality()
                .equals(other.lockVersion, lockVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      lockId,
      alias,
      name,
      mac,
      lockData,
      battery,
      hasGateway,
      groupName,
      const DeepCollectionEquality().hash(lockVersion));
}

/// @nodoc
abstract mixin class $RemoteLockCopyWith<$Res> {
  factory $RemoteLockCopyWith(
          RemoteLock value, $Res Function(RemoteLock) _then) =
      _$RemoteLockCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'lockId') int lockId,
      @JsonKey(name: 'lockAlias') String? alias,
      @JsonKey(name: 'lockName') String name,
      @JsonKey(name: 'lockMac') String mac,
      @JsonKey(name: 'lockData', includeToJson: false) String lockData,
      @JsonKey(name: 'electricQuantity') int? battery,
      @JsonKey(name: 'hasGateway') int? hasGateway,
      @JsonKey(name: 'groupName') String? groupName,
      @JsonKey(name: 'lockVersion') Map<String, dynamic> lockVersion});
}

/// @nodoc
class _$RemoteLockCopyWithImpl<$Res> implements $RemoteLockCopyWith<$Res> {
  _$RemoteLockCopyWithImpl(this._self, this._then);

  final RemoteLock _self;
  final $Res Function(RemoteLock) _then;

  /// Create a copy of RemoteLock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lockId = null,
    Object? alias = freezed,
    Object? name = null,
    Object? mac = null,
    Object? lockData = null,
    Object? battery = freezed,
    Object? hasGateway = freezed,
    Object? groupName = freezed,
    Object? lockVersion = null,
  }) {
    return _then(_self.copyWith(
      lockId: null == lockId
          ? _self.lockId
          : lockId // ignore: cast_nullable_to_non_nullable
              as int,
      alias: freezed == alias
          ? _self.alias
          : alias // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      mac: null == mac
          ? _self.mac
          : mac // ignore: cast_nullable_to_non_nullable
              as String,
      lockData: null == lockData
          ? _self.lockData
          : lockData // ignore: cast_nullable_to_non_nullable
              as String,
      battery: freezed == battery
          ? _self.battery
          : battery // ignore: cast_nullable_to_non_nullable
              as int?,
      hasGateway: freezed == hasGateway
          ? _self.hasGateway
          : hasGateway // ignore: cast_nullable_to_non_nullable
              as int?,
      groupName: freezed == groupName
          ? _self.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String?,
      lockVersion: null == lockVersion
          ? _self.lockVersion
          : lockVersion // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _RemoteLock implements RemoteLock {
  const _RemoteLock(
      {@JsonKey(name: 'lockId') required this.lockId,
      @JsonKey(name: 'lockAlias') this.alias,
      @JsonKey(name: 'lockName') required this.name,
      @JsonKey(name: 'lockMac') required this.mac,
      @JsonKey(name: 'lockData', includeToJson: false) required this.lockData,
      @JsonKey(name: 'electricQuantity') this.battery,
      @JsonKey(name: 'hasGateway') this.hasGateway,
      @JsonKey(name: 'groupName') this.groupName,
      @JsonKey(name: 'lockVersion')
      required final Map<String, dynamic> lockVersion})
      : _lockVersion = lockVersion;
  factory _RemoteLock.fromJson(Map<String, dynamic> json) =>
      _$RemoteLockFromJson(json);

  @override
  @JsonKey(name: 'lockId')
  final int lockId;
  @override
  @JsonKey(name: 'lockAlias')
  final String? alias;
  @override
  @JsonKey(name: 'lockName')
  final String name;
  @override
  @JsonKey(name: 'lockMac')
  final String mac;
  @override
  @JsonKey(name: 'lockData', includeToJson: false)
  final String lockData;
  @override
  @JsonKey(name: 'electricQuantity')
  final int? battery;
  @override
  @JsonKey(name: 'hasGateway')
  final int? hasGateway;
  @override
  @JsonKey(name: 'groupName')
  final String? groupName;
  final Map<String, dynamic> _lockVersion;
  @override
  @JsonKey(name: 'lockVersion')
  Map<String, dynamic> get lockVersion {
    if (_lockVersion is EqualUnmodifiableMapView) return _lockVersion;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_lockVersion);
  }

  /// Create a copy of RemoteLock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RemoteLockCopyWith<_RemoteLock> get copyWith =>
      __$RemoteLockCopyWithImpl<_RemoteLock>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RemoteLockToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RemoteLock &&
            (identical(other.lockId, lockId) || other.lockId == lockId) &&
            (identical(other.alias, alias) || other.alias == alias) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.mac, mac) || other.mac == mac) &&
            (identical(other.lockData, lockData) ||
                other.lockData == lockData) &&
            (identical(other.battery, battery) || other.battery == battery) &&
            (identical(other.hasGateway, hasGateway) ||
                other.hasGateway == hasGateway) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            const DeepCollectionEquality()
                .equals(other._lockVersion, _lockVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      lockId,
      alias,
      name,
      mac,
      lockData,
      battery,
      hasGateway,
      groupName,
      const DeepCollectionEquality().hash(_lockVersion));
}

/// @nodoc
abstract mixin class _$RemoteLockCopyWith<$Res>
    implements $RemoteLockCopyWith<$Res> {
  factory _$RemoteLockCopyWith(
          _RemoteLock value, $Res Function(_RemoteLock) _then) =
      __$RemoteLockCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'lockId') int lockId,
      @JsonKey(name: 'lockAlias') String? alias,
      @JsonKey(name: 'lockName') String name,
      @JsonKey(name: 'lockMac') String mac,
      @JsonKey(name: 'lockData', includeToJson: false) String lockData,
      @JsonKey(name: 'electricQuantity') int? battery,
      @JsonKey(name: 'hasGateway') int? hasGateway,
      @JsonKey(name: 'groupName') String? groupName,
      @JsonKey(name: 'lockVersion') Map<String, dynamic> lockVersion});
}

/// @nodoc
class __$RemoteLockCopyWithImpl<$Res> implements _$RemoteLockCopyWith<$Res> {
  __$RemoteLockCopyWithImpl(this._self, this._then);

  final _RemoteLock _self;
  final $Res Function(_RemoteLock) _then;

  /// Create a copy of RemoteLock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? lockId = null,
    Object? alias = freezed,
    Object? name = null,
    Object? mac = null,
    Object? lockData = null,
    Object? battery = freezed,
    Object? hasGateway = freezed,
    Object? groupName = freezed,
    Object? lockVersion = null,
  }) {
    return _then(_RemoteLock(
      lockId: null == lockId
          ? _self.lockId
          : lockId // ignore: cast_nullable_to_non_nullable
              as int,
      alias: freezed == alias
          ? _self.alias
          : alias // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      mac: null == mac
          ? _self.mac
          : mac // ignore: cast_nullable_to_non_nullable
              as String,
      lockData: null == lockData
          ? _self.lockData
          : lockData // ignore: cast_nullable_to_non_nullable
              as String,
      battery: freezed == battery
          ? _self.battery
          : battery // ignore: cast_nullable_to_non_nullable
              as int?,
      hasGateway: freezed == hasGateway
          ? _self.hasGateway
          : hasGateway // ignore: cast_nullable_to_non_nullable
              as int?,
      groupName: freezed == groupName
          ? _self.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String?,
      lockVersion: null == lockVersion
          ? _self._lockVersion
          : lockVersion // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

// dart format on
