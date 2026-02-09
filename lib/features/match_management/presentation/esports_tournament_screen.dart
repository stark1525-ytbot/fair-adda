import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../../../core/branding/colors.dart';
import '../../../core/services/firestore_service.dart';

class EsportsTournamentScreen extends StatelessWidget {
  final String gameName;

  const EsportsTournamentScreen({super.key, required this.gameName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE31E24),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "${gameName.toUpperCase()} TOURNAMENTS",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFE31E24),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "AVAILABLE TOURNAMENTS",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: FirestoreService.streamTournamentsByGame(gameName),
                  builder: (context, snapshot) {
                    final count = snapshot.data?.length ?? 0;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "$count Active",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: FirestoreService.streamTournamentsByGame(gameName),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Failed to load tournaments",
                        style: TextStyle(color: AppColors.textGrey)),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final tournaments = snapshot.data!;
                if (tournaments.isEmpty) {
                  return const Center(
                    child: Text("No tournaments found",
                        style: TextStyle(color: AppColors.textGrey)),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tournaments.length,
                  itemBuilder: (context, index) {
                    final tournament = tournaments[index];
                    return _buildTournamentCard(context, tournament);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTournamentCard(
      BuildContext context, Map<String, dynamic> tournament) {
    return Card(
      color: const Color(0xFF1A1A1A),
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      child: InkWell(
        onTap: () {
          final id = tournament['id'] ?? '';
          if (id.toString().isNotEmpty) {
            context.push('/tournament/$id');
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      (tournament['name'] ?? 'Tournament') as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showJoinDialog(context, tournament);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade800,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "JOIN",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(Icons.monetization_on,
                            tournament['prize'] ?? 'INR 0', 'Prize Pool'),
                        const SizedBox(height: 8),
                        _buildInfoRow(Icons.people,
                            '${tournament['players'] ?? 0} Players', 'Participants'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildInfoRow(Icons.attach_money,
                            tournament['entry'] ?? 'INR 0', 'Entry Fee'),
                        const SizedBox(height: 8),
                        _buildDateTimeRow(
                          (tournament['date'] ?? 'TBD') as String,
                          (tournament['time'] ?? '--:--') as String,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.white70),
        const SizedBox(width: 6),
        Text(
          '$value ',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          '($label)',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeRow(String date, String time) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.calendar_today, size: 14, color: Colors.white70),
        const SizedBox(width: 4),
        Text(
          '$date | $time',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _showJoinDialog(
      BuildContext context, Map<String, dynamic> tournament) {
    final gameIdController = TextEditingController();
    final gameNameController =
        TextEditingController(text: (tournament['gameName'] ?? gameName) as String);
    final levelController = TextEditingController();
    bool hasDownloadMap = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.cardGrey,
          title: const Text("Join Tournament",
              style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: gameIdController,
                decoration: const InputDecoration(
                  hintText: "Enter Game ID",
                  hintStyle: TextStyle(color: AppColors.textGrey),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: gameNameController,
                decoration: const InputDecoration(
                  hintText: "Game Name",
                  hintStyle: TextStyle(color: AppColors.textGrey),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: levelController,
                decoration: const InputDecoration(
                  hintText: "Game Level",
                  hintStyle: TextStyle(color: AppColors.textGrey),
                ),
              ),
              const SizedBox(height: 12),
              StatefulBuilder(
                builder: (context, setState) {
                  return Row(
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
                  );
                },
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
                  'tournamentId': tournament['id'],
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
        );
      },
    );
  }
}
