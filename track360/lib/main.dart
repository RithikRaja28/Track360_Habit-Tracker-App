import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:track360/screens/home_screen.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("Habit_Database");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Track360',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

