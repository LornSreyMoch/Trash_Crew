import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  DateTime today = DateTime.now();
  String? selectedTime;
  String? selectedWasteType;
  String? hoveredTime;
  String? hoveredWasteType;

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  void _onTimeSelected(String time) {
    setState(() {
      selectedTime = time;
    });
    print("Selected Time: $selectedTime");
  }

  void _onWasteTypeSelected(String type) {
    setState(() {
      selectedWasteType = type;
    });
    print("Selected Waste Type: $selectedWasteType");
  }

  void _onTimeHovered(String? time) {
    setState(() {
      hoveredTime = time;
    });
  }

  void _onWasteTypeHovered(String? type) {
    setState(() {
      hoveredWasteType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _calendarContainer(today, _onDaySelected),
            SizedBox(height: 5),
            SelectableTimeList(
              onTimeSelected: _onTimeSelected,
              onTimeHovered: _onTimeHovered,
              selectedTime: selectedTime,
              hoveredTime: hoveredTime,
            ),
            SizedBox(height: 5),
            WasteTypeSelector(
              onWasteTypeSelected: _onWasteTypeSelected,
              onWasteTypeHovered: _onWasteTypeHovered,
              selectedWasteType: selectedWasteType,
              hoveredWasteType: hoveredWasteType,
            ),
            SizedBox(height: 20),
            _buildSchedulePickupButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSchedulePickupButton() {
    bool isButtonEnabled = selectedTime != null && selectedWasteType != null;

    return MouseRegion(
      onEnter: (_) => setState(() {}),
      onExit: (_) => setState(() {}),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isButtonEnabled ? Colors.white : Colors.grey[300],
          side: BorderSide(
            color: isButtonEnabled ? Colors.green : Colors.grey,
            width: 2,
          ),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed:
            isButtonEnabled
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Pickup Scheduled for $selectedTime with $selectedWasteType',
                        ),
                      ),
                    );
                  }
                : null,
        child: Text(
          'Schedule Pickup',
          style: TextStyle(
            fontSize: 20,
            color: isButtonEnabled ? Colors.green : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.green,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Image.asset('assets/icons/left.png', width: 24, height: 24),
            onPressed: () {},
          ),
          Text(
            'Schedule',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _calendarContainer(
    DateTime today,
    Function(DateTime, DateTime) onDaySelected,
  ) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Container(
        height: 420,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(85, 158, 158, 158),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        padding: EdgeInsets.all(5),
        child: TableCalendar(
          selectedDayPredicate: (day) => isSameDay(day, today),
          focusedDay: today,
          firstDay: DateTime.utc(2020, 12, 18),
          lastDay: DateTime.utc(2030, 12, 18),
          onDaySelected: onDaySelected,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class SelectableTimeList extends StatelessWidget {
  final Function(String) onTimeSelected;
  final Function(String?) onTimeHovered;
  final String? selectedTime;
  final String? hoveredTime;

  const SelectableTimeList({
    Key? key,
    required this.onTimeSelected,
    required this.onTimeHovered,
    required this.selectedTime,
    required this.hoveredTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> times = [
      '9:00 AM',
      '10:00 AM',
      '11:00 AM',
      '2:00 PM',
      '3:00 PM',
    ];

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Time',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: times.map((time) {
                return MouseRegion(
                  onEnter: (_) => onTimeHovered(time),
                  onExit: (_) => onTimeHovered(null),
                  child: GestureDetector(
                    onTap: () => onTimeSelected(time),
                    child: TimeItem(
                      time: time,
                      isSelected: selectedTime == time,
                      isHovered: hoveredTime == time,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class TimeItem extends StatelessWidget {
  final String time;
  final bool isSelected;
  final bool isHovered;

  const TimeItem({
    super.key,
    required this.time,
    required this.isSelected,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.green
            : isHovered
                ? Colors.grey[200]
                : Colors.white,
        border: Border.all(
          color: isSelected ? Colors.green : Colors.black,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      height: 45,
      width: 105,
      padding: EdgeInsets.all(10),
      child: Center(
        child: Text(
          time,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class WasteTypeSelector extends StatelessWidget {
  final Function(String) onWasteTypeSelected;
  final Function(String?) onWasteTypeHovered;
  final String? selectedWasteType;
  final String? hoveredWasteType;

  const WasteTypeSelector({
    Key? key,
    required this.onWasteTypeSelected,
    required this.onWasteTypeHovered,
    required this.selectedWasteType,
    required this.hoveredWasteType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> wasteTypes = [
      'Plastic',
      'Metal',
      'Paper',
      'Glass',
      'Electronic',
    ];

    return Padding(
      padding: EdgeInsets.only(right: 65),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Text(
            'Select Waste Type',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 5,
            runSpacing: 5,
            children: wasteTypes.map((type) {
              return MouseRegion(
                onEnter: (_) => onWasteTypeHovered(type),
                onExit: (_) => onWasteTypeHovered(null),
                child: GestureDetector(
                  onTap: () => onWasteTypeSelected(type),
                  child: WasteTypeItem(
                    type: type,
                    isSelected: selectedWasteType == type,
                    isHovered: hoveredWasteType == type,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class WasteTypeItem extends StatelessWidget {
  final String type;
  final bool isSelected;
  final bool isHovered;

  WasteTypeItem({
    super.key,
    required this.type,
    required this.isSelected,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.green
            : isHovered
                ? Colors.grey[200]
                : Colors.white,
        border: Border.all(
          color: isSelected ? Colors.green : Colors.black,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      height: 45,
      width: 120,
      child: Center(
        child: Text(
          type,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
