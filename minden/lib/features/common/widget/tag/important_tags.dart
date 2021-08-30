import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:minden/features/user/presentation/pages/profile.dart';

class ImportantTag extends Equatable {
  final String title;
  final Color color;
  final List<Tag> tags;
  ImportantTag({required this.title, required this.tags, required this.color});

  @override
  List<Object> get props => [title, color, tags];
}

final List<ImportantTag> importantTags = [
  ImportantTag(title: '私の紹介', color: Color(0xFFFFC2BE), tags: [
    Tag(tagId: 'タグID', tagName: '使い捨てしません'),
    Tag(tagId: 'タグID', tagName: '環境負荷ゼロ'),
    Tag(tagId: 'タグID', tagName: '地産地消'),
    Tag(tagId: 'タグID', tagName: 'フェアトレード'),
    Tag(tagId: 'タグID', tagName: 'エコ'),
  ]),
  ImportantTag(title: '過ごし方', color: Color(0xFFFFCE95), tags: [
    Tag(tagId: 'タグID', tagName: 'プラスチックフリー'),
    Tag(tagId: 'タグID', tagName: '持続可能な開発'),
    Tag(tagId: 'タグID', tagName: '無農薬野菜好き'),
    Tag(tagId: 'タグID', tagName: 'サステナブルコーヒー'),
  ]),
  ImportantTag(title: '信条', color: Color(0xFFFFFFB2), tags: [
    Tag(tagId: 'タグID', tagName: '生物多様性'),
    Tag(tagId: 'タグID', tagName: 'バリアフリー'),
    Tag(tagId: 'タグID', tagName: 'ロハス'),
    Tag(tagId: 'タグID', tagName: '地元を愛する'),
    Tag(tagId: 'タグID', tagName: '地方創生'),
  ]),
  ImportantTag(title: '趣味嗜好', color: Color(0xFFC0E1FE), tags: [
    Tag(tagId: 'タグID', tagName: 'フードロスを減らす'),
    Tag(tagId: 'タグID', tagName: 'リサイクルしよう'),
    Tag(tagId: 'タグID', tagName: '環境を守れる経済活動'),
    Tag(tagId: 'タグID', tagName: '畑仕事してるよ'),
  ]),
];
