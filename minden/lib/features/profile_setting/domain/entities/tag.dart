import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  const Tag({
    required this.tagId,
    required this.tagName,
    required this.colorCode,
  });

  factory Tag.fromJson(Map<String, dynamic> tag) {
    return Tag(
      tagId: tag['tagId'],
      tagName: tag['tagName'],
      colorCode: tag['colorCode'],
    );
  }

  final int tagId;
  final String tagName;
  final String colorCode;

  Map<String, dynamic> toJson() {
    return {
      'tagId': tagId,
      'tagName': tagName,
      'colorCode': colorCode,
    };
  }

  @override
  List<Object> get props => [tagId];
}
