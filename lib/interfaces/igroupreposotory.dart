import 'package:tasklist/data/model/groupmodel.dart';

abstract class IGroupRepository {
  Future<List<Group>> get();
  Future<void> insert(Group group);
  Future<bool> update(Group group);
  Future<bool> delete(int id);
}
