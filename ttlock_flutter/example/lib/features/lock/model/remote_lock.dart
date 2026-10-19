// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_lock.freezed.dart';
part 'remote_lock.g.dart';

@Freezed(toStringOverride: false)
abstract class RemoteLock with _$RemoteLock {
  const factory RemoteLock({
    @JsonKey(name: 'lockId') required int lockId,
    @JsonKey(name: 'lockAlias') String? alias,
    @JsonKey(name: 'lockName') required String name,
    @JsonKey(name: 'lockMac') required String mac,
    @JsonKey(name: 'lockData', includeToJson: false) required String lockData,
    @JsonKey(name: 'electricQuantity') int? battery,
    @JsonKey(name: 'hasGateway') int? hasGateway,
    @JsonKey(name: 'groupName') String? groupName,
    @JsonKey(name: 'lockVersion') required Map<String, dynamic> lockVersion,
  }) = _RemoteLock;

  factory RemoteLock.fromJson(Map<String, dynamic> json) =>
      _$RemoteLockFromJson(json);
}
