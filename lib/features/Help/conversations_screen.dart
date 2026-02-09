import 'package:flutter/material.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE), // Light grey background
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F), // Deep red header
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                  'https://cdn-icons-png.flaticon.com/512/4086/4086679.png'), // Placeholder admin icon
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin for Help',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Offline',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chat Body Area
          const Expanded(
            child: Center(
              child: Text(
                'You have no conversations',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          // Bottom Input Area
          Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Divider Line (Bluish-Purple)
                Container(height: 1.5, color: const Color(0xFF7986CB)),

                // First Row: Text Input and Mic
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 16),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.mic_none,
                            color: Colors.lightBlue, size: 28),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // Second Row: Action Icons
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera_alt_outlined,
                            color: Colors.lightBlue, size: 26),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.videocam_outlined,
                            color: Colors.lightBlue, size: 28),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.attachment_outlined,
                            color: Colors.lightBlue, size: 26),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
