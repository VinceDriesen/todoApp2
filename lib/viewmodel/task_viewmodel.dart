import 'package:flutter/material.dart';
import 'package:todoapp2/data/dao/task_dao.dart';
import 'package:todoapp2/data/model/task_priority.dart';
import '../data/model/task.dart';

class TaskViewModel extends ChangeNotifier {
  Task _task;
  TaskDao taskDao = TaskDao();

  TaskViewModel(this._task);

  String get title => _task.title;
  set title(String value) {
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
    _task = _task.copyWith(isDone: value);
    notifyListeners();
  }

  void save() {
    // print(title);

    taskDao.updateTask(_task);

    // Save to database or API
  }
}
