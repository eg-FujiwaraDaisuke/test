// このページは応援ありがとうメッセージモーダルの表示を確認するだけのモックページです。
import 'package:flutter/material.dart';
import 'package:minden/features/user/presentation/pages/profile_damy_data.dart';
import 'package:minden/features/user/presentation/pages/thanks_message.dart';

class ThanksMessageModalPage extends StatelessWidget {
  final data = ThanksMessageDamyData().damyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              color: Colors.black,
              child: ThanksMessageModal(
                message: data[0],
              )),
        ),
      ),
    );
  }
}

class ThanksMessageModal extends StatelessWidget {
  final ThanksMessage message;
  ThanksMessageModal({required this.message});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Positioned(
            child: Container(
              width: 338,
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
                    height: 76,
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
                    height: 2,
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
                // 応援ありがとうモーダルを閉じる
              },
            ),
          ),
        ],
      ),
    );
  }
}
