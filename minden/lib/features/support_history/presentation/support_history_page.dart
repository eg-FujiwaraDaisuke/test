import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/utile.dart';

class SupportHistoryPage extends StatelessWidget {
  const SupportHistoryPage();

  static const String routeName = '/user/profile/support_history';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/images/common/leading_back.svg',
            width: 44,
            height: 44,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.black,
        ),
        title: Text(
          '応援の軌跡',
          style: TextStyle(
            color: const Color(0xFF575292),
            fontSize: 16,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w700,
            letterSpacing: calcLetterSpacing(letter: 0.5),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }


class _CaseWidget extends StatelessWidget {
  const _CaseWidget({
    required this.balloonText,
    required this.imagePath,
    required this.imageLabelText,
    required this.mainText,
  });

  final String balloonText;
  final String imagePath;
  final String imageLabelText;
  final String mainText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF75C975),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            child: Center(
              child: Text(
                balloonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'NotoSansJP',
                  height: 1.4,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AspectRatio(
            aspectRatio: 1.5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 0,
                  bottom: 20,
                  child: Container(
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Color(0xCCFFFFFF),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(15),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 16),
                        child: Text(
                          imageLabelText,
                          style: const TextStyle(
                            color: Color(0xFF32B432),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'NotoSansJP',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          mainText,
          style: const TextStyle(
            color: Color(0xFF7D7E7F),
            fontSize: 13,
            fontWeight: FontWeight.w400,
            fontFamily: 'NotoSansJP',
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
