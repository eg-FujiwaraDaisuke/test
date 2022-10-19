import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:minden/features/common/widget/ellipse_progress_widget/ellipse_progress_widget.dart';
import 'package:minden/gen/assets.gen.dart';

class _WidgetData {
  _WidgetData({
    required this.serifs,
    required this.serifsInBlessing,
    required this.buildWidget,
    required this.backgroundColor,
    required this.amountTextColor,
    required this.popperLeftImagePath,
    required this.popperRightImagePath,
  });

  final List<String> serifs;
  final List<String> serifsInBlessing;
  final Widget Function({
    required bool isBlessing,
    required double progress,
  }) buildWidget;
  final Color backgroundColor;
  final Color amountTextColor;
  final String popperLeftImagePath;
  final String popperRightImagePath;
}

class SupportHistoryAmountWidget extends StatelessWidget {
  SupportHistoryAmountWidget({
    required this.supportAmount,
    required this.isBlessing,
    required this.progress,
    required this.typeIndex,
  });

  /// 応援金の額
  final int? supportAmount;

  /// 祝福状態の表示にするか
  final bool isBlessing;

  /// 中央キャラクターの足元のグラフの進行度(0~1)
  final double progress;

  /// 表示するタイプ([_widgetData])
  final int typeIndex;

  late final _widgetData = <_WidgetData>[
    _WidgetData(
      serifs: [
        'ふんふふーん。',
        'ブルーベリーを作ってます！',
        '農家さんを応援したい！',
        '農業を実践中です！',
        '畑を活用して発電できるよ',
      ],
      serifsInBlessing: [
        'いつもありがとう！',
        'ブルーベリー酢届くといいな',
      ],
      buildWidget: _buildCharacterAreaType1,
      backgroundColor: const Color(0xFF82D2A3),
      amountTextColor: const Color(0xFF32b432),
      popperLeftImagePath:
          'assets/images/support_history/support_history_popper_left_1.png',
      popperRightImagePath:
          'assets/images/support_history/support_history_popper_right_1.png',
    ),
    _WidgetData(
      serifs: [
        'あたたかくしてね。',
        'おいしい野菜をつくるよ。',
        'さつまいもがとれたよ！',
        'ワーカーズコープって知ってる？',
        '2020年4月から発電してるよ',
      ],
      serifsInBlessing: [
        'わーい！',
        'うれしいなぁ',
      ],
      buildWidget: _buildCharacterAreaType2,
      backgroundColor: const Color(0xFFF09898),
      amountTextColor: const Color(0xFFEB5757),
      popperLeftImagePath:
          'assets/images/support_history/support_history_popper_left_2.png',
      popperRightImagePath:
          'assets/images/support_history/support_history_popper_right_2.png',
    ),
    _WidgetData(
      serifs: [
        'よーし！',
        '小松島市に貢献したい！',
        '海が綺麗に見える場所だよ',
        '林業の未来をつくるんだ',
        '生しらすがおいしいんです',
      ],
      serifsInBlessing: [
        '応援ありがとう！',
        'バイオマスを盛り上げよう！',
      ],
      buildWidget: _buildCharacterAreaType3,
      backgroundColor: const Color(0xFF6DC0D3),
      amountTextColor: const Color(0xFF2F80ED),
      popperLeftImagePath:
          'assets/images/support_history/support_history_popper_left_3.png',
      popperRightImagePath:
          'assets/images/support_history/support_history_popper_right_3.png',
    ),
    _WidgetData(
      serifs: [
        '最近腰が痛くてね。',
        '発電所を増やしたい！',
        '市民の力で発電所をつくったよ',
        '秋の収穫祭が楽しみだわ！',
        '厚木に遊びにこない？',
      ],
      serifsInBlessing: [
        'たくさんの応援、嬉しい！',
        '発電所に遊びにきて！',
      ],
      buildWidget: _buildCharacterAreaType4,
      backgroundColor: const Color(0xFFDFB83A),
      amountTextColor: const Color(0xFFFF8C00),
      popperLeftImagePath:
          'assets/images/support_history/support_history_popper_left_4.png',
      popperRightImagePath:
          'assets/images/support_history/support_history_popper_right_4.png',
    ),
    _WidgetData(
      serifs: [
        'どうだい、やってるかい！',
        '益田市に遊びにおいでよ！',
        '地元出資の発電所です',
        '真庭農園さんのメロン美味しいよ',
        '日本海に沈む夕日が綺麗なんだ',
      ],
      serifsInBlessing: [
        'おっ！ありがとうねぇ',
        'これからもよろしく！',
      ],
      buildWidget: _buildCharacterAreaType5,
      backgroundColor: const Color(0xFFEA963C),
      amountTextColor: const Color(0xFFEB5757),
      popperLeftImagePath:
          'assets/images/support_history/support_history_popper_left_5.png',
      popperRightImagePath:
          'assets/images/support_history/support_history_popper_right_5.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final data = _widgetData[typeIndex % _widgetData.length];
    final serif = isBlessing
        ? data.serifsInBlessing[Random().nextInt(data.serifsInBlessing.length)]
        : data.serifs[Random().nextInt(data.serifs.length)];
    return Container(
      color: data.backgroundColor,
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
                              serif,
                              style: const TextStyle(
                                color: Color(0xFF828282),
                                fontSize: 10,
                                fontFamily: 'NotoSansJP',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Assets.images.supportHistory
                            .supportHistoryWhiteBalloonTriangle
                            .image(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  data.buildWidget(
                    isBlessing: isBlessing,
                    progress: progress,
                  ),
                  const SizedBox(height: 36),
                ],
              ),
              if (isBlessing)
                Assets.images.supportHistory.supportHistoryConfetti.image(),
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
                                    style: TextStyle(
                                      color: data.amountTextColor,
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
                      data.popperLeftImagePath,
                      width: 60,
                    ),
                  ),
                if (isBlessing)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Image.asset(
                      data.popperRightImagePath,
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

  Widget _buildCharacterAreaType1({
    required bool isBlessing,
    required double progress,
  }) {
    return SizedBox(
      width: 320,
      height: 240,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 126,
              height: 240,
              child: Stack(
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
                      alignment: const Alignment(0.2, 0.3),
                      child: Assets
                          .images.supportHistory.supportHistoryCharacter11
                          .image(
                        height: 215,
                      ),
                    )
                  else
                    Align(
                      alignment: const Alignment(1, 0.3),
                      child: Assets
                          .images.supportHistory.supportHistoryCharacter12
                          .image(
                        height: 215,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Align(
            alignment: const Alignment(-0.8, -0.85),
            child: _buildCharacter2Small(isBlessing: isBlessing),
          ),
          Align(
            alignment: const Alignment(-1.12, 0.05),
            child: _buildCharacter3Small(isBlessing: isBlessing),
          ),
          Align(
            alignment: const Alignment(0.75, -0.9),
            child: _buildCharacter4Small(isBlessing: isBlessing),
          ),
          Align(
            alignment: const Alignment(1.15, 0),
            child: _buildCharacter5Small(isBlessing: isBlessing),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterAreaType2({
    required bool isBlessing,
    required double progress,
  }) {
    return SizedBox(
      width: 320,
      height: 220,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 126,
              height: 220,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    width: 126,
                    height: 33,
                    child: EllipseProgressWidget(
                      progress: progress,
                      strokeColor: const Color(0xFFEB5757),
                      strokeWidth: 3,
                      duration: const Duration(milliseconds: 500),
                    ),
                  ),
                  if (isBlessing)
                    Align(
                      alignment: const Alignment(-0.5, 1),
                      child: Assets
                          .images.supportHistory.supportHistoryCharacter31
                          .image(
                        height: 210,
                      ),
                    )
                  else
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Assets
                          .images.supportHistory.supportHistoryCharacter32
                          .image(
                        height: 210,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Align(
            alignment: const Alignment(-0.8, -0.5),
            child: _buildCharacter2Small(isBlessing: isBlessing),
          ),
          Align(
            alignment: const Alignment(-1.12, 0.4),
            child: _buildCharacter1Small(isBlessing: isBlessing),
          ),
          Align(
            alignment: const Alignment(0.75, -0.5),
            child: _buildCharacter4Small(isBlessing: isBlessing),
          ),
          Align(
            alignment: const Alignment(1.15, 0.35),
            child: _buildCharacter5Small(isBlessing: isBlessing),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterAreaType3({
    required bool isBlessing,
    required double progress,
  }) {
    return SizedBox(
      width: 320,
      height: 240,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 126,
              height: 240,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    width: 126,
                    height: 33,
                    child: EllipseProgressWidget(
                      progress: progress,
                      strokeColor: const Color(0xFF2F80ED),
                      strokeWidth: 3,
                      duration: const Duration(milliseconds: 500),
                    ),
                  ),
                  if (isBlessing)
                    Align(
                      alignment: const Alignment(-0.5, 0.5),
                      child: Assets
                          .images.supportHistory.supportHistoryCharacter21
                          .image(
                        height: 230,
                      ),
                    )
                  else
                    Align(
                      alignment: const Alignment(0, 0.5),
                      child: Assets
                          .images.supportHistory.supportHistoryCharacter22
                          .image(
                        height: 230,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Align(
            alignment: const Alignment(-0.8, -1),
            child: _buildCharacter3Small(isBlessing: isBlessing),
          ),
          Align(
            alignment: const Alignment(-1.12, 0.1),
            child: _buildCharacter1Small(isBlessing: isBlessing),
          ),
          Align(
            alignment: const Alignment(0.75, -0.9),
            child: _buildCharacter4Small(isBlessing: isBlessing),
          ),
          Align(
            alignment: const Alignment(1.15, 0),
            child: _buildCharacter5Small(isBlessing: isBlessing),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterAreaType4({
    required bool isBlessing,
    required double progress,
  }) {
    return SizedBox(
      width: 320,
      height: 220,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 126,
              height: 220,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    width: 126,
                    height: 33,
                    child: EllipseProgressWidget(
                      progress: progress,
                      strokeColor: const Color(0xFFFF8C00),
                      strokeWidth: 3,
                      duration: const Duration(milliseconds: 500),
                    ),
                  ),
                  if (isBlessing)
                    Align(
                      alignment: const Alignment(-0.5, 0.5),
                      child: Assets
                          .images.supportHistory.supportHistoryCharacter41
                          .image(
                        height: 200,
                      ),
                    )
                  else
                    Align(
                      alignment: const Alignment(0, 0.5),
                      child: Assets
                          .images.supportHistory.supportHistoryCharacter42
                          .image(
                        height: 200,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Align(
            alignment: const Alignment(-0.8, -1),
            child: _buildCharacter3Small(isBlessing: isBlessing),
          ),
          Align(
            alignment: const Alignment(-1.12, 0.2),
            child: _buildCharacter1Small(isBlessing: isBlessing),
          ),
          Align(
            alignment: const Alignment(0.75, -0.65),
            child: _buildCharacter2Small(isBlessing: isBlessing),
          ),
          Align(
            alignment: const Alignment(1.15, 0.1),
            child: _buildCharacter5Small(isBlessing: isBlessing),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterAreaType5({
    required bool isBlessing,
    required double progress,
  }) {
    return SizedBox(
      width: 320,
      height: 240,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 126,
              height: 260,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    width: 126,
                    height: 33,
                    child: EllipseProgressWidget(
                      progress: progress,
                      strokeColor: const Color(0xFFEB5757),
                      strokeWidth: 3,
                      duration: const Duration(milliseconds: 500),
                    ),
                  ),
                  if (isBlessing)
                    Align(
                      alignment: Alignment.topLeft,
                      child: Assets
                          .images.supportHistory.supportHistoryCharacter51
                          .image(
                        height: 230,
                      ),
                    )
                  else
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Assets
                          .images.supportHistory.supportHistoryCharacter52
                          .image(
                        height: 220,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Align(
            alignment: const Alignment(-0.8, -1.2),
            child: _buildCharacter3Small(isBlessing: isBlessing),
          ),
          Align(
            alignment: const Alignment(-1.2, 0.05),
            child: _buildCharacter1Small(isBlessing: isBlessing),
          ),
          Align(
            alignment: const Alignment(0.75, -0.9),
            child: _buildCharacter2Small(isBlessing: isBlessing),
          ),
          Align(
            alignment: const Alignment(1.15, 0),
            child: _buildCharacter4Small(isBlessing: isBlessing),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacter1Small({
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
              alignment: const Alignment(0.1, 0.7),
              child:
                  Assets.images.supportHistory.supportHistoryCharacter11.image(
                height: 98,
              ),
            )
          else
            Align(
              alignment: const Alignment(0.2, 0.7),
              child:
                  Assets.images.supportHistory.supportHistoryCharacter12.image(
                height: 98,
              ),
            ),
        ],
      ),
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
              child:
                  Assets.images.supportHistory.supportHistoryCharacter21.image(
                height: 117,
              ),
            )
          else
            Align(
              alignment: const Alignment(0.1, 1),
              child:
                  Assets.images.supportHistory.supportHistoryCharacter22.image(
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
              child:
                  Assets.images.supportHistory.supportHistoryCharacter31.image(
                height: 110,
              ),
            )
          else
            Align(
              alignment: const Alignment(0.3, 0.95),
              child:
                  Assets.images.supportHistory.supportHistoryCharacter32.image(
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
              child:
                  Assets.images.supportHistory.supportHistoryCharacter41.image(
                height: 110,
              ),
            )
          else
            Align(
              alignment: Alignment.bottomCenter,
              child:
                  Assets.images.supportHistory.supportHistoryCharacter42.image(
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
              child:
                  Assets.images.supportHistory.supportHistoryCharacter51.image(
                height: 130,
              ),
            )
          else
            Align(
              alignment: const Alignment(-0.3, 0.9),
              child:
                  Assets.images.supportHistory.supportHistoryCharacter52.image(
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
}
