class LotterySlip {
  final int id;
  final List<int> numbers;
  final DateTime createdAt;
  final String type; // 'manual' or 'random'
  final bool isQuickPick;

  LotterySlip({
    required this.id,
    required this.numbers,
    required this.createdAt,
    this.type = 'manual',
    this.isQuickPick = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numbers': numbers,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'type': type,
      'isQuickPick': isQuickPick,
    };
  }

  factory LotterySlip.fromMap(Map<String, dynamic> map) {
    return LotterySlip(
      id: map['id'],
      numbers: List<int>.from(map['numbers']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      type: map['type'] ?? 'manual',
      isQuickPick: map['isQuickPick'] ?? false,
    );
  }

  String get formattedNumbers {
    return numbers.map((n) => n.toString().padLeft(2, '0')).join(' - ');
  }
  
  double get cost => 12; // Each slip costs $2
}