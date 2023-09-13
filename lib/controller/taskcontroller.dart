import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasklist/data/model/groupmodel.dart';
import 'package:tasklist/services/groupservice.dart';
import 'package:tasklist/services/taskservice.dart';

class TaskController {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  final GroupService groupsService = GroupService();
  final TaskService taskService = TaskService();

  int selectedGroupId = 0;
  List<Group> listGroups = [];

  String selectedPriority = 'Normal';
  final List<String> selectedOptions = ['Baixa', 'Normal', 'Alta'];

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      selectedDate = pickedDate;
      dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      selectedTime = pickedTime;
      timeController.text = pickedTime.format(context);
    }
  }

  Future<void> loadGroups() async {
    final lgroups = await groupsService.getGroups();
    if (lgroups.isEmpty) {
      selectedGroupId = 0;
      lgroups.add(Group(description: 'Cadastrar', status: 0, idGroup: 0));
    } else {
      lgroups.removeWhere((element) => element.status == 1);
      selectedGroupId = 1;
      listGroups = lgroups;
    }
  }
}
