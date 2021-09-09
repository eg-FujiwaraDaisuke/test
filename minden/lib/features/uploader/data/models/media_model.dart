import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:minden/core/env/api_config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/login/data/model/user_model.dart';
import 'package:minden/features/token/data/datasources/encryption_token_data_source.dart';
import 'package:minden/features/uploader/domain/entities/media.dart';

import '../../../../injection_container.dart';

// data - model

class MediaModel extends Media {
  const MediaModel({
    required String contentId,
    required String url,
  }) : super(contentId: contentId, url: url);

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(contentId: json['contentId'], url: json['url']);
  }

  Map<String, dynamic> toJson() {
    return {
      "contentId": contentId,
    };
  }
}
