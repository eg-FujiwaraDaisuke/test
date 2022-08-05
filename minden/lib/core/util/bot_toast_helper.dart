import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading {
  static void show(BuildContext context) {
    BotToast.showCustomLoading(
      toastBuilder: (_) => const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  static void hide() {
    BotToast.closeAllLoading();
  }
}
