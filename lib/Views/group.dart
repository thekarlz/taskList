import 'package:flutter/material.dart';
import '../data/model/groupmodel.dart';
import '../services/groupservice.dart';
import '../components/snackbar.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final GroupService _groupsService = GroupService();

  final TextEditingController groupNameController = TextEditingController();
  List<Group> listGroups = [];

  Future<void> _loadGroups() async {
    final lgroups = await _groupsService.getGroups();
    setState(() {
      listGroups = lgroups;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserir Grupo'),
      ),
      body: WillPopScope(
        onWillPop: () async => true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  maxLength: 20,
                  controller: groupNameController,
                  decoration: const InputDecoration(
                      counterText: '', labelText: 'Nome do Grupo'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    final groupName = groupNameController.text;
                    final group = Group(description: groupName, status: 0);
                    await _groupsService.insertTask(group);

                    _loadGroups();
                  },
                  child: const Text('Salvar'),
                ),
                const Divider(),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: listGroups.length,
                    itemBuilder: (context, index) {
                      final groups = listGroups[index];
                      return Card(
                        child: ListTile(
                          leading: IconButton(
                            icon: groups.status == 0
                                ? const Icon(
                                    Icons.lock_open,
                                  )
                                : const Icon(
                                    Icons.lock,
                                  ),
                            onPressed: () async {
                              final res = await _groupsService
                                  .toogleStatusGroups(groups);
                              if (res) {
                                snackbar(context,
                                    msg: 'Status do grupo alterado');
                                _loadGroups();
                              } else {
                                snackbar(context,
                                    msg: 'erro ao modifical grupo');
                              }
                            },
                          ),
                          title: Text(groups.description),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                            ),
                            onPressed: () async {
                              final res = await _groupsService
                                  .delGroup(groups.idGroup!);
                              if (res) {
                                _loadGroups();
                              } else {
                                snackbar(context,
                                    msg:
                                        'Grupo em uso, não é possivel excluir.');
                              }
                            },
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
