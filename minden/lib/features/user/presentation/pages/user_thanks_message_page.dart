import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/user/presentation/pages/profile_damy_data.dart';
import 'package:minden/features/user/presentation/pages/thanks_message.dart';
import 'package:minden/features/user/presentation/pages/thanks_message_modal_page.dart';
import 'package:minden/features/user/presentation/pages/user_page.dart';

import '../../../../utile.dart';

class UserThanksMessagePage extends StatelessWidget {
  final data = ThanksMessageDamyData().damyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: _buildBackLeadingButton(context),
        title: Text(
          i18nTranslate(context, 'user_menu_thanks_message'),
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w700,
            letterSpacing: calcLetterSpacing(letter: 0.5),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 100),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: data
                  .map((message) => _ThanksMessage(message: message))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackLeadingButton(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        'assets/images/common/leading_back.svg',
        width: 44,
        height: 44,
      ),
      onPressed: () {
        final route = NoAnimationMaterialPageRoute(
          builder: (context) => UserPage(),
          settings: RouteSettings(name: "/user"),
        );
        Navigator.pushReplacement(context, route);
      },
      color: Colors.black,
    );
  }
}

class _ThanksMessage extends StatelessWidget {
  final ThanksMessage message;
  _ThanksMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final route = NoAnimationMaterialPageRoute(
          builder: (context) => ThanksMessageModalPage(),
          settings: RouteSettings(name: "/user/thanksMessageModalPage"),
        );
        Navigator.pushReplacement(context, route);
      },
      child: Container(
        width: 288,
        margin: EdgeInsets.only(top: 25),
        padding: EdgeInsets.only(bottom: 13),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFC4C4C4),
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Color(0xFFDCF6DA),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      message.isNew
                          ? i18nTranslate(context, 'thanks_message_new')
                          : '',
                      style: TextStyle(
                        color: Color(0xFFFF8C00),
                        fontSize: 12,
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
                Container(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 200,
                        child: Text(
                          '${message.powerPlant.name}' +
                              i18nTranslate(
                                  context, 'thanks_message_from_plant'),
                          style: TextStyle(
                            color: Color(0xFFFF8C00),
                            fontSize: 10,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        width: 200,
                        child: Text(
                          message.title,
                          style: TextStyle(
                            color: Color(0xFF787877),
                            fontSize: 13,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Text(
                        message.time.toString(),
                        style: TextStyle(
                          color: Color(0xFFC4C4C4),
                          fontSize: 10,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
