import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../data/model/todolist.dart';
import '../data/dao/todolist_dao.dart';
import '../service/navigator.dart';
import '../data/model/task.dart';
import '../data/dao/task_dao.dart';
import '../view/add_task_view.dart';
import '../view/task_view.dart';
import '../data/model/task_priority.dart';

class TodolistViewModel extends ChangeNotifier {
  final NavigatorService _navigatorService;
  final TodoList _todoList;
  final TodoListDao todoDao = TodoListDao();
  final TaskDao taskDao = TaskDao();
  List<Task> tasks = [];

  TodolistViewModel(this._todoList, this._navigatorService) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    tasks = await taskDao.getTasksByList(_todoList.id!);
    notifyListeners();
  }

  Future<void> removeTodoList(TodoList list) async {
    print("removeTodoList called");
    if (list.id == null) {
      print("List ID is null, cannot delete");
      return;
    }
    try {
      _navigatorService.goBack(true);
      await todoDao.deleteList(list.id!);
      print(await todoDao.getLists().then((value) => value.length));
      print("List deleted successfully");
    } catch (e) {
      print("Error deleting list: $e");
    }
  }

  Future<void> addTask(
    String title,
    String? description,
    TaskPriority priority,
  ) async {
    if (title.trim().isEmpty) {
      title = "New Task";
    }
    if (_todoList.id == null) {
      print("TodoList ID is null, cannot add task");
      return;
    }
    final newTask = Task(
      title: title,
      isDone: false,
      description: description ?? '',
      listId: _todoList.id!,
      priority: priority,
      volgorde: tasks.length,
    );
    await taskDao.insertTask(newTask);
    await loadTasks();
  }

  List<Task> getTodos() {
    List<Task> sortedTasks = List.from(tasks);
    sortedTasks.sort((a, b) => a.volgorde - b.volgorde);
    return sortedTasks;
  }

  void gotoAddTask() {
    _navigatorService.navigate(AddTaskView(addTask: addTask));
  }

  void changeIsDone(Task todo) {
    print("changeIsDone called");
    Task copyTask = todo.copyWith(isDone: !todo.isDone);
    todo = copyTask;
    taskDao.updateTask(todo);
    loadTasks();
  }

  Future<void> gotoTask(task) async {
    final result = await _navigatorService.navigate<bool>(TaskView(task: task));
    if (result == true) {
      loadTasks();
    }
  }

  void removeAllDoneTasks() {
    for (Task task in tasks) {
      if (task.isDone) {
        this.deleteTask(task);
      }
    }
    loadTasks();
  }

  void reorderTasks(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;

    final task = tasks.removeAt(oldIndex);
    tasks.insert(newIndex, task);

    // werk de volgorde in DB bij
    for (int i = 0; i < tasks.length; i++) {
      tasks[i] = tasks[i].copyWith(volgorde: i);
      await taskDao.updateTask(tasks[i]);
    }

    notifyListeners();
  }

  void deleteTask(Task task) async {
    final deletedOrder = task.volgorde;

    await taskDao.deleteTask(task.id!);

    tasks.removeWhere((t) => t.id == task.id);

    for (var t in tasks) {
      if (t.volgorde > deletedOrder) {
        t = t.copyWith(volgorde: t.volgorde - 1);
        await taskDao.updateTask(t);
      }
    }

    await loadTasks();
    notifyListeners();
  }
}
