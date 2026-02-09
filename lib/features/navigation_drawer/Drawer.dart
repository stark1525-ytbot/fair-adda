import 'package:flutter/material.dart';
import '../../core/utils/icons.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF121212), // Dark background color
      child: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF6B1113), // Deep red header background
            ),
            child: Column(
              children: [
                // Circular Logo Placeholder
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 2),
                    image: const DecorationImage(
                      // Replace with your actual image asset
                      image: AssetImage('assets/profile.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Yashveer Singh Sikarwar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  'trademoneyresearch349@gmail.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable List Section
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(context, AppIcons.person,
                    'Profile', '/profile'),
                _buildMenuItem(context, Icons.swap_vert_circle_outlined,
                    'My Stats', '/stats'),
                _buildMenuItem(context, AppIcons.wallet,
                    'Wallet', '/user/wallet'),
                _buildMenuItem(context, Icons.emoji_events_outlined,
                    'Leagues', '/leagues'),
                _buildMenuItem(context, Icons.star_outline,
                    'My Leagues', '/my-leagues'),
                _buildMenuItem(
                    context, Icons.filter_center_focus, 'Update KYC', '/kyc'),
                _buildMenuItem(
                    context, Icons.article_outlined, 'TDS Certificate', '/tds'),
                _buildMenuItem(context, AppIcons.leaderboard, 'Leaderboard', '/leaderboard'),
                _buildMenuItem(context, AppIcons.gamepad, 'My Played Quiz', '/quiz'),
                _buildMenuItem(context, AppIcons.users, 'My Referrals', '/referrals'),
                _buildMenuItem(context, Icons.wallet_outlined, 'Deposit Limit',
                    '/deposit-limit'),
                _buildMenuItem(context, AppIcons.settings, 'Settings', '/settings'),
                _buildMenuItem(context, Icons.verified_user_outlined,
                    'Responsible Gaming', '/responsible-gaming'),
                _buildMenuItem(context, AppIcons.helpOutline, 'Tutorial', '/tutorial'),
                _buildMenuItem(context, AppIcons.logout, 'Logout', '/logout'),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                  child: Text(
                    'Social Media',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create menu items
  Widget _buildMenuItem(
      BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 26),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
      onTap: () {
        // Close the drawer first
        Navigator.of(context).pop();
        // Navigate to the route
        context.push(route);
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      visualDensity:
          const VisualDensity(vertical: -2), // Tightens the list spacing
    );
  }
}
