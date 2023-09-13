import 'package:tasklist/interfaces/igroupreposotory.dart';

import '../model/groupmodel.dart';
import '../local/databasemanager.dart';

class GroupRepository implements IGroupRepository {
  final databaseManager = DatabaseManager();

  Future<List<Group>> get() async {
    final db = await databaseManager.database;
    final groups = await db!.query('groups');
    return groups.map((groupMap) => Group.fromMap(groupMap)).toList();
  }

  Future<void> insert(Group group) async {
    final db = await databaseManager.database;
    print(db!.insert('groups', group.toMap()));
  }

  Future<bool> update(Group group) async {
    final db = await databaseManager.database;
    final res = await db!.update(
      'groups',
      group.toMap(),
      where: 'id_group = ?',
      whereArgs: [group.idGroup],
    );
    return res == 0 ? false : true;
  }

  Future<bool> delete(int id) async {
    final db = await databaseManager.database;
    final res = await db!.delete(
      'groups',
      where: 'id_group = ?',
      whereArgs: [id],
    );
    return res == 0 ? false : true;
  }
}
