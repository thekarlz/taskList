import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/model/taskmodel.dart';
import '../services/taskService.dart';

ListTile listadetarefas(Task task, TaskService taskService, func) {
  return ListTile(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('dd/MM/yyyy hh:mm').format(task.enddate),
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
        ),
        Text(task.description),
      ],
    ),
    subtitle: Row(
      children: [
        Container(
          width: 80,
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
              color: task.priority == 'Normal'
                  ? Colors.amber[800]
                  : task.priority == 'Alta'
                      ? Colors.red[900]
                      : Colors.green[900],
              borderRadius: const BorderRadius.all(Radius.circular(500))),
          child: Text(
            task.priority,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8),
          decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: const BorderRadius.all(Radius.circular(50))),
          child: Text(
            'Grupo: ${task.group?.description}',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
      ],
    ),
    trailing: IconButton(
      icon: task.status == 0
          ? const Icon(Icons.circle_outlined)
          : const Icon(Icons.check_circle_outline),
      onPressed: () async {
        await taskService.toogleTaskStatus(task);
        func.call();
      },
    ),
  );
}
