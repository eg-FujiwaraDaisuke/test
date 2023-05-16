import 'dart:convert';
import 'package:minden/core/env/api_config.dart';
import 'package:minden/core/success/success.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/ext/logger_ext.dart';

abstract class FcmTokenDataSource {
  Future<Success> updateFcmToken(String fcmToken);
}

class FcmTokenDataSourceImpl implements FcmTokenDataSource {
  FcmTokenDataSourceImpl({required this.client});

  final http.Client client;
  final _path = '/api/v1/profile/fcm';

  @override
  Future<Success> updateFcmToken(String fcmToken) async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();
    final body = json.encode({'fcm': fcmToken});

    headers.addAll(ApiConfig.contentTypeHeaderApplicationJson);

    final response = await client.post(
      Uri.parse(endpoint + _path),
      headers: headers,
      body: body,
    );
    final responseBody = utf8.decode(response.bodyBytes);
    logD(responseBody);
    return Success();
  }
}
