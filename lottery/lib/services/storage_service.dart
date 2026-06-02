import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bet_slip.dart';
import '../models/draw_result.dart';

class StorageService {
  final SharedPreferences _prefs;
  static const String _betsKey = 'bets';
  static const String _drawsKey = 'draws';

  StorageService(this._prefs);

  Future<void> saveBet(BetSlip bet) async {
    final bets = await getBets();
    bets.insert(0, bet);
    final jsonList = bets.map((b) => jsonEncode(b.toJson())).toList();
    await _prefs.setStringList(_betsKey, jsonList);
  }

  Future<List<BetSlip>> getBets() async {
    final jsonList = _prefs.getStringList(_betsKey) ?? [];
    return jsonList
        .map((jsonStr) {
          try {
            final Map<String, dynamic> map = jsonDecode(jsonStr);
            return BetSlip.fromJson(map);
          } catch (e) {
            return null;
          }
        })
        .whereType<BetSlip>()
        .toList();
  }

  Future<void> updateBet(int index, BetSlip bet) async {
    final bets = await getBets();
    if (index < bets.length) {
      bets[index] = bet;
      final jsonList = bets.map((b) => jsonEncode(b.toJson())).toList();
      await _prefs.setStringList(_betsKey, jsonList);
    }
  }

  Future<void> saveDraw(DrawResult draw) async {
    final draws = await getDraws();
    draws.insert(0, draw);
    final jsonList = draws.map((d) => jsonEncode(d.toJson())).toList();
    await _prefs.setStringList(_drawsKey, jsonList);
  }

  Future<List<DrawResult>> getDraws() async {
    final jsonList = _prefs.getStringList(_drawsKey) ?? [];
    return jsonList
        .map((jsonStr) {
          try {
            final Map<String, dynamic> map = jsonDecode(jsonStr);
            return DrawResult.fromJson(map);
          } catch (e) {
            return null;
          }
        })
        .whereType<DrawResult>()
        .toList();
  }

  Future<void> clearAll() async {
    await _prefs.setStringList(_betsKey, []);
    await _prefs.setStringList(_drawsKey, []);
  }
}