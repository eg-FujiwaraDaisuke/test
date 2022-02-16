import 'package:minden/features/profile_setting/domain/entities/tag.dart';

class TagModel extends Tag {
  const TagModel({required tagId, required tagName, required colorCode})
      : super(tagId: tagId, tagName: tagName, colorCode: colorCode);

  factory TagModel.fromTag(Tag tag) {
    return TagModel(
        tagId: tag.tagId, tagName: tag.tagName, colorCode: tag.colorCode);
  }

  factory TagModel.fromJson(Map<String, dynamic> tag) {
    return TagModel.fromTag(Tag.fromJson(tag));
  }
}
