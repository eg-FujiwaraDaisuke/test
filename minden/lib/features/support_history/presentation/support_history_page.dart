import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/utile.dart';
import 'package:url_launcher/url_launcher.dart';

/// 応援の軌跡ページ
class SupportHistoryPage extends StatelessWidget {
  const SupportHistoryPage();

  static const String routeName = '/user/profile/support_history';

  @override
  Widget build(BuildContext context) {
    const caseWidgets = [
      _CaseWidget(
        balloonText: 'さらなる再エネ発電普及に活用しています！',
        imagePath:
            'assets/images/support_history/support_history_case_id_10.jpg',
        imageLabelText: 'あつぎ市民発電所 第1号機',
        mainText:
            '脱原発と気候危機回避への一歩として、 未来の子どもたちに自立したクリーンなエネルギー環境を、 と市民が自分たちの手で発電事業を始めました。 太陽の恵みできれいな電気とおいしい野菜を！ 応援金はさらなる再エネ発電普及に活用します。',
      ),
      _CaseWidget(
        balloonText: '自給自足の野菜づくりを充実させています！',
        imagePath:
            'assets/images/support_history/support_history_case_id_7.jpg',
        imageLabelText: 'そらまめソーラー',
        mainText:
            '私たちの発電所は、東日本大震災の被災者支援から始まり、主婦6人で開所した高齢者施設です。\n「自分の親を預けたいと思えるデイサービスを」がコンセプト。\n応援金で自給自足の野菜づくりを充実させます！',
      ),
      _CaseWidget(
        balloonText: '子供たちが幸せに生きていけるように、ソーラーシェアリングの普及を目指します！',
        imagePath:
            'assets/images/support_history/support_history_case_id_17.jpg',
        imageLabelText: '橋爪建材三菱ソーラーシェアリング',
        mainText:
            '伊勢の地で未来を担う子供たちが幸せに生きていけるように、農地を守るソーラーシェアリングの普及を目指しております。\n太陽光との組み合わせで稼ぎやすい農業のモデルを作り見本となれるよう頑張ります。',
      ),
      _CaseWidget(
        balloonText: '日本の林業を守っていくため、小規模木質バイオマス発電事業の推進に活用しています！',
        imagePath:
            'assets/images/support_history/support_history_case_id_31.jpg',
        imageLabelText: 'GBバイオマス',
        mainText:
            '私たちは、課題山積の日本の林業・エネルギー問題解決への貢献を目指し、木質バイオマス発電事業を始めました。\n日本の林業を守っていくため、日本に小規模木質バイオマス発電事業を推進するため、ぜひ私たちの挑戦を応援してください。',
      ),
      _CaseWidget(
        balloonText: '豊かで住みよい益田市を実現し、人口減少に歯止めをかけたいと考えています！',
        imagePath:
            'assets/images/support_history/support_history_case_id_26.jpg',
        imageLabelText: '高津川風力発電所',
        mainText:
            '地元出資の地域電力会社を設立し、地域でエネルギーと資金を還流させ、余剰は全国の皆様にこの日本海の電力をお送りし、豊かで住みよい益田市を実現し、人口減少に歯止めをかけたいと考えております。',
      ),
    ];
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
        child: ListView(
          children: [
            const SizedBox(height: 36),
            const Center(
              child: Text(
                '応援活用事例',
                style: TextStyle(
                  color: Color(0xFF575292),
                  fontSize: 16,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'みなさんからの応援金は、\nこのように役立てられています',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF787877),
                  fontSize: 13,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 40),
            for (final widget in caseWidgets) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: widget,
              ),
              if (widget != caseWidgets.last)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 18,
                  ),
                  child: _buildDivider(),
                ),
            ],
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _buildDivider(),
            ),
            const SizedBox(height: 40),
            Center(
              child: GestureDetector(
                onTap: () {
                  launch('https://portal.minden.co.jp/powerplant-list');
                },
                child: Container(
                  width: 284,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFFF8C00), Color(0xFFFFC277)],
                      stops: [0, 1],
                    ),
                    borderRadius: BorderRadius.circular(27),
                  ),
                  child: const Center(
                    child: Text(
                      '活用事例をもっと見る',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                '発電所一覧（WEB）へ',
                style: TextStyle(
                  color: Color(0xFF787877),
                  fontSize: 11,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return SizedBox(
      height: 1,
      child: Container(
        color: const Color(0xFFE2E2E2),
      ),
    );
  }
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
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 36,
            ),
            child: Image.asset(
              'assets/images/support_history/support_history_balloon_triangle.png',
              width: 20,
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
