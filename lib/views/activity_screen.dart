import 'package:flutter/material.dart';
import 'package:trash_crew/controllers/activity_controller.dart';
import 'package:trash_crew/models/activity_model.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final ActivityController _activityController = ActivityController();
  late Future<List<Activity>> _activities;

  @override
  void initState() {
    super.initState();
    _activities = _activityController.fetchActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Activity')),
      body: FutureBuilder<List<Activity>>(
        future: _activities,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No activities found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final activity = snapshot.data![index];
                return ListTile(
                  title: Text(activity.title),
                  subtitle: Text(activity.description),
                );
              },
            );
          }
        },
      ),
    );
  }
}
