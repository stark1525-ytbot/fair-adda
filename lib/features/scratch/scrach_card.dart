import 'package:flutter/material.dart';
import '../../../core/utils/icons.dart';
import 'package:go_router/go_router.dart';

class ScratchCardsScreen extends StatefulWidget {
  const ScratchCardsScreen({super.key});

  @override
  State<ScratchCardsScreen> createState() => _ScratchCardsScreenState();
}

class _ScratchCardsScreenState extends State<ScratchCardsScreen> {
  int selectedIndex = 0; // Highlighting 'Ludo Adda' by default
  bool isRevealed = false;
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  final List<String> categories = [
    "LUDO ADDA",
    "LUDO QUICK MODE",
    "LK",
    "RUMMY ADDA",
    "CALL BREAK",
    "LEAGUE",
    "FANBATTLE",
    "COX CLASH",
    "WORD SEARCH",
    "DROID-O",
    "QUIZ"
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFC62828); // Match the red in header
    const Color darkBackground = Color(0xFF121212); // Dark background

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: primaryRed,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title:
            const Text("Scratch Cards", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black, size: 28),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon')),
              );
            },
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Total Earnings Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: primaryRed,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Earnings",
                    style: TextStyle(color: Colors.white70, fontSize: 16)),
                SizedBox(height: 4),
                Text("Rs 76.29",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Categories",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),

          // 2. Categories Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 items per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                bool isSelected = index == selectedIndex;
                return GestureDetector(
                  onTap: () => setState(() {
                    selectedIndex = index;
                    isRevealed = false;
                  }),
                  child: Container(
                    decoration: BoxDecoration(
                      color: index == 2 || index == 10
                          ? Colors.white70
                          : Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(color: Colors.red, width: 2)
                          : null,
                      image: DecorationImage(
                        image: const AssetImage('assets/scratch.png'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.6),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      categories[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: index == 2 || index == 10
                            ? Colors.black
                            : Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Scratch Cards",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),

          // 3. Scratch Card Section
          Expanded(
            child: selectedIndex >= 0 && selectedIndex < categories.length
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => isRevealed = true),
                          child: Container(
                            height: 200,
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // Scratch Card Content
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.card_giftcard,
                                        size: 60,
                                        color: Colors.orange,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Congratulations!",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "You won Rs 10",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Scratchable overlay (simulated)
                                if (!isRevealed)
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "SCRATCH TO REVEAL",
                                        style: TextStyle(
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
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: isRevealed
                              ? () {
                                  _showVerificationDialog(context);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryRed,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Verify & Enter",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: Text(
                      "Please select a category to see scratch cards",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showVerificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Verification"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  hintText: "Enter verification code",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_codeController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter a code"),
                    ),
                  );
                  return;
                }
                Navigator.of(context).pop(); // Close dialog
                _codeController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Verification successful!"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text("Verify"),
            ),
          ],
        );
      },
    );
  }
}
