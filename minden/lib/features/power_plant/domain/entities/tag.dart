import 'package:equatable/equatable.dart';

/// 発電所タグ
class Tag extends Equatable {
  const Tag({
    required this.tagId,
    required this.tagName,
  });

  /// フィルタタグID
  final String tagId;

  /// フィルタタグ名
  final String tagName;

  @override
  List<Object> get props => [
        tagId,
      ];
}
