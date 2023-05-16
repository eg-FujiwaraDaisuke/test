import 'package:equatable/equatable.dart';

/// 特典
class PowerPlantGift extends Equatable {
  const PowerPlantGift({
    required this.giftTypeId,
    required this.giftTypeName,
  });

  factory PowerPlantGift.fromJson(Map<String, dynamic> gift) {
    return PowerPlantGift(
      giftTypeId: gift['giftTypeId'],
      giftTypeName: gift['giftTypeName'],
    );
  }

  /// 特定id
  final int giftTypeId;

  /// 特典名
  final String giftTypeName;

  Map<String, dynamic> toJson() {
    return {
      'giftTypeId': giftTypeId,
      'giftTypeName': giftTypeName,
    };
  }

  @override
  List<Object> get props => [giftTypeId];
}
