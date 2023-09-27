import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yourjobs_app/ui/views/task_list_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Variable para controlar la apertura y cierre del buscador
  bool _isSearchOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Aquí puedes definir la acción que se realiza cuando se presiona el FAB.
          },
          child: Icon(Icons.add), // Cambia esto por el icono que desees
          foregroundColor: Colors.white, // Cambia el color del icono
          focusElevation: 10.0,
          hoverElevation: 10.0,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          tooltip: 'Agregar Tarea',
          backgroundColor:
              Colors.black, // Cambia el color del botón según tus preferencias
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false, // Oculta la flecha de retroceso
          centerTitle: true, // Centra el título
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home, color: Colors.black, size: 30.0),
                Text(
                  'Inicio',
                  style: TextStyle(
                    color: Colors.black,
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
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.065,
                  child: _isSearchOpen
                      ? Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          padding: EdgeInsets.only(left: 46, top: 2),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(226, 227, 228, 1),
                            border: Border.all(color: Colors.black38),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Buscar',
                                hintStyle: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 20,
                                ),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isSearchOpen = false;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.black38,
                                  ),
                                )),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _isSearchOpen = true;
                              });
                            },
                            icon: CircleAvatar(
                              radius: 40.0,
                              backgroundColor:
                                  Color.fromARGB(255, 212, 210, 210),
                              child: Icon(
                                Icons.search,
                                color: Colors.black38,
                                size: 30.0,
                              ),
                            ),
                          ),
                        ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 243, 241, 241),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TaskListView()),
                                  );
                                },
                                child: Text(
                                  'Tareas >',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.545,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 243, 241, 241),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
