import 'package:equatable/equatable.dart';

class BetSlip extends Equatable {
  final List<int> numbers;
  final DateTime datePlaced;
  final List<int>? drawnNumbers;
  final int matches;
  final bool isWin;

  const BetSlip({
    required this.numbers,
    required this.datePlaced,
    this.drawnNumbers,
    this.matches = 0,
    this.isWin = false,
  });

  BetSlip copyWith({
    List<int>? numbers,
    DateTime? datePlaced,
    List<int>? drawnNumbers,
    int? matches,
    bool? isWin,
  }) {
    return BetSlip(
      numbers: numbers ?? this.numbers,
      datePlaced: datePlaced ?? this.datePlaced,
      drawnNumbers: drawnNumbers ?? this.drawnNumbers,
      matches: matches ?? this.matches,
      isWin: isWin ?? this.isWin,
    );
  }

  Map<String, dynamic> toJson() => {
    'numbers': numbers,
    'datePlaced': datePlaced.toIso8601String(),
    'drawnNumbers': drawnNumbers,
    'matches': matches,
    'isWin': isWin,
  };

  factory BetSlip.fromJson(Map<String, dynamic> json) => BetSlip(
    numbers: List<int>.from(json['numbers']),
    datePlaced: DateTime.parse(json['datePlaced']),
    drawnNumbers: json['drawnNumbers'] != null 
        ? List<int>.from(json['drawnNumbers']) 
        : null,
    matches: json['matches'] ?? 0,
    isWin: json['isWin'] ?? false,
  );

  @override
  List<Object?> get props => [numbers, datePlaced, drawnNumbers, matches, isWin];
}