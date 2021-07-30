// このページは応援ありがとうメッセージモーダルの表示を確認するだけのモックページです。
import 'package:flutter/material.dart';

class ThanksMessageModalPage extends StatelessWidget {
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
            child: Center(
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
                                'XXX発電所',
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
                              '応援いただきありがとうございます！今後も地域社会の一員として、地域の皆様とコミュニケーションをとることで良い関係を築き、地域に愛される発電所であり続けるよう努めていきます。最大文字数110文字程度（仮）テキストテキストテキ',
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
            ),
          ),
        ),
      ),
    );
  }
}

class ThanksMessageModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: null,
    );
  }
}
