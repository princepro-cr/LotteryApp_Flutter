import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/storage_service.dart';
import '../services/stats_service.dart';
import '../models/bet_slip.dart';
import '../models/draw_result.dart';

class StatsViewModel extends ChangeNotifier {
  late final StorageService _storageService;
  final StatsService _statsService = StatsService();

  List<BetSlip> _bets = [];
  List<DrawResult> _draws = [];
  Map<String, dynamic> _userStats = {};
  List<int> _hotNumbers = [];
  bool _isLoading = false;

  List<BetSlip> get bets => _bets;
  List<DrawResult> get draws => _draws;
  Map<String, dynamic> get userStats => _userStats;
  List<int> get hotNumbers => _hotNumbers;
  bool get isLoading => _isLoading;

  StatsViewModel(SharedPreferences prefs) {
    _storageService = StorageService(prefs);
    loadStats();
  }

  Future<void> loadStats() async {
    _isLoading = true;
    notifyListeners();

    _bets = await _storageService.getBets();
    _draws = await _storageService.getDraws();

    _userStats = _statsService.getUserStats(_bets);
    _hotNumbers = _statsService.calculateHotNumbers(_draws);

    _isLoading = false;
    notifyListeners();
  }

  Map<int, int> getHotNumberFrequency() {
    return _statsService.getDrawNumberFrequency(_draws);
  }

  Map<int, int> getFavoriteNumberFrequency() {
    return _statsService.getNumberFrequency(_bets);
  }

  int getWinRate() {
    final played = _userStats['drawsPlayed'] ?? 0;
    final wins = _userStats['wins'] ?? 0;
    return played > 0 ? (wins / played * 100).round() : 0;
  }

  List<MapEntry<int, int>> getTopHotNumbers({int limit = 10}) {
    final frequency = getHotNumberFrequency();
    final entries = frequency.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(limit).toList();
  }

  List<MapEntry<int, int>> getTopFavoriteNumbers({int limit = 10}) {
    final frequency = getFavoriteNumberFrequency();
    final entries = frequency.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(limit).toList();
  }
}