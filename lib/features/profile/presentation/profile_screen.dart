import 'package:flutter/material.dart';
import '../../../core/utils/icons.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/branding/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.black, // Background color for the whole screen
      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C), // Deep Red
        leading: IconButton(
          icon: const Icon(AppIcons.arrowBack, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("My Profile", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.notification, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon')),
              );
            },
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: user == null
          ? const Center(
              child: Text("Please login to view profile",
                  style: TextStyle(color: AppColors.textGrey)),
            )
          : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                final data = snapshot.data?.data() ?? {};
                final name = (data['name'] ?? 'User') as String;
                final phone = (data['phone'] ?? user.phoneNumber ?? 'Not set')
                    as String;
                final email = (data['email'] ?? user.email ?? 'Not set')
                    as String;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      HeaderWidget(
                        name: name,
                        username: data['username'] ?? 'username',
                        email: email,
                      ),
                      InfoSection(
                        phone: phone,
                        email: email,
                      ),
                      const SizedBox(height: 12),
                      QuickActionsRow(
                        onQuiz: () => context.go('/quiz'),
                        onSpin: () => context.go('/scrach'),
                        onReferral: () => context.go('/referrals'),
                      ),
                      const SizedBox(height: 10),
                      const GameItem(
                        title: "Add your BGMI ID",
                        gameName: "BGMI",
                        imageUrl: 'assets/ludo.png',
                      ),
                      const GameItem(
                        title: "Add your FREE FIRE ID",
                        gameName: "FREE FIRE",
                        imageUrl: 'assets/ludo.png',
                      ),
                      const GameItem(
                        title: "Add your VALORANT ID",
                        gameName: "VALORANT",
                        imageUrl: 'assets/ludo.png',
                      ),
                      const GameItem(
                        title: "Add your FF MAX ID",
                        gameName: "FF MAX",
                        imageUrl: 'assets/ludo.png',
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final String name;
  final String username;
  final String email;

  const HeaderWidget(
      {super.key,
      required this.name,
      required this.username,
      required this.email});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF1C1C1C), // Dark Grey Header
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Avatar
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red, width: 2),
                      image: const DecorationImage(
                        image: AssetImage('assets/profile.png'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // User Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Text(username,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14)),
                        Text(email,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12)),
                        const Text("Tap edit to complete your profile",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              // Progress Bar
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: const LinearProgressIndicator(
                        value: 0.8,
                        backgroundColor: Colors.red,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text("80/100",
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        // Overlapping Edit Button
        Positioned(
          bottom: -25,
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit profile coming soon')),
              );
            },
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF1C1C1C),
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: Icon(AppIcons.edit, color: Colors.black),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class InfoSection extends StatelessWidget {
  final String phone;
  final String email;

  const InfoSection({super.key, required this.phone, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 35, left: 15, right: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF121212), // Slightly darker grey
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          InfoRow(
              label: "Mobile Number",
              value: phone,
              statusText: "Verified",
              statusColor: Colors.green),
          const Divider(color: Colors.grey, height: 25),
          InfoRow(
              label: "Email Address",
              value: email,
              statusText: email == 'Not set' ? "Verify" : "Verified",
              statusColor:
                  email == 'Not set' ? Colors.red : Colors.green),
          const Divider(color: Colors.grey, height: 25),
          const InfoRow(
              label: "Aadhar",
              value: "********",
              statusText: "Verified",
              statusColor: Colors.green),
          const Divider(color: Colors.grey, height: 25),
          const InfoRow(
              label: "PAN",
              value: "********",
              statusText: "Update PAN",
              statusColor: Colors.red),
          const Divider(color: Colors.grey, height: 25),
          InfoRow(
              label: "Referral Code",
              value: "Not generated",
              statusIcon: Icons.share,
              onTap: () => context.go('/referrals')),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final String? statusText;
  final Color? statusColor;
  final IconData? statusIcon;
  final VoidCallback? onTap;

  const InfoRow(
      {super.key,
      required this.label,
      required this.value,
      this.statusText,
      this.statusColor,
      this.statusIcon,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 4),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          if (statusText != null)
            Text(statusText!,
                style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          if (statusIcon != null) Icon(statusIcon, color: Colors.white),
        ],
      ),
    );
  }
}

class GameItem extends StatelessWidget {
  final String title;
  final String gameName;
  final String imageUrl;
  final VoidCallback? onTap;

  const GameItem(
      {super.key,
      required this.title,
      required this.gameName,
      required this.imageUrl,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Feature coming soon')),
            );
          },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Image.asset(imageUrl, width: 45, height: 45), // Game Logo
            const SizedBox(width: 15),
            Expanded(
                child: Text(title,
                    style: const TextStyle(color: Colors.white, fontSize: 14))),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFB71C1C),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Column(
                children: [
                  Icon(Icons.play_circle_outline, color: Colors.white, size: 20),
                  Text("PLAY NOW",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class QuickActionsRow extends StatelessWidget {
  final VoidCallback onQuiz;
  final VoidCallback onSpin;
  final VoidCallback onReferral;

  const QuickActionsRow({
    super.key,
    required this.onQuiz,
    required this.onSpin,
    required this.onReferral,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: _QuickActionButton(
              label: 'Quiz',
              icon: Icons.quiz_outlined,
              onTap: onQuiz,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _QuickActionButton(
              label: 'Spin & Earn',
              icon: Icons.casino_outlined,
              onTap: onSpin,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _QuickActionButton(
              label: 'Referral',
              icon: Icons.card_giftcard_outlined,
              onTap: onReferral,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
