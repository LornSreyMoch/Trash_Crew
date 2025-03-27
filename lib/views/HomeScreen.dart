import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:trash_crew/models/point_model.dart';
import 'package:trash_crew/controllers/point_controller.dart';
import 'package:trash_crew/views/Schedule.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PointController _pointsController = PointController();

  late Future<List<Points>> _points;

  @override
  void initState() {
    super.initState();
    _points = _pointsController.fetchPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Hello, Alex',
                            style: TextStyle(
                              color: Color(0xFF059B53),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text('👋', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Let's make earth cleaner",
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/icons/bell2.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: AssetImage('assets/images/profile.jpg'),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Green card with points information
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF059B53),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row with Total Points and percentage
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Points',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '+ 12.5%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Points value
                    FutureBuilder<List<Points>>(
                      future: _points,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text(
                            'Loading...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return const Text(
                            'Error',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else if (snapshot.hasData) {
                          final totalPoints = snapshot.data!.fold(
                            0,
                            (sum, point) => sum + point.totalPoints,
                          );
                          return Text(
                            '$totalPoints',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          return const Text(
                            'No Data',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                      },
                    ),

                    // Dollar value
                    FutureBuilder<List<Points>>(
                      future: _points,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text(
                            'Loading...',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          );
                        } else if (snapshot.hasError) {
                          return const Text(
                            'Error',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          );
                        } else if (snapshot.hasData) {
                          final cashEquivalent = snapshot.data!.fold(
                            0.0,
                            (sum, point) => sum + point.cashEquivalent,
                          );
                          return Text(
                            "\$${cashEquivalent.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          );
                        } else {
                          return const Text(
                            'No Data',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    // Chart
                    SizedBox(
                      height: 80,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineTouchData: const LineTouchData(enabled: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 1),
                                FlSpot(2, 2.5),
                                FlSpot(4, 4),
                                FlSpot(6, 2.5),
                                FlSpot(8, 3),
                                FlSpot(10, 4),
                                FlSpot(12, 3),
                              ],
                              isCurved: true,
                              color: Colors.white,
                              barWidth: 2,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      color: Color(0xFF059B53),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Schedule()),
                          );
                        },
                        child: Container(
                          height: 120,
                          width: 200,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 208, 238, 211),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color.fromARGB(255, 78, 255, 78),
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    140,
                                    219,
                                    124,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Image(
                                  image: AssetImage(
                                    'assets/icons/schedule.webp',
                                  ),
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Schedule',
                                style: TextStyle(
                                  color: Color(0xFF059B53),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Text(
                                'Pickup',
                                style: TextStyle(
                                  color: Color(0xFF059B53),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 120,
                        width: 200,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 235, 225, 190),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color.fromARGB(255, 223, 202, 129),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 232, 197, 146),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Image(
                                image: AssetImage('assets/icons/redeem.png'),
                                width: 24,
                                height: 24,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Recycle Now',
                              style: TextStyle(
                                color: Color.fromARGB(255, 211, 184, 86),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Text(
                              'Points',
                              style: TextStyle(
                                color: Color.fromARGB(255, 211, 184, 86),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Added missing closing brackets for the Column widget
              Column(
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween, // Aligns the texts on opposite ends
                    children: [
                      Text(
                        'Recent Activities',
                        style: TextStyle(
                          color: Color(0xFF059B53),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'View All',
                        style: TextStyle(
                          color: Color.fromARGB(255, 24, 45, 200),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 70,
                        width: 480,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 221, 223, 221),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 15),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 140, 219, 124),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Image(
                                image: AssetImage('assets/icons/cup.png'),
                                width: 24,
                                height: 24,
                              ),
                            ),
                            const SizedBox(width: 15),
                            // Texts in a Row for "Plastic Bottle" and "+ 7 points"
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: const [
                                      Text(
                                        'Plastic Bottle',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(width: 100),
                                      Text(
                                        '+ 7 points',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: const [
                                      Text(
                                        '3.5 kg',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(width: 160),
                                      Text(
                                        '2 hours ago',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 6),
                      Container(
                        height: 70,
                        width: 480,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 221, 223, 221),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 15),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 140, 219, 124),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Image(
                                image: AssetImage('assets/icons/cup.png'),
                                width: 24,
                                height: 24,
                              ),
                            ),
                            const SizedBox(width: 15),
                            // Texts in a Row for "Plastic Bottle" and "+ 7 points"
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: const [
                                      Text(
                                        'Plastic Bottle',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(width: 100),
                                      Text(
                                        '+ 7 points',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: const [
                                      Text(
                                        '3.5 kg',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(width: 160),
                                      Text(
                                        '2 hours ago',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 6),
                      Container(
                        height: 70,
                        width: 480,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 221, 223, 221),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 15),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 140, 219, 124),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Image(
                                image: AssetImage('assets/icons/cup.png'),
                                width: 24,
                                height: 24,
                              ),
                            ),
                            const SizedBox(width: 15),
                            // Texts in a Row for "Plastic Bottle" and "+ 7 points"
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: const [
                                      Text(
                                        'Plastic Bottle',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(width: 100),
                                      Text(
                                        '+ 7 points',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: const [
                                      Text(
                                        '3.5 kg',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(width: 160),
                                      Text(
                                        '2 hours ago',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
