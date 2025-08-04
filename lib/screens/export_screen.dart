import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task_model.dart';

class ExportScreen extends StatelessWidget {
  final List<TaskModel> tasks;

  const ExportScreen({Key? key, required this.tasks}) : super(key: key);

  /// Generates export content for the file
  String _generateExportContent() {
    if (tasks.isEmpty) return "No tasks available.";

    final buffer = StringBuffer();
    buffer.writeln("Task List Export:");
    buffer.writeln("=========================");
    for (var task in tasks) {
      buffer.writeln("Title     : ${task.title}");
      buffer.writeln("Description: ${task.description}");
      buffer.writeln("Due Date  : ${_formatDate(task.dueDate)}");
      buffer.writeln("Priority  : ${task.priority}");
      buffer.writeln("Type      : ${task.type}");
      buffer.writeln("Status    : ${task.status}");
      buffer.writeln("-------------------------");
    }
    return buffer.toString();
  }

  /// Formats date nicely
  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  /// Exports tasks to a text file
  Future<void> _exportTasksToFile(BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/exported_tasks.txt';
      final file = File(filePath);

      final content = _generateExportContent();
      await file.writeAsString(content);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ Tasks exported to file:\n$filePath"),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to export tasks: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: Icon(Icons.download),
        label: Text("Export Tasks to File"),
        onPressed: () => _exportTasksToFile(context),
      ),
    );
  }
}
