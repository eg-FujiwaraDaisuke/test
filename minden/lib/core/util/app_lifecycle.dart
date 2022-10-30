import 'package:flutter/widgets.dart';

class AppLifeCycleObserver with WidgetsBindingObserver {
  AppLifeCycleObserver({
    final this.onResume,
    final this.onPause,
  });

  VoidCallback? onResume;

  VoidCallback? onPause;

  @override
  Future<void> didChangeAppLifecycleState(final AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    final onResumeCallback = onResume;
    final onPauseCallback = onPause;

    switch (state) {
      case AppLifecycleState.resumed:
        if (onResumeCallback != null) {
          onResumeCallback();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        if (onPauseCallback != null) {
          onPauseCallback();
        }
        break;
      case AppLifecycleState.detached:
        break;
    }
  }
}
