import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/ttlock_config.dart';
import 'model/remote_lock.dart';

class LockApiException implements Exception {
  const LockApiException(this.message, {this.errorCode});

  final String message;
  final String? errorCode;

  @override
  String toString() =>
      errorCode == null ? message : '$message (TTLock error $errorCode)';
}

class LockApiService {
  LockApiService({http.Client? client}) : _client = client ?? http.Client();

  static const int _pageSize = 100;
  static const Duration _requestTimeout = Duration(seconds: 30);

  final http.Client _client;

  Future<List<RemoteLock>> fetchAllLocks() async {
    if (TTLockConfig.clientId.isEmpty ||
        TTLockConfig.accessToken.isEmpty ||
        TTLockConfig.clientId == 'ISI_NANTI' ||
        TTLockConfig.accessToken == 'ISI_NANTI') {
      throw const LockApiException(
        'Set the TTLock client ID and access token in ttlock_config.dart.',
      );
    }

    final locks = <RemoteLock>[];
    var pageNo = 1;
    var pages = 1;

    do {
      final uri = _buildUri(pageNo);
      final http.Response response;
      try {
        response = await _client.get(uri).timeout(_requestTimeout);
      } on Exception {
        throw const LockApiException(
          'Could not reach TTLock Cloud. Check the network and try again.',
        );
      }

      final Map<String, dynamic> payload;
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is! Map) {
          throw const FormatException();
        }
        payload = Map<String, dynamic>.from(decoded);
      } on FormatException {
        throw const LockApiException(
          'TTLock Cloud returned an invalid response.',
        );
      } on TypeError {
        throw const LockApiException(
          'TTLock Cloud returned an invalid response.',
        );
      }

      if (payload.containsKey('errcode')) {
        final rawCode = payload['errcode'];
        final code = rawCode is num
            ? rawCode.toInt().toString()
            : rawCode is String && RegExp(r'^-?\d+$').hasMatch(rawCode)
                ? rawCode
                : 'unknown';
        throw LockApiException(
          _apiErrorMessage(code),
          errorCode: code,
        );
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw LockApiException(
          'TTLock Cloud request failed with HTTP ${response.statusCode}.',
        );
      }

      final list = payload['list'];
      final responsePages = payload['pages'];
      if (list is! List || responsePages is! num) {
        throw const LockApiException(
          'TTLock Cloud returned an incomplete lock list.',
        );
      }

      try {
        locks.addAll(
          list.map(
            (item) => RemoteLock.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          ),
        );
      } on Object {
        throw const LockApiException(
          'TTLock Cloud returned lock data in an unexpected format.',
        );
      }

      pages = responsePages.toInt();
      pageNo++;
    } while (pageNo <= pages);

    return locks;
  }

  Uri _buildUri(int pageNo) {
    final baseUri = Uri.parse(TTLockConfig.baseUrl);
    return baseUri.resolve('/v3/lock/list').replace(
      queryParameters: {
        'clientId': TTLockConfig.clientId,
        'accessToken': TTLockConfig.accessToken,
        'pageNo': '$pageNo',
        'pageSize': '$_pageSize',
        'date': '${DateTime.now().millisecondsSinceEpoch}',
      },
    );
  }

  String _apiErrorMessage(String code) {
    if (code == '20002') {
      return 'This account is not the administrator of the lock.';
    }
    return 'TTLock Cloud rejected the request. Check account permissions and token validity.';
  }

  void close() => _client.close();
}
