import 'package:equatable/equatable.dart';

class SupportAction extends Equatable {
  const SupportAction({
    required this.support_action,
  });

  final String support_action;

  Map<String, dynamic> toJson() {
    return {
      'support_action': support_action,
    };
  }

  @override
  List<Object> get props => [];
}
