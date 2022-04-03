import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/utile.dart';

class SupportHistoryPage extends StatelessWidget {
  const SupportHistoryPage();

  static const String routeName = '/user/profile/support_history';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/images/common/leading_back.svg',
            width: 44,
            height: 44,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.black,
        ),
        title: Text(
          '応援の軌跡',
          style: TextStyle(
            color: const Color(0xFF575292),
            fontSize: 16,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w700,
            letterSpacing: calcLetterSpacing(letter: 0.5),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
