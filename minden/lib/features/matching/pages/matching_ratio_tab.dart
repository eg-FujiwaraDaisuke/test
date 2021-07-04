import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minden/features/matching/pages/matching_page.dart';
import 'package:minden/features/matching/viewmodel/matching_page_view_model.dart';

/// マイページ - マッチング - マッチング率
/// マッチング関連のタブを表示する
class MatchingRatioTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO 初期データ取得
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read(matchingPageViewModelProvider.notifier).fetch();
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
            SizedBox(height: 44),
            Text(
              'マッチング量（日別）',
              style: TextStyle(
                fontFamily: 'NotoSansJP',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                height: 1.0,
                letterSpacing: 0.4,
              ),
            ),
            Text(
                "${context.read(matchingPageViewModelProvider).selectedCompanyIndex}")
          ],
        ),
      ),
    );
  }
}

class _MatchingRatioByCompany extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final viewModel = watch(matchingPageViewModelProvider.notifier);
    final data = watch(matchingPageViewModelProvider);

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
              Text(
                "${data.selectedCompanyPercentage()}",
                style: TextStyle(
                  // TODO Barlowフォントを適用
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                  height: 1.2,
                  letterSpacing: 0.04,
                ),
              ),
              Text(
                "%",
                style: TextStyle(
                  // TODO Barlowフォントを適用
                  fontFamily: 'NotoSansJP',
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
        color: isSelected ? const Color(0xFFFF8C00) : const Color(0xfFFFFE7C9),
        value: v.ratio,
        // NOTE: 未設定の場合、[value]の値を表示するため、空文字を設定
        title: '',
        radius: 62,
      );
    }).toList();
  }
}

class _ChartLegends extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final data = watch(matchingPageViewModelProvider);

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
                  : const Color(0xfFFFFE7C9),
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            v.energyCompanyName,
            style: TextStyle(
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
      ;
    }).toList();
  }
}
