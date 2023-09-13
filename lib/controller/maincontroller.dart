import 'package:flutter/material.dart';
import '../data/model/groupmodel.dart';
import '../data/model/taskmodel.dart';
import '../services/groupservice.dart';
import '../services/taskService.dart';

enum Priority {
  Baixa,
  Normal,
  Alta,
}

class MainCrontroller {
  final GroupService groupsService = GroupService();
  final TaskService taskService = TaskService();
  bool ingroup = true;

  List<Task> listTasks = [];
  List<Group> listGroups = [];
  List<Priority> selectedPriorities = [];
  String prioritySelected = 'Todas';
  DateTime? fromDate;
  bool finish = false;

  Future<void> loadTasks() async {
    String where = '';
    List args = [];
    List<Task> ltasks = [];

    if (finish) {
      where = ' tk_status = ? ';
      args.add(0);
    }
    if (prioritySelected != 'Todas') {
      where += where != '' ? ' and tk_priority = ? ' : ' tk_priority = ? ';
      args.add(prioritySelected);
    }
    if (fromDate != null) {
      where += where != ''
          ? ' and tk_enddate >= ? and tk_enddate <= ? '
          : ' tk_enddate >= ? and tk_enddate <= ? ';
      var nextDay = fromDate!.add(const Duration(days: 1));
      args.add(fromDate!.toIso8601String());
      args.add(nextDay.toIso8601String());
    }

    if (where != '') {
      ltasks = await taskService.getfilter(where, args);
    } else {
      ltasks = await taskService.getTasks();
    }
    listTasks = ltasks;

    await loadGroups();
  }

  toggleGroup() {
    ingroup = !ingroup;
  }

  Future<void> loadGroups() async {
    final lgroups = await groupsService.getGroups();
    listGroups = lgroups;
  }

  void filtroConcluidos() async {
    finish = !finish;
    await loadTasks();
  }

  static const menuItems = <String>[
    'Baixa',
    'Normal',
    'Alta',
    'Todas',
  ];

  final List<PopupMenuItem<String>> popUpMenuItems = menuItems
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();
}
