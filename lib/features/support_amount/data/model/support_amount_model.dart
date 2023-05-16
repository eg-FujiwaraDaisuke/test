import 'package:minden/features/support_amount/domain/entities/support_amount.dart';

class SupportAmountModel extends SupportAmount {
  const SupportAmountModel({
    required int supportAmount,
  }) : super(
          supportAmount: supportAmount,
        );

  factory SupportAmountModel.fromJson(Map<String, dynamic> json) {
    return SupportAmountModel(
      supportAmount: json['supportAmount'],
    );
  }
}
