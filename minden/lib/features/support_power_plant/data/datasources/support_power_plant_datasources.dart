import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/env/api_config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/success/success.dart';

abstract class SupportPowerPlantDataSource {
  Future<Success> update(
    Map<String, List<Map<String, String>>> plantIdList,
  );
}

class SupportPowerPlantDataSourceImpl implements SupportPowerPlantDataSource {
  const SupportPowerPlantDataSourceImpl({required this.client});
  final http.Client client;
  String get _updatePath => '/api/v1/power_plant/support';

  @override
  Future<Success> update(
      Map<String, List<Map<String, String>>> plantIdList) async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();
    headers.addAll(ApiConfig.contentTypeHeaderApplicationJson);

    final body = json.encode(plantIdList);
    final response = await client.post(Uri.parse(endpoint + _updatePath),
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
