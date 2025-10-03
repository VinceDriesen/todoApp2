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
  final VoidCallback onListDeleted;
  List<Task> tasks = [];

  TodolistViewModel(
    this._todoList,
    this._navigatorService,
    this.onListDeleted,
  ) {
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
      _navigatorService.goBack();
      await todoDao.deleteList(list.id!);
      print(await todoDao.getLists().then((value) => value.length));
      print("List deleted successfully");
      onListDeleted();
    } catch (e) {
      print("Error deleting list: $e");
    }
  }

  Future<void> addTask(
    String title,
    String? description,
    TaskPriority priority,
  ) async {
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
    // Maak een gesorteerde kopie van de takenlijst
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

  void gotoTask(task) {
    _navigatorService.navigate(TaskView(task: task));
  }

  void removeAllDoneTasks() {
    for (Task task in tasks) {
      if (task.isDone) {
        taskDao.deleteTask(task.id!);
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
}
