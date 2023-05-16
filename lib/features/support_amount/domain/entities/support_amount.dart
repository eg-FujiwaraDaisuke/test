import 'package:equatable/equatable.dart';

class SupportAmount extends Equatable {
  const SupportAmount({
    required this.supportAmount,
  });

  final int supportAmount;

  Map<String, dynamic> toJson() {
    return {
      'supportAmount': supportAmount,
    };
  }

  @override
  List<Object> get props => [
        supportAmount,
      ];
}
