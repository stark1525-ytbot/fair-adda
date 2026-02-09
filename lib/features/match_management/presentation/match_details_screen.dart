import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/branding/colors.dart';
import '../../../shared/widgets/primary_button.dart';

class MatchDetailsScreen extends StatelessWidget {
  final String matchId;
  const MatchDetailsScreen({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MATCH DETAILS")),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('matches')
            .doc(matchId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Failed to load match",
                  style: TextStyle(color: AppColors.textGrey)),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!.data();
          if (data == null) {
            return const Center(
              child: Text("Match not found",
                  style: TextStyle(color: AppColors.textGrey)),
            );
          }

          final entryFee = data['entryFee'] ?? 'INR 0';
          final prizePool = data['poolPrize'] ?? 'INR 0';
          final matchType = (data['type'] ?? 'SOLO') as String;
          final rules = (data['rules'] ?? []) as List<dynamic>;
          final prizes = (data['prizes'] ?? []) as List<dynamic>;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  color: AppColors.surfaceBlack,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _DetailStat(
                          label: "ENTRY FEE",
                          value: entryFee.toString(),
                          color: AppColors.warningOrange),
                      _DetailStat(
                          label: "PRIZE POOL",
                          value: prizePool.toString(),
                          color: AppColors.successGreen),
                      _DetailStat(
                          label: "TYPE",
                          value: matchType,
                          color: Colors.white),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("FAIR PLAY RULES",
                      style: TextStyle(
                          color: AppColors.fairRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: rules.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.gavel,
                              size: 16, color: AppColors.textGrey),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(rules[index].toString(),
                                  style:
                                      const TextStyle(color: Colors.white))),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(color: AppColors.cardGrey),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("PRIZE BREAKDOWN",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
                const SizedBox(height: 10),
                if (prizes.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("No prize breakdown",
                        style: TextStyle(color: AppColors.textGrey)),
                  )
                else
                  ...prizes.asMap().entries.map((entry) {
                    final rank = entry.key + 1;
                    return _buildPrizeRow(rank, entry.value.toString());
                  }),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FairPrimaryButton(
          text: "JOIN MATCH NOW",
          onPressed: () => _showJoinConfirmation(context),
        ),
      ),
    );
  }

  Widget _buildPrizeRow(int rank, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Rank #$rank",
              style: const TextStyle(color: AppColors.textGrey)),
          Text(amount,
              style: const TextStyle(
                  color: AppColors.successGreen, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showJoinConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardGrey,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("CONFIRM ENTRY",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 16),
            const Text("Entry fee will be deducted from your wallet.",
                style: TextStyle(color: AppColors.textGrey)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                    child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("CANCEL"))),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.fairRed),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Joined Successfully!")));
                    },
                    child: const Text("PAY & JOIN"),
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

class _DetailStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _DetailStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.textGrey, fontSize: 10, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                color: color, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
