import 'package:flutter/material.dart';
import 'package:tasklist/data/model/taskmodel.dart';

import '../components/listadetarefas.dart';
import '../controller/maincontroller.dart';
import 'task.dart';

class ListTask extends StatefulWidget {
  const ListTask({super.key, required this.title});
  final String title;

  @override
  State<ListTask> createState() => _ListTaskState();
}

class _ListTaskState extends State<ListTask> {
  late MainCrontroller mainCrontroller;
  List<Task> ltasks = [];
  @override
  void initState() {
    super.initState();
    mainCrontroller = MainCrontroller();
    start();
  }

  start() async {
    await mainCrontroller.loadTasks();
    setState(() {
      mainCrontroller = mainCrontroller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: 'Mostra/Ocultar Excluidos',
            onPressed: () async {
              mainCrontroller.filtroConcluidos();
              await mainCrontroller.loadTasks();
              setState(() {
                mainCrontroller = mainCrontroller;
              });
            },
            icon: mainCrontroller.finish
                ? const Icon(Icons.radio_button_off)
                : const Icon(Icons.check_circle_outline_outlined),
          ),
          PopupMenuButton<String>(
            tooltip: 'Selecionar Grupo',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: mainCrontroller.prioritySelected == 'Todas'
                  ? const Icon(Icons.label_off_outlined)
                  : const Icon(Icons.label),
            ),
            onSelected: (String newValue) async {
              mainCrontroller.prioritySelected = newValue;
              await mainCrontroller.loadTasks();
              setState(() {
                mainCrontroller = mainCrontroller;
              });
            },
            itemBuilder: (BuildContext context) =>
                mainCrontroller.popUpMenuItems,
          ),
          IconButton(
            tooltip: 'Selecionar Data',
            onPressed: () {
              showDatePicker(
                locale: const Locale('pt', 'BR'),
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(DateTime.now().year - 5),
                lastDate: DateTime(DateTime.now().year + 5),
              ).then((DateTime? value) async {
                if (value != null) {
                  mainCrontroller.fromDate = value;
                } else {
                  mainCrontroller.fromDate = null;
                }
                await mainCrontroller.loadTasks();
                setState(() {
                  mainCrontroller = mainCrontroller;
                });
              });
            },
            icon: mainCrontroller.fromDate != null
                ? const Icon(Icons.calendar_month)
                : const Icon(Icons.calendar_today),
          ),
          IconButton(
            onPressed: () {
              mainCrontroller.toggleGroup();
              setState(() {
                mainCrontroller = mainCrontroller;
              });
            },
            icon: mainCrontroller.ingroup
                ? const Icon(Icons.list)
                : const Icon(Icons.line_weight_sharp),
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () async => true,
        child: SingleChildScrollView(
          child: mainCrontroller.listTasks.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Voce não possui task atualmente!',
                      ),
                    ],
                  ),
                )
              : mainCrontroller.ingroup == true
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: mainCrontroller.listGroups.length,
                      itemBuilder: (BuildContext context, int i) {
                        List<Task> temp = mainCrontroller.listTasks.toList();
                        temp.removeWhere((element) =>
                            element.fkGroup !=
                            mainCrontroller.listGroups[i].idGroup);
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Card(
                              color: Colors.grey[700],
                              child: Center(
                                child: Text(
                                  mainCrontroller.listGroups[i].description,
                                  style: const TextStyle(
                                      fontSize: 24, color: Colors.white),
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: temp.length,
                              itemBuilder: (context, index) {
                                final task = temp[index];

                                return Card(
                                  child: listadetarefas(
                                      task, mainCrontroller.taskService, () {
                                    mainCrontroller.loadTasks();
                                    setState(() {
                                      mainCrontroller = mainCrontroller;
                                    });
                                  }),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: mainCrontroller.listTasks.length,
                      itemBuilder: (context, index) {
                        final task = mainCrontroller.listTasks[index];
                        return Card(
                          child: listadetarefas(
                              task, mainCrontroller.taskService, () {
                            mainCrontroller.loadTasks();
                            setState(() {
                              mainCrontroller = mainCrontroller;
                            });
                          }),
                        );
                      },
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskScreen(),
            ),
          );
          await mainCrontroller.loadTasks();
          setState(() {
            mainCrontroller = mainCrontroller;
          });
        },
        tooltip: 'Criar Nova Tarefa',
        child: const Icon(Icons.add),
      ),
    );
  }
}
