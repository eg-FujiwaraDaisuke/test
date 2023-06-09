import 'dart:convert';
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/core/env/api_config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/success/success.dart';
import 'package:http/http.dart' as http;

abstract class IssueReportDataSource {
  Future<Success> sendIssueReport({
    required String userId,
    required String targetUserId,
    required List<int> issueType,
    required String message,
  });
}

class IssueReportDataSourceImpl implements IssueReportDataSource {
  const IssueReportDataSourceImpl({required this.client});

  final http.Client client;

  String get _issueReportPath => '/api/v1/issue_report';

  @override
  Future<Success> sendIssueReport({
    required String userId,
    required String targetUserId,
    required List<int> issueType,
    required String message,
  }) async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();
    headers.addAll(ApiConfig.contentTypeHeaderApplicationJson);
    final url = Uri.parse(endpoint + _issueReportPath);

    final param = {};
    param['userId'] = userId;
    param['targetUserId'] = targetUserId;
    param['message'] = message;
    if (issueType.isNotEmpty) {
      param['issueType'] = issueType;
    }

    final body = json.encode(param);

    final response = await client.post(
      url,
      headers: headers,
      body: body,
    );

    print(body);
    print(response);

    if (response.statusCode == 200) {
      return Success();
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      throw ServerException();
    }
  }
}
