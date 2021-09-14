import 'package:flutter/material.dart';
import 'package:minden/features/message/domain/entities/message.dart';
import 'package:minden/features/user/presentation/pages/custom_dialog_overlay.dart';
import 'package:minden/utile.dart';

class MindenMessageDialog {
  MindenMessageDialog({required this.context, required this.message}) : super();
  final BuildContext context;
  final Message message;

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
                          message.title,
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
                      child: Image.asset(
                        'assets/images/message/character.png',
                        width: 142,
                        height: 142,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: 298,
                      child: Text(
                        message.body,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF27AE60),
                          fontSize: 14,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w500,
                          height: calcFontHeight(fontSize: 14, lineHeight: 18),
                        ),
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
