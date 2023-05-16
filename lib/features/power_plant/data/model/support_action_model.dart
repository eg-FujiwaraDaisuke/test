import 'package:minden/features/power_plant/domain/entities/support_action.dart';

class SupportActionModel extends SupportAction {
  const SupportActionModel({
    required String support_action,
  }) : super(
          support_action: support_action,
        );

  factory SupportActionModel.fromJson(Map<String, dynamic> json) {
    return SupportActionModel(
      support_action: json['support_action'],
    );
  }
}
