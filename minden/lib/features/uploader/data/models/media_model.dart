import 'package:minden/features/uploader/domain/entities/media.dart';

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
      'contentId': contentId,
    };
  }
}
