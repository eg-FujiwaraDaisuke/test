import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final unreadBadgeDataSourceProvider =
    Provider<UnreadBadgeDataSource>((ref) => UnreadBadgeDataSourceImpl());

/// バッジ未読数を提供するDataSource
abstract class UnreadBadgeDataSource {
  Future<int> getUnreadCount();

  Future<void> setUnreadCount(int newCount);
}

class UnreadBadgeDataSourceImpl implements UnreadBadgeDataSource {
  static const _unreadCountKey = 'unread_count_key';

  static const _boxName = 'unread_badge_box';

  @override
  Future<int> getUnreadCount() async {
    final box = await _getBox();
    return box.get(_unreadCountKey, defaultValue: 0);
  }

  @override
  Future<void> setUnreadCount(int newCount) async {
    final box = await _getBox();
    await box.putAll({
      _unreadCountKey: newCount,
    });
  }

  /// Boxを取得する
  Future<Box> _getBox() async {
    return Hive.openBox(_boxName);
  }
}
