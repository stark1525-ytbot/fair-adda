import 'package:flutter/material.dart';

class GameStat {
  final String imageUrl;
  final int contests;
  final int wins;
  final int losses;

  GameStat({
    required this.imageUrl,
    required this.contests,
    required this.wins,
    required this.losses,
  });
}

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data based on the screenshot
    final List<GameStat> stats = [
      GameStat(
          imageUrl:
              'https://via.placeholder.com/300x150/003366/FFFFFF?text=Ludo+Adda+2P',
          contests: 3,
          wins: 1,
          losses: 2),
      GameStat(
          imageUrl:
              'https://via.placeholder.com/300x150/660000/FFFFFF?text=Ludo+Tournament',
          contests: 0,
          wins: 0,
          losses: 0),
      GameStat(
          imageUrl:
              'https://via.placeholder.com/300x150/003366/FFFFFF?text=Ludo+Adda+4P',
          contests: 0,
          wins: 0,
          losses: 0),
      GameStat(
          imageUrl:
              'https://via.placeholder.com/300x150/006633/FFFFFF?text=Ludo+King',
          contests: 0,
          wins: 0,
          losses: 0),
      GameStat(
          imageUrl:
              'https://via.placeholder.com/300x150/CC6600/FFFFFF?text=Rummy+Adda',
          contests: 0,
          wins: 0,
          losses: 0),
      GameStat(
          imageUrl:
              'https://via.placeholder.com/300x150/330066/FFFFFF?text=Call+Break',
          contests: 1,
          wins: 0,
          losses: 0),
      GameStat(
          imageUrl:
              'https://via.placeholder.com/300x150/333333/FFFFFF?text=Battle+Royale',
          contests: 643,
          wins: 120,
          losses: 523),
      GameStat(
          imageUrl:
              'https://via.placeholder.com/300x150/0099CC/FFFFFF?text=Cricket',
          contests: 0,
          wins: 0,
          losses: 0),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Deep black/grey background
      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C), // Deep red
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'My Stats',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.85, // Adjust to fit height perfectly
        ),
        itemCount: stats.length,
        itemBuilder: (context, index) {
          return _StatCard(stat: stats[index]);
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final GameStat stat;

  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Slightly lighter dark grey for card
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          // Game Image
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
              child: Image.network(
                stat.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.games,
                      size: 40,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
          // Stats Section
          Expanded(
            flex: 5,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Contests',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  Text(
                    '${stat.contests}',
                    style: const TextStyle(
                        color: Color(0xFFE1BEE7),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _smallStat('Win', stat.wins, Colors.green),
                      _smallStat('Losses', stat.losses, Colors.red),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallStat(String label, int value, Color valueColor) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        Text(
          '$value',
          style: TextStyle(
              color: valueColor, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
