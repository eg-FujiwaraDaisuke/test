import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/features/common/widget/ellipse_progress_widget/ellipse_progress_widget.dart';
import 'package:minden/features/login/presentation/bloc/logout_bloc.dart';
import 'package:minden/features/login/presentation/bloc/logout_event.dart';
import 'package:minden/features/login/presentation/pages/login_page.dart';
import 'package:minden/features/support_amount/data/datasources/support_amount_data_source.dart';
import 'package:minden/features/support_amount/data/repositories/support_amount_repository_impl.dart';
import 'package:minden/features/support_amount/domain/usecase/support_amount_usecase.dart';
import 'package:minden/features/support_amount/presentation/bloc/support_amount_bloc.dart';
import 'package:minden/features/support_amount/presentation/bloc/support_amount_event.dart';
import 'package:minden/features/support_amount/presentation/bloc/support_amount_state.dart';
import 'package:url_launcher/url_launcher.dart';

/// 応援の軌跡ページ
class SupportHistoryPage extends StatefulWidget {
  const SupportHistoryPage();

  static const String routeName = '/home/top/search/menu/support_history';

  @override
  _SupportHistoryPageState createState() => _SupportHistoryPageState();
}

class _SupportHistoryPageState extends State<SupportHistoryPage> {
  late GetSupportAmountBloc _getSupportAmountBloc;

  @override
  void initState() {
    super.initState();
    _getSupportAmountBloc = GetSupportAmountBloc(
      GetSupportAmount(
        SupportAmountRepositoryImpl(
          supportAmountDataSource: SupportAmountDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );
    _getSupportAmountBloc.add(const GetSupportAmountEvent());
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final day = now.day;
    // 祝福バージョンの表示か
    final isBlessing = day < 7;

    final currentMonthLastDay =
        DateTime(now.year, now.month).add(const Duration(days: -1)).day;
    // 今日が今月の何%か
    final progressMonth = day / currentMonthLastDay;

    return BlocProvider.value(
      value: _getSupportAmountBloc,
      child: BlocListener<GetSupportAmountBloc, SupportAmountState>(
        listener: (context, state) async {
          if (state is SupportAmountStateLoadError) {
            if (state.needLogin) {
              BlocProvider.of<LogoutBloc>(context).add(LogoutEvent());
              Loading.show(context);
              await Future.delayed(const Duration(seconds: 2));
              if (!mounted) return;
              await Navigator.of(
                context,
                rootNavigator: true,
              ).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                (_) {
                  Loading.hide();
                  return false;
                },
              );
            }
          }

          if (state is SupportAmountStateLoading) {
            if (!mounted) return;
            Loading.show(context);
            return;
          }
          Loading.hide();
        },
        child: BlocBuilder<GetSupportAmountBloc, SupportAmountState>(
          builder: (context, state) {
            return ListView(
              children: [
                _buildSupportAmount(
                  progress: progressMonth,
                  supportAmount: state is SupportAmountStateLoaded
                      ? state.supportAmount.supportAmount
                      : null,
                  isBlessing: isBlessing,
                ),
                _buildCases(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSupportAmount({
    int? supportAmount,
    required bool isBlessing,
    required double progress,
  }) {
    return Container(
      color: const Color(0xFF82D2A3),
      child: Column(
        children: [
          const SizedBox(height: 32),
          const Divider(
            thickness: 1,
            color: Colors.white,
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(height: 4),
          const Text(
            'お気に入りの発電所を見つけよう！',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Divider(
            thickness: 1,
            color: Colors.white,
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(height: 12),
          const Text(
            '電気代のうち100円が\nあなたからの応援の気持ちとして\n毎月選んだ発電所に届きます。',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  const SizedBox(height: 40),
                  Opacity(
                    opacity: 0.7,
                    child: Column(
                      children: [
                        Container(
                          width: 200,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              isBlessing ? 'いつもありがとう！' : 'ふんふふーん。',
                              style: const TextStyle(
                                color: Color(0xFF828282),
                                fontSize: 10,
                                fontFamily: 'NotoSansJP',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/images/support_history/support_history_white_balloon_triangle.png',
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: 320,
                    height: 225,
                    child: Stack(
                      children: [
                        _buildCharacter1(
                          isBlessing: isBlessing,
                          progress: progress,
                        ),
                        Align(
                          alignment: const Alignment(-0.75, -0.85),
                          child: _buildCharacter2Small(isBlessing: isBlessing),
                        ),
                        Align(
                          alignment: const Alignment(-1.18, 0.05),
                          child: _buildCharacter3Small(isBlessing: isBlessing),
                        ),
                        Align(
                          alignment: const Alignment(0.85, -0.9),
                          child: _buildCharacter4Small(isBlessing: isBlessing),
                        ),
                        Align(
                          alignment: const Alignment(1.25, 0),
                          child: _buildCharacter5Small(isBlessing: isBlessing),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                ],
              ),
              if (isBlessing)
                Image.asset(
                  'assets/images/support_history/support_history_confetti.gif',
                ),
            ],
          ),
          SizedBox(
            width: 340,
            height: 90,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: supportAmount != null
                        ? Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: NumberFormat('#,###')
                                        .format(supportAmount),
                                    style: const TextStyle(
                                      color: Color(0xFF32B432),
                                      fontSize: 24,
                                      fontFamily: 'NotoSansJP',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: '円',
                                    style: TextStyle(
                                      color: Color(0xFF828282),
                                      fontSize: 11,
                                      fontFamily: 'NotoSansJP',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                                style: const TextStyle(letterSpacing: 10),
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 240,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text(
                        'これまでみんなで届けた応援金',
                        style: TextStyle(
                          color: Color(0xFF828282),
                          fontSize: 11,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                if (isBlessing && supportAmount != null)
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Image.asset(
                      'assets/images/support_history/support_history_popper_left.png',
                      width: 60,
                    ),
                  ),
                if (isBlessing)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Image.asset(
                      'assets/images/support_history/support_history_popper_right.png',
                      width: 60,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildCharacter1({
    required bool isBlessing,
    required double progress,
  }) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          width: 126,
          height: 33,
          child: EllipseProgressWidget(
            progress: progress,
            strokeColor: const Color(0xFF32B432),
            strokeWidth: 3,
            duration: const Duration(milliseconds: 500),
          ),
        ),
        if (isBlessing)
          Align(
            alignment: const Alignment(0.06, 0),
            child: Image.asset(
              'assets/images/support_history/support_history_character_1_1.gif',
              height: 215,
            ),
          )
        else
          Align(
            alignment: const Alignment(0.13, 0),
            child: Image.asset(
              'assets/images/support_history/support_history_character_1_2.gif',
              height: 215,
            ),
          ),
      ],
    );
  }

  Widget _buildCharacter2Small({
    required bool isBlessing,
  }) {
    return SizedBox(
      width: 100,
      height: 130,
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(0, 0.96),
            child: _buildEllipse(width: 40, height: 10),
          ),
          if (isBlessing)
            Align(
              alignment: const Alignment(-0.1, 1),
              child: Image.asset(
                'assets/images/support_history/support_history_character_2_1.gif',
                height: 117,
              ),
            )
          else
            Align(
              alignment: const Alignment(0.1, 1),
              child: Image.asset(
                'assets/images/support_history/support_history_character_2_2.gif',
                height: 117,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCharacter3Small({
    required bool isBlessing,
  }) {
    return SizedBox(
      width: 100,
      height: 140,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildEllipse(width: 40, height: 10),
          ),
          if (isBlessing)
            Align(
              alignment: const Alignment(0.45, 0.95),
              child: Image.asset(
                'assets/images/support_history/support_history_character_3_1.gif',
                height: 110,
              ),
            )
          else
            Align(
              alignment: const Alignment(0.3, 0.95),
              child: Image.asset(
                'assets/images/support_history/support_history_character_3_2.gif',
                height: 110,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCharacter4Small({
    required bool isBlessing,
  }) {
    return SizedBox(
      width: 100,
      height: 130,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildEllipse(width: 40, height: 10),
          ),
          if (!isBlessing)
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/support_history/support_history_character_4_1.gif',
                height: 110,
              ),
            )
          else
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/support_history/support_history_character_4_2.gif',
                height: 110,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCharacter5Small({
    required bool isBlessing,
  }) {
    return SizedBox(
      width: 100,
      height: 150,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildEllipse(width: 40, height: 10),
          ),
          if (!isBlessing)
            Align(
              alignment: const Alignment(-0.5, 0.75),
              child: Image.asset(
                'assets/images/support_history/support_history_character_5_1.gif',
                height: 130,
              ),
            )
          else
            Align(
              alignment: const Alignment(-0.3, 0.9),
              child: Image.asset(
                'assets/images/support_history/support_history_character_5_2.gif',
                height: 120,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEllipse({
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.elliptical(width, height),
        ),
      ),
    );
  }

  Widget _buildCases() {
    const cases = [
      _CaseWidget(
        balloonText: 'さらなる再エネ発電普及に活用しています！',
        imagePath:
            'assets/images/support_history/support_history_case_id_10.jpg',
        imageLabelText: 'あつぎ市民発電所 第1号機',
        mainText: '''
脱原発と気候危機回避への一歩として、未来の子どもたちに自立したクリーンなエネルギー環境を、と市民が自分たちの手で発電事業を始めました。太陽の恵みできれいな電気とおいしい野菜を！応援金はさらなる再エネ発電普及に活用します。''',
      ),
      _CaseWidget(
        balloonText: '自給自足の野菜づくりを充実させています！',
        imagePath:
            'assets/images/support_history/support_history_case_id_7.jpg',
        imageLabelText: 'そらまめソーラー',
        mainText: '''
私たちの発電所は、東日本大震災の被災者支援から始まり、主婦6人で開所した高齢者施設です。
「自分の親を預けたいと思えるデイサービスを」がコンセプト。
応援金で自給自足の野菜づくりを充実させます！''',
      ),
      _CaseWidget(
        balloonText: '子供たちが幸せに生きていけるように、ソーラーシェアリングの普及を目指します！',
        imagePath:
            'assets/images/support_history/support_history_case_id_17.jpg',
        imageLabelText: '橋爪建材三菱ソーラーシェアリング',
        mainText: '''
伊勢の地で未来を担う子供たちが幸せに生きていけるように、農地を守るソーラーシェアリングの普及を目指しております。
太陽光との組み合わせで稼ぎやすい農業のモデルを作り見本となれるよう頑張ります。''',
      ),
      _CaseWidget(
        balloonText: '日本の林業を守っていくため、小規模木質バイオマス発電事業の推進に活用しています！',
        imagePath:
            'assets/images/support_history/support_history_case_id_31.jpg',
        imageLabelText: 'GBバイオマス',
        mainText: '''
私たちは、課題山積の日本の林業・エネルギー問題解決への貢献を目指し、木質バイオマス発電事業を始めました。
日本の林業を守っていくため、日本に小規模木質バイオマス発電事業を推進するため、ぜひ私たちの挑戦を応援してください。''',
      ),
      _CaseWidget(
        balloonText: '豊かで住みよい益田市を実現し、人口減少に歯止めをかけたいと考えています！',
        imagePath:
            'assets/images/support_history/support_history_case_id_26.jpg',
        imageLabelText: '高津川風力発電所',
        mainText: '''
地元出資の地域電力会社を設立し、地域でエネルギーと資金を還流させ、余剰は全国の皆様にこの日本海の電力をお送りし、豊かで住みよい益田市を実現し、人口減少に歯止めをかけたいと考えております。''',
      ),
    ];
    return Column(
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
        for (final widget in cases) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: widget,
          ),
          if (widget != cases.last)
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

  @override
  void dispose() {
    _getSupportAmountBloc.close();
    super.dispose();
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
              'assets/images/support_history/support_history_green_balloon_triangle.png',
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
