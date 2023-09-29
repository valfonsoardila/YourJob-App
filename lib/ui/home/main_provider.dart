import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:yourjobs_app/ui/home/navegation_main.dart';
import 'package:yourjobs_app/ui/models/task.dart';

class MainProvider extends StatefulWidget {
  final profile;
  const MainProvider({super.key, this.profile});

  @override
  State<MainProvider> createState() => _MainProviderState();
}

class _MainProviderState extends State<MainProvider> {
  //CONSULTAS
  List<dynamic> _tasks = [];
  List<TaskModel> tasks = [];
  Map<String, dynamic> profile = {};
  //VARIABLES
  String? uid;

  Future<void> _getTasks() async {
    final response = await http.get(
      Uri.parse('http://192.168.100.3:3000/tasks'),
      headers: {
        "Accept": "application/json",
      },
    );
    var data = jsonDecode(response.body);
    _tasks = data;
    print("Tareas en el main: $_tasks");
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        print("No esta vacio");
        for (var i = 0; i < _tasks.length; i++) {
          print("Tareas en la posicion $i: ${_tasks[i]}");
          if (_tasks[i]["UserId"].toString() == uid) {
            tasks.add(TaskModel(
              _tasks[i]["id"].toString(),
              _tasks[i]["title"],
              _tasks[i]["description"],
              _tasks[i]["dueDate"],
              _tasks[i]["status"],
            ));
          }
        }
        print("Tareas Model: $tasks");
      }
    } else {
      print("Error al cargar las tareas");
    }
  }

  Future<void> getDataLogged() async {
    print("Perfil en el main: ${widget.profile}");
    profile = widget.profile;
    uid = profile["id"].toString();
    print(uid);
  }

  @override
  void initState() {
    getDataLogged();
    if (uid != null) {
      _getTasks();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: FutureBuilder(
          future: Future.delayed(
              Duration(seconds: 3)), //Establece el tiempo de carga
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.grey[900],
                      backgroundColor: Colors.black,
                    ),
                    Text(
                      "Cargando...",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              if (snapshot.hasError) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.network_check,
                            color: Color.fromARGB(255, 231, 30, 15),
                          ),
                          Icon(
                            Icons.error,
                            color: Color.fromARGB(255, 231, 30, 15),
                          ),
                        ],
                      ),
                      Text(
                        "Error: ${snapshot.error}",
                        style: TextStyle(
                          color: Color.fromARGB(255, 231, 30, 15),
                          fontSize: 20,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Text(
                        "Verifique su conexión a internet",
                        style: TextStyle(
                          color: Color.fromARGB(255, 231, 30, 15),
                          fontSize: 20,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        color: Colors.grey[900],
                        backgroundColor: Colors.black,
                      ),
                      TextButton(
                        onPressed: () {
                          Get.offAll(() => MainProvider());
                        },
                        child: Text(
                          "Intentar de nuevo",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                print("Perfil: $profile");
                if (profile["id"] != null) {
                  return Scaffold(
                    body: Stack(
                      children: [
                        NavegationMain(
                          uid: uid,
                          profile: profile,
                          tasks: tasks,
                        ),
                      ],
                    ),
                  );
                } else {
                  print("Error desconocido");
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.help_outline,
                          color: Color.fromARGB(255, 231, 30, 15),
                        ),
                        Text(
                          "Error desconocido",
                          style: TextStyle(
                            color: Color.fromARGB(255, 231, 30, 15),
                            fontSize: 20,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Text(
                          "Por favor vuelva a ingresar",
                          style: TextStyle(
                            color: Color.fromARGB(255, 231, 30, 15),
                            fontSize: 20,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.offAllNamed("/login");
                          },
                          child: Text(
                            "Volver",
                            style: TextStyle(
                              color: Color.fromARGB(255, 231, 30, 15),
                              fontSize: 20,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
            }
          },
        ),
      ),
    );
  }
}
