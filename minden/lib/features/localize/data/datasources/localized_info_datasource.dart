import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/localize/data/models/localized_info_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// data - datasource

abstract class LocalizedInfoDataSource {
  Future<LocalizedInfoModel> getLocalizedInfo({
    String osLanguageCode,
  });

  Future<LocalizedInfoModel> updateLocalizedInfo(String updateCode);
}

class LocalizedInfoDataSourceImpl implements LocalizedInfoDataSource {
  @override
  Future<LocalizedInfoModel> getLocalizedInfo({
    String osLanguageCode,
  }) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String languageCode = sharedPreferences.getString("language_code") ?? "";
    if (languageCode.isEmpty) {
      languageCode = osLanguageCode;
    }
    if (languageCode?.isEmpty ?? true) {
      throw LocalCacheException();
    }
    return LocalizedInfoModel(languageCode: languageCode);
  }

  @override
  Future<LocalizedInfoModel> updateLocalizedInfo(String updateCode) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("language_code", updateCode);
    return LocalizedInfoModel(languageCode: updateCode);
  }
}
