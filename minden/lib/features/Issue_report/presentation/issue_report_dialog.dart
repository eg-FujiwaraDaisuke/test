import 'package:flutter/material.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/custom_dialog_overlay/custom_dialog_overlay.dart';

class IssueReportDialog {
  IssueReportDialog({
    required this.context,
  }) : super();

  final BuildContext context;

  Future<bool?> showDialog() async {
    return Navigator.push(
      context,
      CustomDialogOverlay(
        Container(
          width: 338,
          height: 209,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 23,
              ),
              Text(
                i18nTranslate(context, 'violate_user_name'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF575292),
                  fontSize: 18,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 23,
              ),
              Container(
                width: 339,
                height: 1,
                color: const Color(0xFFE2E2E2),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context, true);
                },
                child: SizedBox(
                  height: 65,
                  width: 338,
                  child: Center(
                    child: Text(
                      i18nTranslate(context, 'violate_user'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFEA4C4C),
                        fontSize: 15,
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context, false);
                },
                child: SizedBox(
                  height: 65,
                  width: 338,
                  child: Center(
                    child: GestureDetector(
                      child: Text(
                        i18nTranslate(context, 'cancel_katakana'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF787877),
                          fontSize: 15,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        isAndroidBackEnable: false,
      ),
    );
  }
}
