import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/branding/colors.dart';
import '../../../core/services/firestore_service.dart';

class MatchListScreen extends StatelessWidget {
  const MatchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("BATTLEGROUND"),
          bottom: const TabBar(
            indicatorColor: AppColors.fairRed,
            labelColor: AppColors.fairRed,
            unselectedLabelColor: AppColors.textGrey,
            tabs: [
              Tab(text: "UPCOMING"),
              Tab(text: "LIVE & RESULTS"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMatchList(false),
            _buildMatchList(true),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.fairRed,
          onPressed: () {
            _showPrivateRoomDialog(context);
          },
          label: const Text("JOIN PRIVATE"),
          icon: const Icon(Icons.vpn_key),
        ),
      ),
    );
  }

  Widget _buildMatchList(bool isResult) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: FirestoreService.streamMatches(isResult: isResult),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Failed to load matches",
                style: TextStyle(color: AppColors.textGrey)),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final matches = snapshot.data!;
        if (matches.isEmpty) {
          return const Center(
            child: Text("No matches found",
                style: TextStyle(color: AppColors.textGrey)),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];
            final title = (match['title'] ??
                    (isResult ? "MATCH COMPLETED" : "MATCH")) as String;
            final image = (match['image'] ?? 'assets/ludo.png') as String;
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBlack,
                      image: DecorationImage(
                        image: image.startsWith('http')
                            ? NetworkImage(image) as ImageProvider
                            : AssetImage(image),
                        fit: BoxFit.cover,
                        opacity: 0.3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _statColumn("Pool", match['poolPrize'] ?? "INR 0"),
                        _statColumn("Per Kill", match['perKill'] ?? "INR 0"),
                        _statColumn("Entry", match['entryFee'] ?? "INR 0"),
                        ElevatedButton(
                          onPressed: isResult
                              ? null
                              : () {
                                  _showJoinDialog(context, match);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isResult ? Colors.grey : AppColors.fairRed,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          child: Text(isResult ? "STATS" : "JOIN"),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _statColumn(String label, String value) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 10)),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _showPrivateRoomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardGrey,
        title:
            const Text("Private Room", style: TextStyle(color: Colors.white)),
        content: const TextField(
            decoration: InputDecoration(hintText: "Enter Room ID")),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("CANCEL")),
          TextButton(
              onPressed: () {},
              child: const Text("JOIN",
                  style: TextStyle(color: AppColors.fairRed))),
        ],
      ),
    );
  }

  void _showJoinDialog(BuildContext context, Map<String, dynamic> match) {
    final gameIdController = TextEditingController();
    final gameNameController =
        TextEditingController(text: (match['gameName'] ?? 'Game') as String);
    final levelController = TextEditingController();
    bool hasDownloadMap = false;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardGrey,
        title: const Text("Join Match",
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
                'matchId': match['id'],
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
