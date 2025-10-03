import 'package:flutter/material.dart';
import '../data/model/todolist.dart';
import '../data/dao/todolist_dao.dart';
import '../service/navigator.dart';
import '../view/todolist_view.dart';

class TodolistsViewModel extends ChangeNotifier {
  final NavigatorService _navigatorService;
  List<TodoList> todoLists = [];
  final TodoListDao dao = TodoListDao();

  TodolistsViewModel(this._navigatorService) {
    loadTodoLists();
  }

  Future<void> loadTodoLists() async {
    todoLists = await dao.getLists();
    notifyListeners();
  }

  Future<void> addTodoList(String listName) async {
    final existingList = await dao.getListByName(listName);
    if (existingList != null) {
      return;
    }
    final list = TodoList(name: listName);
    await dao.insertList(list);
    await loadTodoLists();
  }

  Future<void> removeTodoList(TodoList list) async {
    if (list.id == null) {
      return;
    }
    await dao.deleteList(list.id!);
    await loadTodoLists();
  }

  Future<void> updateTodoList(TodoList updatedList) async {
    if (updatedList.id == null) return;
    await dao.updateList(updatedList);
    await loadTodoLists();
  }

  List<TodoList> getTodoLists() {
    return todoLists;
  }

  void onListDeleted() async {
    await loadTodoLists();
  }

  void gotoTodoList(TodoList todoList) {
    _navigatorService.navigate(
      TodolistView(
        todoList: todoList,
        onListDeleted: onListDeleted, // Pass callback
      ),
    );
  }
}
