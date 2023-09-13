import 'package:tasklist/interfaces/Itaskrepository.dart';
import 'package:tasklist/interfaces/igroupreposotory.dart';
import '../data/model/groupmodel.dart';
import '../data/repositories/grouprepository.dart';
import '../data/repositories/taskrepository.dart';

class GroupService {
  IGroupRepository groupRepository = GroupRepository();
  ITaskRepository taskRepository = TaskRepository();

  Future<void> insertTask(Group group) async {
    await groupRepository.insert(group);
  }

  Future<List<Group>> getGroups() async {
    return await groupRepository.get();
  }

  Future<bool> toogleStatusGroups(Group group) async {
    group.status = group.status == 0 ? 1 : 0;
    return await groupRepository.update(group);
  }

  Future<bool> delGroup(int id) async {
    if (await taskRepository.checkGroupInUse(id)) {
      return false;
    } else {
      await groupRepository.delete(id);
      return true;
    }
  }
}
