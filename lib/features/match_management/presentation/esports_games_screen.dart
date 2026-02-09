import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/utils/icons.dart';
import 'package:go_router/go_router.dart';
import '../../../core/branding/colors.dart';
import '../../../core/services/firestore_service.dart';

class EsportsGamesScreen extends StatelessWidget {
  const EsportsGamesScreen({super.key});

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
        title: const Text(
          "ESPORTS GAMES",
          style: TextStyle(
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
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Text(
              "SELECT A GAME",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('games')
                  .where('isEsports', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Failed to load games",
                        style: TextStyle(color: AppColors.textGrey)),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final games = snapshot.data!.docs
                    .map((d) => {'id': d.id, ...d.data()})
                    .toList();
                if (games.isEmpty) {
                  return const Center(
                    child: Text("No esports games found",
                        style: TextStyle(color: AppColors.textGrey)),
                  );
                }

                final width = MediaQuery.sizeOf(context).width;
                final crossAxisCount = width > 900
                    ? 4
                    : width > 640
                        ? 3
                        : 2;
                final aspect = width > 640 ? 0.95 : 0.85;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: aspect,
                  ),
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    return _buildGameCard(context, games[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, Map<String, dynamic> gameData) {
    final image = (gameData['image'] ?? 'assets/ludo.png') as String;
    final tag = gameData['tag'];
    final tournaments = gameData['tournaments'] ?? 0;
    final color =
        FirestoreService.parseColor(gameData['color'], fallback: Colors.black);
    return GestureDetector(
      onTap: () {
        // Navigate to specific game tournaments
        final rawName = (gameData['name'] ?? '') as String;
        final safeName = rawName.toLowerCase().replaceAll(' ', '_');
        context.push('/esports/$safeName/tournaments',
            extra: {'gameName': rawName});
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
        ),
        child: Stack(
          children: [
            // Game image
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: image.startsWith('http')
                      ? NetworkImage(image) as ImageProvider
                      : AssetImage(image),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.multiply,
                  ),
                ),
              ),
            ),
            // Tag
            if (tag != null)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(tag,
                      style: const TextStyle(
                          fontSize: 9,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            // Game info at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  children: [
                    Text(gameData['name'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.sports_esports,
                            size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text('$tournaments Tournaments',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
