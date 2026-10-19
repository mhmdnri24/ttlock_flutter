import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ttlock_flutter/ttlock.dart';

import '../../core/storage/lock_list_provider.dart';
import '../settings/model/saved_lock_device.dart';
import 'model/remote_lock.dart';
import 'remote_lock_api_service.dart';

part 'remote_lock_list_provider.g.dart';

@riverpod
class RemoteLockList extends _$RemoteLockList {
  late final LockApiService _service = LockApiService();

  @override
  Future<List<RemoteLock>> build() async {
    ref.onDispose(_service.close);
    return _fetchAndSync();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchAndSync);
  }

  Future<List<RemoteLock>> _fetchAndSync() async {
    final remoteLocks = await _service.fetchAllLocks();
    await syncRemoteLocksToLocal(ref, remoteLocks);
    return remoteLocks;
  }
}

Future<void> syncRemoteLocksToLocal(
  Ref ref,
  List<RemoteLock> remoteLocks,
) async {
  final now = DateTime.now();
  final devices = remoteLocks.map((remote) {
    final version = remote.lockVersion;
    return SavedLockDevice.fromLockVersion(
      name: remote.name,
      mac: remote.mac,
      lockData: remote.lockData,
      lockVersion: TTLockVersion(
        protocolType: _requiredVersionInt(version, 'protocolType'),
        protocolVersion: _requiredVersionInt(version, 'protocolVersion'),
        scene: _requiredVersionInt(version, 'scene'),
        groupId: _requiredVersionInt(version, 'groupId'),
        orgId: _requiredVersionInt(version, 'orgId'),
      ),
      lockAlias: remote.alias,
      battery: remote.battery,
      hasGateway: remote.hasGateway,
      groupName: remote.groupName,
      initializedAt: now,
    );
  }).toList();

  await ref.read(lockListNotifierProvider.notifier).mergeRemoteDevices(devices);
}

int _requiredVersionInt(Map<String, dynamic> lockVersion, String key) {
  final value = lockVersion[key];
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    final parsed = int.tryParse(value);
    if (parsed != null) return parsed;
  }
  throw const LockApiException(
    'TTLock Cloud returned unsupported lock version metadata.',
  );
}
