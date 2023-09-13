import 'package:flutter/material.dart';
import 'package:tasklist/components/snackbar.dart';
import 'package:tasklist/controller/taskcontroller.dart';
import 'package:tasklist/Views/group.dart';
import '../data/model/taskmodel.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  TaskController taskController = TaskController();

  // TextEditingController _descriptionController = TextEditingController();
  // TextEditingController _dateController = TextEditingController();
  // TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    start();
  }

  start() async {
    await taskController.loadGroups();
    setState(() {
      taskController = taskController;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserir Tarefa'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: taskController.descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Descrição da Tarefa'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: taskController.dateController,
                decoration: const InputDecoration(
                  labelText: 'Data de Vencimento',
                ),
                onTap: () async {
                  await taskController.selectDate(context);
                  setState(() {
                    taskController = taskController;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: taskController.timeController,
                decoration:
                    const InputDecoration(labelText: 'Hora de Vencimento'),
                onTap: () async {
                  await taskController.selectTime(context);
                  setState(() {
                    taskController = taskController;
                  });
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: taskController.selectedPriority,
                onChanged: (value) {
                  setState(() {
                    taskController.selectedPriority = value!;
                  });
                },
                items: taskController.selectedOptions
                    .asMap()
                    .map((index, priorityName) => MapEntry(
                          index,
                          DropdownMenuItem<String>(
                            value: priorityName,
                            child: Text(priorityName),
                          ),
                        ))
                    .values
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Prioridade',
                ),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                value: taskController.selectedGroupId,
                onChanged: (value) {
                  taskController.selectedGroupId = value!;
                  setState(() {
                    taskController = taskController;
                  });
                },
                items: taskController.listGroups
                    .asMap()
                    .map((index, group) => MapEntry(
                          index,
                          DropdownMenuItem<int>(
                            value: group.idGroup,
                            child: Text(group.description),
                          ),
                        ))
                    .values
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'Grupo',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupScreen(),
                        ),
                      );
                      await taskController.loadGroups();
                      setState(() {
                        taskController = taskController;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () async {
                  // Obtenha os valores dos campos de texto
                  final description = taskController.descriptionController.text;
                  final priority = taskController.selectedPriority;
                  final enddateDate = taskController.selectedDate;
                  final enddateTime = taskController.selectedTime;
                  final groupid = taskController.selectedGroupId;

                  if (groupid == 0) {
                    snackbar(context, msg: 'Cadastre um grupo para continuar.');
                    return;
                  }
                  if (enddateDate == null ||
                      enddateTime == null ||
                      description == '') {
                    snackbar(context,
                        msg: 'É preciso preencher todos os campos.');
                    return;
                  }

                  final enddate = DateTime(
                    enddateDate.year,
                    enddateDate.month,
                    enddateDate.day,
                    enddateTime.hour,
                    enddateTime.minute,
                  );

                  final task = Task(
                    fkGroup: groupid,
                    description: description,
                    enddate: enddate,
                    priority: priority,
                    status: 0,
                  );

                  await taskController.taskService.insertTask(task);
                  Navigator.pop(context);
                },
                child: const Text('Inserir Tarefa'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    taskController.descriptionController.dispose();
    super.dispose();
  }
}
