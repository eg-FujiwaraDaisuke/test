import 'package:flutter/widgets.dart';

class AppLifeCycleObserver with WidgetsBindingObserver {
  AppLifeCycleObserver({
    final this.onResume,
  });

  VoidCallback? onResume;

  @override
  Future<void> didChangeAppLifecycleState(final AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    final onResumeCallback = onResume;

    switch (state) {
      case AppLifecycleState.resumed:
        if (onResumeCallback != null) {
          onResumeCallback();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        break;
    }
  }
}
