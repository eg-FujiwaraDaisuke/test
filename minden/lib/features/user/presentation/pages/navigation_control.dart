import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NavigationControls extends StatelessWidget {
  const NavigationControls({required this.controller});

  final Completer<WebViewController> controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller.future,
      builder: (context, snapshot) {
        final controller = snapshot.data;
        if (snapshot.connectionState != ConnectionState.done ||
            controller == null) {
          return Row(
            children: const <Widget>[
              Icon(Icons.arrow_back_ios),
            ],
          );
        }

        return Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                  Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios),
              onPressed: () async {
                if (await controller.canGoBack()) {
                  await controller.goBack();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
