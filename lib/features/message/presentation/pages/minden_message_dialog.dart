import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:minden/features/common/widget/custom_dialog_overlay/custom_dialog_overlay.dart';
import 'package:minden/features/message/domain/entities/message_detail.dart';
import 'package:minden/gen/assets.gen.dart';
import 'package:minden/utile.dart';
import 'package:url_launcher/url_launcher.dart';

class MindenMessageDialog {
  MindenMessageDialog({
    required this.context,
    required this.messageDetail,
  }) : super();

  static const String routeName = '/user/message/detail';

  final BuildContext context;
  final MessageDetail messageDetail;

  void showDialog() {
    Navigator.push(
      context,
      CustomDialogOverlay(
        Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              child: Container(
                width: 338,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 35, bottom: 84),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 2,
                    color: const Color(0xFF75C975),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: 276,
                      height: 76,
                      child: Center(
                        child: Text(
                          messageDetail.title,
                          style: TextStyle(
                              color: const Color(0xFF27AE60),
                              fontSize: 18,
                              fontFamily: 'NotoSansJP',
                              fontWeight: FontWeight.w700,
                              height:
                                  calcFontHeight(fontSize: 18, lineHeight: 18)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    SizedBox(
                      width: 142,
                      height: 142,
                      child: Assets.images.message.character.image(
                        width: 142,
                        height: 142,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: 298,
                      child: Linkify(
                        onOpen: (link) async {
                          if (await canLaunch(link.url)) {
                            await launch(link.url, forceSafariVC: false);
                          }
                        },
                        text: messageDetail.body,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF27AE60),
                          fontSize: 14,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w500,
                          height: calcFontHeight(fontSize: 14, lineHeight: 18),
                        ),
                        linkStyle: const TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 27,
              top: 25,
              child: GestureDetector(
                onTap: _hideDialog,
                child: const Icon(Icons.close),
              ),
            ),
          ],
        ),
        isAndroidBackEnable: false,
        settings: const RouteSettings(name: routeName),
      ),
    );
  }

  /*
   * 非表示
   */
  void _hideDialog() {
    Navigator.of(context).pop();
  }
}
