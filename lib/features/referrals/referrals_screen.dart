import 'package:flutter/material.dart';
import '../../core/utils/icons.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class ReferralsScreen extends StatelessWidget {
  const ReferralsScreen({super.key});

  final String referralCode = "lvvxsziv";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Main dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C), // Deep Red
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Refer & Earn',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        actions: [
          IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // 1. Top Banner Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFE53935), Color(0xFFB71C1C)],
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Refer friends &",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      Text("Earn ₹5",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold)),
                      Text("for each referral",
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    ],
                  ),
                ),
                // Coin Graphic Placeholder
                Icon(Icons.monetization_on,
                    size: 80, color: Color(0xFFFFD54F)),
              ],
            ),
          ),

          // 2. Referral Code Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomPaint(
              painter: DottedBorderPainter(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      referralCode,
                      style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 18,
                          letterSpacing: 1.2),
                    ),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: referralCode));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Code Copied!")),
                        );
                      },
                      child: const Icon(Icons.copy, color: Color(0xFFB71C1C)),
                    )
                  ],
                ),
              ),
            ),
          ),

          // 3. Share Buttons Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF9CCC65), // WhatsApp Green
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    icon: const Icon(Icons.message,
                        size: 20, color: Colors.white),
                    label: const Text("Invite via whatsapp",
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF6C00), // Orange
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    icon:
                        const Icon(Icons.share, size: 18, color: Colors.white),
                    label: const Text("Other sharing options",
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          const Divider(color: Colors.white10),

          // 4. Friends Joined Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Friends joined",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                TextButton(
                  onPressed: () {},
                  child: const Text("View all",
                      style: TextStyle(
                          color: Colors.red,
                          decoration: TextDecoration.underline)),
                ),
              ],
            ),
          ),

          // 5. Empty State
          const Expanded(
            child: Center(
              child: Text(
                "no data available",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter to create the Red Dotted Border around the referral code
class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5, dashSpace = 3, startX = 0;
    final paint = Paint()
      ..color = const Color(0xFFB71C1C)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(30),
    );

    Path path = Path()..addRRect(rrect);
    Path dashPath = Path();

    for (ui.PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0;
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
