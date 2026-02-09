import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/branding/colors.dart';

class StaffDashboard extends StatelessWidget {
  const StaffDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("STAFF CONSOLE"),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      drawer: const Drawer(),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('matches').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Failed to load dashboard",
                  style: TextStyle(color: AppColors.textGrey)),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final matches = snapshot.data!.docs
              .map((d) => {'id': d.id, ...d.data()})
              .toList();

          int pending = 0;
          int active = 0;
          int disputed = 0;
          for (final m in matches) {
            final status = (m['status'] ?? '').toString().toLowerCase();
            if (status == 'pending') pending++;
            if (status == 'active') active++;
            if (status == 'disputed') disputed++;
          }
          final first = matches.isNotEmpty ? matches.first : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Overview",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStatCard("Pending", "$pending", AppColors.warningOrange),
                    const SizedBox(width: 10),
                    _buildStatCard("Active", "$active", AppColors.successGreen),
                    const SizedBox(width: 10),
                    _buildStatCard("Disputed", "$disputed", AppColors.errorRed),
                  ],
                ),
                const SizedBox(height: 24),
                const Text("Assigned Matches",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                if (first == null)
                  const Text("No assigned matches",
                      style: TextStyle(color: AppColors.textGrey))
                else
                  _buildMatchCard(context, first),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardGrey,
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: color, width: 4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(count,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            Text(title,
                style:
                    const TextStyle(color: AppColors.textGrey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchCard(BuildContext context, Map<String, dynamic> match) {
    final matchId = match['id'] ?? '---';
    final title = (match['title'] ?? 'Match') as String;
    final mapName = (match['map'] ?? 'Map') as String;
    final mode = (match['mode'] ?? 'Mode') as String;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Match #$matchId",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.fairRed)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4)),
                  child: Text("$title • $mapName • $mode",
                      style: const TextStyle(color: Colors.blue, fontSize: 12)),
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Room ID: ${match['roomId'] ?? '----'}",
                    style: const TextStyle(color: Colors.white)),
                Text("Pass: ${match['roomPass'] ?? '----'}",
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
            const Divider(color: Colors.grey),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.successGreen),
                    onPressed: () {},
                    child: const Text("Set Room ID"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text("Upload Result"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
