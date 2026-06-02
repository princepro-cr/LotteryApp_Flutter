import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'viewmodels/pick_viewmodel.dart';
import 'viewmodels/draw_viewmodel.dart';
import 'viewmodels/history_viewmodel.dart';
import 'viewmodels/stats_viewmodel.dart';
import 'views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PickViewModel(prefs)),
        ChangeNotifierProvider(create: (_) => DrawViewModel(prefs)),
        ChangeNotifierProvider(create: (_) => HistoryViewModel(prefs)),
        ChangeNotifierProvider(create: (_) => StatsViewModel(prefs)),
      ],
      child: MaterialApp(
        title: 'LuckyDraw',
        theme: ThemeData(
          fontFamily: 'Roboto',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0D6B47),
            primary: const Color(0xFF0D6B47),
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}