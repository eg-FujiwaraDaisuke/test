import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PushNotificationPermissionDialog {
  final BuildContext context;
  PushNotificationPermissionDialog({required this.context}) : super();

  void showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(
                  "みんな電力アプリはあなたにプッシュ通知送信します。\nよろしいですか？",
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  "通知方法は、テキスト、サウンド、アイコンバッチが利用できる可能性があります。\n通知方法は”設定”で設定できます。",
                  textAlign: TextAlign.center,
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text("許可しない"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoDialogAction(
                    child: Text("OK"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              )
            : AlertDialog(
                title: Text(
                  "みんな電力アプリはあなたにプッシュ通知送信します。\nよろしいですか？",
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  "通知方法は、テキスト、サウンド、アイコンバッチが利用できる可能性があります。\n通知方法は”設定”で設定できます。",
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
      },
    );
  }
}
