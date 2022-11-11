import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minden/core/hook/use_logger.dart';
import 'package:minden/features/token/data/datasources/app_badge_data_source.dart';
import 'package:minden/injection_container.dart';

final unreadBadgeCountProvider =
    StateNotifierProvider<UnreadBadgeCountStateNotifier, int>(
        (ref) => UnreadBadgeCountStateNotifier(ref.read));

class UnreadBadgeCountStateNotifier extends StateNotifier<int> {
  UnreadBadgeCountStateNotifier(this._read) : super(0);

  final Reader _read;

  AppBadgeManager get _appBadgeManager => _read(appBadgeManagerProvider);

  void increment() {
    // 未読バッジ数を+1する
    _appBadgeManager.incrementCount();
  }

  void setCount(int newCount) {
    // 未読件数変化に応じて、未読バッジ数に反映する
    _appBadgeManager.setCount(newCount);
  }
}

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

    logD('Increment unread count. $currentUnreadCount -> $newUnreadCount');

    await _dataSource.setUnreadCount(newUnreadCount);

    if (await isSupportedAppBadger) {
      await FlutterAppBadger.updateBadgeCount(newUnreadCount);
    }

    return;
  }

  /// 未読バッジ数を [newCount] に応じて設定する
  /// [newCount] が0の場合、バッジを非表示にする
  Future<void> setCount(int newCount) async {
    logD('Update unread count. $newCount');

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
