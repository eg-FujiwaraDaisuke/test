import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:minden/core/env/api_config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/power_plant/data/model/public_power_plant_detail_model.dart';
import 'package:minden/features/power_plant/data/model/public_power_plant_model.dart';

abstract class PublicPowerPlantDataSource {
  Future<List<PublicPowerPlantModel>> getPublicPowerPlant(
      List<String> mpNumbers);

  Future<PublicPowerPlantDetailModel> getPublicPowerPlantDetail(String id);
}

class PublicPowerPlantDataSourceImpl implements PublicPowerPlantDataSource {
  PublicPowerPlantDataSourceImpl({required this.client});

  final http.Client client;

  final _authPath = '/api/v1/public-power-plants';

  @override
  Future<List<PublicPowerPlantModel>> getPublicPowerPlant(
      List<String> mpNumbers) async {
    final body = json.encode({'mpNumbers': mpNumbers});
    final env = ApiConfig.apiEndpoint();

    // TODO bodyにmpNumbersを設定
    final response = await client.post(
      Uri.parse((env['url'] as String) + _authPath),
      headers: env['headers'] as Map<String, String>,
      body: body,
    );

    if (response.statusCode == 200) {
      final Iterable iterable = json.decode(response.body);
      return List<PublicPowerPlantModel>.from(
          iterable.map((model) => PublicPowerPlantModel.fromJson(model)));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<PublicPowerPlantDetailModel> getPublicPowerPlantDetail(
      String id) async {
    final env = ApiConfig.apiEndpoint();

    // TODO bodyにmpNumbersを設定
    final response = await client.post(
      Uri.parse('${env['url'] as String}$_authPath${'/$id'}'),
      headers: env['headers'] as Map<String, String>,
    );

    if (response.statusCode == 200) {
      return PublicPowerPlantDetailModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
