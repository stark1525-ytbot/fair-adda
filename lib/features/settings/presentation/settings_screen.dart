import 'package:flutter/material.dart';
import '../../../core/utils/icons.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors based on the screenshot
    const Color darkRed = Color(0xFF6B1113);
    const Color lightRed = Color(0xFF911A1D);

    return Scaffold(
      backgroundColor: darkRed,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(AppIcons.arrowBack, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.notification, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon')),
              );
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Wavy background shape
          Positioned.fill(
            child: CustomPaint(
              painter: BackgroundPainter(lightRed),
            ),
          ),

          // Menu List
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ListView(
                children: [
                  _buildSettingItem(context, 'Terms and Conditions'),
                  _buildSettingItem(context, 'Legality'),
                  _buildSettingItem(context, 'Privacy Policy'),
                  _buildSettingItem(context, 'Cancellation Policy'),
                  _buildSettingItem(context, 'Contact Us'),
                  _buildSettingItem(context, 'About Us'),
                  _buildSettingItem(context, 'Notification'),
                  _buildSettingItem(context, 'Logout'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to build the setting rows
  Widget _buildSettingItem(BuildContext context, String title) {
    String pagePath;
    switch (title) {
      case 'Terms and Conditions':
        pagePath = 'terms-and-conditions';
        break;
      case 'Legality':
        pagePath = 'legality';
        break;
      case 'Privacy Policy':
        pagePath = 'privacy-policy';
        break;
      case 'Cancellation Policy':
        pagePath = 'cancellation-policy';
        break;
      case 'Contact Us':
        pagePath = 'contact-us';
        break;
      case 'About Us':
        pagePath = 'about-us';
        break;
      case 'Notification':
        pagePath = 'notification';
        break;
      default:
        pagePath = 'settings';
    }

    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.white,
        size: 28,
      ),
      onTap: () {
        // Handle navigation based on the setting item
        if (title == 'Logout') {
          FirebaseAuth.instance.signOut();
          context.go('/login');
          return;
        }
        context.push('/settings/$pagePath');
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    );
  }
}

// Custom Painter to draw the curved "blob" shape on the left
class BackgroundPainter extends CustomPainter {
  final Color shapeColor;
  BackgroundPainter(this.shapeColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = shapeColor
      ..style = PaintingStyle.fill;

    final path = Path();

    // Starting point
    path.moveTo(0, 0);
    // Draw a wavy path down the screen
    path.lineTo(size.width * 0.4, 0);

    path.quadraticBezierTo(
      size.width * 0.7, size.height * 0.3, // Control point
      size.width * 0.2, size.height * 0.5, // Destination
    );

    path.quadraticBezierTo(
      size.width * -0.1, size.height * 0.7, // Control point
      size.width * 0.3, size.height, // Destination
    );

    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
