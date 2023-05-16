import 'package:after_layout/after_layout.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/injection_container.dart';

class FCMDebugPage extends StatefulWidget {
  @override
  _FCMDebugPage createState() => _FCMDebugPage();
}

class _FCMDebugPage extends State<FCMDebugPage> with AfterLayoutMixin {
  late NotificationSettings _settings;
  late String _token = '';
  late String _desciption = '';

  Future<void> _requestPermissions() async {
    final settings = await si<FirebaseMessaging>().requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );

    setState(() {
      _settings = settings;
    });

    logD('${_settings.alert}');
  }

  void setToken(String? token) {
    if (token == null) return;
    setState(() {
      _token = token;
    });
  }

  @override
  void initState() {
    super.initState();
    si<FirebaseMessaging>().getToken().then((String? token) {
      if (mounted) setToken(token);
    });
    si<FirebaseMessaging>().onTokenRefresh.listen((event) {
      if (mounted) setToken(event);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('バックグラウンド状態からプッシュ通知をタップした');
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('バックグラウンド状態からプッシュ通知をタップした');
      logD('${message.toString()}');

      setState(() {
        _desciption = 'message.senderId: ${message.senderId.toString()},\n'
            'message.category: ${message.category.toString()},\n'
            'message.collapseKey: ${message.collapseKey.toString()},\n'
            'message.contentAvailable: ${message.contentAvailable.toString()},\n\n'

            'message.data: ${message.data.toString()},\n\n'
            'message.from: ${message.from.toString()},\n'
            'message.messageId: ${message.messageId.toString()},\n'
            'message.messageType: ${message.messageType.toString()},\n'
            'message.mutableContent: ${message.mutableContent.toString()},\n'
            'message.notification.title: ${message.notification?.title.toString()},\n'
            'message.notification.body: ${message.notification?.body.toString()},\n'
            'message.sentTime: ${message.sentTime.toString()},\n'
            'message.threadId: ${message.threadId.toString()},\n'
            'message.ttl: ${message.ttl.toString()},\n';
      });
    });

    () async {
      await si<FirebaseMessaging>()
          .getInitialMessage()
          .then((RemoteMessage? message) {
        print('ターミネイト状態からプッシュ通知をタップした');
        logD('${message?.data}');
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: SafeArea(
          child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              final data = ClipboardData(text: _token);
              await Clipboard.setData(data);
              await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return AlertDialog(
                      content: Text('FCM token copied!'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('OK'),
                        ),
                      ],
                    );
                  });
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(_token),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(_desciption),
          ),
        ],
      )),
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    await _requestPermissions();
  }
}
