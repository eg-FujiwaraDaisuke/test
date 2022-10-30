import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minden/features/token/data/datasources/app_badge_data_source.dart';
import 'package:minden/injection_container.dart';

final unreadBadgeCountProvider = StateProvider<int>((ref) => 1);

final appBadgeManagerProvider = Provider<AppBadgeManager>(
    (ref) => AppBadgeManager(ref.watch(unreadBadgeDataSourceProvider)));

class AppBadgeManager {
  AppBadgeManager(this._dataSource);

  final UnreadBadgeDataSource _dataSource;

  Future<bool> get isSupportedAppBadger {
    return FlutterAppBadger.isAppBadgeSupported();
  }

  /// 未読バッジ数を+1する
  Future<void> incrementCount() async {
    final currentUnreadCount = await _dataSource.getUnreadCount();
    final newUnreadCount = currentUnreadCount + 1;

    await _dataSource.setUnreadCount(newUnreadCount);

    if (await isSupportedAppBadger) {
      await FlutterAppBadger.updateBadgeCount(newUnreadCount);
    }

    return;
  }

  /// 未読バッジ数を [newCount] に応じて設定する
  /// [newCount] が0の場合、バッジを非表示にする
  Future<void> setCount(int newCount) async {
    await _dataSource.setUnreadCount(newCount);

    if (newCount > 0) {
      await FlutterAppBadger.updateBadgeCount(newCount);
    } else {
      await si<FlutterLocalNotificationsPlugin>().cancelAll();
      if (await isSupportedAppBadger) {
        await FlutterAppBadger.removeBadge();
      }
    }
  }
}
