import 'package:flutter/foundation.dart';
import '../models/lottery_slip.dart';
import '../models/lottery_draw.dart';
 import '../services/lottery_service.dart';

class LotteryViewModel with ChangeNotifier {
  final LotteryService _lotteryService = LotteryService();
  final List<LotterySlip> _slips = [];
  final List<LotteryDraw> _drawHistory = [];
  LotteryDraw? _currentDraw;
  bool _isLoading = false;
  int _quickPickCount = 1;

  List<LotterySlip> get slips => List.unmodifiable(_slips);
  List<LotteryDraw> get drawHistory => List.unmodifiable(_drawHistory);
  LotteryDraw? get currentDraw => _currentDraw;
  bool get isLoading => _isLoading;
  int get quickPickCount => _quickPickCount;
  
  LotteryStats get stats => _lotteryService.calculateStats(_slips, _drawHistory);
  
  double get totalCost => _slips.length * 2.0;

  // Add a new slip
  void addSlip(List<int> numbers, {String type = 'manual', bool isQuickPick = false}) {
    if (!_lotteryService.validateNumbers(numbers)) {
      throw Exception('Invalid numbers provided. Numbers must be unique and between 1-49.');
    }

    final slip = LotterySlip(
      id: DateTime.now().millisecondsSinceEpoch,
      numbers: numbers..sort(),
      createdAt: DateTime.now(),
      type: type,
      isQuickPick: isQuickPick,
    );
    
    _slips.add(slip);
    notifyListeners();
  }

  // Generate a random slip
  void addRandomSlip() {
    final numbers = _lotteryService.generateRandomNumbers();
    addSlip(numbers, type: 'random');
  }

  // Add multiple quick pick slips
  void addQuickPicks(int count) {
    final quickPicks = _lotteryService.generateQuickPicks(count);
    for (final numbers in quickPicks) {
      addSlip(numbers, type: 'quickpick', isQuickPick: true);
    }
  }

  // Update quick pick count
  void updateQuickPickCount(int count) {
    _quickPickCount = count.clamp(1, 10);
    notifyListeners();
  }

  // Remove a slip
  void removeSlip(int id) {
    _slips.removeWhere((slip) => slip.id == id);
    notifyListeners();
  }

  // Clear all slips
  void clearSlips() {
    _slips.clear();
    notifyListeners();
  }

  // Perform the draw
  Future<void> performDraw() async {
    if (_slips.isEmpty) {
      throw Exception('No slips to draw. Please add at least one slip.');
    }

    _isLoading = true;
    notifyListeners();

    // Simulate some processing time
    await Future.delayed(const Duration(seconds: 2));

    final draw = _lotteryService.performDraw(_slips);
    _currentDraw = draw;
    _drawHistory.add(draw);
    
    _isLoading = false;
    notifyListeners();
  }

  // Clear current draw
  void clearDraw() {
    _currentDraw = null;
    notifyListeners();
  }

  // Check if numbers are already in slips (for duplicate checking)
  bool hasDuplicateNumbers(List<int> numbers) {
    final sortedNumbers = numbers.toList()..sort();
    return _slips.any((slip) => 
      listEquals(slip.numbers, sortedNumbers)
    );
  }

  // Get most common numbers from all slips
  Map<int, int> getNumberFrequency() {
    final frequency = <int, int>{};
    for (final slip in _slips) {
      for (final number in slip.numbers) {
        frequency[number] = (frequency[number] ?? 0) + 1;
      }
    }
    return frequency;
  }

  // Get slip statistics
  Map<String, int> getSlipStats() {
    final stats = <String, int>{
      'manual': 0,
      'random': 0,
      'quickpick': 0,
    };
    
    for (final slip in _slips) {
      stats[slip.type] = (stats[slip.type] ?? 0) + 1;
    }
    
    return stats;
  }
}