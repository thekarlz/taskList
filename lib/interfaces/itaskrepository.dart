import '../data/model/taskmodel.dart';

abstract class ITaskRepository {
  Future<List<Task>> get();
  Future<void> insert(Task task);
  Future<void> update(Task task);
  Future<void> delete(int id);
  Future<bool> checkGroupInUse(idgroup);
  Future<List<Task>> getfilter(String where, List args);
}
