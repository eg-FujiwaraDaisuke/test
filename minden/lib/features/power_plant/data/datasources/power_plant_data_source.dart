import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/env/api_config.dart';
import 'package:minden/core/error/exceptions.dart';
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
}

class PowerPlantDataSourceImpl implements PowerPlantDataSource {
  PowerPlantDataSourceImpl({required this.client});

  final http.Client client;

  final _powerPlantsPath = '/api/v1/power_plants';

  final _powerPlantPath = '/api/v1/power_plant';

  final _powerPlantParticipantPath = '/api/v1/power_plant/participants';

  final _powerPlantTags = '/api/v1/power_plant/tags';

  @override
  Future<PowerPlantsResponseModel> getPowerPlant(String? tagId) async {
    final body = (tagId != null) ? json.encode({'tagId': tagId}) : '';
    final env = ApiConfig.apiEndpoint();

    final response = await client.post(
      Uri.parse((env['url']! as String) + _powerPlantsPath),
      headers: env['headers']! as Map<String, String>,
      body: body,
    );

    if (response.statusCode == 200) {
      return PowerPlantsResponseModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<PowerPlantDetailModel> getPowerPlantDetail(String plantId) async {
    final body = json.encode({'plantId': plantId});
    final env = ApiConfig.apiEndpoint();

    final response = await client.post(
      Uri.parse((env['url']! as String) + _powerPlantPath),
      headers: env['headers']! as Map<String, String>,
      body: body,
    );

    if (response.statusCode == 200) {
      return PowerPlantDetailModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<PowerPlantParticipantModel> getPowerPlantParticipants(
      String plantId) async {
    final body = json.encode({'plantId': plantId});
    final env = ApiConfig.apiEndpoint();

    final response = await client.post(
      Uri.parse((env['url']! as String) + _powerPlantParticipantPath),
      headers: env['headers']! as Map<String, String>,
      body: body,
    );

    if (response.statusCode == 200) {
      return PowerPlantParticipantModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TagResponseModel> getPowerPlantTags(String plantId) async {
    final body = json.encode({'plantId': plantId});
    final env = ApiConfig.apiEndpoint();

    final response = await client.post(
      Uri.parse((env['url']! as String) + _powerPlantTags),
      headers: env['headers']! as Map<String, String>,
      body: body,
    );

    if (response.statusCode == 200) {
      return TagResponseModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
