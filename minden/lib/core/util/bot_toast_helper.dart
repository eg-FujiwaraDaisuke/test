import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading {
  static void show(BuildContext context) {
    BotToast.showCustomLoading(
      toastBuilder: (_) => CircularProgressIndicator(
        valueColor:
            AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
      ),
    );
  }

  static void hide() {
    BotToast.closeAllLoading();
  }
}
