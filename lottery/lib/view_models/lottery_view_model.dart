import 'package:flutter/foundation.dart';
import '../models/lottery_slip.dart';
import '../models/lottery_draw.dart';
import '../services/lottery_service.dart';

class LotteryViewModel with ChangeNotifier {
  final LotteryService _lotteryService = LotteryService();
  final List<LotterySlip> _slips = [];
  LotteryDraw? _currentDraw;
  bool _isLoading = false;

  List<LotterySlip> get slips => List.unmodifiable(_slips);
  LotteryDraw? get currentDraw => _currentDraw;
  bool get isLoading => _isLoading;

  // Add a new slip
  void addSlip(List<int> numbers) {
    if (!_lotteryService.validateNumbers(numbers)) {
      throw Exception('Invalid numbers provided. Numbers must be unique and between 1-49.');
    }

    final slip = LotterySlip(
      id: DateTime.now().millisecondsSinceEpoch,
      numbers: numbers..sort(),
      createdAt: DateTime.now(),
    );
    
    _slips.add(slip);
    notifyListeners();
  }

  // Generate a random slip
  void addRandomSlip() {
    final numbers = _lotteryService.generateRandomNumbers();
    addSlip(numbers);
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

    _currentDraw = _lotteryService.performDraw(_slips);
    _isLoading = false;
    notifyListeners();
  }

  // Clear current draw
  void clearDraw() {
    _currentDraw = null;
    notifyListeners();
  }
}