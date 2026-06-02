import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/storage_service.dart';
import '../models/bet_slip.dart';

class HistoryViewModel extends ChangeNotifier {
  late final StorageService _storageService;

  List<BetSlip> _bets = [];
  bool _isLoading = false;

  List<BetSlip> get bets => _bets;
  bool get isLoading => _isLoading;
  bool get isEmpty => _bets.isEmpty;

  HistoryViewModel(SharedPreferences prefs) {
    _storageService = StorageService(prefs);
    loadHistory();
  }

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();

    _bets = await _storageService.getBets();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadHistory();
  }

  String formatDate(DateTime date) {
    return '${date.day} ${_getMonthAbbr(date.month)} ${date.year}';
  }

  String _getMonthAbbr(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}