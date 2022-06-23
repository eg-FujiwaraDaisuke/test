import 'package:minden/core/hook/use_logger.dart';

/// 発電所詳細を開くurl
const String _powerPlantDetailPath = 'powerplant-info';

/// DynamicLinksで扱う種別
enum DynamicLinksType {
  /// 発電所詳細
  powerPlantDetail,

  /// 未定義
  undefined,
}

extension DynamicLinksTypeExt on DynamicLinksType {
  String get pathByType {
    switch (this) {
      case DynamicLinksType.powerPlantDetail:
        return _powerPlantDetailPath;
      case DynamicLinksType.undefined:
        return '';
    }
  }
}

/// uriから、合致するDynamicLinksTypeを検索する
/// ex: https://portal.minden.co.jp/powerplant-info/xxx
DynamicLinksType? typeByUri(Uri? uri) {
  if (uri == null) {
    return null;
  }

  final url = uri.toString();
  logD('Search DynamicLinksType by uri. uri: $uri');

  if (url.contains(_powerPlantDetailPath)) {
    return DynamicLinksType.powerPlantDetail;
  }

  return DynamicLinksType.undefined;
}
