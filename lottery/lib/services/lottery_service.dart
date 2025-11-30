import 'dart:math';
import '../models/lottery_slip.dart';
import '../models/lottery_draw.dart';

class LotteryService {
  static const int minNumber = 1;
  static const int maxNumber = 49;
  static const int numbersPerSlip = 6;

  // Generate random numbers for a slip
  List<int> generateRandomNumbers() {
    final random = Random();
    final numbers = <int>{};
    
    while (numbers.length < numbersPerSlip) {
      numbers.add(minNumber + random.nextInt(maxNumber - minNumber + 1));
    }
    
    return numbers.toList()..sort();
  }

  // Validate if numbers are within range and unique
  bool validateNumbers(List<int> numbers) {
    if (numbers.length != numbersPerSlip) return false;
    
    final uniqueNumbers = numbers.toSet();
    if (uniqueNumbers.length != numbersPerSlip) return false;
    
    for (final number in numbers) {
      if (number < minNumber || number > maxNumber) return false;
    }
    
    return true;
  }

  // Generate winning numbers
  List<int> generateWinningNumbers() {
    return generateRandomNumbers();
  }

  // Calculate matches and prizes
  LotteryDraw performDraw(List<LotterySlip> slips) {
    final winningNumbers = generateWinningNumbers();
    final results = <LotteryResult>[];

    for (final slip in slips) {
      final matchedNumbers = _countMatches(slip.numbers, winningNumbers);
      final prize = _determinePrize(matchedNumbers);
      
      results.add(LotteryResult(
        slip: slip,
        matchedNumbers: matchedNumbers,
        prize: prize,
      ));
    }

    return LotteryDraw(
      winningNumbers: winningNumbers,
      results: results,
      drawnAt: DateTime.now(),
    );
  }

  int _countMatches(List<int> slipNumbers, List<int> winningNumbers) {
    return slipNumbers.where((number) => winningNumbers.contains(number)).length;
  }

  String _determinePrize(int matchedNumbers) {
    switch (matchedNumbers) {
      case 6:
        return 'First Prize!';
      case 5:
        return 'Second Prize';
      case 4:
        return 'Third Prize';
      case 3:
        return 'Fourth Prize';
      default:
        return 'No Prize';
    }
  }
}