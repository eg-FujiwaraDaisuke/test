import 'package:equatable/equatable.dart';

class Support extends Equatable {
  const Support({
    required this.plantId,
    required this.status,
    required this.yearMonth,
    required this.fromApp,
  });

  factory Support.fromJson(Map<String, dynamic> support) {
    return Support(
      plantId: support['plantId'],
      status: support['status'],
      yearMonth: support['yearMonth'],
      fromApp: support['fromApp'],
    );
  }

  final String plantId;
  final int status;
  final String yearMonth;
  final bool fromApp;

  Map<String, dynamic> toJson() {
    return {
      'plantId': plantId,
      'status': status,
      'yearMonth': yearMonth,
      'fromApp': fromApp,
    };
  }

  @override
  List<Object> get props => [plantId];
}
