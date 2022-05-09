import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/env/api_config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/features/support_amount/data/model/support_amount_model.dart';
import 'package:minden/features/support_amount/domain/entities/support_amount.dart';

final supportAmountDataSourceProvider = Provider<SupportAmountDataSource>(
    (ref) => SupportAmountDataSourceImpl(client: http.Client()));

abstract class SupportAmountDataSource {
  Future<SupportAmount> getSupportAmount();
}

class SupportAmountDataSourceImpl implements SupportAmountDataSource {
  SupportAmountDataSourceImpl({
    required this.client,
  });

  final http.Client client;

  final _supportAmountPath = '/api/v1/supportAmount';

  @override
  Future<SupportAmount> getSupportAmount() async {
    final url = Uri.parse(ApiConfig.apiEndpoint() + _supportAmountPath);
    final headers = ApiConfig.tokenHeader()
      ..addAll(ApiConfig.contentTypeHeaderApplicationJson);
    final response = await client.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      return SupportAmountModel.fromJson(json.decode(responseBody));
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      logW('${response.statusCode}: ${response.body}');
      throw ServerException();
    }
  }
}
