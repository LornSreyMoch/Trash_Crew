import 'package:flutter/material.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  final List<RewardItem> rewards = [
    RewardItem("Cash Voucher", "\$10", 500),
    RewardItem("Shopping Discount", "20% OFF", 1000),
    RewardItem("Free Pickup", "1 Service", 250),
    RewardItem("Eco-friendly Product", "Gift Box", 750),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const RewardHeader(points: 1234),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Available Rewards",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          Expanded(child: RewardList(rewards: rewards)),
        ],
      ),
    );
  }
}

class RewardHeader extends StatelessWidget {
  final int points;

  const RewardHeader({super.key, required this.points});

  String formatPoints(int points) {
    return points.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 20, left: 16, right: 16),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.green,
      
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
          Column(
            children: [
              Text(
                formatPoints(points),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Available Points",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RewardItem {
  final String title;
  final String subtitle;
  final int points;

  RewardItem(this.title, this.subtitle, this.points);
}

class RewardList extends StatelessWidget {
  final List<RewardItem> rewards;

  const RewardList({super.key, required this.rewards});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        return RewardCard(reward: rewards[index]);
      },
    );
  }
}

class RewardCard extends StatelessWidget {
  final RewardItem reward;

  const RewardCard({super.key, required this.reward});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.card_giftcard, color: Colors.green, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reward.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${reward.subtitle}\n${reward.points} points",
                    style: const TextStyle(color: Colors.green, fontSize: 14),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: const Text("Redeem"),
            ),
          ],
        ),
      ),
    );
  }
}
