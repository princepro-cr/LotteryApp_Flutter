import 'dart:math';
import '../models/app_settings.dart';

class QuickPickService {
  final Random _random = Random();

  List<int> generateQuickPick() {
    final numbers = <int>[];
    final pool = List.generate(AppSettings.numberRangeMax, (i) => i + 1);

    while (numbers.length < AppSettings.maxNumbersPerTicket) {
      final index = _random.nextInt(pool.length);
      numbers.add(pool.removeAt(index));
    }

    numbers.sort();
    return numbers;
  }
}