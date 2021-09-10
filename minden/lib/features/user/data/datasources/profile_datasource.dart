import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/env/api_config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/user/data/model/profile_model.dart';

abstract class ProfileDataSource {
  Future<ProfileModel> update(
      {required String name,
      required String icon,
      required String bio,
      required String wallPaper});
}

class ProfileDataSourceImpl implements ProfileDataSource {
  const ProfileDataSourceImpl({required this.client});

  final http.Client client;

  String get _v1Path => '/api/v1/profile/edit';

  @override
  Future<ProfileModel> update(
      {required String name,
      required String icon,
      required String bio,
      required String wallPaper}) async {
    final env = ApiConfig.apiEndpoint();
    final headers = await ApiConfig.tokenHeader();
    var param = Map<String, String>();
    if (name.isNotEmpty) {
      param['name'] = name;
    }
    if (icon.isNotEmpty) {
      param['icon'] = icon;
    }
    if (bio.isNotEmpty) {
      param['bio'] = bio;
    }
    if (wallPaper.isNotEmpty) {
      param['wallPaper'] = wallPaper;
    }

    final body = json.encode(param);
    final response = await client.post(
        Uri.parse((env['url']! as String) + _v1Path),
        headers: headers,
        body: body);

    if (response.statusCode == 200) {
      return ProfileModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      throw ServerException();
    }
  }
}
