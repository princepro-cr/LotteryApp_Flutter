import 'package:lucky_dip/models/lottery_slip.dart';

class LotteryDraw {
  final List<int> winningNumbers;
  final List<LotteryResult> results;
  final DateTime drawnAt;
  final String drawId;
  final double totalPrizes;

  LotteryDraw({
    required this.winningNumbers,
    required this.results,
    required this.drawnAt,
    required this.drawId,
    required this.totalPrizes,
  });
}

class LotteryResult {
  final LotterySlip slip;
  final int matchedNumbers;
  final String prize;
  final double prizeAmount;
  final bool isWinner;

  LotteryResult({
    required this.slip,
    required this.matchedNumbers,
    required this.prize,
    required this.prizeAmount,
    required this.isWinner,
  });
}

class LotteryStats {
  final int totalSlips;
  final int totalDraws;
  final double totalSpent;
  final double totalWon;
  final int bestMatch;

  LotteryStats({
    required this.totalSlips,
    required this.totalDraws,
    required this.totalSpent,
    required this.totalWon,
    required this.bestMatch,
  });

  double get netProfit => totalWon - totalSpent;
  double get roi => totalSpent > 0 ? (netProfit / totalSpent) * 100 : 0;
}