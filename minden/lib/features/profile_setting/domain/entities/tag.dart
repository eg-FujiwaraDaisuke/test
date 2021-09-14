import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  const Tag({
    required this.tagId,
    required this.tagName,
  });

  factory Tag.fromJson(Map<String, dynamic> tag) {
    return Tag(
      tagId: tag['tagId'],
      tagName: tag['tagName'],
    );
  }

  final int tagId;
  final String tagName;

  Map<String, dynamic> toJson() {
    return {
      'tagId': tagId,
      'tagName': tagName,
    };
  }

  @override
  List<Object> get props => [tagId];
}
