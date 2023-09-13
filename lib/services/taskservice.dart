import 'package:tasklist/data/repositories/grouprepository.dart';
import 'package:tasklist/data/repositories/taskrepository.dart';
import 'package:tasklist/interfaces/Itaskrepository.dart';
import 'package:tasklist/interfaces/igroupreposotory.dart';
import '../data/model/taskmodel.dart';

class TaskService {
  ITaskRepository taskRepository = TaskRepository();
  IGroupRepository groupRepository = GroupRepository();
  Future<void> insertTask(Task task) async {
    await taskRepository.insert(task);
  }

  Future<void> toogleTaskStatus(Task task) async {
    task.status = task.status == 0 ? 1 : 0;
    await taskRepository.update(task);
  }

  Future<List<Task>> getfilter(String w, List a) async {
    var tasks = await taskRepository.getfilter(w, a);
    final groups = await groupRepository.get();
    for (var element in tasks) {
      for (final el in groups) {
        if (el.idGroup == element.fkGroup) {
          element.group = el;
        }
      }
    }
    return tasks;
  }

  Future<List<Task>> getTasks() async {
    var tasks = await taskRepository.get();
    final groups = await groupRepository.get();
    for (var element in tasks) {
      for (final el in groups) {
        if (el.idGroup == element.fkGroup) {
          element.group = el;
        }
      }
    }
    return tasks;
  }
}
