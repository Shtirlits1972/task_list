import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_list/ItemTask.dart';
import 'package:task_list/repoData.dart';

import 'ItemTaskCrud.dart';

class CenterListWidget extends StatefulWidget {
  const CenterListWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<CenterListWidget> createState() => _CenterListWidgetState();
}

class _CenterListWidgetState extends State<CenterListWidget> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Column(
      children: [
        Expanded(
          flex: 1,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            const Expanded(
              flex: 8,
              child: Text('Tasks',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  context.read<RepoData>().setVisible(true);
                },
                icon: const Icon(Icons.add),
              ),
            )
          ]),
        ),
        Expanded(
          child: Visibility(
            replacement: const SizedBox.shrink(),
            //  maintainSize: false,
            // maintainAnimation: true,
            visible: context.watch<RepoData>().getVisible,
            child: TextField(
              controller: controller,
              onEditingComplete: () async {
                ItemTaskCrud crud = ItemTaskCrud();
                int id = await crud.add(controller.text);
                ItemTask itemTask = ItemTask.create(id, controller.text, false);
                context.read<RepoData>().addTask(itemTask);
                context.read<RepoData>().setVisible(false);
              },
              decoration: const InputDecoration(
                hintText: 'Enter text of task',
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 3)),
              ),
            ),
          ),
          flex: 1,
        ),
        Expanded(
          flex: 10,
          child: Container(
            color: Colors.white,
            child: Center(
              child: ListView(
                children: _buildList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
//   MediaQuery.of(context).size.width

  List<Widget> _buildList() {
    ItemTaskCrud crud = ItemTaskCrud();
    return context
        .watch<RepoData>()
        .getTaskList
        .map(
          (ItemTask f) => Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Colors.blueGrey,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Are you shure? ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 30),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      print('yes');
                                      crud.del(f.id);
                                      context.read<RepoData>().delTask(f.id);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('yes')),
                                TextButton(
                                    onPressed: () {
                                      print('no');
                                      Navigator.pop(context);
                                    },
                                    child: const Text('no')),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );

                  print('delete id = ${f.id}');
                },
              ),
              title: Text(f.TextTask),
              //  subtitle: Text(f.symbol),
              leading: Checkbox(
                  value: f.IsExec,
                  onChanged: (bool? newValue) async {
                    setState(() {
                      f.IsExec = newValue!;
                    });
                    await crud.edit(f.id, f.TextTask, f.IsExec);
                    print('Id = ${f.id} ');
                  }),
            ),
          ),
        )
        .toList();
  }

  _loadItemTasks() async {
    ItemTaskCrud crud = ItemTaskCrud();
    List<ItemTask> list = await crud.getAll();
    context.read<RepoData>().setTasksList(list);
  }

  @override
  void initState() {
    ItemTaskCrud crud = ItemTaskCrud();
    crud.init();

    super.initState();
    _loadItemTasks();
  }
}
