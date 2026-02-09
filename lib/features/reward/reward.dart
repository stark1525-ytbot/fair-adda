import 'package:flutter/material.dart';
import '../../../core/utils/icons.dart';
import 'package:go_router/go_router.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors extracted from the image
    const Color brandRed = Color(0xFFD32F2F);
    const Color buttonRed = Color(0xFFC62828);
    const Color tabBgColor = Color(0xFF1E1E1E);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // --- Red Header Section ---
              Container(
                padding: const EdgeInsets.all(16.0),
                color: brandRed,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Back, Title, Notification, Wallet
                    Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(AppIcons.arrowBack, color: Colors.white),
                          onPressed: () => context.pop(),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Rewards',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        // Notification Icon with rounded box
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(AppIcons.notification, size: 24, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        // Wallet Button
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.account_balance_wallet_outlined,
                                  size: 18, color: Colors.white),
                              SizedBox(width: 6),
                              Text('Wallet',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    // Balance and Sort By Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '₹338.99',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        // Sort By Button
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: buttonRed,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2))
                            ],
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.tune, size: 18, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Sort By',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Total Rewards Earned',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              // --- Custom Tab Bar ---
              Container(
                color: tabBgColor,
                child: const TabBar(
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  unselectedLabelStyle:
                      TextStyle(fontWeight: FontWeight.normal),
                  tabs: [
                    Tab(text: "Live rewards"),
                    Tab(text: "Expired rewards"),
                  ],
                ),
              ),

              // --- Body Content ---
              const Expanded(
                child: TabBarView(
                  children: [
                    Center(
                      child: Text(
                        'no data found',
                        style: TextStyle(color: Colors.white54, fontSize: 22),
                      ),
                    ),
                    Center(
                      child: Text(
                        'no data found',
                        style: TextStyle(color: Colors.white54, fontSize: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
