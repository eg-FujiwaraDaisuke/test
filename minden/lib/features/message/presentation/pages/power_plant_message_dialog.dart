import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:minden/features/common/widget/custom_dialog_overlay/custom_dialog_overlay.dart';
import 'package:minden/features/message/domain/entities/message_detail.dart';
import 'package:minden/gen/assets.gen.dart';
import 'package:url_launcher/url_launcher.dart';

class PowerPlantMessageDialog {
  PowerPlantMessageDialog({
    required this.context,
    required this.messageDetail,
  }) : super();

  static const String routeName = '/user/message/detail';

  final BuildContext context;
  final MessageDetail messageDetail;
  final int bgNum = DateTime.now().month % 4;

  void showDialog() {
    Navigator.push(
      context,
      CustomDialogOverlay(
        Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.topCenter,
          children: [
            Positioned(
              child: SizedBox(
                width: 344,
                height: 515,
                child: Image.asset(
                  'assets/images/message/letter_bg_${bgNum.toString()}.png',
                  width: 344,
                  height: 515,
                ),
              ),
            ),
            Positioned(
              top: 118,
              child: Column(
                children: [
                  SizedBox(
                    width: 256,
                    height: 192,
                    child: CachedNetworkImage(
                      imageUrl: messageDetail.image ?? '',
                      placeholder: (context, url) {
                        return Assets.images.common.placeholder.image(
                          fit: BoxFit.cover,
                        );
                      },
                      errorWidget: (context, url, error) =>
                          Assets.images.common.noimage.image(fit: BoxFit.cover),
                      width: 256,
                      height: 192,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: 265,
                    height: 90,
                    child: Scrollbar(
                      isAlwaysShown: false,
                      controller: ScrollController(),
                      child: SingleChildScrollView(
                        child: Linkify(
                          onOpen: (link) async {
                            if (await canLaunch(link.url)) {
                              await launch(link.url);
                            }
                          },
                          text: messageDetail.body,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Color(0xFF967D5E),
                            fontSize: 14,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w500,
                          ),
                          linkStyle: const TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 40,
              left: 40,
              child: SizedBox(
                width: 200,
                child: Text(
                  messageDetail.title,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Color(0xFF967D5E),
                    fontSize: 12,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 28,
              top: 17,
              child: GestureDetector(
                onTap: _hideDialog,
                child: const Icon(Icons.close),
              ),
            ),
            Positioned(
              bottom: -119,
              right: -39,
              child: Assets.images.message.characterFly.image(
                width: 160,
                height: 119,
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
