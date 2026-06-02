import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:LuckyDip/main.dart';
import 'package:LuckyDip/views/home_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LuckyDraw App Tests', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    testWidgets('App loads successfully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MyApp(prefs: prefs),
      );

      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('Home screen is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MyApp(prefs: prefs),
      );

      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}