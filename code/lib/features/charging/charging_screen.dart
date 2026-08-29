import 'package:flutter/material.dart';
import 'charging_form.dart';

class ChargingScreen extends StatelessWidget {
  const ChargingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('记账')),
      body: Center(
        child: FilledButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ChargingForm()),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('记一笔'),
        ),
      ),
    );
  }
}
