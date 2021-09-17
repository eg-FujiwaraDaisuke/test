import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/features/power_plant/data/repositories/power_plant_repository_impl.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant.dart';
import 'package:minden/features/power_plant/domain/repositories/power_plant_repository.dart';
import 'package:minden/features/token/data/repositories/token_repository_impl.dart';
import 'package:minden/features/token/domain/repositories/token_repository.dart';

final powerPlantPageViewModelProvider =
    StateNotifierProvider<PowerPlantPageViewModel, PowerPlantPageState>(
        (ref) => PowerPlantPageViewModel(
              ref.read(tokenRepositoryProvider),
              ref.read(powerPlantRepositoryProvider),
            ));

/// 発電所画面のViewModel
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

  Future<void> fetch() async {
    (await powerPlantRepository.getPowerPlant(null)).fold(
      (left) => {
        // TODO エラーハンドリング
        logD('$left')
      },
      (right) => {
        state = PowerPlantPageState(
          value: right.powerPlants,
          selectedCompanyIndex: 0,
        )
      },
    );
  }

  void setSelectedPickupIndex(int index) {
    state = PowerPlantPageState(
      value: state.value,
      selectedCompanyIndex: index,
    );
  }

  Future<void> historyFetch(String historyType) async {
    logD(historyType);
    (await powerPlantRepository.getPowerPlantHistory(historyType)).fold(
          (left) => {
        // TODO エラーハンドリング
        logD('$left')
      },
          (right) => {
        state = PowerPlantPageState(
          value: right.powerPlants,
          selectedCompanyIndex: 0,
        )
      },
    );
  }

}

class PowerPlantPageState {
  PowerPlantPageState({
    required this.value,
    required this.selectedCompanyIndex,
  });

  /// 電力会社情報
  late final List<PowerPlant> value;

  /// 選択中のピックアップ電力会社index
  late final int selectedCompanyIndex;
}
