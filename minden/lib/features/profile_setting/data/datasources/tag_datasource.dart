import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/env/api_config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/features/profile_setting/data/models/tag_category_model.dart';
import 'package:minden/features/profile_setting/data/models/tag_model.dart';

abstract class TagDataSource {
  Future<Success> updateTags({required List<int> tags});

  Future<List<TagCategoryModel>> getAllTags();

  Future<List<TagModel>> getTags();

  Future<List<TagModel>> getPlantTags(String plantId);

  Future<List<TagModel>> getPlantsTags();
}

class TagDataSourceImpl implements TagDataSource {
  const TagDataSourceImpl({required this.client});

  final http.Client client;

  String get _updateTagsPath => '/api/v1/profile/tags';

  String get _getAllTagsPath => '/api/v1/tags';

  String get _getTagsPath => '/api/v1/profile/tags';

  String get _getPlantTagsPath => '/api/v1/power_plant/tags';

  String get _getPlantsTagsPath => '/api/v1/power_plants/tags';

  @override
  Future<Success> updateTags({required List<int> tags}) async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();
    headers.addAll(ApiConfig.contentTypeHeaderApplicationJson);
    final body = json.encode({
      'tags': tags.toSet().toList().map<String>((e) => e.toString()).toList()
    });

    final response = await client.post(Uri.parse(endpoint + _updateTagsPath),
        headers: headers, body: body);

    print('### update tag $body, ${response.body}');
    if (response.statusCode == 200) {
      return Success();
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TagCategoryModel>> getAllTags() async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();
    headers.addAll(ApiConfig.contentTypeHeaderApplicationXFormUrlEncoded);
    final response = await client.get(
      Uri.parse(endpoint + _getAllTagsPath),
      headers: headers,
    );

    final responseBody = utf8.decode(response.bodyBytes);
    final list = json.decode(responseBody);
    final categories = list.map<TagCategoryModel>((e) {
      return TagCategoryModel.fromJson(e);
    }).toList();
    if (response.statusCode == 200) {
      return categories;
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TagModel>> getTags() async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();
    headers.addAll(ApiConfig.contentTypeHeaderApplicationXFormUrlEncoded);
    final response = await client.get(
      Uri.parse(endpoint + _getTagsPath),
      headers: headers,
    );

    final responseBody = utf8.decode(response.bodyBytes);
    final map = json.decode(responseBody);
    final list = map['tags'] ?? [];
    final tags = list.map<TagModel>((e) {
      return TagModel.fromJson(e);
    }).toList();

    if (response.statusCode == 200) {
      return tags;
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TagModel>> getPlantTags(String plantId) async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();
    headers.addAll(ApiConfig.contentTypeHeaderApplicationXFormUrlEncoded);
    final response = await client.get(
      Uri.parse(endpoint + _getPlantTagsPath),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return [TagModel.fromJson({})];
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TagModel>> getPlantsTags() async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();
    headers.addAll(ApiConfig.contentTypeHeaderApplicationXFormUrlEncoded);
    final response = await client.get(
      Uri.parse(endpoint + _getPlantsTagsPath),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return [TagModel.fromJson({})];
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      throw ServerException();
    }
  }
}
