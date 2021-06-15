import 'package:flutter/material.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          color: Color(0xFFf6f5f0),
          child: Column(
            children: [
              Container(
                width: 270,
                height: 270,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/tutorial/test1.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48,
              ),
              Container(
                height: 65,
                alignment: Alignment.center,
                child: Text(
                  '電気の生産者の顔が\n見える・つながる',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 26,
              ),
              Container(
                height: 67,
                alignment: Alignment.center,
                child:Text(
                    '何でも薄暗いじめじめした所でニャーニャー泣いていた\n事だけは記憶している。\n吾輩はここで始めて人間というものを見た。',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                    ),
                  ),
              ),
              SizedBox(
                height: 116,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
