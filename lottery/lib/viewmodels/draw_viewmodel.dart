import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/storage_service.dart';
import '../services/draw_service.dart';
import '../models/bet_slip.dart';
import '../models/draw_result.dart';
import '../models/app_settings.dart';

class DrawViewModel extends ChangeNotifier {
  late final StorageService _storageService;
  final DrawService _drawService = DrawService();

  List<int> _currentBet = [];
  List<int>? _lastDrawNumbers;
  int _matchCount = 0;
  bool _isWin = false;
  bool _isSpinning = false;
  String? _resultMessage;
  int? _currentDrawIndex;

  List<int> get currentBet => _currentBet;
  List<int>? get lastDrawNumbers => _lastDrawNumbers;
  int get matchCount => _matchCount;
  bool get isWin => _isWin;
  bool get isSpinning => _isSpinning;
  String? get resultMessage => _resultMessage;
  bool get hasBet => _currentBet.length == AppSettings.maxNumbersPerTicket;

  DrawViewModel(SharedPreferences prefs) {
    _storageService = StorageService(prefs);
    _loadLatestBet();
  }

  Future<void> _loadLatestBet() async {
    final bets = await _storageService.getBets();
    if (bets.isNotEmpty && bets.first.drawnNumbers == null) {
      _currentBet = bets.first.numbers;
      _currentDrawIndex = 0;
    } else {
      _currentBet = [];
      _currentDrawIndex = null;
    }
    notifyListeners();
  }

  Future<void> performDraw() async {
    if (!hasBet || _isSpinning) return;

    _isSpinning = true;
    _lastDrawNumbers = null;
    _resultMessage = null;
    notifyListeners();

    // Simulate spinning delay
    await Future.delayed(const Duration(milliseconds: 800));

    final draw = _drawService.generateDraw();
    _lastDrawNumbers = draw.numbers;

    await Future.delayed(const Duration(milliseconds: 400));

    _matchCount = _drawService.calculateMatches(_currentBet, draw.numbers);
    _isWin = _drawService.isWin(_matchCount);
    _resultMessage = _drawService.getWinMessage(_matchCount);

    await _storageService.saveDraw(draw);

    if (_currentDrawIndex != null) {
      final bets = await _storageService.getBets();
      final updatedBet = bets[_currentDrawIndex!].copyWith(
        drawnNumbers: draw.numbers,
        matches: _matchCount,
        isWin: _isWin,
      );
      await _storageService.updateBet(_currentDrawIndex!, updatedBet);
    }

    _isSpinning = false;
    notifyListeners();
  }

  void resetForNewBet() {
    _currentBet = [];
    _lastDrawNumbers = null;
    _matchCount = 0;
    _isWin = false;
    _resultMessage = null;
    _currentDrawIndex = null;
    _loadLatestBet();
  }

  bool isWinnerNumber(int number) {
    return _lastDrawNumbers?.contains(number) ?? false;
  }
}