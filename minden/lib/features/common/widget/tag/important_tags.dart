import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:minden/features/profile_setting/domain/entities/tag.dart';

class ImportantTag extends Equatable {
  final String title;
  final Color color;
  final List<Tag> tags;

  const ImportantTag({required this.title, required this.tags, required this.color});

  @override
  List<Object> get props => [title, color, tags];
}

final List<ImportantTag> importantTags = [
  ImportantTag(title: '私の紹介', color: Color(0xFFFFC2BE), tags: [
    Tag(tagId: 1, tagName: '使い捨てしません'),
    Tag(tagId: 2, tagName: '環境負荷ゼロ'),
    Tag(tagId: 3, tagName: '地産地消'),
    Tag(tagId: 4, tagName: 'フェアトレード'),
    Tag(tagId: 5, tagName: 'エコ'),
  ]),
  ImportantTag(title: '過ごし方', color: Color(0xFFFFCE95), tags: [
    Tag(tagId: 6, tagName: 'プラスチックフリー'),
    Tag(tagId: 7, tagName: '持続可能な開発'),
    Tag(tagId: 8, tagName: '無農薬野菜好き'),
    Tag(tagId: 9, tagName: 'サステナブルコーヒー'),
  ]),
  ImportantTag(title: '信条', color: Color(0xFFFFFFB2), tags: [
    Tag(tagId: 10, tagName: '生物多様性'),
    Tag(tagId: 11, tagName: 'バリアフリー'),
    Tag(tagId: 12, tagName: 'ロハス'),
    Tag(tagId: 13, tagName: '地元を愛する'),
    Tag(tagId: 14, tagName: '地方創生'),
  ]),
  ImportantTag(title: '趣味嗜好', color: Color(0xFFC0E1FE), tags: [
    Tag(tagId: 15, tagName: 'フードロスを減らす'),
    Tag(tagId: 16, tagName: 'リサイクルしよう'),
    Tag(tagId: 17, tagName: '環境を守れる経済活動'),
    Tag(tagId: 18, tagName: '畑仕事してるよ'),
  ]),
];
