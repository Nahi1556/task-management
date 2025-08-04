import 'package:flutter/material.dart';
import '../models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskModel? task;
  final int? taskIndex;

  const AddTaskScreen({super.key, this.task, this.taskIndex});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  DateTime dueDate = DateTime.now();
  String priority = 'Low';
  String type = 'Work';

  final List<String> priorities = ['Low', 'Medium', 'High'];
  final List<String> types = ['Work', 'Personal', 'School'];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      title = widget.task!.title;
      description = widget.task!.description;
      dueDate = widget.task!.dueDate;
      priority = widget.task!.priority;
      type = widget.task!.type;
    }
  }

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newTask = TaskModel(
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
        type: type,
        status: _getStatusFromDate(dueDate),
      );

      Navigator.pop(context, {
        'task': newTask,
        'index': widget.taskIndex,
      });
    }
  }

  String _getStatusFromDate(DateTime date) {
    final today = DateTime.now();
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'today';
    } else if (date.isAfter(today)) {
      return 'upcoming';
    } else {
      return 'completed';
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != dueDate) {
      setState(() {
        dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Task" : "Add Task"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(labelText: 'Task Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
                onSaved: (value) => title = value!,
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onSaved: (value) => description = value ?? '',
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Due Date: ${dueDate.day}/${dueDate.month}/${dueDate.year}",
                    style: TextStyle(fontSize: 16),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: _pickDate,
                    child: Text("Pick Date"),
                  ),
                ],
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: priority,
                decoration: InputDecoration(labelText: 'Priority'),
                items: priorities
                    .map((level) =>
                        DropdownMenuItem(value: level, child: Text(level)))
                    .toList(),
                onChanged: (value) => setState(() => priority = value!),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: type,
                decoration: InputDecoration(labelText: 'Task Type'),
                items: types
                    .map((cat) =>
                        DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => setState(() => type = value!),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitTask,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.all(16)),
                child: Text(isEditing ? "Update Task" : "Save Task"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
