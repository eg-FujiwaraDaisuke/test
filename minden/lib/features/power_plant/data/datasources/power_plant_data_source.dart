import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/env/api_config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/features/power_plant/data/model/power_plant_detail_model.dart';
import 'package:minden/features/power_plant/data/model/power_plant_gift_model.dart';
import 'package:minden/features/power_plant/data/model/power_plant_participant_model.dart';
import 'package:minden/features/power_plant/data/model/power_plants_response_model.dart';
import 'package:minden/features/power_plant/data/model/support_action_model.dart';
import 'package:minden/features/power_plant/data/model/support_history_model.dart';
import 'package:minden/features/power_plant/data/model/tag_response_model.dart';

final powerPlantDataSourceProvider = Provider<PowerPlantDataSource>(
    (ref) => PowerPlantDataSourceImpl(client: http.Client()));

abstract class PowerPlantDataSource {
  Future<PowerPlantsResponseModel> getPowerPlant(
    String? tagId,
    String? giftTypeId,
  );

  Future<PowerPlantDetailModel> getPowerPlantDetail(String plantId);

  Future<PowerPlantParticipantModel> getPowerPlantParticipants(String plantId);

  Future<TagResponseModel> getPowerPlantTags(String plantId);

  Future<SupportHistoryModel> getPowerPlantHistory(
      String historyType, String? userId);

  Future<SupportActionModel> getSupportAction(String plantId);

  Future<List<PowerPlantGiftModel>> getPlantsGifts();
}

class PowerPlantDataSourceImpl implements PowerPlantDataSource {
  PowerPlantDataSourceImpl({required this.client});

  final http.Client client;

  final _powerPlantsPath = '/api/v1.1/power_plants';

  final _powerPlantPath = '/api/v1/power_plant';

  final _powerPlantParticipantPath = '/api/v1/power_plant/participants';

  final _powerPlantTags = '/api/v1/power_plant/tags';

  final _powerPlantHistory = '/api/v1/support_history';

  final _supportAction = '/api/v1/power_plant/support_action';

  final _getPlantsGiftsPath = '/api/v1/power_plants/gift_types';

  @override
  Future<PowerPlantsResponseModel> getPowerPlant(
    String? tagId,
    String? giftTypeId,
  ) async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();
    headers.addAll(ApiConfig.contentTypeHeaderApplicationXFormUrlEncoded);

    var url = Uri.parse(endpoint + _powerPlantsPath);
    if (tagId?.isNotEmpty ?? false) {
      url = url.replace(queryParameters: {
        'tagId': tagId,
      });
    } else if (giftTypeId?.isNotEmpty ?? false) {
      url = url.replace(queryParameters: {
        'giftTypeId': giftTypeId,
      });
    }

    final response = await client.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
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
  Future<SupportHistoryModel> getPowerPlantHistory(
    String historyType,
    String? userId,
  ) async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();
    headers.addAll(ApiConfig.contentTypeHeaderApplicationXFormUrlEncoded);

    final url = Uri.parse(endpoint + _powerPlantHistory);

    final queryParameters = userId?.isEmpty ?? true
        ? {
            'historyType': historyType,
          }
        : {
            'historyType': historyType,
            'userId': userId,
          };

    final response = await client.get(
      url.replace(queryParameters: queryParameters),
      headers: headers,
    );

    final responseBody = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      logI('${responseBody}');
      return SupportHistoryModel.fromJson(json.decode(responseBody));
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      logW('${response.statusCode}: ${response.body}');
      throw ServerException();
    }
  }

  @override
  Future<SupportActionModel> getSupportAction(
    String plantId,
  ) async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();
    headers.addAll(ApiConfig.contentTypeHeaderApplicationXFormUrlEncoded);

    final url = Uri.parse(endpoint + _supportAction);
    final response = await client.get(
      url.replace(queryParameters: {
        'plantId': plantId,
      }),
      headers: headers,
    );

    final responseBody = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      logD('${responseBody}');
      return SupportActionModel.fromJson(json.decode(responseBody));
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      logW('${response.statusCode}: ${response.body}');
      throw ServerException();
    }
  }

  @override
  Future<List<PowerPlantGiftModel>> getPlantsGifts() async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();
    headers.addAll(ApiConfig.contentTypeHeaderApplicationJson);

    final url = Uri.parse(endpoint + _getPlantsGiftsPath);
    final response = await client.get(
      url,
      headers: headers,
    );

    final responseBody = utf8.decode(response.bodyBytes);
    logD(responseBody);
    final map = json.decode(responseBody);
    final list = map['gift_types'] ?? [];
    final gifts = list.map<PowerPlantGiftModel>((e) {
      return PowerPlantGiftModel.fromJson(e);
    }).toList();

    if (response.statusCode == 200) {
      return gifts;
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      throw ServerException();
    }
  }
}
