import 'package:flutter/material.dart';
import '../data/model/groupmodel.dart';
import '../services/groupservice.dart';

class GroupController {
  final GroupService groupsService = GroupService();
  TextEditingController groupNameController = TextEditingController();

  List<Group> listGroups = [];

  Future<void> loadGroups() async {
    listGroups = await groupsService.getGroups();
  }

  Future<void> insertGroup() async {
    final group = Group(description: groupNameController.text, status: 0);
    await groupsService.insertTask(group);
  }
}
