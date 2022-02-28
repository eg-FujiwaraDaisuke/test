import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/login/presentation/pages/login_page.dart';
import 'package:minden/injection_container.dart';
import 'package:minden/utile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tutorial {
  Tutorial({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.tittlePosition,
    required this.titleTextAlign,
  });

  final String title;
  final String description;
  final String imagePath;
  final Map<String, double> tittlePosition;
  final TextAlign titleTextAlign;
}

class TutorialPage extends StatefulWidget {
  static const String routeName = '/tutorial';

  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final CarouselController _controller = CarouselController();
  int _currentIndex = 0;

  Future<void> _requestPermissions() async {
    await si<FirebaseMessaging>().requestPermission();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tutorialData = <Tutorial>[
      Tutorial(
        imagePath: 'tutorial-1.png',
        title: i18nTranslate(context, 'tutorial_step_1_title'),
        description: i18nTranslate(context, 'tutorial_step_1_description'),
        titleTextAlign: TextAlign.left,
        tittlePosition: {'left': 39, 'top': 86},
      ),
      Tutorial(
        imagePath: 'tutorial-2.png',
        title: i18nTranslate(context, 'tutorial_step_2_title'),
        description: i18nTranslate(context, 'tutorial_step_2_description'),
        titleTextAlign: TextAlign.right,
        tittlePosition: {'left': 30, 'top': 85},
      ),
      Tutorial(
        imagePath: 'tutorial-3.png',
        title: i18nTranslate(context, 'tutorial_step_3_title'),
        description: i18nTranslate(context, 'tutorial_step_3_description'),
        titleTextAlign: TextAlign.right,
        tittlePosition: {'left': 25, 'top': 85},
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFf5f3ed),
      body: SafeArea(
        child: Container(
          color: const Color(0xFFf5f3ed),
          child: Stack(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                    height: MediaQuery.of(context).size.height,
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
              Positioned(
                left: 39,
                right: 39,
                bottom: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (_currentIndex == tutorialData.length - 1) return;
                        await _toLogin();
                      },
                      child: Opacity(
                        opacity: _currentIndex != tutorialData.length - 1
                            ? 1.0
                            : 0.0,
                        child: Text(
                          i18nTranslate(context, 'skip'),
                          style: TextStyle(
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: const Color(0xFFABAAAB),
                            letterSpacing: calcLetterSpacing(letter: 4),
                          ),
                        ),
                      ),
                    ),
                    if (_currentIndex != tutorialData.length - 1)
                      GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut);
                        },
                        child: Text(
                          i18nTranslate(context, 'next'),
                          style: TextStyle(
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: const Color(0xFF787877),
                            letterSpacing: calcLetterSpacing(letter: 4),
                          ),
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () async {
                          await _toLogin();
                        },
                        child: Text(
                          i18nTranslate(context, 'start'),
                          style: TextStyle(
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: const Color(0xFF787877),
                            letterSpacing: calcLetterSpacing(letter: 4),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: tutorialData.asMap().entries.map((entry) {
                    final index = entry.key;
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? const Color(0xFF000000)
                              : const Color(0xFFCCCCCC)),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _toLogin() async {
    await _requestPermissions();
    await _doneTutorial();
    Navigator.pushReplacement(context, LoginPage.route());
  }

  Future<void> _doneTutorial() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('has_tutorial', true);
  }
}

class Slide extends StatelessWidget {
  const Slide({required this.data});

  final Tutorial data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 486,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/tutorial/${data.imagePath}'),
                ),
              ),
            ),
            Positioned(
              top: data.tittlePosition['top'],
              left: data.tittlePosition['left'],
              child: Text(
                data.title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  height: calcFontHeight(fontSize: 18, lineHeight: 32.4),
                  letterSpacing: calcLetterSpacing(letter: 4),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Container(
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
        const SizedBox(
          height: 41,
        ),
      ],
    );
  }
}
