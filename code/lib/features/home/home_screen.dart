import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onGoToCharging;
  const HomeScreen({super.key, this.onGoToCharging});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('概览')));
  }
}