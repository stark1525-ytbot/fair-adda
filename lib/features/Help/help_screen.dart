import 'package:flutter/material.dart';
import '../../core/utils/icons.dart';

// Import conversations screen
import 'conversations_screen.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // List of query items based on the image with appropriate icons
    final List<Map<String, dynamic>> helpItems = [
      {
        'title': 'LUDO ADDA\nQUERY',
        'color': const Color(0xFF1B0F2B),
        'icon': AppIcons.dice,
        'iconColor': Colors.purpleAccent,
        'iconType': 'materialDesign'
      },
      {
        'title': 'LUDO\nTOURNAMENT\nQUERY',
        'color': const Color(0xFF1E3A8A),
        'icon': AppIcons.trophy,
        'iconColor': Colors.blue,
        'iconType': 'materialDesign'
      },
      {
        'title': 'L K\nQuery',
        'color': const Color(0xFF0284C7),
        'icon': AppIcons.gamepad,
        'iconColor': Colors.cyan,
        'iconType': 'materialDesign'
      },
      {
        'title': 'RUMMY ADDA\nQUERY',
        'color': const Color(0xFF450A0A),
        'icon': AppIcons.cards,
        'iconColor': Colors.red,
        'iconType': 'materialDesign'
      },
      {
        'title': 'CALL BREAK\nQUERY',
        'color': const Color(0xFF064E3B),
        'icon': AppIcons.cards,
        'iconColor': Colors.green,
        'iconType': 'materialDesign'
      },
      {
        'title': 'FREE FIRE\nQUERY',
        'color': const Color(0xFF0C4A6E),
        'icon': AppIcons.fire,
        'iconColor': Colors.orange,
        'iconType': 'materialDesign'
      },
      {
        'title': 'PUBG/BGMI\nQUERY',
        'color': const Color(0xFF0F172A),
        'icon': AppIcons.controller,
        'iconColor': Colors.grey,
        'iconType': 'materialDesign'
      },
      {
        'title': 'FREE FIRE\nMAX QUERY',
        'color': const Color(0xFF000000),
        'icon': AppIcons.flash,
        'iconColor': Colors.yellow,
        'iconType': 'materialDesign'
      },
      {
        'title': 'WITHDRAW\nQUERY',
        'color': const Color(0xFF312E81),
        'icon': AppIcons.withdraw,
        'iconColor': Colors.indigo,
        'iconType': 'materialDesign'
      },
      {
        'title': 'DEPOSIT\nQUERY',
        'color': const Color(0xFF4C1D95),
        'icon': AppIcons.deposit,
        'iconColor': Colors.purple,
        'iconType': 'materialDesign'
      },
      {
        'title': 'KYC QUERY',
        'color': const Color(0xFF166534),
        'icon': AppIcons.shield,
        'iconColor': Colors.green,
        'iconType': 'materialDesign'
      },
      {
        'title': 'FANBATTLE\nQUERY',
        'color': const Color(0xFF0369A1),
        'icon': AppIcons.users,
        'iconColor': Colors.lightBlue,
        'iconType': 'materialDesign'
      },
      {
        'title': 'CLASH',
        'color': const Color(0xFF1E1B4B),
        'icon': AppIcons.sword,
        'iconColor': Colors.deepPurple,
        'iconType': 'materialDesign'
      },
      {
        'title': 'WORD\nSEARCH',
        'color': const Color(0xFF1E1B4B),
        'icon': AppIcons.search,
        'iconColor': Colors.deepPurple,
        'iconType': 'materialDesign'
      },
      {
        'title': 'MECH',
        'color': const Color(0xFF1E1B4B),
        'icon': AppIcons.tools,
        'iconColor': Colors.deepPurple,
        'iconType': 'materialDesign'
      },
    ];

    return Scaffold(
      // The background color of the screen
      backgroundColor: const Color(0xFF8B0000),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC62828), // Red header
        elevation: 0,
        leading: IconButton(
          icon: const Icon(AppIcons.arrowBack, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Help",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.chat, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ConversationsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 columns as per image
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7, // Makes the cards rectangular
          ),
          itemCount: helpItems.length,
          itemBuilder: (context, index) {
            return HelpQueryCard(
              title: helpItems[index]['title'],
              bgColor: helpItems[index]['color'],
              icon: helpItems[index]['icon'],
              iconColor: helpItems[index]['iconColor'],
            );
          },
        ),
      ),
    );
  }
}

class HelpQueryCard extends StatelessWidget {
  final String title;
  final Color bgColor;
  final dynamic icon;
  final Color iconColor;
  final String iconType;

  const HelpQueryCard({
    super.key,
    required this.title,
    required this.bgColor,
    required this.icon,
    required this.iconColor,
    this.iconType = 'material', // Default to material icons
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle card tap - could navigate to specific query screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening ${title.split('\n')[0]} support'),
            backgroundColor: bgColor,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Graphic Placeholder (Top 2/3 of the card)
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: _buildIcon(),
                ),
              ),
            ),
            // Label Section (Bottom 1/3 of the card)
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    switch (iconType) {
      case 'fontAwesome':
      case 'ionicons':
      case 'materialDesign':
      case 'lineIcons':
        return Icon(
          icon,
          color: iconColor,
          size: 40,
        );
      default:
        return Icon(
          icon,
          color: iconColor,
          size: 40,
        );
    }
  }
}
