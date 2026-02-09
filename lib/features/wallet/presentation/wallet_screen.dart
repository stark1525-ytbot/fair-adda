import 'package:flutter/material.dart';
import '../../../core/utils/icons.dart';
import 'package:go_router/go_router.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Main background
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F), // Darker red
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text("My Wallet & Voucher",
            style: TextStyle(color: Colors.white, fontSize: 18)),
        actions: [
          // Payment History Button
          GestureDetector(
            onTap: () {
              // Navigate to payment history screen
              context.push(
                  '/payment-history'); // Navigate to payment history screen
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Text("Payment History",
                      style: TextStyle(fontSize: 12, color: Colors.white)),
                  SizedBox(width: 5),
                  Icon(AppIcons.history, size: 18, color: Colors.white),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(AppIcons.notification, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Red Header Section (Balance)
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFD32F2F),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Total Balance",
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
                const Text("Rs 0.90",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _balanceBox("Deposited", "0.00"),
                    _balanceBox("Winning", "0.90"),
                    _balanceBox("Bonus", "0.00"),
                  ],
                )
              ],
            ),
          ),

          // 2. Recent Transactions Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF121212),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Recent Transactions",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: () => context.push('/payment-history'),
                  child: const Text("View all",
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ),
              ],
            ),
          ),

          // 3. Scrollable Transaction List
          Expanded(
            child: ListView(
              children: const [
                TransactionTile(
                  amount: "110.0",
                  status: "DEBITED",
                  statusColor: Colors.red,
                  details: "Deposit: 0.00, Winning: 110.00, Bonus: 0.00",
                  desc: "Coins Transfered Successfully!!",
                  date: "31-08-2025 10:17 pm",
                ),
                TransactionTile(
                  amount: "110.0",
                  status: "DEBITED",
                  statusColor: Colors.red,
                  details: "Deposit: 110.00, Winning: 0.00, Bonus: 0.00",
                  desc:
                      "Your Deposit Balance has been transferred to Winning balance.",
                  date: "31-08-2025 04:58 pm",
                ),
                TransactionTile(
                  amount: "110.0",
                  status: "CREDITED",
                  statusColor: Colors.green,
                  details: "Deposit: 0.00, Winning: 110.00, Bonus: 0.00",
                  desc: "Coins received from Deposit Wallet.",
                  date: "31-08-2025 04:58 pm",
                ),
                TransactionTile(
                  amount: "0.0",
                  status: "DEBITED",
                  statusColor: Colors.red,
                  details: "Deposit: 0.00, Winning: 0.00, Bonus: 0.00",
                  desc: "For Playing Callbreak #cb_2ydmemupp3c",
                  date: "22-08-2025 06:44 pm",
                ),
              ],
            ),
          ),

          // 4. Voucher Redemption Section
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF1E1E1E),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Click below to redeem voucher.\nVoucher Code & Pin required to avail the voucher.",
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to redeem voucher screen
                    context.push(
                        '/redeem-voucher'); // Navigate to redeem voucher screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Text("REDEEM\nVOUCHER",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10)),
                )
              ],
            ),
          ),

          // 5. Bottom Action Buttons
          Row(
            children: [
              _bottomActionButton(Icons.add, "ADD", () {
                // Show dialog with both add and withdraw options
                _showTransactionOptionsDialog(context);
              }),
              _bottomActionButton(Icons.account_balance, "WITHDRAW", () {
                // Navigate to withdraw screen
                context.push('/withdraw'); // Add this route if needed
              }),
            ],
          )
        ],
      ),
    );
  }

  // Widget for the balance breakdown boxes
  Widget _balanceBox(String label, String amount) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24, width: 0.5),
        ),
        child: Column(
          children: [
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 11)),
            Text(amount,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Method to show transaction options dialog
  void _showTransactionOptionsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose Transaction Type',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _dialogOption(
                    context,
                    Icons.add,
                    'Add Money',
                    () {
                      Navigator.pop(context);
                      context.push('/add_money');
                    },
                  ),
                  _dialogOption(
                    context,
                    Icons.account_balance,
                    'Withdraw',
                    () {
                      Navigator.pop(context);
                      context.push('/withdraw');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper widget for dialog options
  Widget _dialogOption(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFD32F2F),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for ADD/WITHDRAW buttons
  Widget _bottomActionButton(
      IconData icon, String label, VoidCallback? onPressed) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFD32F2F),
            border: Border.all(color: Colors.black, width: 0.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

// Transaction List Item Component
class TransactionTile extends StatelessWidget {
  final String amount, status, details, desc, date;
  final Color statusColor;

  const TransactionTile({
    super.key,
    required this.amount,
    required this.status,
    required this.statusColor,
    required this.details,
    required this.desc,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 1),
      color: const Color(0xFF1A1A1A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Rs $amount",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              Text(status,
                  style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          Text(details,
              style: const TextStyle(color: Colors.green, fontSize: 11)),
          const SizedBox(height: 4),
          Text(desc,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
          const SizedBox(height: 4),
          Text(date, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }
}
