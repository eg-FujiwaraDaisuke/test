import 'dart:convert';
import 'package:minden/core/ext/logger_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minden/core/env/api_config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/features/message/data/model/message_detail_model.dart';
import 'package:minden/features/message/data/model/message_model.dart';
import 'package:minden/features/message/domain/entities/messages.dart';
import 'package:minden/features/message/domain/entities/message_detail.dart';
import 'package:http/http.dart' as http;

abstract class MessageDataSource {
  Future<Messages> getMessages(String page);
  Future<MessageDetail> getMessageDetail({required int messageId});
  Future<Success> readMessage({required int messageId});
}

class MessageDataSourceImpl implements MessageDataSource {
  const MessageDataSourceImpl({required this.client});

  final http.Client client;

  String get _messagesPath => '/api/v1/profile/messages';
  String get _messageDetailPath => '/api/v1/profile/message';
  String get _readMessagePath => '/api/v1/profile/message/read';

  @override
  Future<MessagesModel> getMessages(String page) async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();
    headers.addAll(ApiConfig.contentTypeHeaderApplicationXFormUrlEncoded);
    final url = Uri.parse(endpoint + _messagesPath);

    final response = await client.get(
      url.replace(queryParameters: {
        'page': page,
      }),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      logD(responseBody);
      return MessagesModel.fromJson(json.decode(responseBody));
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<MessageDetailModel> getMessageDetail({required int messageId}) async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();

    final url = Uri.parse(endpoint + _messageDetailPath);

    final response = await client.get(
      url.replace(queryParameters: {
        'messageId': messageId,
      }),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      logD(responseBody);
      return MessageDetailModel.fromJson(json.decode(responseBody));
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Success> readMessage({required int messageId}) async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();

    headers.addAll(ApiConfig.contentTypeHeaderApplicationJson);
    final body = json.encode({'messageId': messageId});

    final response = await client.post(Uri.parse(endpoint + _readMessagePath),
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
