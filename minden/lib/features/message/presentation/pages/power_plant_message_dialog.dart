import 'package:flutter/material.dart';
import 'package:minden/features/common/widget/custom_dialog_overlay/custom_dialog_overlay.dart';
import 'package:minden/features/message/domain/entities/message.dart';

class PowerPlantMessageDialog {
  PowerPlantMessageDialog({required this.context, required this.message})
      : super();
  final BuildContext context;
  final Message message;

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
                  'assets/images/message/letter_bg.png',
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
                    child: Image.network(
                      message.image,
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
                    child: Text(
                      message.body,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Color(0xFF967D5E),
                        fontSize: 14,
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 40,
              left: 48,
              child: Text(
                // TODO ここに発電所の名前がはいる
                message.plantId,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Color(0xFF967D5E),
                  fontSize: 18,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w700,
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
              child: Image.asset(
                'assets/images/message/character_fly.png',
                width: 160,
                height: 119,
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
