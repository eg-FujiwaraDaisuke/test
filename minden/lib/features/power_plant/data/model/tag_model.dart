import 'package:minden/features/power_plant/domain/entities/tag.dart';

class TagModel extends Tag {
  const TagModel({
    required String tagId,
    required String tagName,
  }) : super(
          tagId: tagId,
          tagName: tagName,
        );

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      tagId: json['tagId'],
      tagName: json['tagName'],
    );
  }
}
