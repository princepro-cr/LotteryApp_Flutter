 import 'package:lucky_dip/models/lottery_slip.dart';

class LotteryDraw {
  final List<int> winningNumbers;
  final List<LotteryResult> results;
  final DateTime drawnAt;

  LotteryDraw({
    required this.winningNumbers,
    required this.results,
    required this.drawnAt,
  });
}

class LotteryResult {
  final LotterySlip slip;
  final int matchedNumbers;
  final String prize;

  LotteryResult({
    required this.slip,
    required this.matchedNumbers,
    required this.prize,
  });
}