import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minden/features/matching/pages/matching_page.dart';
import 'package:minden/features/matching/viewmodel/matching_page_view_model.dart';

/// マイページ - マッチング - マッチング率
/// マッチング関連のタブを表示する
class MatchingRatioTab extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO 初期データ取得
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      ref.read(matchingPageViewModelProvider.notifier).fetch();
    });

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // マッチング率（円グラフ）
            _MatchingRatioByCompany(),
            // 凡例
            _ChartLegends(),
            const SizedBox(height: 44),
            // マッチング量（日別）
            // TODO デザイン確定後、設定している条件に応じて棒グラフの表示内容も変わる見込み
            const Text(
              'マッチング量（日別）',
              style: TextStyle(
                fontFamily: 'NotoSansJP',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                height: 1.0,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 20),
            _MatchingRatioByDate(),
          ],
        ),
      ),
    );
  }
}

class _MatchingRatioByCompany extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(matchingPageViewModelProvider.notifier);
    final data = ref.watch(matchingPageViewModelProvider);

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 円グラフ
          PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (pieTouchResponse) {
                  final touchedSectionIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;

                  // NOTE: 円グラフの要素部分以外のタッチの場合、indexは-1
                  if (touchedSectionIndex != -1) {
                    viewModel.setSelectedCompanyIndex(touchedSectionIndex);
                  }
                },
              ),
              startDegreeOffset: 270,
              borderData: FlBorderData(
                show: false,
              ),
              // 円グラフの間隔
              sectionsSpace: 3,
              centerSpaceRadius: 92,
              sections: _generateSections(data),
            ),
          ),
          // 選択中の電力会社が占める割合
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 18),
              Text(
                data.selectedCompanyPercentage(),
                style: const TextStyle(
                  fontFamily: 'Barlow',
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                  height: 1.2,
                  letterSpacing: 0.04,
                ),
              ),
              const Text(
                '%',
                style: TextStyle(
                  fontFamily: 'Barlow',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  height: 1.2,
                  letterSpacing: 0.04,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// 電力会社のマッチングデータに基づき、円グラフの各構成要素（セクション）データを作成する
  List<PieChartSectionData> _generateSections(MatchingPageState data) {
    final selectedIndex = data.selectedCompanyIndex;
    return data.value.map((v) {
      final index = data.value.indexOf(v);
      final isSelected = index == selectedIndex;

      return PieChartSectionData(
        color: isSelected ? const Color(0xFFFF8C00) : const Color(0xFFFFE7C9),
        value: v.ratio,
        // NOTE: 未設定の場合、[value]の値を表示するため、空文字を設定
        title: '',
        radius: 62,
      );
    }).toList();
  }
}

class _ChartLegends extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(matchingPageViewModelProvider);

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _generateLegends(data),
    );
  }

  /// 電力会社のマッチングデータに基づき、円グラフの各構成要素（セクション）データを作成する
  List<Widget> _generateLegends(MatchingPageState data) {
    final selectedIndex = data.selectedCompanyIndex;
    return data.value.map((v) {
      final index = data.value.indexOf(v);
      final isSelected = index == selectedIndex;

      return Row(
        children: <Widget>[
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(3)),
              color: isSelected
                  ? const Color(0xFFFF8C00)
                  : const Color(0xFFFFE7C9),
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            v.energyCompanyName,
            style: const TextStyle(
              color: Color(0xFF6A6F7D),
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.w500,
              fontSize: 12,
              height: 1.1,
              letterSpacing: 0.04,
            ),
          )
        ],
      );
    }).toList();
  }
}

class _MatchingRatioByDate extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                // 下側軸ラベル
                bottomTitles: SideTitles(
                  showTitles: true,
                  margin: 16,
                  getTextStyles: (value) => const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 10,
                  ),
                  getTitles: (double value) {
                    switch (value.toInt()) {
                      case 0:
                        return '1';
                      case 1:
                        return '2';
                      case 2:
                        return '3';
                      case 3:
                        return '4';
                      case 4:
                        return '5';
                      case 5:
                        return '6';
                      case 6:
                        return '7';
                      case 7:
                        return '8';
                      case 8:
                        return '9';
                      default:
                        return '';
                    }
                  },
                ),
                // 左側軸ラベル
                leftTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (value) => const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 10,
                  ),
                  getTitles: (value) {
                    if (value == 9) {
                      return 'kW';
                    } else {
                      return value.toStringAsFixed(0);
                    }
                  },
                  margin: 4,
                ),
              ),
              // 目盛線
              gridData: FlGridData(
                show: true,
                getDrawingHorizontalLine: (value) => FlLine(
                    color: const Color(0xFFE5E7EB),
                    strokeWidth: 1,
                    dashArray: [2]),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  bottom: BorderSide(
                    color: Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
              ),
              // TODO データ最大値 + 1とし、ラベルを設定する
              maxY: 9,
              groupsSpace: 20,
              barGroups: getData(),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> getData() {
    return [
      _generateBarChartGroupData(0, 7),
      _generateBarChartGroupData(1, 1),
      _generateBarChartGroupData(2, 4),
      _generateBarChartGroupData(3, 8),
      _generateBarChartGroupData(4, 2),
      _generateBarChartGroupData(5, 3),
      _generateBarChartGroupData(6, 4),
      _generateBarChartGroupData(7, 5),
      _generateBarChartGroupData(8, 9),
    ];
  }
}

BarChartGroupData _generateBarChartGroupData(int x, double value) {
  return BarChartGroupData(
    x: x,
    barsSpace: 4,
    barRods: [
      _generateBarChartRodData(value),
    ],
  );
}

BarChartRodData _generateBarChartRodData(double value) {
  return BarChartRodData(
    y: value,
    width: 16,
    colors: [Color(0xFFFF8C00)],
    borderRadius: const BorderRadius.all(Radius.zero),
  );
}
