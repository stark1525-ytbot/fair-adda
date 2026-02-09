import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../../core/utils/icons.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Top Background Decoration Section
            SizedBox(
              height: 220,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Decorative Cards at the top (Representing the tilted banners)
                  Positioned(
                    top: -40,
                    left: -20,
                    child: Transform.rotate(
                      angle: -0.1,
                      child: _buildTopBannerCard(
                          "Erangel", "₹450", Colors.red.shade900),
                    ),
                  ),
                  Positioned(
                    top: -30,
                    right: -30,
                    child: Transform.rotate(
                      angle: 0.1,
                      child: _buildTopBannerCard(
                          "Bermuda", "₹452", Colors.red.shade800),
                    ),
                  ),

                  // 2. Main Logo with Red Glow Effect
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.5),
                            blurRadius: 50,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: Image.asset(
                        'assets/logo.jpg', // Actual logo from assets folder
                        height: 180,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 180,
                          height: 180,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: const Icon(Icons.gamepad,
                              size: 80, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 3. Input Form Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Mobile Number Field
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        if (value.length != 10) {
                          return 'Please enter a valid 10-digit mobile number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Mobile Number",
                        prefixIcon: const Icon(Icons.phone_outlined,
                            color: Colors.white70),
                        filled: true,
                        fillColor: const Color(0xFF1A1A1A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // SEND OTP Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A1A), // Dark Grey
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _isLoading ? null : _sendOtp,
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white70,
                              ),
                            )
                          : const Text(
                              "SEND OTP",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Social Login Text
                  const Center(
                    child: Text(
                      "or Login via",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4. Social Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialIcon(
                          'https://cdn-icons-png.flaticon.com/512/2991/2991148.png'), // Google
                      const SizedBox(width: 30),
                      _socialIcon(
                          'https://cdn-icons-png.flaticon.com/512/5968/5968951.png'), // Truecaller
                    ],
                  ),

                  const SizedBox(height: 30),

                  // New User Link
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "New User? ",
                        style: const TextStyle(color: Colors.white70),
                        children: [
                          TextSpan(
                            text: "Create an Account",
                            style: const TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Navigate to signup screen
                                GoRouter.of(context).push('/signup');
                              },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 5. Need Support Button
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.headset_mic_outlined,
                              size: 20, color: Colors.white),
                          SizedBox(width: 10),
                          Text("Need Support",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 6. Mandatory Warning Footer
                  const Center(
                    child: Text(
                      "ONLINE GAMING IS ADDICTIVE IN NATURE",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendOtp() {
    if (_formKey.currentState!.validate()) {
      final phone = _phoneController.text.trim();
      final formatted = phone.startsWith('+') ? phone : '+91$phone';
      setState(() {
        _isLoading = true;
      });
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: formatted,
        verificationCompleted: (credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (!mounted) return;
          context.push('/user');
        },
        verificationFailed: (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.message ?? 'Verification failed'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        codeSent: (verificationId, resendToken) {
          if (!mounted) return;
          GoRouter.of(context).push('/otp', extra: {
            'phoneNumber': formatted,
            'verificationId': verificationId,
          });
        },
        codeAutoRetrievalTimeout: (_) {},
      ).whenComplete(() {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  // Helper widget for top decorative cards
  Widget _buildTopBannerCard(String title, String price, Color color) {
    return Container(
      width: 180,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: Column(
        children: [
          Container(
            color: Colors.grey.shade200,
            width: double.infinity,
            padding: const EdgeInsets.all(4),
            child: Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black, fontSize: 10)),
          ),
          const Spacer(),
          Text("Win: $price",
              style: const TextStyle(
                  color: Colors.green, fontWeight: FontWeight.bold)),
          Container(
            width: double.infinity,
            color: Colors.red,
            child: const Text("Play Now",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 10)),
          )
        ],
      ),
    );
  }

  // Helper for social icons
  Widget _socialIcon(String url) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Image.network(url, height: 25, width: 25),
    );
  }
}
