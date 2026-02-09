import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/branding/colors.dart';

class TournamentDetailScreen extends StatelessWidget {
  final String tournamentId;

  const TournamentDetailScreen({super.key, required this.tournamentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(
        title: const Text("TOURNAMENT"),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('tournaments')
            .doc(tournamentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Failed to load tournament",
                  style: TextStyle(color: AppColors.textGrey)),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!.data();
          if (data == null) {
            return const Center(
              child: Text("Tournament not found",
                  style: TextStyle(color: AppColors.textGrey)),
            );
          }
          final banner = (data['banner'] ?? 'assets/ludo.png') as String;
          final name = (data['name'] ?? 'Tournament') as String;
          final gameName = (data['gameName'] ?? 'Game') as String;
          final prize = (data['prize'] ?? 'INR 0').toString();
          final entry = (data['entry'] ?? 'INR 0').toString();
          final players = (data['players'] ?? 0).toString();
          final date = (data['date'] ?? 'TBD').toString();
          final time = (data['time'] ?? '--:--').toString();
          final rules = (data['rules'] ?? '').toString();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  image: DecorationImage(
                    image: banner.startsWith('http')
                        ? NetworkImage(banner) as ImageProvider
                        : AssetImage(banner),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(gameName,
                  style:
                      const TextStyle(color: AppColors.textGrey, fontSize: 13)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _pill("Prize", prize),
                  _pill("Entry", entry),
                  _pill("Players", players),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 16, color: AppColors.textGrey),
                  const SizedBox(width: 8),
                  Text("$date | $time",
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
              if (rules.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text("Rules",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(rules,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 13)),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.fairRed),
                onPressed: () {
                  _showJoinDialog(context, tournamentId, gameName);
                },
                child: const Text("JOIN NOW"),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _pill(String label, String value) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 10)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _showJoinDialog(
      BuildContext context, String tournamentId, String gameName) {
    final gameIdController = TextEditingController();
    final gameNameController = TextEditingController(text: gameName);
    final levelController = TextEditingController();
    bool hasDownloadMap = false;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardGrey,
        title: const Text("Join Tournament",
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: gameIdController,
              decoration: const InputDecoration(hintText: "Enter Game ID"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: gameNameController,
              decoration: const InputDecoration(hintText: "Game Name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: levelController,
              decoration: const InputDecoration(hintText: "Game Level"),
            ),
            const SizedBox(height: 12),
            StatefulBuilder(
              builder: (context, setState) => Row(
                children: [
                  Checkbox(
                    value: hasDownloadMap,
                    onChanged: (value) {
                      setState(() {
                        hasDownloadMap = value ?? false;
                      });
                    },
                    activeColor: AppColors.fairRed,
                  ),
                  const Text("Do you have download map?",
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("CANCEL")),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('join_requests')
                  .add({
                'tournamentId': tournamentId,
                'gameId': gameIdController.text.trim(),
                'gameName': gameNameController.text.trim(),
                'gameLevel': levelController.text.trim(),
                'hasDownloadMap': hasDownloadMap,
                'createdAt': FieldValue.serverTimestamp(),
              });
              if (context.mounted) Navigator.pop(ctx);
            },
            child: const Text("SUBMIT",
                style: TextStyle(color: AppColors.fairRed)),
          ),
        ],
      ),
    );
  }
}
