import 'dart:math';
import '../models/lottery_slip.dart';
import '../models/lottery_draw.dart';

class LotteryService {
  static const int minNumber = 1;
  static const int maxNumber = 49;
  static const int numbersPerSlip = 6;
  
  // Prize structure
  static const Map<int, double> prizeAmounts = {
    6: 500000.0, // First prize
    5: 5000.0,   // Second prize
    4: 500.0,    // Third prize
    3: 50.0,     // Fourth prize
  };

  // Generate random numbers for a slip
  List<int> generateRandomNumbers() {
    final random = Random();
    final numbers = <int>{};
    
    while (numbers.length < numbersPerSlip) {
      numbers.add(minNumber + random.nextInt(maxNumber - minNumber + 1));
    }
    
    return numbers.toList()..sort();
  }

  // Generate quick pick numbers (multiple slips at once)
  List<List<int>> generateQuickPicks(int count) {
    return List.generate(count, (_) => generateRandomNumbers());
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
    double totalPrizes = 0;

    for (final slip in slips) {
      final matchedNumbers = _countMatches(slip.numbers, winningNumbers);
      final prizeInfo = _determinePrize(matchedNumbers);
      final prizeAmount = prizeInfo['amount'] as double;
      final prizeName = prizeInfo['name'] as String;
      final isWinner = prizeAmount > 0;
      
      if (isWinner) {
        totalPrizes += prizeAmount;
      }
      
      results.add(LotteryResult(
        slip: slip,
        matchedNumbers: matchedNumbers,
        prize: prizeName,
        prizeAmount: prizeAmount,
        isWinner: isWinner,
      ));
    }

    return LotteryDraw(
      winningNumbers: winningNumbers,
      results: results,
      drawnAt: DateTime.now(),
      drawId: DateTime.now().millisecondsSinceEpoch.toString(),
      totalPrizes: totalPrizes,
    );
  }

  int _countMatches(List<int> slipNumbers, List<int> winningNumbers) {
    return slipNumbers.where((number) => winningNumbers.contains(number)).length;
  }

  Map<String, dynamic> _determinePrize(int matchedNumbers) {
    final amount = prizeAmounts[matchedNumbers] ?? 0.0;
    String name;
    
    switch (matchedNumbers) {
      case 6:
        name = 'Jackpot!';
        break;
      case 5:
        name = 'Second Prize';
        break;
      case 4:
        name = 'Third Prize';
        break;
      case 3:
        name = 'Fourth Prize';
        break;
      default:
        name = 'No Prize';
    }
    
    return {'name': name, 'amount': amount};
  }

  // Calculate statistics
  LotteryStats calculateStats(List<LotterySlip> slips, List<LotteryDraw> draws) {
    double totalSpent = slips.length * 12; // $2 per slip
    double totalWon = 0;
    int bestMatch = 0;
    
    for (final draw in draws) {
      totalWon += draw.totalPrizes;
      for (final result in draw.results) {
        if (result.matchedNumbers > bestMatch) {
          bestMatch = result.matchedNumbers;
        }
      }
    }
    
    return LotteryStats(
      totalSlips: slips.length,
      totalDraws: draws.length,
      totalSpent: totalSpent,
      totalWon: totalWon,
      bestMatch: bestMatch,
    );
  }
}