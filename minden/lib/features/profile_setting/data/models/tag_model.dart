import 'package:minden/features/profile_setting/domain/entities/tag.dart';

class TagModel extends Tag {
  const TagModel({
    required tagId,
    required tagName,
  }) : super(tagId: tagId, tagName: tagName);

  factory TagModel.fromTag(Tag tag) {
    return TagModel(tagId: tag.tagId, tagName: tag.tagName);
  }

  factory TagModel.fromJson(Map<String, dynamic> tag) {
    return TagModel.fromTag(Tag.fromJson(tag));
  }
}
