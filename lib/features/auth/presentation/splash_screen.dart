import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/branding/colors.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  _navigate() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    if (mounted) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        context.push('/login');
      } else {
        context.push('/user');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Placeholder
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: AppColors.fairRed,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.fairRed.withOpacity(0.5), blurRadius: 20)
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.asset(
                  'logo.jpg',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "FAIR ADDA",
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppColors.fairRed,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Play With Integrity",
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 16,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
