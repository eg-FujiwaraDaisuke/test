import 'package:minden/features/localize/domain/entities/localized.dart';

// data - model

class LocalizedModel extends Localized {
  const LocalizedModel({
    required String languageCode,
  }) : super(languageCode: languageCode);

  factory LocalizedModel.fromJson(Map<String, dynamic> json) {
    return LocalizedModel(
      languageCode: json['language_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language_code': languageCode,
    };
  }
}
