import '../models/bet_slip.dart';
import '../models/draw_result.dart';

class StatsService {
  List<int> calculateHotNumbers(List<DrawResult> draws) {
    final frequency = <int, int>{};

    for (final draw in draws) {
      for (final number in draw.numbers) {
        frequency[number] = (frequency[number] ?? 0) + 1;
      }
    }

    final entries = frequency.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(10).map((e) => e.key).toList();
  }

  Map<String, dynamic> getUserStats(List<BetSlip> bets) {
    final played = bets.where((b) => b.drawnNumbers != null).length;
    final wins = bets.where((b) => b.isWin).length;
    final bestMatch = bets.fold(0, (max, b) => b.matches > max ? b.matches : max);
    final winRate = played > 0 ? (wins / played * 100).round() : 0;

    return {
      'drawsPlayed': played,
      'wins': wins,
      'bestMatch': bestMatch,
      'winRate': winRate,
    };
  }

  Map<int, int> getNumberFrequency(List<BetSlip> bets) {
    final frequency = <int, int>{};
    for (final bet in bets) {
      for (final number in bet.numbers) {
        frequency[number] = (frequency[number] ?? 0) + 1;
      }
    }
    return frequency;
  }

  Map<int, int> getDrawNumberFrequency(List<DrawResult> draws) {
    final frequency = <int, int>{};
    for (final draw in draws) {
      for (final number in draw.numbers) {
        frequency[number] = (frequency[number] ?? 0) + 1;
      }
    }
    return frequency;
  }
}