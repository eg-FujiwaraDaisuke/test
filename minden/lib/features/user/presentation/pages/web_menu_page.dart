import 'package:flutter/material.dart';
import 'package:minden/features/user/presentation/pages/custom_webview.dart';

class WebMenuPage extends StatelessWidget {
  static const String routeName = '/webMyMenu';

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => WebMenuPage(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const CustomWebView(url: 'http://portal.minden.co.jp');
  }
}
