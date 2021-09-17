import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_list_item.dart';
import 'package:minden/features/power_plant/presentation/viewmodel/power_plant_page_view_model.dart';

class SupportHistoryPowerPlantList extends StatelessWidget {
  const SupportHistoryPowerPlantList(this.historyType);

  final String historyType;

  @override
  Widget build(BuildContext context) {

    logD(historyType);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context
          .read(powerPlantPageViewModelProvider.notifier)
          .historyFetch(historyType);
    });
    return const _SupportHistoryPowerPlantList();
  }
}

class _SupportHistoryPowerPlantList extends ConsumerWidget {
  const _SupportHistoryPowerPlantList({Key? key}) : super(key: key);

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
          isShowCatchphras: false,
          aspectRatio: 340 / 289,
          thumbnailImageHeight: 226,
          supportedData: '2021年8月',
          reservedDate: '2021年9月',
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
