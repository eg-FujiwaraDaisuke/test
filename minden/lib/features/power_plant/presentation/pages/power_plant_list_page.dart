import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_list_item.dart';
import 'package:minden/features/power_plant/presentation/viewmodel/power_plant_page_view_model.dart';

/// 発電所一覧
class PowerPlantList extends ConsumerWidget {
  const PowerPlantList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final data = watch(powerPlantPageViewModelProvider);

    return ListView.builder(
      itemCount: data.value.length,
      itemBuilder: (BuildContext context, int index) {
        final powerPlant = data.value[index];
        final direction = searchDirectionByIndex(index);

        return PowerPlantListItem(
          key: ValueKey(powerPlant.plantId),
          powerPlant: powerPlant,
          direction: direction,
        );
      },
    );
  }

  Direction searchDirectionByIndex(int index) {
    switch (index % 4) {
      case 0:
        return Direction.topLeft;
      case 1:
        return Direction.topRight;
      case 2:
        return Direction.bottomRight;
      case 3:
        return Direction.bottomLeft;
      default:
        return Direction.topLeft;
    }
  }
}
