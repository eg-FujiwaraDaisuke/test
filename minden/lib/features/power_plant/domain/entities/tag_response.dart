import 'package:equatable/equatable.dart';
import 'package:minden/features/profile_setting/domain/entities/tag.dart';

/// 大切にしているタグ一覧APIレスポンス
class TagResponse extends Equatable {
  const TagResponse({
    required this.tags,
  });

  /// タグ
  final List<Tag> tags;

  @override
  List<Object> get props => [
        tags,
      ];
}
