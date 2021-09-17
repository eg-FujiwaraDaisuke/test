import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/env/api_config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/features/power_plant/data/model/power_plant_detail_model.dart';
import 'package:minden/features/power_plant/data/model/power_plant_participant_model.dart';
import 'package:minden/features/power_plant/data/model/power_plants_response_model.dart';
import 'package:minden/features/power_plant/data/model/tag_response_model.dart';

final powerPlantDataSourceProvider = Provider<PowerPlantDataSource>(
    (ref) => PowerPlantDataSourceImpl(client: http.Client()));

abstract class PowerPlantDataSource {
  Future<PowerPlantsResponseModel> getPowerPlant(String? tagId);

  Future<PowerPlantDetailModel> getPowerPlantDetail(String plantId);

  Future<PowerPlantParticipantModel> getPowerPlantParticipants(String plantId);

  Future<TagResponseModel> getPowerPlantTags(String plantId);

  Future<PowerPlantsResponseModel> getPowerPlantHistory(String historyType);
}

class PowerPlantDataSourceImpl implements PowerPlantDataSource {
  PowerPlantDataSourceImpl({required this.client});

  final http.Client client;

  final _powerPlantsPath = '/api/v1/power_plants';

  final _powerPlantPath = '/api/v1/power_plant';

  final _powerPlantParticipantPath = '/api/v1/power_plant/participants';

  final _powerPlantTags = '/api/v1/power_plant/tags';

  final _powerPlantHistory = '/api/v1/support_history';

  @override
  Future<PowerPlantsResponseModel> getPowerPlant(String? tagId) async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();
    headers.addAll(ApiConfig.contentTypeHeaderApplicationXFormUrlEncoded);

    final url = Uri.parse(endpoint + _powerPlantsPath);
    final response = await client.get(
      url.replace(queryParameters: {
        // TODO fix
        'tagId': '0',
      }),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      logD(responseBody);
      return PowerPlantsResponseModel.fromJson(json.decode(responseBody));
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      logW('${response.statusCode}: ${response.body}');
      throw ServerException();
    }
  }

  @override
  Future<PowerPlantDetailModel> getPowerPlantDetail(String plantId) async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();
    headers.addAll(ApiConfig.contentTypeHeaderApplicationXFormUrlEncoded);

    final url = Uri.parse(endpoint + _powerPlantPath);
    final response = await client.get(
      url.replace(queryParameters: {'plantId': plantId}),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      logD(responseBody);
      return PowerPlantDetailModel.fromJson(json.decode(responseBody));
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      logW('${response.statusCode}: ${response.body}');
      throw ServerException();
    }
  }

  @override
  Future<PowerPlantParticipantModel> getPowerPlantParticipants(
      String plantId) async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();
    headers.addAll(ApiConfig.contentTypeHeaderApplicationXFormUrlEncoded);

    final url = Uri.parse(endpoint + _powerPlantParticipantPath);
    final response = await client.get(
      url.replace(queryParameters: {
        'plantId': plantId,
        'page': '1', // TODO optionalだけど400を返されるので一旦追加
      }),
      headers: headers,
    );

    if (response.statusCode == 200) {
      logD(utf8.decode(response.bodyBytes));
      return PowerPlantParticipantModel.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      logW('${response.statusCode}: ${response.body}');
      throw ServerException();
    }
  }

  @override
  Future<TagResponseModel> getPowerPlantTags(String plantId) async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();
    headers.addAll(ApiConfig.contentTypeHeaderApplicationXFormUrlEncoded);

    final url = Uri.parse(endpoint + _powerPlantTags);
    final response = await client.get(
      url.replace(queryParameters: {'plantId': plantId}),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return TagResponseModel.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      logW('${response.statusCode}: ${response.body}');
      throw ServerException();
    }
  }

  @override
  Future<PowerPlantsResponseModel> getPowerPlantHistory(
      String historyType) async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();
    headers.addAll(ApiConfig.contentTypeHeaderApplicationXFormUrlEncoded);

    final url = Uri.parse(endpoint + _powerPlantHistory);
    final response = await client.get(
      url.replace(queryParameters: {
        'historyType': historyType,
      }),
      headers: headers,
    );

    final responseBody = utf8.decode(response.bodyBytes);
    logD(responseBody);
    if (response.statusCode == 200) {
      return PowerPlantsResponseModel.fromJson(json.decode(responseBody));
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      logW('${response.statusCode}: ${response.body}');
      throw ServerException();
    }
  }
}