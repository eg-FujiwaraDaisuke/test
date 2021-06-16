import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Tutorial {
  late final String title;
  late final String description;
  late final String imagePath;

  Tutorial({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

class TutorialPage extends StatefulWidget {
  TutorialPage({Key? key}) : super(key: key);

  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final CarouselController _controller = CarouselController();
  List<Tutorial> tutorialData = [
    Tutorial(
        imagePath: 'tutorial-1.png',
        title: '電気の生産者の顔が\n見える・つながる',
        description:
            '何でも薄暗いじめじめした所でニャーニャー泣いていた\n事だけは記憶している。\n吾輩はここで始めて人間というものを見た。'),
    Tutorial(
        imagePath: 'tutorial-2.png',
        title: '電気の使用量や\n料金の行き先が見える',
        description:
            '何でも薄暗いじめじめした所でニャーニャー泣いていた\n事だけは記憶している。\n吾輩はここで始めて人間というものを見た。'),
    Tutorial(
        imagePath: 'tutorial-3.png',
        title: 'あの有名企業も使っている',
        description:
            '何でも薄暗いじめじめした所でニャーニャー泣いていた\n事だけは記憶している。\n吾輩はここで始めて人間というものを見た。'),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          color: Color(0xFFf6f5f0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                    height: 585,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: false,
                    viewportFraction: 1,
                    initialPage: _currentIndex,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    }),
                carouselController: _controller,
                items: tutorialData.map((Tutorial data) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Slide(data: data);
                    },
                  );
                }).toList(),
              ),
              Container(
                width: 291,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 47,
                      height: 17,
                      child: GestureDetector(
                        onTap: () {
                          // ここで別ページに飛ばす
                          print('skip');
                        },
                        child: Opacity(
                          opacity: _currentIndex != tutorialData.length - 1
                              ? 1.0
                              : 0.0,
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              fontFamily: 'NotoSansJP',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: tutorialData.asMap().entries.map((entry) {
                        int index = entry.key;
                        return Container(
                          width: 7,
                          height: 7,
                          margin: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 4),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? Color(0xFF000000)
                                  : Color(0xFFCCCCCC)),
                        );
                      }).toList(),
                    ),
                    Container(
                      width: 47,
                      height: 17,
                      child: _currentIndex != tutorialData.length - 1
                          ? GestureDetector(
                              onTap: () {
                                _controller.nextPage(
                                    duration: Duration(milliseconds: 250),
                                    curve: Curves.easeOut);
                              },
                              child: Text(
                                'Next',
                                style: TextStyle(
                                    fontFamily: 'NotoSansJP',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color(0xFF000000)),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                // ここで別ページに飛ばす
                                print('Start');
                              },
                              child: Text(
                                'Start',
                                style: TextStyle(
                                    fontFamily: 'NotoSansJP',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color(0xFF000000)),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
                image: AssetImage('assets/images/tutorial/${data.imagePath}'),
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
              style: TextStyle(
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
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(
            height: 109,
          ),
        ],
      ),
    );
  }
}
