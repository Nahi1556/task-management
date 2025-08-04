import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/task_model.dart';

class CalendarScreen extends StatefulWidget {
  final List<TaskModel> tasks;

  const CalendarScreen({Key? key, required this.tasks}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Map<DateTime, List<TaskModel>> taskMap;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    taskMap = {};

    for (var task in widget.tasks) {
      final dateKey = DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
      taskMap[dateKey] = (taskMap[dateKey] ?? [])..add(task);
    }
  }

  List<TaskModel> _getTasksForDay(DateTime day) {
    final dateKey = DateTime(day.year, day.month, day.day);
    return taskMap[dateKey] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final tasksToday = _getTasksForDay(_selectedDay!);

    return Column(
      children: [
        TableCalendar<TaskModel>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: CalendarFormat.month,
          eventLoader: _getTasksForDay,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          calendarStyle: CalendarStyle(
            markerDecoration: BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Tasks on ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: tasksToday.isEmpty
              ? Center(child: Text("🎉 No tasks on this day"))
              : ListView.builder(
                  itemCount: tasksToday.length,
                  itemBuilder: (context, index) {
                    final task = tasksToday[index];
                    return ListTile(
                      leading: Icon(Icons.check_circle_outline, color: Colors.blue),
                      title: Text(task.title),
                      subtitle: Text(task.description),
                      trailing: Text(task.priority),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
