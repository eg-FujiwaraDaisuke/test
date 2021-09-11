import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minden/features/power_plant/data/model/power_plant_model.dart';
import 'package:minden/features/power_plant/data/repositories/power_plant_repository_impl.dart';
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
        PowerPlantModel(
          plantId: '1',
          areaCode: '1',
          name: 'ABC発電所',
          viewAddress: '東京都',
          voltageType: '1',
          powerGenerationMethod: '太陽光発電',
          renewableType: '1',
          generationCapacity: '1234',
          displayOrder: '1',
          isRecommend: true,
          ownerName: '1',
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          plantImage1: '1',
          supportGiftName: '1',
          shortCatchphrase: '1',
          catchphrase: 'キャッチフレーズ',
          thankYouMessage: '1',
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
  late final List<PowerPlantModel> value;

  /// 選択中のピックアップ電力会社index
  late final int selectedCompanyIndex;

  PowerPlantPageState({
    required this.value,
    required this.selectedCompanyIndex,
  });
}
