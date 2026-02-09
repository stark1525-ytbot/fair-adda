import 'package:flutter/material.dart';
import '../../core/utils/icons.dart';

class DepositLimitScreen extends StatefulWidget {
  const DepositLimitScreen({super.key});

  @override
  State<DepositLimitScreen> createState() => _DepositLimitScreenState();
}

class _DepositLimitScreenState extends State<DepositLimitScreen> {
  // Initial values based on your screenshot
  double monthlyLimit = 6000000;
  double weeklyLimit = 1000000;
  double dailyLimit = 80000;
  bool isAgreed = false;

  // Max constraints based on the text in the UI
  final double maxMonthly = 6000000;
  final double maxWeekly = 1000000;
  final double maxDaily = 120000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C), // Deep red
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Deposit Limit',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Know More',
                  style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildLimitCard(
                    title: "Your Monthly Limit",
                    description:
                        "You are allowed to add up to ₹${maxMonthly.toInt()} per month.",
                    currentValue: monthlyLimit,
                    max: maxMonthly,
                    onChanged: (val) => setState(() => monthlyLimit = val),
                  ),
                  const SizedBox(height: 16),
                  _buildLimitCard(
                    title: "Set Your Weekly Limit",
                    description:
                        "You are allowed to add up to ₹${maxWeekly.toInt()} per week.",
                    currentValue: weeklyLimit,
                    max: maxWeekly,
                    onChanged: (val) => setState(() => weeklyLimit = val),
                  ),
                  const SizedBox(height: 16),
                  _buildLimitCard(
                    title: "Set Your Daily Limit",
                    description:
                        "You are allowed to add up to ₹${maxDaily.toInt()} per day.",
                    currentValue: dailyLimit,
                    max: maxDaily,
                    onChanged: (val) => setState(() => dailyLimit = val),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.red),
                        child: Checkbox(
                          value: isAgreed,
                          activeColor: Colors.red,
                          side: const BorderSide(color: Colors.red, width: 2),
                          onChanged: (val) => setState(() => isAgreed = val!),
                        ),
                      ),
                      const Text("I agree to ",
                          style: TextStyle(color: Colors.white)),
                      const Text(
                        "Terms and Conditions",
                        style: TextStyle(
                            color: Colors.red,
                            decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Fixed Bottom Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFB71C1C),
            child: TextButton(
              onPressed: isAgreed
                  ? () {
                      // Action here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Deposit limits updated successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  : null,
              child: const Text(
                'Set Limit',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLimitCard({
    required String title,
    required String description,
    required double currentValue,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 4),
          Text(description,
              style: TextStyle(color: Colors.grey[400], fontSize: 13)),
          const SizedBox(height: 20),
          const Divider(color: Colors.white10),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "₹ ${currentValue.toInt()}/-",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        onChanged((currentValue - 1000).clamp(0, max)),
                    icon: const Icon(Icons.remove_circle_outline,
                        color: Colors.grey),
                  ),
                  IconButton(
                    onPressed: () =>
                        onChanged((currentValue + 1000).clamp(0, max)),
                    icon: const Icon(Icons.add_circle_outline,
                        color: Colors.grey),
                  ),
                ],
              )
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.red,
              inactiveTrackColor: Colors.grey[800],
              thumbColor: Colors.white,
              trackHeight: 4,
              overlayShape: SliderComponentShape.noOverlay,
            ),
            child: Slider(
              value: currentValue,
              min: 0,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
