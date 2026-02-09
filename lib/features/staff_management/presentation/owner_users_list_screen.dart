import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/branding/colors.dart';

class OwnerUsersListScreen extends StatelessWidget {
  const OwnerUsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("USER MANAGEMENT")),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Failed to load users",
                  style: TextStyle(color: AppColors.textGrey)),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data!.docs
              .map((d) => {'id': d.id, ...d.data()})
              .toList();
          if (users.isEmpty) {
            return const Center(
              child: Text("No users found",
                  style: TextStyle(color: AppColors.textGrey)),
            );
          }
          return ListView.separated(
            itemCount: users.length,
            separatorBuilder: (_, __) =>
                const Divider(color: AppColors.cardGrey, height: 1),
            itemBuilder: (context, index) {
              final user = users[index];
              final isBanned = (user['isBanned'] ?? false) as bool;
              final name = (user['name'] ?? 'User') as String;
              final balance = user['balance']?.toString() ?? '0';

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      isBanned ? AppColors.errorRed : AppColors.surfaceBlack,
                  child: Icon(Icons.person,
                      color: isBanned ? Colors.white : AppColors.textGrey),
                ),
                title: Text(name,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(user['id'] as String,
                    style: const TextStyle(color: AppColors.textGrey)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text("Wallet",
                            style: TextStyle(
                                color: AppColors.textGrey, fontSize: 10)),
                        Text("INR $balance",
                            style:
                                const TextStyle(color: AppColors.successGreen)),
                      ],
                    ),
                    const SizedBox(width: 12),
                    PopupMenuButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      color: AppColors.cardGrey,
                      onSelected: (value) async {
                        final userId = user['id'] as String;
                        if (value == 'ban') {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .update({'isBanned': !isBanned});
                        } else if (value == 'wallet') {
                          _showWalletDialog(context, userId, balance);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'ban',
                          child: Text(isBanned ? "Unban User" : "Ban User",
                              style: TextStyle(
                                  color: isBanned
                                      ? AppColors.successGreen
                                      : AppColors.errorRed)),
                        ),
                        const PopupMenuItem(
                          value: 'wallet',
                          child: Text("Adjust Wallet",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showWalletDialog(
      BuildContext context, String userId, String currentBalance) {
    final controller = TextEditingController(text: currentBalance);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardGrey,
        title: const Text("Adjust Wallet",
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "New Balance"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("CANCEL")),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .update({'balance': controller.text.trim()});
              if (context.mounted) Navigator.pop(ctx);
            },
            child: const Text("SAVE",
                style: TextStyle(color: AppColors.fairRed)),
          ),
        ],
      ),
    );
  }
}
