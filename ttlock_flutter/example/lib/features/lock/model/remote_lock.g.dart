// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_lock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RemoteLock _$RemoteLockFromJson(Map<String, dynamic> json) => _RemoteLock(
      lockId: (json['lockId'] as num).toInt(),
      alias: json['lockAlias'] as String?,
      name: json['lockName'] as String,
      mac: json['lockMac'] as String,
      lockData: json['lockData'] as String,
      battery: (json['electricQuantity'] as num?)?.toInt(),
      hasGateway: (json['hasGateway'] as num?)?.toInt(),
      groupName: json['groupName'] as String?,
      lockVersion: json['lockVersion'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$RemoteLockToJson(_RemoteLock instance) =>
    <String, dynamic>{
      'lockId': instance.lockId,
      'lockAlias': instance.alias,
      'lockName': instance.name,
      'lockMac': instance.mac,
      'electricQuantity': instance.battery,
      'hasGateway': instance.hasGateway,
      'groupName': instance.groupName,
      'lockVersion': instance.lockVersion,
    };
