import 'package:flutter/material.dart';
import 'package:minden/features/user/presentation/pages/custom_webview.dart';

class ContactPage extends StatelessWidget {
  static const String routeName = '/contact';

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => ContactPage(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const CustomWebView(url: 'http://portal.minden.co.jp/contact/guest');
  }
}
