import '../model/groupmodel.dart';

class Task {
  int? idTask;
  int fkGroup;
  String description;
  DateTime enddate;
  String priority;
  int status;
  Group? group;

  Task(
      {this.idTask,
      required this.fkGroup,
      required this.description,
      required this.enddate,
      required this.priority,
      required this.status,
      this.group});

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      idTask: map['id_task'],
      fkGroup: map['fk_group'],
      description: map['tk_description'],
      enddate: DateTime.parse(map['tk_enddate']),
      priority: map['tk_priority'],
      status: map['tk_status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_task': idTask,
      'fk_group': fkGroup,
      'tk_description': description,
      'tk_enddate': enddate.toIso8601String(),
      'tk_priority': priority,
      'tk_status': status,
    };
  }
}
