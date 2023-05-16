import 'package:equatable/equatable.dart';
import 'package:minden/features/profile_setting/domain/entities/tag.dart';

class TagCategory extends Equatable {
  const TagCategory({
    required this.categoryName,
    required this.tags,
    required this.colorCode,
  });

  factory TagCategory.fromJson(Map<String, dynamic> elem) {
    final List<Tag> tags = elem['tags']?.map<Tag>((e) {
          return Tag.fromJson(e);
        }).toList() ??
        [];

    return TagCategory(
        categoryName: elem['categoryName'],
        tags: tags,
        colorCode: elem['colorCode']);
  }

  final List<Tag> tags;
  final String categoryName;
  final String colorCode;

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'tags': tags.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object> get props => [categoryName];
}
