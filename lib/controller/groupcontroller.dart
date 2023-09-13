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
}
