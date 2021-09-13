import 'package:equatable/equatable.dart';
import 'package:minden/features/user/domain/entities/profile.dart';

class TagCategory extends Equatable {
  const TagCategory({
    required this.categoryName,
    required this.tags,
  });

  factory TagCategory.fromJson(Map<String, dynamic> elem) {
    final List<Tag> tags = elem['tags']?.map<Tag>((e) {
          return Tag.fromJson(e);
        }).toList() ??
        [];

    return TagCategory(
      categoryName: elem['categoryName'],
      tags: tags,
    );
  }

  final List<Tag> tags;
  final String categoryName;

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'tags': tags.map((e) => e.toJson()),
    };
  }

  @override
  List<Object> get props => [categoryName];
}
