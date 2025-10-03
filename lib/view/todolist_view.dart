import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add this if using provider
import '../data/model/todolist.dart';
import '../viewmodel/todolist_viewmodel.dart'; // Import your viewmodel
import '../service/navigator.dart';

class TodolistView extends StatelessWidget {
  const TodolistView({
    super.key,
    required this.todoList,
    required this.onListDeleted,
  });
  final TodoList todoList;
  final VoidCallback onListDeleted;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          TodolistViewModel(todoList, NavigatorService.instance, onListDeleted),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Todo List: ${todoList.name}'),
          actions: [
            Consumer<TodolistViewModel>(
              builder: (context, viewModel, child) {
                return IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    viewModel.removeTodoList(todoList);
                  },
                );
              },
            ),
          ],
        ),
        body: Consumer<TodolistViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.getTodos().isEmpty) {
              return const Center(child: Text('Geen taken'));
            }
            return ReorderableListView.builder(
              onReorder: (oldIndex, newIndex) {
                print('Old index: $oldIndex, New index: $newIndex');
                viewModel.reorderTasks(oldIndex, newIndex);
              },
              itemCount: viewModel.getTodos().length,
              itemBuilder: (context, index) {
                final task = viewModel.getTodos()[index];
                return InkWell(
                  key: ValueKey(task.volgorde),
                  onTap: () {
                    viewModel.gotoTask(task);
                  },
                  child: ListTile(
                    title: Row(
                      children: [
                        Checkbox(
                          value: task.isDone,
                          onChanged: (value) {
                            viewModel.changeIsDone(task);
                          },
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(task.title),
                              Row(
                                children: [
                                  Text('Priority: '),
                                  Text(task.priority.toString().split('.')[1]),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),

        floatingActionButton: Consumer<TodolistViewModel>(
          builder: (context, viewModel, child) {
            return FloatingActionButton(
              onPressed: () {
                viewModel.gotoAddTask();
              },
              child: const Icon(Icons.add),
            );
          },
        ),
        bottomNavigationBar: Consumer<TodolistViewModel>(
          builder: (context, viewModel, child) {
            return BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('Remove all done'),
                  onPressed: () {
                    viewModel.removeAllDoneTasks();
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
