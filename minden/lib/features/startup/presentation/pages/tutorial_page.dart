import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Tutorial {
  late final String title;
  late final String description;

  Tutorial({
    required this.title,
    required this.description,
  });
}

class TutorialPage extends StatelessWidget {
  const TutorialPage() : super();

  @override
  Widget build(BuildContext context) {
    final CarouselController _controller = CarouselController();
    List<Tutorial> tutorialData = [
      Tutorial(
          title: '電気の生産者の顔が\n見える・つながる',
          description:
              '何でも薄暗いじめじめした所でニャーニャー泣いていた\n事だけは記憶している。\n吾輩はここで始めて人間というものを見た。'),
      Tutorial(
          title: '電気の使用量や\n料金の行き先が見える',
          description:
              '何でも薄暗いじめじめした所でニャーニャー泣いていた\n事だけは記憶している。\n吾輩はここで始めて人間というものを見た。'),
      Tutorial(
          title: 'あの有名企業も使っている',
          description:
              '何でも薄暗いじめじめした所でニャーニャー泣いていた\n事だけは記憶している。\n吾輩はここで始めて人間というものを見た。'),
    ];

    return Scaffold(
      body: SizedBox.expand(
        child: Container(
            color: Color(0xFFf6f5f0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 599,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: false,
                    viewportFraction: 1,
                  ),
                  carouselController: _controller,
                  items: tutorialData.map((Tutorial data) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Slide(data: data);
                      },
                    );
                  }).toList(),
                ),
                // Slide(data: tutorialData[0]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Skip',
                      style: const TextStyle(
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: tutorialData.map((i) {
                        return Container(
                          width: 7,
                          height: 7,
                          margin: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 4),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFCCCCCC)),
                        );
                      }).toList(),
                    ),
                    Text(
                      'Next',
                      style: const TextStyle(
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}

class Slide extends StatelessWidget {
  final Tutorial data;
  const Slide({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      width: MediaQuery.of(context).size.width,
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
              data.title,
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
            child: Text(
              data.description,
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
    );
  }
}
