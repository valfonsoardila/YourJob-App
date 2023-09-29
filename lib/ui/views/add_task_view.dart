import 'package:flutter/material.dart';
import 'package:yourjobs_app/ui/models/task.dart';
import 'package:yourjobs_app/ui/views/task_list_view.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class AddTaskView extends StatefulWidget {
  final opcionView;
  final dataEdit;
  final uid;
  final profile;
  final tasks;
  final isEdit;
  final tasksManaged;
  const AddTaskView(
      {super.key,
      this.opcionView,
      this.dataEdit,
      this.uid,
      this.profile,
      this.tasks,
      this.tasksManaged,
      this.isEdit});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  String uid = '';
  bool opcionView = false;
  String estadoSeleccionado = 'Pendiente'; // Valor inicial del dropdown
  List<TaskModel> tasks = [];
  List<String> estados = [
    'Pendiente',
    'En proceso',
    'Completado',
  ]; // Valores del dropdown
  // Variable para controlar la apertura y cierre del buscador
  DateTime _selectedDate = DateTime.now();
  DateTime firstDate = DateTime(2021, 1, 1);
  DateTime lastDate =
      DateTime(2024, 1, 1); // Cambia la fecha a una fecha futura válida

  //callback function
  void callbackTasks(List<TaskModel> tasks) {
    widget.tasksManaged(tasks);
  }

  Future<void> updateTask(task) async {
    if (task['title'] == '' || task['description'] == '') {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No se puede actualizar la tarea'),
            content: Text('Debes completar todos los campos'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cerrar'),
              ),
            ],
          );
        },
      );
    } else {
      print(task);
      var urlTask = "http://192.168.100.3:3000/tasks/${task['id']}";
      print(urlTask);
      final response = await http.put(
        Uri.parse(urlTask), // Reemplaza con la URL de tu servidor Node.js
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(task),
      );
      var message = jsonDecode(response.body);
      print(message);
      if (response.statusCode == 200) {
        // Si la solicitud es exitosa, puedes manejar la respuesta aquí
        print('Tarea actualizada exitosamente');
        tasks.removeWhere((element) => element.id == task['id']);
        tasks.add(
          TaskModel(
            task['id'].toString(),
            task['title'],
            task['description'],
            task['dueDate'],
            task['status'],
          ),
        );
        callbackTasks(tasks);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskListView(
              uid: uid,
              profile: widget.profile,
              tasks: tasks,
            ),
          ),
        );
      } else {
        // Si la solicitud falla, puedes manejar el error aquí
        print('Error al actualizar la tarea');
        print('Código de respuesta: ${response.statusCode}');
        print('Mensaje de error: ${response.body}');
      }
    }
  }

  Future<void> createTask(task) async {
    if (task['title'] == '' || task['description'] == '') {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No se puede crear la tarea'),
            content: Text('Debes completar todos los campos'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cerrar'),
              ),
            ],
          );
        },
      );
    } else {
      print(task);
      var urlTask = "http://192.168.100.3:3000/tasks";
      print(urlTask);
      final response = await http.post(
        Uri.parse(urlTask), // Reemplaza con la URL de tu servidor Node.js
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(task),
      );
      var message = jsonDecode(response.body);
      print(message);
      if (response.statusCode == 200) {
        // Si la solicitud es exitosa, puedes manejar la respuesta aquí
        tasks.add(
          TaskModel(
            task['id'].toString(),
            task['title'],
            task['description'],
            task['dueDate'],
            task['status'],
          ),
        );
        print('Tarea creada exitosamente');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskListView(
              uid: uid,
              profile: widget.profile,
              tasks: tasks,
            ),
          ),
        );
      } else {
        // Si la solicitud falla, puedes manejar el error aquí
        print('Error al crear la tarea');
        print('Código de respuesta: ${response.statusCode}');
        print('Mensaje de error: ${response.body}');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    uid = widget.uid;
    print(uid);
    if (widget.opcionView != null) {
      opcionView = widget.opcionView;
    }
    if (widget.tasks != null) {
      tasks = widget.tasks;
    }
    if (widget.dataEdit != null) {
      _titleController.text = widget.dataEdit.title;
      _descriptionController.text = widget.dataEdit.description;
      _selectedDate = DateTime.parse(widget.dataEdit.dueDate);
      estadoSeleccionado = widget.dataEdit.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: opcionView
          ? AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              centerTitle: true, // Centra el título
              title: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment, color: Colors.black, size: 30.0),
                    Text(
                      'Agregar Tareas',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false, // Oculta la flecha de retroceso
              centerTitle: true, // Centra el título
              title: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment,
                        color: Color.fromARGB(255, 46, 155, 73), size: 30.0),
                    Text(
                      'Agregar Tareas',
                      style: TextStyle(
                        color: Color.fromARGB(255, 46, 155, 73),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Text('Titulo de la tarea',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Escribe el título de la tarea',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Text('Descripción de la tarea',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Escribe la descripcion de la tarea',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: EdgeInsets.only(
                            left: 10, top: 70, bottom: 70, right: 10),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Text('Fecha de vencimiento',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.black38),
                      ),
                      child: TextButton(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: firstDate,
                            lastDate: lastDate,
                          ).then((date) {
                            setState(() {
                              _selectedDate = date!;
                            });
                          });
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_today, color: Colors.black),
                              SizedBox(width: 10.0),
                              Text(
                                '$_selectedDate',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              widget.isEdit
                  ? Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Text('Estado de la tarea',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold)),
                          Container(
                            height: 60.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey
                                    .shade500, // Puedes cambiar el color del borde aquí
                                width:
                                    1.0, // Puedes ajustar el grosor del borde aquí
                              ),
                              borderRadius: BorderRadius.circular(
                                  8.0), // Puedes ajustar la esquina redondeada aquí
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Icon(
                                      Icons
                                          .dashboard_rounded, // Puedes cambiar el icono aquí
                                      color: Color.fromARGB(255, 72, 143, 202)),
                                ),
                                Expanded(
                                  child: DropdownButton(
                                    hint: Text(
                                      'Talla',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    dropdownColor: Colors.white,
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black,
                                    ),
                                    iconSize: 36,
                                    isExpanded: true,
                                    underline: SizedBox(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                    value: estadoSeleccionado,
                                    onChanged: (newValue) {
                                      setState(() {
                                        estadoSeleccionado = newValue
                                            .toString(); // Actualiza el valor seleccionado
                                      });
                                    },
                                    items: estados.map((valueItem) {
                                      return DropdownMenuItem(
                                        value: valueItem,
                                        child: Text(valueItem),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Text('Estado de la tarea',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold)),
                          Container(
                            height: 60.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade500,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Icon(
                                    Icons.dashboard_rounded,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      // Puedes agregar alguna acción si es necesario
                                    },
                                    child: AbsorbPointer(
                                      absorbing: true,
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: estadoSeleccionado,
                                          hintStyle: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 18,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.isEdit
                        ? ElevatedButton(
                            onPressed: () {
                              var task = {
                                'title': _titleController.text,
                                'description': _descriptionController.text,
                                'dueDate': _selectedDate.toString(),
                                'status': estadoSeleccionado,
                                'UserId': uid,
                              };
                              updateTask(task);
                            },
                            child: Text('Actualizar',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(150, 50),
                              backgroundColor:
                                  Color.fromARGB(255, 72, 143, 202),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              var task = {
                                'title': _titleController.text,
                                'description': _descriptionController.text,
                                'dueDate': _selectedDate.toString(),
                                'status': estadoSeleccionado,
                                'UserId': uid,
                              };
                              createTask(task);
                            },
                            child: Text('Guardar',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(150, 50),
                              backgroundColor:
                                  Color.fromARGB(255, 72, 143, 202),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
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
    );
  }
}
