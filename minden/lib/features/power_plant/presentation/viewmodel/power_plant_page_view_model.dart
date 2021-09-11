import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minden/features/power_plant/data/repositories/power_plant_repository_impl.dart';
import 'package:minden/features/power_plant/domain/power_plant.dart';
import 'package:minden/features/power_plant/domain/repositories/power_plant_repository.dart';
import 'package:minden/features/token/data/repositories/token_repository_impl.dart';
import 'package:minden/features/token/domain/repositories/token_repository.dart';

final powerPlantPageViewModelProvider =
    StateNotifierProvider<PowerPlantPageViewModel, PowerPlantPageState>(
        (ref) => PowerPlantPageViewModel(
              ref.read(tokenRepositoryProvider),
              ref.read(powerPlantRepositoryProvider),
            ));

/// マイページ - マッチングのViewModel
/// 本画面のタブも共用とする
class PowerPlantPageViewModel extends StateNotifier<PowerPlantPageState> {
  PowerPlantPageViewModel(
    this.tokenRepository,
    this.powerPlantRepository,
  ) : super(PowerPlantPageState(
          value: [],
          selectedCompanyIndex: 0,
        ));

  final TokenRepository tokenRepository;
  final PowerPlantRepository powerPlantRepository;

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
          capacity: '567',
          powerGenerationMethods: '風力発電',
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
          capacity: '890',
          powerGenerationMethods: '水力発電',
          isNewArrivals: false,
          created: DateTime.now(),
          modified: DateTime.now(),
        ),
      ],
      selectedCompanyIndex: 0,
    );
  }

  void setSelectedPickupIndex(int index) {
    state = PowerPlantPageState(
      value: state.value,
      selectedCompanyIndex: index,
    );
  }
}

class PowerPlantPageState {
  /// 電力会社情報
  late final List<PowerPlant> value;

  /// 選択中のピックアップ電力会社index
  late final int selectedCompanyIndex;

  PowerPlantPageState(
      {required this.value, required this.selectedCompanyIndex});
}
