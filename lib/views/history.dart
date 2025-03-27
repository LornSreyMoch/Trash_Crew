import 'package:flutter/material.dart';
import 'package:trash_crew/controllers/history_controller.dart';
import 'package:trash_crew/models/history_model.dart';

class PickupHistoryScreen extends StatefulWidget {
  @override
  _PickupHistoryScreenState createState() => _PickupHistoryScreenState();
}

class _PickupHistoryScreenState extends State<PickupHistoryScreen> {
  late Future<List<ScheduledPickup>> scheduledPickups;

  @override
  void initState() {
    super.initState();
    scheduledPickups = PickupHistoryController.fetchScheduledPickups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Pickup History',
        style: TextStyle(fontSize: 20, color: Colors.white)),
        backgroundColor: const Color(0xFF41A317), // Updated color
      ),
      body: FutureBuilder<List<ScheduledPickup>>(
        future: scheduledPickups,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No scheduled pickups found'));
          }

          final pickups = snapshot.data!;
          return ListView.builder(
            itemCount: pickups.length,
            itemBuilder: (context, index) {
              final pickup = pickups[index];
              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(
                    Icons.local_shipping,
                    color: Color(0xFF41A317), // Updated color
                  ),
                  title: Text(
                    'Pickup ID: ${pickup.pickupId}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${pickup.date.toLocal()}'.split(' ')[0]),
                      Text('Waste Types: ${pickup.wasteTypes.join(", ")}'),
                      Text('Estimated Weight: ${pickup.estimateWeight} kg'),
                      Text(
                        'Status: ${pickup.status}',
                        style: TextStyle(
                          color: pickup.status == 'Scheduled'
                              ? Colors.orange
                              : const Color(0xFF41A317), // Updated color
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}