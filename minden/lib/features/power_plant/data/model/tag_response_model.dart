import 'package:minden/features/power_plant/domain/entities/tag_response.dart';
import 'package:minden/features/user/data/model/profile_model.dart';

class TagResponseModel extends TagResponse {
  const TagResponseModel({
    required List<TagModel> tags,
  }) : super(
          tags: tags,
        );

  factory TagResponseModel.fromJson(Map<String, dynamic> json) {
    final Iterable iterable = json['tags'];

    return TagResponseModel(
        tags: List<TagModel>.from(
            iterable.map((model) => TagModel.fromJson(model))));
  }
}
