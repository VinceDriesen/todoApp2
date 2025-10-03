import 'package:flutter/material.dart';
import '../data/model/todolist.dart';
import '../viewmodel/todolists_viewmodel.dart';
import 'package:provider/provider.dart';

class TodolistsView extends StatelessWidget {
  const TodolistsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo Lists')),
      body: const Center(child: TodoLists()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (dialogContext) => PopUpMenu());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PopUpMenu extends StatelessWidget {
  PopUpMenu({super.key});

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<TodolistsViewModel>(); // werkt nu
    return AlertDialog(
      title: const Text('Nieuwe lijst toevoegen'),
      content: TextField(
        controller: textController,
        decoration: const InputDecoration(hintText: 'Naam van de lijst'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            viewModel.addTodoList(textController.text);
            Navigator.of(context).pop();
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}

class TodoLists extends StatelessWidget {
  const TodoLists({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodolistsViewModel>(
      builder: (context, viewModel, child) {
        final lists = viewModel.todoLists;
        print(lists);
        return ListView.builder(
          itemCount: lists.length,
          itemBuilder: (context, index) {
            final todoList = lists[index];
            return TodoListTile(todoList: todoList);
          },
        );
      },
    );
  }
}

class TodoListTile extends StatelessWidget {
  final TodoList todoList;
  const TodoListTile({super.key, required this.todoList});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<TodolistsViewModel>().gotoTodoList(todoList);
      },
      child: Ink(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: ListTile(title: Text(todoList.name)),
      ),
    );
  }
}
