import 'dart:convert';
import 'package:minden/core/env/api_config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/success/success.dart';
import 'package:http/http.dart' as http;

abstract class ResetPasswordDataSource {
  Future<Success> resetPassword({required String loginId});
  Future<Success> updataPassword(
      {required String loginId,
      required String confirmationCode,
      required String newPassword});
}

class ResetPasswordDataSourceImpl implements ResetPasswordDataSource {
  const ResetPasswordDataSourceImpl({required this.client});

  final http.Client client;

  String get _resetPasswordPath => '/api/v1/password/reset';
  String get _updataPasswordPath => '/api/v1/password';

  @override
  Future<Success> resetPassword({required String loginId}) async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();

    headers.addAll(ApiConfig.contentTypeHeaderApplicationJson);
    final body = json.encode({'loginId': loginId});

    final response = await client.post(Uri.parse(endpoint + _resetPasswordPath),
        headers: headers, body: body);

    if (response.statusCode == 200) {
      return Success();
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Success> updataPassword(
      {required String loginId,
      required String confirmationCode,
      required String newPassword}) async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();

    headers.addAll(ApiConfig.contentTypeHeaderApplicationJson);
    final body = json.encode({
      'loginId': loginId,
      'confirmationCode': confirmationCode,
      'newPassword': newPassword
    });

    final response = await client.put(Uri.parse(endpoint + _updataPasswordPath),
        headers: headers, body: body);

    if (response.statusCode == 200) {
      return Success();
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      throw ServerException();
    }
  }
}
