import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fair_adda/features/league/presentation/my_league_screen.dart';

class LeagueDetailScreen extends StatelessWidget {
  final String? leagueId;
  const LeagueDetailScreen({super.key, this.leagueId});

  @override
  Widget build(BuildContext context) {
    const Color brandRed = Color(0xFF8B0000); // Deep red from the bottom bar

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text("Match Details", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        // Fetching main match info
        stream: FirebaseFirestore.instance
            .collection('matches')
            .doc(leagueId ?? 'match_001')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load match details.'));
          }
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final raw = snapshot.data!.data();
          if (raw == null) {
            return const Center(child: Text('Match not found.'));
          }
          final data = raw as Map<String, dynamic>;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // 1. Banner Image
                      Image.network(
                        data['bannerUrl'] ?? 'https://via.placeholder.com/400x150',
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),

                      // 2. Rules Link
                      Container(
                        width: double.infinity,
                        color: Colors.grey[800],
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: const Text(
                          "Rules/How To Play",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),

                      // 3. Match Info Section
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              "Match: ${data['title'] ?? 'Unknown'}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                            ),
                            const SizedBox(height: 8),
                            Text("${data['dateTime']} , Bonus 30%", style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),

                      const Divider(height: 1),

                      // 4. Stats Row (Entry Fee, Participants, Prize)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(Icons.payments_outlined, "Entry Fee", "${data['entryFee']} Coins"),
                            _buildStatItem(Icons.person_outline, "Participant", "${data['joined']}/${data['total']}"),
                            _buildStatItem(Icons.emoji_events_outlined, "Prize", "${data['prizePool']} Coins", color: brandRed),
                          ],
                        ),
                      ),

                      // 5. Game Metadata Row (Mode, Map, etc)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        color: Colors.grey[200],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSubStat("Mode", data['mode'] ?? "TPP"),
                            _buildSubStat("Bonus", "30%"),
                            _buildSubStat("Map", data['map'] ?? "KALAHARI"),
                          ],
                        ),
                      ),

                      // 6. Prize Pool Breakup Table
                      const PrizePoolTable(),
                    ],
                  ),
                ),
              ),

              // 7. Bottom Navigation Bar
              Container(
                height: 60,
                color: brandRed,
                child: Row(
                  children: [
                    _bottomAction(context, Icons.emoji_events, "MY LEAGUES"),
                    const VerticalDivider(color: Colors.white24, width: 1),
                    _bottomAction(context, Icons.groups, "PARTICIPANT"),
                    const VerticalDivider(color: Colors.white24, width: 1),
                    _bottomAction(context, Icons.add, "JOIN", flex: 2),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, {Color color = Colors.black54}) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)),
      ],
    );
  }

  Widget _buildSubStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }

  Widget _bottomAction(BuildContext context, IconData icon, String label, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () {
          if (label == "MY LEAGUES") {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MyLeaguesScreen()),
            );
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label coming soon')),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class PrizePoolTable extends StatelessWidget {
  const PrizePoolTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        children: [
          // Header Tabs
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey.shade300))),
                  child: const Text("Prize Pool Breakup", textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                ),
              ),
              const Expanded(
                child: Text("View Full PrizePool", textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const Divider(height: 1),
          // Table Headers
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Standing", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Prize (Coins)", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // Dynamic List from Firebase
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('matches')
                .doc('match_001')
                .collection('prize_breakup')
                .orderBy('prize', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              return Column(
                children: snapshot.data!.docs.map((doc) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(doc['standing'], style: const TextStyle(color: Colors.black54)),
                        Text(doc['prize'], style: const TextStyle(color: Colors.black54)),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
