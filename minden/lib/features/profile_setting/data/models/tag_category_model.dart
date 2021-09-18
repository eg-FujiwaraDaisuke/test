import 'package:minden/features/profile_setting/domain/entities/tag_category.dart';

class TagCategoryModel extends TagCategory {
  const TagCategoryModel({
    required categoryName,
    required tags,
    required colorCode,
  }) : super(categoryName: categoryName, tags: tags, colorCode: colorCode);

  factory TagCategoryModel.fromTagCategory(TagCategory tagCategory) {
    return TagCategoryModel(
      categoryName: tagCategory.categoryName,
      tags: tagCategory.tags,
      colorCode: tagCategory.colorCode,
    );
  }

  factory TagCategoryModel.fromJson(Map<String, dynamic> json) {
    return TagCategoryModel.fromTagCategory(TagCategory.fromJson(json));
  }
}
