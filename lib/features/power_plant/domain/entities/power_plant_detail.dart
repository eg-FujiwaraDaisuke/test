import 'package:equatable/equatable.dart';

/// 顔の見える発電所情報（詳細）
class PowerPlantDetail extends Equatable {
  const PowerPlantDetail({
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
    this.projectName,
    this.url,
    this.ownerMessage,
    this.aboutPlant,
    this.prospect,
    this.twitter,
    this.facebook,
    required this.plantImage1,
    this.plantImage2,
    this.plantImage3,
    this.plantImage4,
    this.limitedIntroducerId,
    this.giftName,
    this.giftDescription,
    this.giftImage,
    this.shortCatchphrase,
    this.catchphrase,
    this.thankYouMessage,
    this.thankYouImage,
  });

  /// MP番号
  final String plantId;

  /// 電力会社エリアコード
  /// "01" 〜 "10"
  final String areaCode;

  /// 発電署名
  final String? name;

  /// 表示用設備所在地
  /// 都道府県＋市区町村
  /// 番地は除く
  final String? viewAddress;

  /// 電圧区分
  /// """1"" 〜 ""3""
  /// (1:低圧/2:高圧/3:特高)"
  final String voltageType;

  /// 発電方法
  /// """1"" 〜 ""5""
  /// (1: 太陽光/2: 風力/3: 地熱/4: 水力/5 : バイオマス)"
  final String? powerGenerationMethod;

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

  /// プロジェクト名
  final String? projectName;

  /// 公式URL
  final String? url;

  /// OWNERの思い
  final String? ownerMessage;

  /// 説明
  final String? aboutPlant;

  /// 展望
  final String? prospect;

  /// Twitterアカウント
  final String? twitter;

  /// Facebookアカウント
  final String? facebook;

  /// 発電所写真1
  /// S3のURL
  final String plantImage1;

  /// 発電所写真2
  /// S3のURL
  final String? plantImage2;

  /// 発電所写真3
  /// S3のURL
  final String? plantImage3;

  /// 発電所写真4
  /// S3のURL
  final String? plantImage4;

  /// 紹介元指定
  /// ARTIST or 空文字('')
  final String? limitedIntroducerId;

  /// 特典名
  final String? giftName;

  /// 特典説明
  final String? giftDescription;

  /// 特典写真
  /// S3のURL
  final String? giftImage;

  /// 短いキャッチフレーズ
  final String? shortCatchphrase;

  /// キャッチコピー
  final String? catchphrase;

  /// 応援のお礼メッセージ
  final String? thankYouMessage;

  /// 応援のお礼イメージ
  final String? thankYouImage;

  Map<String, dynamic> toJson() {
    return {
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
      'startDate': startDate,
      'endDate': endDate,
      'projectName': projectName,
      'url': url,
      'ownerMessage': ownerMessage,
      'aboutPlant': aboutPlant,
      'prospect': prospect,
      'twitter': twitter,
      'facebook': facebook,
      'plantImage1': plantImage1,
      'plantImage2': plantImage2,
      'plantImage3': plantImage3,
      'plantImage4': plantImage4,
      'limitedIntroducerId': limitedIntroducerId,
      'giftName': giftName,
      'giftDescription': giftDescription,
      'giftImage': giftImage,
      'shortCatchphrase': shortCatchphrase,
      'catchphrase': catchphrase,
      'thankYouMessage': thankYouMessage,
      'thankYouImage': thankYouImage,
    };
  }

  @override
  List<Object> get props => [
        plantId,
      ];
}
