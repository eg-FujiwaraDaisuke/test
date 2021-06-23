import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/utile.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final CarouselController _controller = CarouselController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Tutorial> _tutorialData = [
      Tutorial(
        imagePath: 'tutorial-1.png',
        title: i18nTranslate(context, 'tutorial_step_1_title'),
        description: i18nTranslate(context, 'tutorial_step_1_description'),
      ),
      Tutorial(
        imagePath: 'tutorial-2.png',
        title: i18nTranslate(context, 'tutorial_step_2_title'),
        description: i18nTranslate(context, 'tutorial_step_2_description'),
      ),
      Tutorial(
        imagePath: 'tutorial-3.png',
        title: i18nTranslate(context, 'tutorial_step_3_title'),
        description: i18nTranslate(context, 'tutorial_step_3_description'),
      ),
    ];

    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          color: Color(0xFFf5f3ed),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                    height: 690,
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
                items: _tutorialData.map((Tutorial data) {
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
                        onTap: () async {
                          // ここで別ページに飛ばす
                          await setHasTutorial();
                          print('skip');
                        },
                        child: Opacity(
                          opacity: _currentIndex != _tutorialData.length - 1
                              ? 1.0
                              : 0.0,
                          child: Text(
                            i18nTranslate(context, "skip"),
                            style: TextStyle(
                              fontFamily: 'NotoSansJP',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xFFABAAAB),
                              letterSpacing: calcLetterSpacing(letter: 4),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: _tutorialData.asMap().entries.map((entry) {
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
                      child: _currentIndex != _tutorialData.length - 1
                          ? GestureDetector(
                              onTap: () {
                                _controller.nextPage(
                                    duration: Duration(milliseconds: 250),
                                    curve: Curves.easeOut);
                              },
                              child: Text(
                                i18nTranslate(context, "next"),
                                style: TextStyle(
                                  fontFamily: 'NotoSansJP',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color(0xFF000000),
                                  letterSpacing: calcLetterSpacing(letter: 4),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                print('Start');
                                await setHasTutorial();
                              },
                              child: Text(
                                i18nTranslate(context, "start"),
                                style: TextStyle(
                                  fontFamily: 'NotoSansJP',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color(0xFF000000),
                                  letterSpacing: calcLetterSpacing(letter: 4),
                                ),
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

  Future<void> setHasTutorial() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("has_tutorial", true);
  }
}

class Slide extends StatelessWidget {
  final Tutorial data;
  const Slide({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 328,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/tutorial/${data.imagePath}'),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 328,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset.center,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    const Color(0xFFf5f3ed).withOpacity(0),
                    const Color(0xFFf5f3ed).withOpacity(1),
                  ],
                  stops: const [
                    0.0,
                    1.0,
                  ],
                ),
              ),
            ),
          ],
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
              height: calcFontHeight(fontSize: 18, lineHeight: 32.4),
              letterSpacing: calcLetterSpacing(letter: 4),
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
              height: calcFontHeight(fontSize: 12, lineHeight: 22.2),
              letterSpacing: calcLetterSpacing(letter: 4),
            ),
          ),
        ),
        SizedBox(
          height: 109,
        ),
      ],
    );
  }
}
