import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/env/api_config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/features/user/data/model/profile_model.dart';

abstract class ProfileDataSource {
  Future<ProfileModel> update({
    required String name,
    required String icon,
    required String bio,
    required String wallPaper,
  });

  Future<ProfileModel> get({
    required String userId,
  });
}

class ProfileDataSourceImpl implements ProfileDataSource {
  const ProfileDataSourceImpl({required this.client});

  final http.Client client;

  String get _updatePath => '/api/v1/profile/edit';

  String get _getPath => '/api/v1/profile';

  @override
  Future<ProfileModel> update({
    required String name,
    required String icon,
    required String bio,
    required String wallPaper,
  }) async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();
    headers.addAll(ApiConfig.contentTypeHeaderApplicationJson);
    final param = {};

    if (name.isNotEmpty) {
      param['name'] = name;
    }
    if (icon.isNotEmpty) {
      param['icon'] = icon;
    }
    param['bio'] = bio;
    if (wallPaper.isNotEmpty) {
      param['wallPaper'] = wallPaper;
    }

    final body = json.encode(param);
    final response = await client.post(Uri.parse(endpoint + _updatePath),
        headers: headers, body: body);

    logD('#### profile update'
        ' : $body $headers, ${response.body}, ${response.headers}');
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      return ProfileModel.fromJson(json.decode(responseBody));
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProfileModel> get({required String userId}) async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();
    headers.addAll(ApiConfig.contentTypeHeaderApplicationXFormUrlEncoded);
    final queryParameters = {
      'userId': userId,
    };
    var url = Uri.parse(endpoint + _getPath);
    url = url.replace(queryParameters: queryParameters);
    final response = await client.get(
      url,
      headers: headers,
    );

    logD(response.body);
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      return ProfileModel.fromJson(json.decode(responseBody));
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      throw ServerException();
    }
  }
}
