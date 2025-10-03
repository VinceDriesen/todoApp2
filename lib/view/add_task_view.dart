import 'package:flutter/material.dart';
import 'package:todoapp2/data/model/task_priority.dart';

class AddTaskView extends StatelessWidget {
  const AddTaskView({super.key, required this.addTask});
  final Future<void> Function(String, String?, TaskPriority) addTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add task')),
      body: TaskForm(addTask: addTask),
    );
  }
}

class TaskForm extends StatefulWidget {
  TaskForm({super.key, required this.addTask});

  final Future<void> Function(String, String?, TaskPriority) addTask;

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final textController = TextEditingController();
  final descriptionController = TextEditingController();
  TaskPriority _selectedPriority = TaskPriority.low; // Default value

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: 'Naam van de taak'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: 'Beschrijving van de taak',
            ),
          ),
          const SizedBox(height: 20),
          DropdownButton<TaskPriority>(
            value: _selectedPriority,
            onChanged: (TaskPriority? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedPriority = newValue;
                });
              }
            },
            items: TaskPriority.values.map((TaskPriority priority) {
              return DropdownMenuItem<TaskPriority>(
                value: priority,
                child: Text(priority.name),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              widget.addTask(
                textController.text,
                descriptionController.text,
                _selectedPriority,
              );
              Navigator.of(context).pop();
            },
            child: const Text('Save Task'),
          ),
        ],
      ),
    );
  }
}
