import 'package:flutter/material.dart';
import 'package:tasklist/controller/groupcontroller.dart';
import '../data/model/groupmodel.dart';
import '../components/snackbar.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  GroupController groupController = GroupController();

  @override
  void initState() {
    super.initState();
    start();
  }

  start() async {
    await groupController.loadGroups();
    setState(() {
      groupController = groupController;
    });
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
                  controller: groupController.groupNameController,
                  decoration: const InputDecoration(
                      counterText: '', labelText: 'Nome do Grupo'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    await groupController.insertGroup();
                    await groupController.loadGroups();
                    setState(() {
                      groupController = groupController;
                    });
                  },
                  child: const Text('Salvar'),
                ),
                const Divider(),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: groupController.listGroups.length,
                    itemBuilder: (context, index) {
                      final groups = groupController.listGroups[index];
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
                              final res = await groupController.groupsService
                                  .toogleStatusGroups(groups);
                              if (res) {
                                snackbar(context,
                                    msg: 'Status do grupo alterado');
                                groupController.loadGroups();
                                setState(() {
                                  groupController = groupController;
                                });
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
                              final res = await groupController.groupsService
                                  .delGroup(groups.idGroup!);
                              if (res) {
                                groupController.loadGroups();
                                setState(() {
                                  groupController = groupController;
                                });
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
