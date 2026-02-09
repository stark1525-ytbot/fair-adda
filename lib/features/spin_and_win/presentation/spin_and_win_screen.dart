import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SpinAndWinScreen extends StatefulWidget {
  const SpinAndWinScreen({super.key});

  @override
  State<SpinAndWinScreen> createState() => _SpinAndWinScreenState();
}

class _SpinAndWinScreenState extends State<SpinAndWinScreen> {
  final _random = Random();
  final List<String> _rewards = [
    'Rs 5',
    'Rs 10',
    'Rs 20',
    'Rs 50',
    'Better luck next time',
    'Bonus Coins',
  ];
  String? _lastReward;
  bool _spinning = false;

  void _spin() async {
    setState(() => _spinning = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    final reward = _rewards[_random.nextInt(_rewards.length)];
    setState(() {
      _lastReward = reward;
      _spinning = false;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You got: $reward')),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFC62828);
    const Color darkBackground = Color(0xFF121212);

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: primaryRed,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Spin & Win', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black, size: 28),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon')),
              );
            },
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Spin the wheel to win rewards',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 30),
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 2),
                ),
                child: Center(
                  child: Text(
                    _lastReward ?? 'SPIN',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _spinning ? null : _spin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(_spinning ? 'Spinning...' : 'SPIN NOW'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
