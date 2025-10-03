import 'package:flutter/material.dart';
import '../data/model/task.dart';
import '../viewmodel/task_viewmodel.dart';
import 'package:provider/provider.dart';
import '../data/model/task_priority.dart';

class TaskView extends StatelessWidget {
  final Task task;

  const TaskView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskViewModel(task),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(title: Text(task.title)),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<TaskViewModel>(
              builder: (context, viewModel, _) {
                return Column(
                  children: [
                    FormTitle(viewModel: viewModel),
                    FormDescription(viewModel: viewModel),
                    IsTaskDone(viewModel: viewModel),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class IsTaskDone extends StatefulWidget {
  const IsTaskDone({super.key, required this.viewModel});

  final TaskViewModel viewModel;

  @override
  State<IsTaskDone> createState() => _IsTaskDoneState();
}

class _IsTaskDoneState extends State<IsTaskDone> {
  late TaskPriority _selectedPriority;

  @override
  void initState() {
    super.initState();
    _selectedPriority = widget.viewModel.priority;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black54, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text("Done: "),
                Checkbox(
                  value: widget.viewModel.isDone,
                  onChanged: (value) {
                    setState(() {
                      widget.viewModel.isDone = value!;
                    });
                    widget.viewModel.save();
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text("Priority: "),
                DropdownButton<TaskPriority>(
                  value: _selectedPriority,
                  onChanged: (TaskPriority? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedPriority = newValue;
                        widget.viewModel.priority = newValue;
                      });
                      widget.viewModel.save();
                    }
                  },
                  items: TaskPriority.values.map((TaskPriority priority) {
                    return DropdownMenuItem<TaskPriority>(
                      value: priority,
                      child: Text(priority.name),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FormTitle extends StatelessWidget {
  const FormTitle({super.key, required this.viewModel});
  final TaskViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FocusTraversalGroup(
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 60, // Adjust height as needed
              child: TextFormField(
                initialValue: viewModel.title,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                style: const TextStyle(fontSize: 16),
                onChanged: (value) {
                  viewModel.title = value;
                  Form.of(primaryFocus!.context!).save();
                },
                onSaved: (_) => viewModel.save(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FormDescription extends StatelessWidget {
  const FormDescription({super.key, required this.viewModel});
  final TaskViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FocusTraversalGroup(
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 150, // Adjust height as needed
              child: TextFormField(
                initialValue: viewModel.description,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                style: const TextStyle(fontSize: 16),
                keyboardType: TextInputType.multiline,
                maxLines: null, // Allows unlimited lines
                expands: true, // Fills parent height, enables scrolling
                onChanged: (value) {
                  viewModel.description = value;
                  Form.of(primaryFocus!.context!).save();
                },
                onSaved: (_) => viewModel.save(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
