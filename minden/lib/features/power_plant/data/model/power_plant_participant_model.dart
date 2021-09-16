import 'package:minden/features/power_plant/data/model/power_plant_participant_user_model.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_participant.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_participant_user.dart';

class PowerPlantParticipantModel extends PowerPlantParticipant {
  const PowerPlantParticipantModel({
    required String page,
    required String total,
    required String plantId,
    required String yearMonth,
    required List<PowerPlantParticipantUser> userList,
  }) : super(
          page: page,
          total: total,
          plantId: plantId,
          yearMonth: yearMonth,
          userList: userList,
        );

  factory PowerPlantParticipantModel.fromJson(Map<String, dynamic> json) {
    final Iterable iterable = json['userList'];

    return PowerPlantParticipantModel(
        page: json['page'],
        total: json['total'],
        plantId: json['plantId'],
        yearMonth: json['yearMonth'],
        userList: List<PowerPlantParticipantUserModel>.from(iterable
            .map((model) => PowerPlantParticipantUserModel.fromJson(model))));
  }
}
