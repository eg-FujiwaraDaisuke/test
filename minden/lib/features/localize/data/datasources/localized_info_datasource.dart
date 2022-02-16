import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/localize/data/models/localized_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// data - datasource

abstract class LocalizedInfoDataSource {
  Future<LocalizedModel> getLocalizedInfo({
    required String osLanguageCode,
  });

  Future<LocalizedModel> updateLocalizedInfo(String updateCode);
}

class LocalizedInfoDataSourceImpl implements LocalizedInfoDataSource {
  @override
  Future<LocalizedModel> getLocalizedInfo({
    required String osLanguageCode,
  }) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    var languageCode = sharedPreferences.getString('language_code') ?? '';
    if (languageCode.isEmpty) {
      languageCode = osLanguageCode;
    }
    if (languageCode.isEmpty) {
      throw LocalCacheException();
    }
    return LocalizedModel(languageCode: languageCode);
  }

  @override
  Future<LocalizedModel> updateLocalizedInfo(String updateCode) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('language_code', updateCode);
    return LocalizedModel(languageCode: updateCode);
  }
}
