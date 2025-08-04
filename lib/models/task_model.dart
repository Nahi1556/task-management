class TaskModel {
  final String title;
  final String description;
  final DateTime dueDate;
  final String priority;
  final String type;

  // ❗️Modified: status is no longer final so we can update it
  String status; // 'today', 'upcoming', 'completed'

  TaskModel({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.type,
    required this.status,
  });
}
