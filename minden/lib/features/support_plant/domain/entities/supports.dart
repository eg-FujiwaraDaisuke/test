class Support {
  Support({
    required this.plantId,
    required this.status,
    required this.yearMonth,
    required this.fromApp,
  });

  final String plantId;
  final int status;
  final String yearMonth;
  final bool fromApp;
}

final supportDammyData = [
  Support(
    plantId: 'MP2021080808',
    status: 3,
    yearMonth: '202109',
    fromApp: true,
  ),
  Support(
    plantId: 'MP2021080809',
    status: 3,
    yearMonth: '202110',
    fromApp: true,
  )
];
