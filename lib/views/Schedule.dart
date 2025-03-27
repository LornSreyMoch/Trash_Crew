import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trash_crew/controllers/schedule_controller.dart';
import 'package:trash_crew/models/schedule_model.dart';
import 'package:trash_crew/views/HomeScreen.dart';
import 'package:trash_crew/views/history.dart';

enum RecurringPickupOption { oneDay, oneWeek, twoWeeks, oneMonth, oneYear }

final SchedulePickupController _pickupController = SchedulePickupController();

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  DateTime selectedDate = DateTime.now();
  List<String> selectedWasteTypes = [];
  TextEditingController dateController = TextEditingController();
  TextEditingController wasteTypeController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  final List<String> wasteTypes = [
    "Paper",
    "Plastic",
    "Metal",
    "Glass",
    "Electronic",
  ];

  RecurringPickupOption? selectedRecurringOption;

  // Function to show Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  // Function to handle Waste Type Selection Dialog
  Future<void> _selectWasteTypes(BuildContext context) async {
    final List<String>? selected = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          wasteTypes: wasteTypes,
          selectedWasteTypes: List.from(selectedWasteTypes),
        );
      },
    );

    if (selected != null) {
      setState(() {
        selectedWasteTypes = selected;
        wasteTypeController.text = selected.join(', ');
      });
    }
  }

  // Function to schedule Pickup
  Future<void> _schedulePickup() async {
    try {
      final weightValue =
          double.tryParse(weightController.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;

      await _pickupController.schedulePickup(
        userId: '1',
        date: selectedDate.toIso8601String(),
        wasteTypes: selectedWasteTypes,
        estimateWeight: weightValue,
        recurring: selectedRecurringOption != null,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pickup scheduled successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to schedule pickup: $e')),
      );
    }
  }

  // Widget for recurring pickup radio buttons
  Widget _buildRadioOption(RecurringPickupOption option, String text) {
    return RadioListTile<RecurringPickupOption>(
      title: Text(
        text,
        style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
      ),
      value: option,
      groupValue: selectedRecurringOption,
      onChanged: (RecurringPickupOption? value) {
        setState(() {
          selectedRecurringOption = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Schedule Pickup',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PickupHistoryScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Pickup History',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Date Picker
            const Text(
              "Select Date",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: dateController,
              readOnly: true,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: "MM/DD/YYYY",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ),
              ),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 15),

            // Waste Type Selection
            const Text(
              "Waste Type (Multiple Selection)",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: wasteTypeController,
              readOnly: true,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: "Select Waste Types",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ),
              ),
              onTap: () => _selectWasteTypes(context),
            ),
            const SizedBox(height: 15),

            // Weight Input
            const Text(
              "Estimate Weight",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: "Enter weight in kg",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Recurring Pickup Section
            const Text(
              "Recurring Pickup",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            _buildRadioOption(RecurringPickupOption.oneDay, "1 Day"),
            _buildRadioOption(RecurringPickupOption.oneWeek, "1 Week"),
            _buildRadioOption(RecurringPickupOption.twoWeeks, "2 Weeks"),
            _buildRadioOption(RecurringPickupOption.oneMonth, "1 Month"),
            _buildRadioOption(RecurringPickupOption.oneYear, "1 Year"),

            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: 350,
                child: ElevatedButton(
                  onPressed: _schedulePickup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Schedule Pickup',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MultiSelectDialog extends StatefulWidget {
  final List<String> wasteTypes;
  final List<String> selectedWasteTypes;

  MultiSelectDialog({
    required this.wasteTypes,
    required this.selectedWasteTypes,
  });

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> selectedWasteTypes = List.from(widget.selectedWasteTypes);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        'Select Waste Types',
        style: TextStyle(color: Colors.black87),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: widget.wasteTypes.map((wasteType) {
            return CheckboxListTile(
              title: Text(
                wasteType,
                style: const TextStyle(color: Colors.black87),
              ),
              value: selectedWasteTypes.contains(wasteType),
              onChanged: (bool? selected) {
                setState(() {
                  selected!
                      ? selectedWasteTypes.add(wasteType)
                      : selectedWasteTypes.remove(wasteType);
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(selectedWasteTypes);
          },
          child: const Text('OK', style: TextStyle(color: Colors.black87)),
        ),
      ],
    );
  }
}