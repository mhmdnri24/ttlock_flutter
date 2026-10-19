import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttlock_flutter/ttlock.dart';

part 'saved_lock_device.freezed.dart';
part 'saved_lock_device.g.dart';

@freezed
abstract class SavedLockDevice with _$SavedLockDevice {
  const factory SavedLockDevice({
    required String name,
    required String mac,
    required String lockData,
    String? lockAlias,
    int? battery,
    int? hasGateway,
    String? groupName,
    @Default(5) int protocolType,
    @Default(3) int protocolVersion,
    @Default(2) int scene,
    @Default(1) int groupId,
    @Default(1) int orgId,
    required DateTime initializedAt,
  }) = _SavedLockDevice;

  const SavedLockDevice._();

  factory SavedLockDevice.fromJson(Map<String, dynamic> json) =>
      _$SavedLockDeviceFromJson(json);

  TTLockVersion get lockVersion => TTLockVersion(
        protocolType: protocolType,
        protocolVersion: protocolVersion,
        scene: scene,
        groupId: groupId,
        orgId: orgId,
      );

  factory SavedLockDevice.fromLockVersion({
    required String name,
    required String mac,
    required String lockData,
    String? lockAlias,
    int? battery,
    int? hasGateway,
    String? groupName,
    required TTLockVersion lockVersion,
    required DateTime initializedAt,
  }) =>
      SavedLockDevice(
        name: name,
        mac: mac,
        lockData: lockData,
        lockAlias: lockAlias,
        battery: battery,
        hasGateway: hasGateway,
        groupName: groupName,
        protocolType: lockVersion.protocolType,
        protocolVersion: lockVersion.protocolVersion,
        scene: lockVersion.scene,
        groupId: lockVersion.groupId,
        orgId: lockVersion.orgId,
        initializedAt: initializedAt,
      );
}
