import '../database/app_database.dart';
import '../model/todolist.dart';

class TodoListDao {
  Future<int> insertList(TodoList list) async {
    final db = await AppDatabase.instance.database;
    return await db.insert('todolists', list.toMap());
  }

  Future<List<TodoList>> getLists() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('todolists');
    return result.map((map) => TodoList.fromMap(map)).toList();
  }

  Future<TodoList?> getListByName(String name) async {
    final db = await AppDatabase.instance.database;
    final result = await db.query(
      'todolists',
      where: 'name = ?',
      whereArgs: [name],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return TodoList.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<int> deleteList(int id) async {
    final db = await AppDatabase.instance.database;
    return await db.delete('todolists', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateList(TodoList list) async {
    final db = await AppDatabase.instance.database;
    await db.update(
      'todolists',
      list.toMap(),
      where: 'id = ?',
      whereArgs: [list.id],
    );
  }
}
