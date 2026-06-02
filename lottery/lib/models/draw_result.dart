import 'package:equatable/equatable.dart';

class DrawResult extends Equatable {
  final List<int> numbers;
  final DateTime drawDate;
  final int jackpotAmount;

  const DrawResult({
    required this.numbers,
    required this.drawDate,
    this.jackpotAmount = 4200000,
  });

  DrawResult copyWith({
    List<int>? numbers,
    DateTime? drawDate,
    int? jackpotAmount,
  }) {
    return DrawResult(
      numbers: numbers ?? this.numbers,
      drawDate: drawDate ?? this.drawDate,
      jackpotAmount: jackpotAmount ?? this.jackpotAmount,
    );
  }

  Map<String, dynamic> toJson() => {
    'numbers': numbers,
    'drawDate': drawDate.toIso8601String(),
    'jackpotAmount': jackpotAmount,
  };

  factory DrawResult.fromJson(Map<String, dynamic> json) => DrawResult(
    numbers: List<int>.from(json['numbers']),
    drawDate: DateTime.parse(json['drawDate']),
    jackpotAmount: json['jackpotAmount'] ?? 4200000,
  );

  @override
  List<Object?> get props => [numbers, drawDate, jackpotAmount];
}