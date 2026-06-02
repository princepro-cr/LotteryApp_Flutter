import 'dart:math';
import '../models/draw_result.dart';
import '../models/app_settings.dart';

class DrawService {
  final Random _random = Random();

  DrawResult generateDraw() {
    final numbers = <int>[];
    final pool = List.generate(AppSettings.numberRangeMax, (i) => i + 1);

    while (numbers.length < AppSettings.maxNumbersPerTicket) {
      final index = _random.nextInt(pool.length);
      numbers.add(pool.removeAt(index));
    }

    numbers.sort();
    return DrawResult(
      numbers: numbers,
      drawDate: DateTime.now(),
    );
  }

  int calculateMatches(List<int> userNumbers, List<int> drawNumbers) {
    return userNumbers.where((n) => drawNumbers.contains(n)).length;
  }

  bool isWin(int matches) {
    return matches >= AppSettings.winThreshold;
  }

  String getWinMessage(int matches) {
    if (matches >= 6) return 'JACKPOT WINNER! 🏆';
    if (matches >= 5) return 'Amazing! 5 matches! 🎉';
    if (matches >= 4) return 'Great! 4 matches! ✨';
    if (matches >= 3) return 'Nice! 3 matches! 🍀';
    return 'Better luck next time!';
  }
}