import 'package:flutter/material.dart';
import '../../../../core/branding/colors.dart';

void showEmergencyActions(BuildContext context, String matchId) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surfaceBlack,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("EMERGENCY ACTIONS", style: TextStyle(color: AppColors.errorRed, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Match ID: $matchId", style: const TextStyle(color: AppColors.textGrey)),
            const Divider(color: AppColors.cardGrey),
            const SizedBox(height: 16),
            
            _ActionTile(
              icon: Icons.pause, 
              title: "Pause Match", 
              color: AppColors.warningOrange,
              onTap: () { /* API call to pause */ Navigator.pop(context); }
            ),
            _ActionTile(
              icon: Icons.cancel, 
              title: "Cancel & Refund All", 
              color: AppColors.errorRed,
              onTap: () { 
                // Show confirmation dialog before executing
                Navigator.pop(context); 
              }
            ),
            _ActionTile(
              icon: Icons.refresh, 
              title: "Regenerate Room Password", 
              color: Colors.blue,
              onTap: () { /* API call */ Navigator.pop(context); }
            ),
          ],
        ),
      );
    },
  );
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({required this.icon, required this.title, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}