import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/env/api_config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/features/profile_setting/data/models/tag_category_model.dart';
import 'package:minden/features/profile_setting/domain/entities/tag_category.dart';

abstract class TagDataSource {
  Future<Success> updateTags({required List<int> tags});

  Future<List<TagCategory>> getAllTags();

  Future<List<TagCategory>> getTags();

  Future<List<TagCategory>> getPlantTags(String plantId);

  Future<List<TagCategory>> getPlantsTags();
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
    final env = ApiConfig.apiEndpoint();
    final headers = await ApiConfig.tokenHeader();
    final body = json.encode(tags.map((e) => e.toString()).toList());
    final response = await client.post(
        Uri.parse((env['url']! as String) + _updateTagsPath),
        headers: headers,
        body: body);

    if (response.statusCode == 200) {
      return Success();
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TagCategory>> getAllTags() async {
    final env = ApiConfig.apiEndpoint();
    final headers = await ApiConfig.tokenHeader();
    final response = await client.get(
      Uri.parse((env['url']! as String) + _getAllTagsPath),
      headers: headers,
    );

    final list = json.decode(response.body);
    final categories = list.map<TagCategory>((e) {
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
  Future<List<TagCategory>> getTags() async {
    final env = ApiConfig.apiEndpoint();
    final headers = await ApiConfig.tokenHeader();
    final response = await client.get(
      Uri.parse((env['url']! as String) + _getTagsPath),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return [TagCategoryModel.fromJson({})];
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TagCategory>> getPlantTags(String plantId) async {
    final env = ApiConfig.apiEndpoint();
    final headers = await ApiConfig.tokenHeader();
    final response = await client.get(
      Uri.parse((env['url']! as String) + _getPlantTagsPath),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return [TagCategoryModel.fromJson({})];
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TagCategory>> getPlantsTags() async {
    final env = ApiConfig.apiEndpoint();
    final headers = await ApiConfig.tokenHeader();
    final response = await client.get(
      Uri.parse((env['url']! as String) + _getPlantsTagsPath),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return [TagCategoryModel.fromJson({})];
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      throw ServerException();
    }
  }
}
