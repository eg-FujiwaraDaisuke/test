import 'package:flutter/material.dart';
import 'package:minden/features/thanks_message/domain/entities/message.dart';
import 'package:minden/features/user/presentation/pages/custom_dialog_overlay.dart';

class MessageDialog {
  MessageDialog({required this.context, required this.message}) : super();
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
                padding: const EdgeInsets.only(top: 35, bottom: 90),
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
                      child: Center(
                        child: Text(
                          message.plantId,
                          style: const TextStyle(
                            color: Color(0xFF27AE60),
                            fontSize: 18,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 252,
                      height: 190,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 29,
                    ),
                    SizedBox(
                      width: 265,
                      child: Text(
                        message.body,
                        style: const TextStyle(
                          color: Color(0xFF27AE60),
                          fontSize: 14,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w400,
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
                child: Icon(Icons.close),
                onTap: () {
                  _hideDialog();
                },
              ),
            ),
            Positioned(
              bottom: -75,
              right: -80,
              child: Image.asset(
                'assets/images/user/bee.png',
                width: 236,
                height: 104,
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
