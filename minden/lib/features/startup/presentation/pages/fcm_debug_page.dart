import 'package:after_layout/after_layout.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:minden/injection_container.dart';

class FCMDebugPage extends StatefulWidget {
  @override
  _FCMDebugPage createState() => _FCMDebugPage();
}

class _FCMDebugPage extends State<FCMDebugPage> with AfterLayoutMixin {
  late NotificationSettings _settings;
  late String _token = '';
  late Stream<String> _tokenStream;

  Future<void> _requestPermissions() async {
    final settings = await si<FirebaseMessaging>().requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );

    setState(() {
      _settings = settings;
    });

    print(_settings.alert);
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
        child: GestureDetector(
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
      ),
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    await _requestPermissions();
  }
}
