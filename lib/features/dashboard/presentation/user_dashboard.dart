import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/utils/icons.dart';
import 'package:go_router/go_router.dart';
import '../../navigation_drawer/Drawer.dart';
import '../../../core/branding/colors.dart';
import '../../../core/services/firestore_service.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
    bool isSelected,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFFE31E24) : Colors.white,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFFE31E24) : Colors.white,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D), // Dark background for games
      appBar: AppBar(
        backgroundColor: const Color(0xFFE31E24),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(AppIcons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          "Fair Adda",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          // Wallet Balance Widget
          GestureDetector(
            onTap: () {
              context.push('/user/wallet');
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(AppIcons.wallet, size: 16, color: Colors.white),
                  SizedBox(width: 8),
                  Text("INR 1",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(AppIcons.notification, color: Colors.white),
            onPressed: () {
              // Handle notifications
            },
          ),
          const SizedBox(width: 15),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // Tabs Section
          Container(
            color: const Color(0xFFE31E24),
            child: TabBarWidget(
              onEsportsTabPressed: () {
                context.push('/esports/games');
              },
            ),
          ),

          Expanded(
            child: Stack(
              children: [
                const SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnnouncementBanner(),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          "Games",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      GamesGrid(),
                      TournamentBanner(),
                      SizedBox(height: 80), // Space for bottom nav
                    ],
                  ),
                ),
                // Floating Scratch Card
                Positioned(
                  bottom: 20,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      context.push('/user/scratch');
                    },
                    child: Image.asset(
                      'assets/scratch.png',
                      height: 80,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 80,
                          width: 80,
                          color: Colors.grey,
                          child: const Icon(Icons.card_giftcard,
                              color: Colors.white),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}

// --- Components ---

class TabBarWidget extends StatefulWidget {
  final VoidCallback? onEsportsTabPressed;
  const TabBarWidget({super.key, this.onEsportsTabPressed});

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  int _selectedIndex = 1; // Default to Games

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate based on selected tab
    if (index == 3) {
      // Esports
      widget.onEsportsTabPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _tabItem("All", 0, _selectedIndex == 0),
        _tabItem("Games", 1, _selectedIndex == 1),
        _tabItem("Esports", 3, _selectedIndex == 3),
      ],
    );
  }

  Widget _tabItem(String title, int index, bool isActive) {
    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : Colors.white70,
              ),
            ),
          ),
          if (isActive)
            Container(height: 3, width: 40, color: Colors.white)
          else
            const SizedBox(height: 3),
        ],
      ),
    );
  }
}

class AnnouncementBanner extends StatelessWidget {
  const AnnouncementBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 80,
                color: const Color(0xFFE31E24),
                child:
                    const Icon(Icons.campaign, color: Colors.white, size: 40),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("! Great News",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      Text("You can now withdraw your funds",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                      Text(
                        "We are excited to share that we have smoothly transferred your balance...",
                        style: TextStyle(color: Colors.black, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GamesGrid extends StatelessWidget {
  const GamesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('games').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Failed to load games",
                style: TextStyle(color: AppColors.textGrey)),
          );
        }
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final games = snapshot.data!.docs
            .map((d) => {'id': d.id, ...d.data()})
            .toList();

        if (games.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text("No games found",
                style: TextStyle(color: AppColors.textGrey)),
          );
        }

        final width = MediaQuery.sizeOf(context).width;
        final crossAxisCount = width > 900
            ? 4
            : width > 640
                ? 3
                : 2;
        final aspect = width > 640 ? 1.15 : 1.0;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: aspect,
          ),
          itemCount: games.length,
          itemBuilder: (context, index) {
            return _gameCard(context, games[index]);
          },
        );
      },
    );
  }

  Widget _gameCard(BuildContext context, Map<String, dynamic> gameData) {
    final image = (gameData['image'] ?? 'assets/ludo.png') as String;
    final tag = gameData['tag'];
    final isEsports = (gameData['isEsports'] ?? false) as bool;
    final color =
        FirestoreService.parseColor(gameData['color'], fallback: Colors.black);
    return GestureDetector(
      onTap: () {
        // Navigate differently based on game type
        if (isEsports) {
          context.push('/esports/games');
        } else {
          context.push('/user/matches');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Game Image - Full coverage
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: image.startsWith('http')
                      ? NetworkImage(image) as ImageProvider
                      : AssetImage(image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            // Dark overlay for better text visibility
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
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
            // Game name - centered
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 70),
                child: Text(
                  (gameData['name'] ?? 'GAME') as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TournamentBanner extends StatelessWidget {
  const TournamentBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('tournaments')
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }
        final data = snapshot.data!.docs.first.data();
        final id = snapshot.data!.docs.first.id;
        final name = (data['name'] ?? 'Tournament') as String;
        final banner = (data['banner'] ?? '') as String;

        return Container(
          height: 140,
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade800,
            borderRadius: BorderRadius.circular(15),
            image: banner.isEmpty
                ? null
                : DecorationImage(
                    image: banner.startsWith('http')
                        ? NetworkImage(banner) as ImageProvider
                        : AssetImage(banner),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.35),
                      BlendMode.darken,
                    ),
                  ),
          ),
          child: Stack(
            children: [
              Center(
                  child: Text(name.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    context.push('/tournament/$id');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.8),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                    ),
                    child: const Text("TOURNAMENT",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE31E24),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(context, AppIcons.gift, "Reward",
              () => context.push('/rewards')),
          _navItem(context, Icons.quiz, "Quizes", () => context.push('/quiz')),
          _navItem(context, AppIcons.home, "Home", null),
          _navItem(context, Icons.trending_up, "Winner",
              () => context.push('/leaderboard')),
          _navItem(context, AppIcons.help, "Help", () => context.push('/help')),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label,
      void Function()? onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white, size: 24),
          onPressed: onPressed,
          padding: EdgeInsets.zero,
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 11)),
      ],
    );
  }
}
