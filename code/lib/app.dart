import 'package:flutter/material.dart';
import 'features/shell.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoltTrack',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32))),
      home: const Shell(),
    );
  }
}