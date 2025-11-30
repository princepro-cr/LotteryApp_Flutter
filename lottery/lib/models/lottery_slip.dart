class LotterySlip {
  final int id;
  final List<int> numbers;
  final DateTime createdAt;

  LotterySlip({
    required this.id,
    required this.numbers,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numbers': numbers,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory LotterySlip.fromMap(Map<String, dynamic> map) {
    return LotterySlip(
      id: map['id'],
      numbers: List<int>.from(map['numbers']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}