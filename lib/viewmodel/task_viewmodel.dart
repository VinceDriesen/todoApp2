import 'package:flutter/material.dart';
import 'package:todoapp2/data/dao/task_dao.dart';
import 'package:todoapp2/data/model/task_priority.dart';
import '../data/model/task.dart';
import '../service/navigator.dart';

class TaskViewModel extends ChangeNotifier {
  Task _task;
  TaskDao taskDao = TaskDao();

  TaskViewModel(this._task);

  String get title => _task.title;
  set title(String value) {
    if (value.trim().isEmpty) {
      value = "New Task";
    }
    _task = _task.copyWith(title: value);
    notifyListeners();
  }

  TaskPriority get priority => _task.priority;
  set priority(TaskPriority value) {
    _task = _task.copyWith(priority: value);
    notifyListeners();
  }

  String get description => _task.description;
  set description(String value) {
    _task = _task.copyWith(description: value);
    notifyListeners();
  }

  bool get isDone => _task.isDone;
  set isDone(bool value) {
    print("isDone set to $value");
    _task = _task.copyWith(isDone: value);
    notifyListeners();
  }

  void save() {
    taskDao.updateTask(_task);
  }
}
