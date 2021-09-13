import 'package:flutter/material.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/common/widget/button/button_size.dart';
import 'package:minden/features/common/widget/custom_dialog_overlay/custom_dialog_overlay.dart';
import 'package:minden/utile.dart';

class SupportPlantDecideDialog {
  final BuildContext context;

  SupportPlantDecideDialog({
    required this.context,
  }) : super();

  void showDialog() {
    Navigator.push(
      context,
      CustomDialogOverlay(
        Stack(
          children: [
            Positioned(
              child: Container(
                width: 338,
                padding: const EdgeInsets.only(top: 69, bottom: 50),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      //TODO ここに発電所の名前が入ります。
                      '「XXX発電所」',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFF8C00),
                        fontSize: 18,
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'を応援します。よろしいですか？',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF575292),
                        fontSize: 16,
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    _buildSelectedPlantListItem(),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      '応援する発電所は今月末まで変更可能です',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF787877),
                        fontSize: 12,
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Button(onTap: () {}, text: '決定する', size: ButtonSize.S),
                    const SizedBox(
                      height: 12,
                    ),
                    GestureDetector(onTap: _hideDialog, child: Text('キャンセル')),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 25,
              right: 27,
              child: GestureDetector(
                child: Icon(Icons.close),
                onTap: _hideDialog,
              ),
            ),
          ],
        ),
        isAndroidBackEnable: false,
      ),
    );
  }

  Widget _buildSelectedPlantListItem() {
    return Container(
      width: 286,
      height: 80,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            child: Image.network(
              'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2250&q=80',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 27,
          ),
          SizedBox(
            width: 157,
            //TODO ここに発電所の名前が入ります。
            child: Text(
              'みつばち発電所みつばち発電所みつばち発電所',
              style: TextStyle(
                color: Color(0xFF575292),
                fontSize: 13,
                fontFamily: 'NotoSansJP',
                fontWeight: FontWeight.w700,
                height: calcFontHeight(fontSize: 13, lineHeight: 19.5),
              ),
            ),
          )
        ],
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
