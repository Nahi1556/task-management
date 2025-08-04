import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';
import '../models/task_model.dart';
import '../screens/add_task_screen.dart';
import '../screens/calendar_screen.dart';
import '../screens/export_screen.dart';
import '../screens/profile_screen.dart';
import '../widgets/bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String selectedFilter = 'all';
  String searchQuery = '';
  bool isSearching = false;

  List<TaskModel> allTasks = [
    TaskModel(
      title: 'Meeting with team',
      description: 'Discuss next sprint tasks',
      dueDate: DateTime.now(),
      priority: 'High',
      type: 'Work',
      status: 'today',
    ),
    
     TaskModel(
      title: 'Mobile APP course training',
      description: 'Working on project',
      dueDate: DateTime.now(),
      priority: 'High',
      type: 'Work',
      status: 'today',
    ),
     TaskModel(
      title: 'Shopping',
      description: 'To BY Fruit and Vegetables',
      dueDate: DateTime.now(),
      priority: 'Low',
      type: 'Work',
      status: 'today',
    ),
  ];

  void _addNewTask() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddTaskScreen(),
    );

    if (result != null && result['task'] != null) {
      setState(() {
        allTasks.add(result['task']);
      });
    }
  }

  List<TaskModel> get filteredTasks {
    final filtered = selectedFilter == 'all'
        ? allTasks
        : allTasks.where((task) => task.status == selectedFilter).toList();

    if (searchQuery.isEmpty) return filtered;

    return filtered.where((task) =>
        task.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
  }

  void _showTodayTaskNotification() async {
    final todayTasks = allTasks.where((task) {
      final now = DateTime.now();
      return task.dueDate.year == now.year &&
          task.dueDate.month == now.month &&
          task.dueDate.day == now.day;
    }).toList();

    final String message = todayTasks.isEmpty
        ? "You have no tasks due today."
        : "You have ${todayTasks.length} task(s) due today.";

    const androidDetails = AndroidNotificationDetails(
      'task_reminders',
      'Task Reminders',
      channelDescription: 'Daily task notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Task Reminder',
      message,
      notificationDetails,
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabTapped,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: isSearching
          ? TextField(
              autofocus: true,
              decoration: const InputDecoration(hintText: "Search tasks..."),
              onChanged: (val) => setState(() => searchQuery = val),
            )
          : const Text("TaskFlow", style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        IconButton(
          icon: Icon(isSearching ? Icons.close : Icons.search),
          onPressed: () {
            setState(() {
              isSearching = !isSearching;
              if (!isSearching) searchQuery = '';
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: _showTodayTaskNotification,
        ),
        GestureDetector(
          onTap: () => setState(() => _currentIndex = 3),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text("NJ", style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ],
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.black87,
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildFilterTabs(),
            Expanded(child: _buildTaskList()),
          ],
        );
      case 1:
        return CalendarScreen(tasks: allTasks);
      case 2:
        return ExportScreen(tasks: allTasks);
      case 3:
        return const ProfileScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("My Tasks", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text("You have ${filteredTasks.length} tasks shown", style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _tabButton("All Tasks", selectedFilter == 'all'),
          _tabButton("Today", selectedFilter == 'today'),
          _tabButton("Upcoming", selectedFilter == 'upcoming'),
          _tabButton("Completed", selectedFilter == 'completed'),
        ],
      ),
    );
  }

  Widget _tabButton(String title, bool selected) {
    final value = title.toLowerCase().replaceAll(' ', '');
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: OutlinedButton(
        onPressed: () => setState(() {
          selectedFilter = value == 'alltasks' ? 'all' : value;
        }),
        style: OutlinedButton.styleFrom(
          backgroundColor: selected ? Colors.blue : Colors.white,
          foregroundColor: selected ? Colors.white : Colors.black,
        ),
        child: Text(title),
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            color: Colors.red,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            setState(() => allTasks.remove(task));
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Task deleted')));
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(task.title),
              subtitle: Text(task.description),
              trailing: Text(task.type),
              leading: Checkbox(
                value: task.status == 'completed',
                onChanged: (checked) {
                  setState(() {
                    task.status = checked!
                        ? 'completed'
                        : _getStatusFromDate(task.dueDate);
                  });
                },
              ),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddTaskScreen(
                      task: task,
                      taskIndex: allTasks.indexOf(task),
                    ),
                  ),
                );
                if (result != null && result['task'] != null) {
                  setState(() => allTasks[result['index']] = result['task']);
                }
              },
            ),
          ),
        );
      },
    );
  }

  String _getStatusFromDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'today';
    } else if (date.isAfter(now)) {
      return 'upcoming';
    } else {
      return 'completed';
    }
  }
}
