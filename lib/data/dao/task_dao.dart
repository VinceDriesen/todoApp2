import '../database/app_database.dart';
import '../model/task.dart';

class TaskDao {
  Future<int> insertTask(Task task) async {
    final db = await AppDatabase.instance.database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasksByList(int listId) async {
    final db = await AppDatabase.instance.database;
    final result = await db.query(
      'tasks',
      where: 'listId = ?',
      whereArgs: [listId],
    );
    return result.map((map) => Task.fromMap(map)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await AppDatabase.instance.database;
    print(task.isDone);
    print("HUUUUUUUUUUUUUUu");
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await AppDatabase.instance.database;

    final result = await db.query('tasks', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return 0;
    final taskToDelete = Task.fromMap(result.first);
    final listId = taskToDelete.listId;
    final volgorde = taskToDelete.volgorde;

    final deleted = await db.delete('tasks', where: 'id = ?', whereArgs: [id]);

    final tasksToUpdate = await db.query(
      'tasks',
      where: 'listId = ? AND volgorde > ?',
      whereArgs: [listId, volgorde],
    );

    for (final map in tasksToUpdate) {
      final task = Task.fromMap(map);
      final updatedTask = task.copyWith(volgorde: task.volgorde - 1);
      await db.update(
        'tasks',
        updatedTask.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
    }

    return deleted;
  }
}
