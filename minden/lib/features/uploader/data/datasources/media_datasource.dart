import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/env/api_config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/uploader/data/models/media_model.dart';

abstract class MediaDataSource {
  Future<MediaModel> upload({required Uint8List bytes});
}

class MediaDataSourceImpl implements MediaDataSource {
  const MediaDataSourceImpl({required this.client});

  final http.Client client;

  String get _v1Path => '/api/v1/media/upload';

  @override
  Future<MediaModel> upload({required Uint8List bytes}) async {
    final endpoint = ApiConfig.apiEndpoint();
    final headers = ApiConfig.tokenHeader();
    headers.addAll(ApiConfig.contentTypeHeaderMultipartFormData);

    final request =
        http.MultipartRequest('POST', Uri.parse(endpoint + _v1Path));
    request.headers.addAll(headers);

    final stream = http.ByteStream.fromBytes(bytes);
    final multipartFile =
        http.MultipartFile('content', stream, bytes.length, filename: 'image');
    request.files.add(multipartFile);
    final response = await request.send();

    final value = await () {
      final completer = Completer<String>();
      response.stream.transform(utf8.decoder).listen((value) {
        completer.complete(value.toString());
      });
      return completer.future;
    }();
    print('${value}');
    if (response.statusCode == 200) {
      return MediaModel.fromJson(json.decode(value));
    } else if (response.statusCode == 401) {
      throw TokenExpiredException();
    } else {
      throw ServerException();
    }
  }
}
