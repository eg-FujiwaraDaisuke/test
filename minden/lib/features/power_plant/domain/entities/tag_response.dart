import 'package:equatable/equatable.dart';
import 'package:minden/features/user/domain/entities/profile.dart';

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
