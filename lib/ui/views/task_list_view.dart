import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourjobs_app/ui/models/assets.dart';
import 'package:yourjobs_app/ui/models/task.dart';
import 'package:yourjobs_app/ui/views/add_task_view.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class TaskListView extends StatefulWidget {
  final uid;
  final profile;
  final tasks;
  final tasksManaged;
  const TaskListView(
      {super.key, this.tasks, this.uid, this.profile, this.tasksManaged});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  List<TaskModel> _tasks = [];
  List<TaskModel> taskListAux = [];
  List<TaskModel> categories = [];
  List<IconData> itemIcons = [
    Icons.home,
    Icons.assignment_late_rounded,
    Icons.access_time_filled_outlined,
    Icons.assignment_turned_in_rounded,
  ];
  //callback function
  void callbackTasks(List<TaskModel> tasks) {
    _tasks = tasks;
    widget.tasksManaged(_tasks);
  }

  Future<void> deleteTask(id) async {
    var urlTask = "http://192.168.100.3:3000/tasks/$id";
    var response = await http.delete(
      Uri.parse(urlTask),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 204) {
      setState(() {
        _tasks.removeWhere((element) => element.id == id);
      });
      callbackTasks(_tasks);
    } else {
      Get.snackbar(
        'Ha ocurrido un error',
        'No se pudo eliminar la tarea',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void selectCategory(categoria) {
    print("Categoria: $categoria");
    categories = [];
    _tasks = taskListAux;
    if (categoria != "Todos") {
      for (var i = 0; i < _tasks.length; i++) {
        if (_tasks[i].status == categoria) {
          categories.add(_tasks[i]);
        }
      }
      _tasks = [];
      _tasks = categories;
    } else {
      _tasks = taskListAux;
    }
  }

  String selectedCategoryId = "0"; // ID de la categoría seleccionada
  List<Widget> buildCategories() {
    return AssetsModel.generateCategories().map((e) {
      bool isSelected = selectedCategoryId == e.id;
      return Container(
        padding: EdgeInsets.only(left: 15, bottom: 10),
        child: ElevatedButton(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  color: Colors.white,
                  child: Icon(
                    itemIcons[int.parse(e.id)],
                    color: Color.fromARGB(255, 46, 155, 73),
                    size: 30,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                e.status,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(
              isSelected ? Colors.white : Colors.black38,
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
              isSelected ? Color.fromARGB(255, 72, 143, 202) : Colors.white,
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          onPressed: () {
            setState(() {
              selectedCategoryId = e.id;
              print(selectedCategoryId);
              print(e.status);
              selectCategory(e.status);
            });
          },
        ),
      );
    }).toList();
  }

  @override
  void initState() {
    _tasks = widget.tasks;
    taskListAux = widget.tasks;
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
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.06,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: buildCategories(),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Container(
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
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                            radius: 12,
                                            backgroundColor:
                                                _tasks[index].status ==
                                                        'Pendiente'
                                                    ? Colors.red
                                                    : Colors.grey,
                                            child: _tasks[index].status ==
                                                    'Pendiente'
                                                ? Icon(
                                                    Icons
                                                        .assignment_late_rounded,
                                                    color: Colors.white,
                                                    size: 20,
                                                  )
                                                : Container()),
                                        SizedBox(width: 5),
                                        CircleAvatar(
                                            radius: 12,
                                            backgroundColor:
                                                _tasks[index].status ==
                                                        'En proceso'
                                                    ? Colors.orange
                                                    : Colors.grey,
                                            child: _tasks[index].status ==
                                                    'En proceso'
                                                ? Icon(
                                                    Icons
                                                        .access_time_filled_outlined,
                                                    color: Colors.white,
                                                    size: 20,
                                                  )
                                                : Container()),
                                        SizedBox(width: 5),
                                        CircleAvatar(
                                            radius: 12,
                                            backgroundColor:
                                                _tasks[index].status ==
                                                        'Completado'
                                                    ? Colors.green
                                                    : Colors.grey,
                                            child: _tasks[index].status ==
                                                    'Completado'
                                                ? Icon(
                                                    Icons
                                                        .assignment_turned_in_rounded,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          iconSize: 55,
                                          onPressed: () {
                                            deleteTask(_tasks[index].id);
                                          },
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
                                            bool _isEdit = true;
                                            var data = _tasks[index];
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddTaskView(
                                                          opcionView: true,
                                                          dataEdit: data,
                                                          uid: widget.uid,
                                                          profile:
                                                              widget.profile,
                                                          tasks: _tasks,
                                                          isEdit: _isEdit,
                                                          tasksManaged:
                                                              callbackTasks)),
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
            ),
          ],
        ),
      ),
    );
  }
}
