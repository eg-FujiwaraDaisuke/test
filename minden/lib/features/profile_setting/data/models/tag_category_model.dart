import 'package:minden/features/profile_setting/domain/entities/tag_category.dart';

class TagCategoryModel extends TagCategory {
  const TagCategoryModel({
    required categoryName,
    required tags,
  }) : super(
          categoryName: categoryName,
          tags: tags,
        );

  factory TagCategoryModel.fromTagCategory(TagCategory tagCategory) {
    return TagCategoryModel(
      categoryName: tagCategory.categoryName,
      tags: tagCategory.tags,
    );
  }

  factory TagCategoryModel.fromJson(Map<String, dynamic> json) {
    return TagCategoryModel.fromTagCategory(TagCategory.fromJson(json));
  }
}
