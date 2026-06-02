import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/storage_service.dart';
import '../services/quick_pick_service.dart';
import '../models/bet_slip.dart';
import '../models/app_settings.dart';

class PickViewModel extends ChangeNotifier {
  late final StorageService _storageService;
  final QuickPickService _quickPickService = QuickPickService();

  List<int> _selectedNumbers = [];
  List<int> _hotNumbers = AppSettings.defaultHotNumbers;
  bool _isLoading = false;

  List<int> get selectedNumbers => _selectedNumbers;
  List<int> get hotNumbers => _hotNumbers;
  bool get isLoading => _isLoading;
  bool get canPlaceBet => _selectedNumbers.length == AppSettings.maxNumbersPerTicket;

  PickViewModel(SharedPreferences prefs) {
    _storageService = StorageService(prefs);
  }

  void toggleNumber(int number) {
    if (_selectedNumbers.contains(number)) {
      _selectedNumbers.remove(number);
    } else if (_selectedNumbers.length < AppSettings.maxNumbersPerTicket) {
      _selectedNumbers.add(number);
      _selectedNumbers.sort();
    }
    notifyListeners();
  }

  void quickPick() {
    _selectedNumbers = _quickPickService.generateQuickPick();
    notifyListeners();
  }

  void clearSlip() {
    _selectedNumbers.clear();
    notifyListeners();
  }

  Future<bool> placeBet() async {
    if (!canPlaceBet) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final bet = BetSlip(
        numbers: List.from(_selectedNumbers),
        datePlaced: DateTime.now(),
      );
      await _storageService.saveBet(bet);
      clearSlip();
      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}