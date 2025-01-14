class ShiftModel {
  DateTime openDate;
  DateTime? closeDate;
  String userId, id;
  double openAmount;
  double? closeAmount;

  ShiftModel({
    required this.openDate,
    required this.userId,
    required this.id,
    required this.openAmount,
    this.closeAmount,
    this.closeDate,
  });
}
