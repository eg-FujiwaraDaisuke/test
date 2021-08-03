import 'package:flutter/material.dart';
import 'package:minden/features/user/presentation/pages/custom_dialog_overlay.dart';
import 'package:minden/features/user/presentation/pages/thanks_message.dart';

class ThanksMessageDialog {
  final BuildContext context;
  final ThanksMessage message;
  ThanksMessageDialog({required this.context, required this.message}) : super();

  void showDialog() {
    Navigator.push(
      context,
      CustomDialogOverlay(
        Stack(
          children: [
            Positioned(
              child: Container(
                width: 338,
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 35, bottom: 90),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 2,
                    color: Color(0xFF75C975),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 276,
                      child: Center(
                        child: Text(
                          message.powerPlant.name,
                          style: TextStyle(
                            color: Color(0xFF27AE60),
                            fontSize: 18,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
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
                            spreadRadius: 1.0,
                            blurRadius: 4.0,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 29,
                    ),
                    Container(
                      width: 265,
                      child: Text(
                        message.message,
                        style: TextStyle(
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
