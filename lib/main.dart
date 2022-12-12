import 'package:flutter/material.dart';
import 'package:outfit_tracker/screens/components/bottom_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Outfit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BottomBar(),
    );
  }
}
