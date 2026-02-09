import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/branding/colors.dart';
import 'package:go_router/go_router.dart';

class OwnerDashboard extends StatelessWidget {
  const OwnerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("OWNER COMMAND")),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('owner_dashboard')
            .doc('summary')
            .snapshots(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data() ?? {};
          final revenue = data['revenue'] ?? 0;
          final delta = data['deltaPercent'] ?? 0;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppColors.fairRedDark, AppColors.backgroundBlack]),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.fairRed),
                ),
                child: Column(
                  children: [
                    const Text("TOTAL REVENUE",
                        style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 12,
                            letterSpacing: 1.2)),
                    const SizedBox(height: 8),
                    Text("INR $revenue",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text("$delta% from last update",
                        style: const TextStyle(
                            color: AppColors.successGreen, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text("Quick Actions",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.5,
                children: [
                  _buildActionCard(Icons.people, "Manage Users",
                      () => context.push('/owner/users')),
                  _buildActionCard(Icons.attach_money, "Withdrawals",
                      () => context.push('/withdraw')),
                  _buildActionCard(Icons.sports_esports, "Create Match", () {}),
                  _buildActionCard(Icons.analytics, "Reports", () {}),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionCard(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceBlack,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.fairRed, size: 32),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
