import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:ttlock_flutter_example/features/lock/remote_lock_api_service.dart';

void main() {
  group('LockApiService.fetchAllLocks', () {
    test('fetches every page with page size 100 and a date per request',
        () async {
      final requests = <http.Request>[];
      final client = MockClient((request) async {
        requests.add(request);
        final pageNo = request.url.queryParameters['pageNo'];
        return http.Response(
          jsonEncode({
            'list': pageNo == '1' ? [_lockJson] : [],
            'pageNo': int.parse(pageNo!),
            'pageSize': 100,
            'pages': 2,
            'total': 1,
          }),
          200,
        );
      });
      final service = LockApiService(client: client);
      addTearDown(service.close);

      final locks = await service.fetchAllLocks();

      expect(locks, hasLength(1));
      expect(locks.single.name, 'Front door');
      expect(locks.single.alias, 'Entry');
      expect(locks.single.battery, 45);
      expect(locks.single.groupName, 'Home');
      expect(locks.single.hasGateway, 1);
      expect(requests, hasLength(2));
      expect(
        requests.map((request) => request.url.queryParameters['pageNo']),
        ['1', '2'],
      );
      for (final request in requests) {
        expect(request.url.path, '/v3/lock/list');
        expect(request.url.queryParameters['pageSize'], '100');
        expect(
          int.tryParse(request.url.queryParameters['date'] ?? ''),
          isNotNull,
        );
      }
      expect(locks.single.toJson(), isNot(contains('lockData')));
      expect(locks.single.toJson(), isNot(contains('noKeyPwd')));
      expect(locks.single.toString(), isNot(contains('private-lock-data')));
    });

    test(
        'surfaces the cloud error code without echoing sensitive response text',
        () async {
      final service = LockApiService(
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({
              'errcode': 20002,
              'errmsg': 'private-token private-lock-data private-no-key-pwd',
            }),
            200,
          ),
        ),
      );
      addTearDown(service.close);

      try {
        await service.fetchAllLocks();
        fail('Expected a LockApiException.');
      } on LockApiException catch (error) {
        expect(error.errorCode, '20002');
        expect(error.toString(), contains('administrator'));
        expect(error.toString(), isNot(contains('private-token')));
        expect(error.toString(), isNot(contains('private-lock-data')));
        expect(error.toString(), isNot(contains('private-no-key-pwd')));
      }
    });
  });
}

const _lockJson = {
  'lockId': 1,
  'lockAlias': 'Entry',
  'lockName': 'Front door',
  'lockMac': 'AA:BB:CC:DD:EE:FF',
  'lockData': 'private-lock-data',
  'electricQuantity': 45,
  'hasGateway': 1,
  'groupName': 'Home',
  'lockVersion': {
    'protocolType': 5,
    'protocolVersion': 3,
    'scene': 2,
    'groupId': 1,
    'orgId': 1,
  },
  'noKeyPwd': 'private-no-key-pwd',
};
