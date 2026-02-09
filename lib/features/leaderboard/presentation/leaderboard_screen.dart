import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String selectedCategory = "FREE FIRE";

  @override
  Widget build(BuildContext context) {
    const Color brandRed = Color(0xFFFF1717);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: brandRed,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "${selectedCategory.toUpperCase()} LEADERBOARD",
          style: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 1.2),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: brandRed.withOpacity(0.8),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Row(
              children: [
                Text("All", style: TextStyle(color: Colors.white)),
                Icon(Icons.keyboard_arrow_down, color: Colors.white),
              ],
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Querying Firebase based on selected category, ordered by rank
        stream: FirebaseFirestore.instance
            .collection('leaderboard')
            .where('category', isEqualTo: selectedCategory)
            .orderBy('rank')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load leaderboard.'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final players = snapshot.data?.docs ?? [];
          if (players.isEmpty) {
            return const Center(child: Text('No leaderboard data yet.'));
          }
          
          // Separating Top 3 for the podium and the rest for the list
          final top3 = players.take(3).toList();
          final others = players.skip(3).toList();

          return Column(
            children: [
              // 1. Top Red Section with Podium
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 30),
                decoration: const BoxDecoration(
                  color: brandRed,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: PodiumWidget(top3: top3),
              ),

              // 2. Category Selector
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      _categoryTab("FREE FIRE", true),
                      _categoryTab("LUDO", false),
                      _categoryTab("FAN BATTLE", false),
                      _categoryTab("+ More", false, isMore: true),
                    ],
                  ),
                ),
              ),

              // 3. List of other players
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: others.length,
                  itemBuilder: (context, index) {
                    var data = others[index].data() as Map<String, dynamic>;
                    return _leaderboardListTile(data);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _categoryTab(String label, bool isActive, {bool isMore = false}) {
    final selected = selectedCategory == label;
    return InkWell(
      onTap: () {
        if (isMore) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('More categories coming soon')),
          );
          return;
        }
        setState(() => selectedCategory = label);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFC62828) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFC62828)),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFFC62828),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            if (isMore) const Icon(Icons.chevron_right, size: 16, color: Color(0xFFC62828)),
          ],
        ),
      ),
    );
  }

  Widget _leaderboardListTile(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.red,
            radius: 25,
            child: CircleAvatar(
              radius: 23,
              backgroundImage: (data['imageUrl'] ?? '').toString().isNotEmpty
                  ? NetworkImage(data['imageUrl'])
                  : null,
              child: (data['imageUrl'] ?? '').toString().isEmpty
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data['name'], style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                "Won: Rs ${data['winnings']}",
                style: const TextStyle(color: Colors.green, fontSize: 13),
              ),
            ],
          ),
          const Spacer(),
          Text("#${data['rank']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}

class PodiumWidget extends StatelessWidget {
  final List<QueryDocumentSnapshot> top3;
  const PodiumWidget({super.key, required this.top3});

  @override
  Widget build(BuildContext context) {
    if (top3.isEmpty) return const SizedBox(height: 200);

    // Arranging as: [2nd, 1st, 3rd] for the visual podium
    Map<String, dynamic>? first = top3.length > 0 ? top3[0].data() as Map<String, dynamic> : null;
    Map<String, dynamic>? second = top3.length > 1 ? top3[1].data() as Map<String, dynamic> : null;
    Map<String, dynamic>? third = top3.length > 2 ? top3[2].data() as Map<String, dynamic> : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (second != null) _podiumUser(second, 2, 80),
        if (first != null) _podiumUser(first, 1, 110),
        if (third != null) _podiumUser(third, 3, 80),
      ],
    );
  }

  Widget _podiumUser(Map<String, dynamic> data, int rank, double size) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 2),
                  image: DecorationImage(
                    image: (data['imageUrl'] ?? '').toString().isNotEmpty
                        ? NetworkImage(data['imageUrl'])
                        : const AssetImage('assets/profile.png') as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Crown Icon logic
            Positioned(
              top: 0,
              child: Image.network(
                rank == 1 
                  ? 'https://cdn-icons-png.flaticon.com/512/6941/6941697.png' // Gold Crown
                  : 'https://cdn-icons-png.flaticon.com/512/2583/2583319.png', // Silver/Bronze Crown
                width: 30,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "$rank.${data['name']}",
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        Text(
          "Won: Rs ${data['winnings']}",
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}
