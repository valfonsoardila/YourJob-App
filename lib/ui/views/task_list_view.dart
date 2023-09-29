import 'package:flutter/material.dart';

import 'package:yourjobs_app/ui/models/task.dart';
import 'package:yourjobs_app/ui/views/add_task_view.dart';

class TaskListView extends StatefulWidget {
  final uid;
  final profile;
  final tasks;
  const TaskListView({super.key, this.tasks, this.uid, this.profile});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  List<TaskModel> _tasks = [];
  @override
  void initState() {
    _tasks = widget.tasks;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.black)),
          title: Row(
            children: [
              Icon(
                Icons.assignment_turned_in_outlined,
                color: Colors.black,
              ),
              Text('Lista de Tareas', style: TextStyle(color: Colors.black)),
            ],
          )),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ExpansionTile(
                iconColor: Colors.white70,
                initiallyExpanded: false,
                trailing: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                leading: Icon(
                  Icons.assignment,
                  color: Colors.black,
                ),
                title: Text(
                  'Tarea ${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  'Fecha: ${_tasks[index].dueDate}',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Text(
                                  _tasks[index].title,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  _tasks[index].description,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Estado',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                    radius: 12,
                                    backgroundColor:
                                        _tasks[index].status == 'Pendiente'
                                            ? Colors.red
                                            : Colors.grey,
                                    child: _tasks[index].status == 'Pendiente'
                                        ? Icon(
                                            Icons.assignment_late_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          )
                                        : Container()),
                                SizedBox(width: 5),
                                CircleAvatar(
                                    radius: 12,
                                    backgroundColor:
                                        _tasks[index].status == 'En proceso'
                                            ? Colors.orange
                                            : Colors.grey,
                                    child: _tasks[index].status == 'En proceso'
                                        ? Icon(
                                            Icons.access_time_filled_outlined,
                                            color: Colors.white,
                                            size: 20,
                                          )
                                        : Container()),
                                SizedBox(width: 5),
                                CircleAvatar(
                                    radius: 12,
                                    backgroundColor:
                                        _tasks[index].status == 'Completado'
                                            ? Colors.green
                                            : Colors.grey,
                                    child: _tasks[index].status == 'Completado'
                                        ? Icon(
                                            Icons.assignment_turned_in_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          )
                                        : Container()),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _tasks[index].status,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  iconSize: 55,
                                  onPressed: () {},
                                  icon: CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Colors.red,
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  iconSize: 55,
                                  onPressed: () {
                                    var data = _tasks[index];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddTaskView(
                                              opcionView: true,
                                              dataEdit: data,
                                              uid: widget.uid,
                                              profile: widget.profile,
                                              tasks: _tasks)),
                                    );
                                  },
                                  icon: CircleAvatar(
                                    radius: 35,
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
