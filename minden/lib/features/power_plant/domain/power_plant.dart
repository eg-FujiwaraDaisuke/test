import 'package:equatable/equatable.dart';

/// 生産者情報
@Deprecated('UI側で利用するモデル変更されたら削除')
class PowerPlant extends Equatable {
  /// 生産者ID
  final String plantId;

  /// 生産者名称
  final String name;

  /// 発電所イメージ配列
  /// NOTE: 名称にゆらぎがあるが統一しなくてよいか？（生産者・発電所）
  final List<PowerPlantImage> images;

  /// キャッチフレーズ
  final String catchPhrase;

  /// 位置情報
  /// NOTE: issue記載のレスポンス内容準拠
  /// しかし実際は緯度経度と精度を持つモデルを定義されると思われる
  final String location;

  /// 発電容量
  final String capacity;

  /// 発電方法
  /// NOTE: enumで定義などしなくてよいか？
  final String powerGenerationMethods;

  /// 新着フラグ
  final bool isNewArrivals;

  /// 作成日
  final DateTime created;

  /// 変更日
  final DateTime modified;

  PowerPlant(
      {required this.plantId,
      required this.name,
      required this.images,
      required this.catchPhrase,
      required this.location,
      required this.capacity,
      required this.powerGenerationMethods,
      required this.isNewArrivals,
      required this.created,
      required this.modified});

  @override
  List<Object> get props => [
        plantId,
        name,
        images,
        catchPhrase,
        location,
        capacity,
        powerGenerationMethods,
        isNewArrivals,
        created,
        modified,
      ];
}

class PowerPlantImage {
  final String url;

  PowerPlantImage({required this.url});
}
