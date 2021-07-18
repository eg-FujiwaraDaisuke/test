import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minden/features/power_plant/domain/power_plant.dart';

/// マイページ - マッチングのViewModel
/// 本画面のタブも共用とする
class PowerPlantPageViewModel extends StateNotifier<PowerPlantPageState> {
  PowerPlantPageViewModel() : super(PowerPlantPageState(value: []));

  PowerPlantPageState matchingData() => state;

  void fetch() {
    state = PowerPlantPageState(
      value: [
        PowerPlant(
          plantId: '1',
          name: 'ABC発電所',
          images: [],
          catchPhrase: 'キャッチフレーズ',
          location: '山形県',
          capacity: '1234',
          powerGenerationMethods: '太陽光発電',
          isNewArrivals: true,
          created: DateTime.now(),
          modified: DateTime.now(),
        ),
        PowerPlant(
          plantId: '2',
          name: 'DCE発電所',
          images: [],
          catchPhrase: 'キャッチフレーズ',
          location: '新潟県',
          capacity: '1234',
          powerGenerationMethods: '太陽光発電',
          isNewArrivals: true,
          created: DateTime.now(),
          modified: DateTime.now(),
        ),
        PowerPlant(
          plantId: '1',
          name: 'XYZ発電所',
          images: [],
          catchPhrase: 'キャッチフレーズ',
          location: '東京都',
          capacity: '1234',
          powerGenerationMethods: '太陽光発電',
          isNewArrivals: false,
          created: DateTime.now(),
          modified: DateTime.now(),
        ),
      ],
    );
  }
}

class PowerPlantPageState {
  /// 電力会社情報
  late final List<PowerPlant> value;

  PowerPlantPageState({required this.value});
}
