import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // List of query items based on the image
    final List<Map<String, dynamic>> helpItems = [
      {'title': 'LUDO ADDA\nQUERY', 'color': const Color(0xFF1B0F2B)},
      {'title': 'LUDO\nTOURNAMENT\nQUERY', 'color': const Color(0xFF1E3A8A)},
      {'title': 'L K\nQuery', 'color': const Color(0xFF0284C7)},
      {'title': 'RUMMY ADDA\nQUERY', 'color': const Color(0xFF450A0A)},
      {'title': 'CALL BREAK\nQUERY', 'color': const Color(0xFF064E3B)},
      {'title': 'FREE FIRE\nQUERY', 'color': const Color(0xFF0C4A6E)},
      {'title': 'PUBG/BGMI\nQUERY', 'color': const Color(0xFF0F172A)},
      {'title': 'FREE FIRE\nMAX QUERY', 'color': const Color(0xFF000000)},
      {'title': 'WITHDRAW\nQUERY', 'color': const Color(0xFF312E81)},
      {'title': 'DEPOSIT\nQUERY', 'color': const Color(0xFF4C1D95)},
      {'title': 'KYC QUERY', 'color': const Color(0xFF166534)},
      {'title': 'FANBATTLE\nQUERY', 'color': const Color(0xFF0369A1)},
      {'title': 'CLASH', 'color': const Color(0xFF1E1B4B)},
      {'title': 'WORD\nSEARCH', 'color': const Color(0xFF1E1B4B)},
      {'title': 'MECH', 'color': const Color(0xFF1E1B4B)},
    ];

    return Scaffold(
      // The background color of the screen
      backgroundColor: const Color(0xFF8B0000),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC62828), // Red header
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: const Text(
          "Help",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
        actions: const [
          Icon(Icons.notifications, color: Colors.black, size: 28),
          SizedBox(width: 15),
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

  const HelpQueryCard({super.key, required this.title, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                child: Icon(
                  Icons.videogame_asset, // Replace with actual images/assets
                  color: Colors.white.withOpacity(0.5),
                  size: 40,
                ),
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
    );
  }
}
