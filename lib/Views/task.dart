import 'package:flutter/material.dart';
import 'package:tasklist/components/snackbar.dart';
import 'package:tasklist/data/model/groupmodel.dart';
import 'package:tasklist/Views/group.dart';
import 'package:tasklist/services/groupservice.dart';
import 'package:tasklist/services/taskservice.dart';
import '../data/model/taskmodel.dart';
import 'package:intl/intl.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  final GroupService _groupsService = GroupService();
  final TaskService _taskService = TaskService();

  int _selectedGroupId = 0;
  List<Group> listGroups = [];

  String _selectedPriority = 'Normal';
  final List<String> _selectedOptions = ['Baixa', 'Normal', 'Alta'];

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        _timeController.text = pickedTime.format(context);
      });
    }
  }

  Future<void> _loadGroups() async {
    final lgroups = await _groupsService.getGroups();
    if (lgroups.isEmpty) {
      _selectedGroupId = 0;
      lgroups.add(Group(description: 'Cadastrar', status: 0, idGroup: 0));
    } else {
      lgroups.removeWhere((element) => element.status == 1);
      _selectedGroupId = 1;
      listGroups = lgroups;
    }
    setState(() {
      listGroups = lgroups;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadGroups();
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
                controller: _descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Descrição da Tarefa'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Data de Vencimento',
                ),
                onTap: () {
                  _selectDate(context);
                },
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _timeController,
                decoration:
                    const InputDecoration(labelText: 'Hora de Vencimento'),
                onTap: () {
                  _selectTime(context);
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value!;
                  });
                },
                items: _selectedOptions
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
                value: _selectedGroupId,
                onChanged: (value) {
                  setState(() {
                    _selectedGroupId = value!;
                  });
                },
                items: listGroups
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
                      _loadGroups();
                    },
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () async {
                  // Obtenha os valores dos campos de texto
                  final description = _descriptionController.text;
                  final priority = _selectedPriority;
                  final enddateDate = _selectedDate;
                  final enddateTime = _selectedTime;
                  final groupid = _selectedGroupId;

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

                  await _taskService.insertTask(task);
                  Navigator.pop(context);
                },
                child: Text('Inserir Tarefa'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
