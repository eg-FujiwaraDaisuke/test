import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minden/features/power_plant/data/repositories/power_plant_repository_impl.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_detail.dart';
import 'package:minden/features/power_plant/domain/repositories/power_plant_repository.dart';
import 'package:minden/features/token/data/repositories/token_repository_impl.dart';
import 'package:minden/features/token/domain/repositories/token_repository.dart';

final powerPlantDetailPageViewModelProvider = StateNotifierProvider<
        PowerPlantDetailPageViewModel, PowerPlantDetailPageState>(
    (ref) => PowerPlantDetailPageViewModel(
          ref.read(tokenRepositoryProvider),
          ref.read(powerPlantRepositoryProvider),
        ));

/// 発電所画面のViewModel
class PowerPlantDetailPageViewModel
    extends StateNotifier<PowerPlantDetailPageState> {
  PowerPlantDetailPageViewModel(
    this.tokenRepository,
    this.powerPlantRepository,
  ) : super(PowerPlantDetailPageState(
          value: null,
          selectedCompanyIndex: 0,
        ));

  final TokenRepository tokenRepository;

  final PowerPlantRepository powerPlantRepository;

  Future<void> fetchByPlantId(String plantId) async {
    (await powerPlantRepository.getPowerPlantDetail(plantId)).fold(
      (left) => {
        // TODO エラーハンドリング
      },
      (right) => {
        state = PowerPlantDetailPageState(
          value: right,
          selectedCompanyIndex: 0,
        )
      },
    );
  }

  void setSelectedPickupIndex(int index) {
    state = PowerPlantDetailPageState(
      value: state.value,
      selectedCompanyIndex: index,
    );
  }
}

class PowerPlantDetailPageState {
  PowerPlantDetailPageState({
    required this.value,
    required this.selectedCompanyIndex,
  });

  /// 電力会社詳細情報
  late final PowerPlantDetail? value;

  /// 選択中のピックアップ電力会社index
  late final int selectedCompanyIndex;
}
