import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fair_adda/features/league/presentation/league_detail_screen.dart';

class MyLeaguesScreen extends StatelessWidget {
  const MyLeaguesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color brandRed = Color(0xFFC62828); 

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFE0E0E0), // Light grey background
        appBar: AppBar(
          backgroundColor: brandRed,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'My Leagues : TDM',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black87),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            tabs: [
              Tab(text: 'LIVE'),
              Tab(text: 'PAST'),
              Tab(text: 'UPCOMING'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LeagueListContainer(status: 'live'),
            LeagueListContainer(status: 'past'),
            LeagueListContainer(status: 'upcoming'),
          ],
        ),
      ),
    );
  }
}

class LeagueListContainer extends StatelessWidget {
  final String status;
  const LeagueListContainer({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // Filtering Firebase data by status and game type
      stream: FirebaseFirestore.instance
          .collection('leagues')
          .where('type', isEqualTo: 'TDM')
          .where('status', isEqualTo: status)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFC62828)));
        }

        // If no data is found, show the "Empty State" UI from your screenshot
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const EmptyStateWidget();
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data = snapshot.data!.docs[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                title: Text(data['title'] ?? 'League Name'),
                subtitle: Text('Status: ${status.toUpperCase()}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LeagueDetailScreen(
                        leagueId: data.id,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Hey, Please join a league to win and earn.\n'
            'Go to Home, Click Games tab, Select the game you want to play and join a League.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
