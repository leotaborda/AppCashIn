class FinanceModel {
  final String id;
  final String month;
  final int monthNumber;
  final double invested;
  final double saved;
  final double personal;

  FinanceModel({
    required this.id,
    required this.month,
    required this.monthNumber,
    required this.invested,
    required this.saved,
    required this.personal,
  });

  factory FinanceModel.fromMap(String id, Map<String, dynamic> data) {
    return FinanceModel(
      id: id,
      month: data['month'] ?? '',
      monthNumber: data['monthNumber'] ?? 1,
      invested: (data['invested'] ?? 0).toDouble(),
      saved: (data['saved'] ?? 0).toDouble(),
      personal: (data['personal'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'monthNumber': monthNumber,
      'invested': invested,
      'saved': saved,
      'personal': personal,
    };
  }
}
