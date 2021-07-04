import 'package:flutter_riverpod/flutter_riverpod.dart';

/// マイページ - マッチングのViewModel
/// 本画面のタブも共用とする
class MatchingPageViewModel extends StateNotifier<MatchingData> {
  MatchingPageViewModel()
      : super(MatchingData(value: [20], selectedCompanyIndex: 0));

  MatchingData matchingData() => state;

  void fetch() {
    state = MatchingData(
      value: [20, 75],
      selectedCompanyIndex: 0,
    );
  }

  void setSelectedCompanyIndex(int index) {
    state = MatchingData(
      value: state.value,
      selectedCompanyIndex: index,
    );
  }
}

class MatchingData {
  /// スコアリスト
  /// TODO ここが電力会社情報のリストになる想定
  late final List<double> value;

  /// 選択中の電力会社index
  late final selectedCompanyIndex;

  String selectedCompanyPercentage() {
    return (value[selectedCompanyIndex] /
            value.reduce((value, element) => value + element) *
            100)
        .toStringAsFixed(1);
  }

  MatchingData({required this.value, required this.selectedCompanyIndex});
}
