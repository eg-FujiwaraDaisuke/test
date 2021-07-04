import 'package:flutter_riverpod/flutter_riverpod.dart';

/// マイページ - マッチングのViewModel
/// 本画面のタブも共用とする
class MatchingPageViewModel extends StateNotifier<MatchingPageState> {
  MatchingPageViewModel()
      : super(MatchingPageState(value: [
          MatchingData(energyCompanyName: '', ratio: 0),
        ], selectedCompanyIndex: 0));

  MatchingPageState matchingData() => state;

  void fetch() {
    state = MatchingPageState(
      value: [
        MatchingData(energyCompanyName: 'いとうせいこう', ratio: 25),
        MatchingData(energyCompanyName: 'その他', ratio: 80),
      ],
      selectedCompanyIndex: 0,
    );
  }

  void setSelectedCompanyIndex(int index) {
    state = MatchingPageState(
      value: state.value,
      selectedCompanyIndex: index,
    );
  }
}

class MatchingPageState {
  /// 電力会社情報
  late final List<MatchingData> value;

  /// 選択中の電力会社index
  late final selectedCompanyIndex;

  String selectedCompanyPercentage() {
    final molecule = value[selectedCompanyIndex].ratio;
    final denominator =
        value.map((v) => v.ratio).reduce((value, element) => value + element);

    return (molecule / denominator * 100).toStringAsFixed(1);
  }

  MatchingPageState({required this.value, required this.selectedCompanyIndex});
}

class MatchingData {
  final String energyCompanyName;
  final double ratio;

  MatchingData({required this.energyCompanyName, required this.ratio});
}
