// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:trash_crew/controllers/schedule_controller.dart';
// import 'package:trash_crew/models/schedule_model.dart';

// class Schedule extends StatefulWidget {
//   const Schedule({super.key});

//   @override
//   State<Schedule> createState() => _ScheduleState();
// }

// class _ScheduleState extends State<Schedule> {
//   DateTime today = DateTime.now();
//   String? selectedTime;
//   String? selectedWasteType;
//   String? hoveredTime;
//   String? hoveredWasteType;

//   final SchedulePickupController _schedulepickupcontroller = SchedulePickupController();

//   void _onDaySelected(DateTime day, DateTime focusedDay) {
//     setState(() {
//       today = day;
//     });
//   }

//   void _onTimeSelected(String time) {
//     setState(() {
//       selectedTime = time;
//     });
//     print("Selected Time: $selectedTime");
//   }

//   void _onWasteTypeSelected(String type) {
//     setState(() {
//       selectedWasteType = type;
//     });
//     print("Selected Waste Type: $selectedWasteType");
//   }

//   void _onTimeHovered(String? time) {
//     setState(() {
//       hoveredTime = time;
//     });
//   }

//   void _onWasteTypeHovered(String? type) {
//     setState(() {
//       hoveredWasteType = type;
//     });
//   }

//   Future<void> _schedulepickupcontroller() async {
//     if (selectedTime != null && selectedWasteType != null) {
//       final pickupRequest = PickupRequest(
//         date: today,
//         wasteTypes: [selectedWasteType!],
//         estimateWeight: 0, // Set the estimate weight as needed
//         recurring: true, // Set the recurring flag as needed
//       );

//       await _schedulepickupcontroller.SchedulePickupController(pickupRequest);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Pickup Scheduled for $selectedTime with $selectedWasteType',
//           ),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Please select both time and waste type.'),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _appBar(),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             _calendarContainer(today, _onDaySelected),
//             SizedBox(height: 5),
//             SelectableTimeList(
//               onTimeSelected: _onTimeSelected,
//               onTimeHovered: _onTimeHovered,
//               selectedTime: selectedTime,
//               hoveredTime: hoveredTime,
//             ),
//             SizedBox(height: 5),
//             WasteTypeSelector(
//               onWasteTypeSelected: _onWasteTypeSelected,
//               onWasteTypeHovered: _onWasteTypeHovered,
//               selectedWasteType: selectedWasteType,
//               hoveredWasteType: hoveredWasteType,
//             ),
//             SizedBox(height: 20),
//             _buildSchedulePickupButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSchedulePickupButton() {
//     bool isButtonEnabled = selectedTime != null && selectedWasteType != null;

//     return MouseRegion(
//       onEnter: (_) => setState(() {}),
//       onExit: (_) => setState(() {}),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: isButtonEnabled ? Colors.white : Colors.grey[300],
//           side: BorderSide(
//             color: isButtonEnabled ? Colors.green : Colors.grey,
//             width: 2,
//           ),
//           padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         onPressed: isButtonEnabled ? _schedulePickup : null,
//         child: Text(
//           'Schedule Pickup',
//           style: TextStyle(
//             fontSize: 20,
//             color: isButtonEnabled ? Colors.green : Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   AppBar _appBar() {
//     return AppBar(
//       backgroundColor: Colors.green,
//       elevation: 0,
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           IconButton(
//             icon: Image.asset('assets/icons/left.png', width: 24, height: 24),
//             onPressed: () {},
//           ),
//           Text(
//             'Schedule',
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(width: 24),
//         ],
//       ),
//     );
//   }

//   Widget _calendarContainer(
//     DateTime today,
//     Function(DateTime, DateTime) onDaySelected,
//   ) {
//     return Padding(
//       padding: EdgeInsets.all(15),
//       child: Container(
//         height: 420,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(
//               color: const Color.fromARGB(85, 158, 158, 158),
//               spreadRadius: 2,
//               blurRadius: 5,
//             ),
//           ],
//         ),
//         padding: EdgeInsets.all(5),
//         child: TableCalendar(
//           selectedDayPredicate: (day) => isSameDay(day, today),
//           focusedDay: today,
//           firstDay: DateTime.utc(2020, 12, 18),
//           lastDay: DateTime.utc(2030, 12, 18),
//           onDaySelected: onDaySelected,
//           headerStyle: HeaderStyle(
//             formatButtonVisible: false,
//             titleCentered: true,
//             titleTextStyle: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           calendarStyle: CalendarStyle(
//             todayDecoration: BoxDecoration(
//               color: Colors.blue,
//               shape: BoxShape.circle,
//             ),
//             selectedDecoration: BoxDecoration(
//               color: Colors.green,
//               shape: BoxShape.circle,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SelectableTimeList extends StatelessWidget {
//   final Function(String) onTimeSelected;
//   final Function(String?) onTimeHovered;
//   final String? selectedTime;
//   final String? hoveredTime;

//   const SelectableTimeList({
//     Key? key,
//     required this.onTimeSelected,
//     required this.onTimeHovered,
//     required this.selectedTime,
//     required this.hoveredTime,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     List<String> times = [
//       '9:00 AM',
//       '10:00 AM',
//       '11:00 AM',
//       '2:00 PM',
//       '3:00 PM',
//     ];

//     return Padding(
//       padding: const EdgeInsets.all(15),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Select Time',
//             style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 5),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: times.map((time) {
//                 return MouseRegion(
//                   onEnter: (_) => onTimeHovered(time),
//                   onExit: (_) => onTimeHovered(null),
//                   child: GestureDetector(
//                     onTap: () => onTimeSelected(time),
//                     child: TimeItem(
//                       time: time,
//                       isSelected: selectedTime == time,
//                       isHovered: hoveredTime == time,
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TimeItem extends StatelessWidget {
//   final String time;
//   final bool isSelected;
//   final bool isHovered;

//   const TimeItem({
//     super.key,
//     required this.time,
//     required this.isSelected,
//     required this.isHovered,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
//       decoration: BoxDecoration(
//         color: isSelected
//             ? Colors.green
//             : isHovered
//                 ? Colors.grey[200]
//                 : Colors.white,
//         border: Border.all(
//           color: isSelected ? Colors.green : Colors.black,
//           width: 1,
//         ),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       height: 45,
//       width: 105,
//       padding: EdgeInsets.all(10),
//       child: Center(
//         child: Text(
//           time,
//           style: TextStyle(
//             fontSize: 16,
//             color: isSelected ? Colors.white : Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class WasteTypeSelector extends StatelessWidget {
//   final Function(String) onWasteTypeSelected;
//   final Function(String?) onWasteTypeHovered;
//   final String? selectedWasteType;
//   final String? hoveredWasteType;

//   const WasteTypeSelector({
//     Key? key,
//     required this.onWasteTypeSelected,
//     required this.onWasteTypeHovered,
//     required this.selectedWasteType,
//     required this.hoveredWasteType,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     List<String> wasteTypes = [
//       'Plastic',
//       'Metal',
//       'Paper',
//       'Glass',
//       'Electronic',
//     ];

//     return Padding(
//       padding: EdgeInsets.only(right: 65),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Select Waste Type',
//             style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 5),
//           Wrap(
//             alignment: WrapAlignment.start,
//             spacing: 5,
//             runSpacing: 5,
//             children: wasteTypes.map((type) {
//               return MouseRegion(
//                 onEnter: (_) => onWasteTypeHovered(type),
//                 onExit: (_) => onWasteTypeHovered(null),
//                 child: GestureDetector(
//                   onTap: () => onWasteTypeSelected(type),
//                   child: WasteTypeItem(
//                     type: type,
//                     isSelected: selectedWasteType == type,
//                     isHovered: hoveredWasteType == type,
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class WasteTypeItem extends StatelessWidget {
//   final String type;
//   final bool isSelected;
//   final bool isHovered;

//   WasteTypeItem({
//     super.key,
//     required this.type,
//     required this.isSelected,
//     required this.isHovered,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//       decoration: BoxDecoration(
//         color: isSelected
//             ? Colors.green
//             : isHovered
//                 ? Colors.grey[200]
//                 : Colors.white,
//         border: Border.all(
//           color: isSelected ? Colors.green : Colors.black,
//           width: 1,
//         ),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       height: 45,
//       width: 120,
//       child: Center(
//         child: Text(
//           type,
//           style: TextStyle(
//             fontSize: 16,
//             color: isSelected ? Colors.white : Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trash_crew/controllers/schedule_controller.dart';
import 'package:trash_crew/models/schedule_model.dart';
import 'package:trash_crew/views/HomeScreen.dart';

enum RecurringPickupOption { oneDay, oneWeek, twoWeeks, oneMonth, oneYear }

final SchedulePickupController _pickupController = SchedulePickupController();

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  DateTime selectedDate = DateTime.now();
  List<String> selectedWasteTypes = [];
  String selectedWeightUnit = "(kg)";
  bool recurringMonth = false;
  bool recurringWeek = false;
  bool recurringDay = false;
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
          double.tryParse(
            weightController.text.replaceAll(RegExp(r'[^0-9.]'), ''),
          ) ??
          0.0;

      final _ = await _pickupController.schedulePickup(
        userId: '1',
        date: selectedDate.toIso8601String(),
        wasteTypes: selectedWasteTypes,
        estimateWeight: weightValue,
        recurring: recurringMonth || recurringWeek || recurringDay,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Pickup scheduled successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to schedule pickup: $e')));
    }
  }

  // Widget for recurring pickup radio buttons
  Widget _buildRadioOption(RecurringPickupOption option, String text) {
    return RadioListTile<RecurringPickupOption>(
      title: Text(
        text,
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
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
      backgroundColor: Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                const Text(
                  'Schedule Pickup',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                // Pickup History Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4CAF50),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: dateController,
              readOnly: true,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: "MM/DD/YYYY",
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 15),

            // Waste Type Selection
            const Text(
              "Waste Type (Multiple Selection)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: wasteTypeController,
              readOnly: true,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: "Select Waste Types",
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
              onTap: () => _selectWasteTypes(context),
            ),
            const SizedBox(height: 15),

            // Weight Input
            const Text(
              "Estimate Weight",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: "Enter weight in kg",
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
            ),
            const SizedBox(height: 20),

            // Recurring Pickup Section
            const Text(
              "Recurring Pickup",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            _buildRadioOption(RecurringPickupOption.oneDay, "1 Day"),
            _buildRadioOption(RecurringPickupOption.oneWeek, "1 Week"),
            _buildRadioOption(RecurringPickupOption.twoWeeks, "2 Weeks"),
            _buildRadioOption(RecurringPickupOption.oneMonth, "1 Month"),
            _buildRadioOption(RecurringPickupOption.oneYear, "1 Year"),

            const SizedBox(height: 30),
            Center(
              child: Container(
                width: 350,
                child: ElevatedButton(
                  onPressed: _schedulePickup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4CAF50),
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
                style: TextStyle(color: Colors.black87),
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
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }
}

