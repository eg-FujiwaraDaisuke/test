import 'package:equatable/equatable.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant.dart';
import 'package:minden/features/profile_setting/domain/entities/tag.dart';

/// 顔の見える発電所情報APIレスポンス
class PowerPlantsResponse extends Equatable {
  const PowerPlantsResponse({
    required this.tag,
    required this.powerPlants,
  });

  /// タグ
  final Tag? tag;

  /// 顔の見える発電所情報
  final List<PowerPlant> powerPlants;

  @override
  List<Object> get props => [
        powerPlants,
      ];
}
