import 'package:equatable/equatable.dart';
import 'package:minden/features/power_plant/data/model/power_plant_participant_user_model.dart';

/// 顔の見える発電所情報
class PowerPlant extends Equatable {
  const PowerPlant({
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
    this.userList = const [],
    this.giftName,
    this.giftDescription,
    this.giftImage,
  });

  factory PowerPlant.fromJson(Map<String, dynamic> json) {
    final Iterable iterable = json['userList'] ?? [];

    return PowerPlant(
      plantId: json['plantId'],
      areaCode: json['areaCode'],
      name: json['name'],
      viewAddress: json['viewAddress'],
      voltageType: json['voltageType'],
      powerGenerationMethod: json['powerGenerationMethod'],
      renewableType: json['renewableType'],
      generationCapacity: json['generationCapacity'],
      displayOrder: json['displayOrder'],
      isRecommend: json['isRecommend'],
      ownerName: json['ownerName'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      plantImage1: json['plantImage1'],
      supportGiftName: json['supportGiftName'],
      shortCatchphrase: json['shortCatchphrase'],
      catchphrase: json['catchphrase'],
      thankYouMessage: json['thankYouMessage'],
      userList: List<PowerPlantParticipantUserModel>.from(iterable
          .map((model) => PowerPlantParticipantUserModel.fromJson(model))),
      giftName: json['giftName'],
      giftDescription: json['giftDescription'],
      giftImage: json['giftImage'],
    );
  }

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

  ///　応援ユーザー
  final List<PowerPlantParticipantUserModel> userList;

  /// ギフト名
  final String? giftName;

  /// ギフト詳細
  final String? giftDescription;

  /// ギフト写真
  final String? giftImage;

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
      'startDate': startDate.toString(),
      'endDate': endDate.toString(),
      'plantImage1': plantImage1,
      'supportGiftName': supportGiftName,
      'shortCatchphrase': shortCatchphrase,
      'catchphrase': catchphrase,
      'thankYouMessage': thankYouMessage,
      'userList': userList.map((user) => user.toJson()).toList(),
      'giftName': giftName,
      'giftDescription': giftDescription,
      'giftImage': giftImage,
    };
  }

  @override
  List<Object> get props => [
        plantId,
      ];

  /// 条件に従ってを並び替えた応援ユーザーのリスト
  List<PowerPlantParticipantUserModel> get orderedUserList {
    return List.of(userList)
      ..sort((a, b) {
        // 名前、アイコンありユーザーを優先する
        if (a.hasIconAndName && !b.hasIconAndName) {
          return -1;
        }
        if (!a.hasIconAndName && b.hasIconAndName) {
          return 1;
        }

        return userList.indexOf(a).compareTo(userList.indexOf(b));
      });
  }
}
