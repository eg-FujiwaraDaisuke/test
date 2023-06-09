import 'package:flutter/material.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/custom_dialog_overlay/custom_dialog_overlay.dart';
import 'package:minden/gen/assets.gen.dart';

import '../../../utile.dart';

class IssueReportCompleteDialog {
  IssueReportCompleteDialog({
    required this.context,
  }) : super();

  static const String routeName = '/user/profile/issueReport/complete';

  final BuildContext context;

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
                padding: const EdgeInsets.only(top: 60, bottom: 36),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      i18nTranslate(context, 'violate_thanks'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF575292),
                        fontSize: 18,
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 19,
                    ),
                    SizedBox(
                      width: 285,
                      child: Text(
                        i18nTranslate(context, 'violate_be_useful'),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: const Color(0xFF967D5E),
                          fontSize: 12,
                          height: calcFontHeight(fontSize: 12, lineHeight: 18),
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 160,
                      height: 122,
                      child: Assets.images.violate.character.image(
                        width: 160,
                        height: 122,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
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
          ],
        ),
        isAndroidBackEnable: false,
        settings: const RouteSettings(name: routeName),
      ),
    );
  }

  void _hideDialog() {
    Navigator.of(context).pop();
  }
}
