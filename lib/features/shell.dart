import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'charging/charging_screen.dart';
import 'stats/stats_screen.dart';
import 'vehicle/vehicle_screen.dart';
import 'calculator/calculator_screen.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onGoToCharging: () => setState(() => _index = 1)),
      const ChargingScreen(),
      const StatsScreen(),
      const VehicleScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const CalculatorScreen()),
          );
        },
        child: const Icon(Icons.calculate_outlined),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: '概览'),
          NavigationDestination(icon: Icon(Icons.bolt), label: '记账'),
          NavigationDestination(icon: Icon(Icons.query_stats), label: '统计'),
          NavigationDestination(icon: Icon(Icons.electric_meter), label: '档案'),
        ],
      ),
    );
  }
}
