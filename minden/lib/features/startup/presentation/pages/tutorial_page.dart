import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/utile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../injection_container.dart';

enum PositionAlign { left, right }

class Tutorial {
  final String title;
  final String description;
  final String imagePath;
  final Map<String, double> tittlePosition;
  final TextAlign titleTextAlign;
  final PositionAlign positionAlign;

  Tutorial(
      {required this.title,
      required this.description,
      required this.imagePath,
      required this.tittlePosition,
      required this.titleTextAlign,
      required this.positionAlign});
}

class TutorialPage extends StatefulWidget {
  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final CarouselController _controller = CarouselController();
  int _currentIndex = 0;

  late bool _fetching = false;
  late NotificationSettings _settings;
  late String _token;
  late Stream<String> _tokenStream;

  Future<void> requestPermissions() async {
    setState(() {
      _fetching = true;
    });

    final settings = await si<FirebaseMessaging>().requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );

    setState(() {
      _fetching = false;
      _settings = settings;
    });

    print(_settings.alert);
  }

  void setToken(String? token) {
    print(token);
    if (token == null) return;
    setState(() {
      _token = token;
    });
  }

  @override
  void initState() {
    super.initState();
    si<FirebaseMessaging>().getToken().then((String? token) {
      setToken(token);
    });
    //TODO トークンの変更を検知したらサーバにトークンを送信して常に最新の FCM トークンを使う
    _tokenStream = si<FirebaseMessaging>().onTokenRefresh;
    _tokenStream.listen(setToken);
  }

  @override
  Widget build(BuildContext context) {
    List<Tutorial> _tutorialData = [
      Tutorial(
        imagePath: 'tutorial-1.png',
        title: i18nTranslate(context, 'tutorial_step_1_title'),
        description: i18nTranslate(context, 'tutorial_step_1_description'),
        titleTextAlign: TextAlign.left,
        tittlePosition: {'left': 39, 'right': 0, 'top': 227},
        positionAlign: PositionAlign.left,
      ),
      Tutorial(
        imagePath: 'tutorial-2.png',
        title: i18nTranslate(context, 'tutorial_step_2_title'),
        description: i18nTranslate(context, 'tutorial_step_2_description'),
        titleTextAlign: TextAlign.right,
        tittlePosition: {'right': 18, 'left': 0, 'top': 201},
        positionAlign: PositionAlign.right,
      ),
      Tutorial(
        imagePath: 'tutorial-3.png',
        title: i18nTranslate(context, 'tutorial_step_3_title'),
        description: i18nTranslate(context, 'tutorial_step_3_description'),
        titleTextAlign: TextAlign.right,
        tittlePosition: {'right': 32, 'left': 0, 'top': 74},
        positionAlign: PositionAlign.right,
      ),
    ];

    if (_fetching) {
      return const CircularProgressIndicator();
    }

    return Scaffold(
      body: SafeArea(
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
                          // ここでプッシュ通知許可ダイアログを出す
                          // PushNotificationPermissionDialog(context: context).showPermissionDialog();
                          await requestPermissions();
                          await setHasTutorial();
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
                                // ここでプッシュ通知許可ダイアログを出す
                                // PushNotificationPermissionDialog(
                                //         context: context)
                                //     .showPermissionDialog();
                                await requestPermissions();
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
              height: 484,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/tutorial/${data.imagePath}'),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 484,
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
            Positioned(
              top: data.tittlePosition['top'],
              left: data.tittlePosition['left'],
              right: data.tittlePosition['right'],
              child: Text(
                data.title,
                textAlign: data.titleTextAlign,
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
        SizedBox(
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
        SizedBox(
          height: 41,
        ),
      ],
    );
  }
}
