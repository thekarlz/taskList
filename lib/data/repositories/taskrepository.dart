import 'package:tasklist/interfaces/Itaskrepository.dart';
import '../model/taskmodel.dart';
import '../local/databasemanager.dart';

class TaskRepository implements ITaskRepository {
  final databaseManager = DatabaseManager();

  Future<List<Task>> get() async {
    final db = await databaseManager.database;
    final tasks = await db!.query('tasks', orderBy: 'tk_enddate ASC');
    return tasks.map((taskMap) => Task.fromMap(taskMap)).toList();
  }

  Future<List<Task>> getfilter(String where, List args) async {
    final db = await databaseManager.database;
    final tasks = await db!.query('tasks',
        where: where, whereArgs: args, orderBy: 'tk_enddate ASC');
    return tasks.map((taskMap) => Task.fromMap(taskMap)).toList();
  }

  Future<void> insert(Task task) async {
    final db = await databaseManager.database;
    task.idTask = null;
    print(db!.insert('tasks', task.toMap()));
  }

  Future<void> update(Task task) async {
    final db = await databaseManager.database;
    await db!.update(
      'tasks',
      task.toMap(),
      where: 'id_task = ?',
      whereArgs: [task.idTask],
    );
  }

  Future<void> delete(int id) async {
    final db = await databaseManager.database;
    await db!.delete(
      'tasks',
      where: 'id_task = ?',
      whereArgs: [id],
    );
  }

  Future<bool> checkGroupInUse(idgroup) async {
    final db = await databaseManager.database;
    List<Map> result = await db!.rawQuery(
        'SELECT count(fk_group) as qtd FROM tasks WHERE fk_group = ?',
        [idgroup]);
    if (result[0]['qtd'] > 0) {
      return true;
    } else {
      return false;
    }
  }
}
