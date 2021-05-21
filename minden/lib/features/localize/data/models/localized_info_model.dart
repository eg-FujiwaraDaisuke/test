import 'package:minden/features/localize/domain/entities/localized_info.dart';

// data - model

class LocalizedInfoModel extends LocalizedInfo {
  LocalizedInfoModel({
    required String languageCode,
  }) : super(languageCode: languageCode);

  factory LocalizedInfoModel.fromJson(Map<String, dynamic> json) {
    return LocalizedInfoModel(
      languageCode: json["language_code"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "language_code": languageCode,
    };
  }
}
