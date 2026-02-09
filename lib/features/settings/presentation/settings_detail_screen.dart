import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsDetailScreen extends StatelessWidget {
  final String title;
  const SettingsDetailScreen({super.key, required this.title});

  String _formatTitle(String value) {
    final normalized = value.replaceAll('-', ' ').trim();
    if (normalized.isEmpty) return 'Settings';
    return normalized
        .split(' ')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFC62828);
    const Color darkBackground = Color(0xFF121212);
    final titleText = _formatTitle(title);

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: primaryRed,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(titleText, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Text(
          '$titleText content will be added here.',
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
