import 'package:equatable/equatable.dart';

class SupportHistory extends Equatable {
  const SupportHistory({
    required this.page,
    required this.total,
    required this.historyType,
    required this.powerPlants,
  });

  final String page;
  final String total;
  final String historyType;
  final List<SupportHistoryPowerPlant> powerPlants;

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'total': total,
      'historyType': historyType,
      'powerPlants': powerPlants.map((e) => e.toJson()).toList()
    };
  }

  @override
  List<Object> get props => [];
}

class SupportHistoryPowerPlant extends Equatable {
  const SupportHistoryPowerPlant({
    required this.yearMonth,
    required this.fromApp,
    required this.plantId,
    required this.areaCode,
    required this.name,
    required this.viewAddress,
    required this.voltageType,
    required this.powerGenerationMethod,
    required this.renewableType,
    required this.generationCapacity,
    required this.displayOrder,
    required this.isRecommend,
    required this.ownerName,
    required this.startDate,
    required this.endDate,
    required this.plantImage1,
    this.supportGiftName,
    this.shortCatchphrase,
    this.catchphrase,
    this.thankYouMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      'yearMonth': yearMonth,
      'fromApp': fromApp,
      'plantId': plantId,
      'areaCode': areaCode,
      'name': name,
      'viewAddress': viewAddress,
      'voltageType': voltageType,
      'powerGenerationMethod': powerGenerationMethod,
      'renewableType': renewableType,
      'generationCapacity': generationCapacity,
      'displayOrder': displayOrder,
      'isRecommend': isRecommend,
      'ownerName': ownerName,
      'startDate': startDate.toString(),
      'endDate': endDate.toString(),
      'plantImage1': plantImage1,
      'supportGiftName': supportGiftName,
      'shortCatchphrase': shortCatchphrase,
      'catchphrase': catchphrase,
      'thankYouMessage': thankYouMessage,
    };
  }

  final String yearMonth;
  final bool fromApp;

  /// MP番号
  final String plantId;

  /// 電力会社エリアコード
  /// "01" 〜 "10"
  final String areaCode;

  /// 発電署名
  final String name;

  /// 表示用設備所在地
  /// 都道府県＋市区町村
  /// 番地は除く
  final String viewAddress;

  /// 電圧区分
  /// """1"" 〜 ""3""
  /// (1:低圧/2:高圧/3:特高)"
  final String voltageType;

  /// 発電方法
  /// """1"" 〜 ""5""
  /// (1: 太陽光/2: 風力/3: 地熱/4: 水力/5 : バイオマス)"
  final String powerGenerationMethod;

  /// 再エネ種別
  /// "0" 〜 "1"
  /// (0: 非FIT(卒FIT/非FIT/試運転)/1: FIT)
  final String renewableType;

  /// 発電設備容量（kW）
  final double generationCapacity;

  /// 表示順
  /// 発電所の作成日時の順(MP番号の昇順)で
  /// 買取CISで採番
  final int displayOrder;

  /// おすすめ
  final bool isRecommend;

  /// 発電事業者名
  final String ownerName;

  /// 掲載開始日
  /// YYYY-MM-DD 例：2021-06-30
  final DateTime startDate;

  /// 掲載終了日
  /// "YYYY-MM-DD 例：2999-12-31
  /// 設定されていない場合は 2999-12-31 をセット"
  final DateTime endDate;

  /// 発電所写真1
  /// S3のURL
  final String plantImage1;

  /// 特典名
  final String? supportGiftName;

  /// 短いキャッチフレーズ
  final String? shortCatchphrase;

  /// キャッチコピー
  final String? catchphrase;

  /// 応援のお礼メッセージ
  final String? thankYouMessage;

  @override
  List<Object> get props => [];
}
