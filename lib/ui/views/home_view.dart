import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yourjobs_app/ui/models/task.dart';
import 'package:yourjobs_app/ui/views/add_task_view.dart';
import 'package:yourjobs_app/ui/views/task_list_view.dart';

class HomeView extends StatefulWidget {
  final uid;
  final profile;
  final tasks;
  final tasksManaged;
  const HomeView(
      {super.key, this.profile, this.tasks, this.uid, this.tasksManaged});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  int indexIcon = 1;
  int indexFiltro = 0;
  String filtroSeleccionadoDropd1 = 'Filtros';
  int indexSelected2 = 0;
  List<IconData> itemIcons = [
    Icons.home,
    Icons.assignment_late_rounded,
    Icons.access_time_filled_outlined,
    Icons.assignment_turned_in_rounded,
  ];
  //Lista de conceptos
  var filtros = <String>[
    'Filtros',
    'Pendiente',
    'En proceso',
    'Completado',
  ];
  List<String> Meses = [
    'Ene',
    'Feb',
    'Mar',
    'Abr',
    'May',
    'Jun',
    'Jul',
    'Ago',
    'Sep',
    'Oct',
    'Nov',
    'Dic'
  ];

  var coloresFiltro = <Color>[
    Colors.white,
    Colors.red,
    Colors.orange,
    Colors.green,
  ];
  // Variable para controlar la apertura y cierre del buscador
  Map<String, dynamic> profile = {};
  bool _isSearchOpen = false;
  bool _opcionView = false;
  double min = 0;
  double max = 10;
  int quantityTasks = 0;
  List<TaskModel> taskList = [];
  List<Color> gradientColors = [
    Color(0xff23b6e6),
    Color(0xff02d39a),
  ];
  getsTasksManaged(List<TaskModel> tasks) {
    setState(() {
      this.taskList = tasks;
      quantityTasks = taskList.length;
    });
    callbackTasks(taskList);
  }

  //callback function
  void callbackTasks(List<TaskModel> tasks) {
    widget.tasksManaged(tasks);
  }

  void graficarTareasPorMes(tasks) {
    var contador = 0;
    for (int i = 0; i < Meses.length; i++) {
      for (int j = 0; j < tasks.length; j++) {
        if (int.parse(tasks[j].dueDate.substring(5, 7)) == i + 1) {
          //obtener la cantidad de tareas en este mes
          contador++;
          print("contador: $contador");
          data[i] = _ChartData(Meses[i], contador);
        }
      }
    }
  }

  @override
  void initState() {
    data = <_ChartData>[
      _ChartData('Ene', 0),
      _ChartData('Feb', 0),
      _ChartData('Mar', 0),
      _ChartData('Abr', 0),
      _ChartData('May', 0),
      _ChartData('Jun', 0),
      _ChartData('Jul', 0),
      _ChartData('Ago', 0),
      _ChartData('Sep', 0),
      _ChartData('Oct', 0),
      _ChartData('Nov', 0),
      _ChartData('Dic', 0),
    ];
    _tooltip = TooltipBehavior(enable: true);
    profile = widget.profile;
    if (widget.tasks != null) {
      taskList = widget.tasks;
      quantityTasks = taskList.length;
      graficarTareasPorMes(taskList);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _opcionView = true;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddTaskView(
                        opcionView: _opcionView,
                        uid: widget.uid,
                        profile: profile,
                        tasks: taskList,
                        isEdit: false,
                      )),
            );
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
                Icon(Icons.home,
                    color: Color.fromARGB(255, 46, 155, 73), size: 30.0),
                Text(
                  'Inicio',
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
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                          child: Container(
                              child: SfCartesianChart(
                                  plotAreaBorderWidth: 0,
                                  title: ChartTitle(
                                      text: 'Flujo de tareas: $quantityTasks'),
                                  legend: Legend(isVisible: false),
                                  primaryXAxis: CategoryAxis(
                                    labelPlacement: LabelPlacement.onTicks,
                                    majorGridLines: MajorGridLines(width: 0),
                                    name: 'Meses',
                                    title: AxisTitle(text: 'Meses'),
                                    axisLine: AxisLine(width: 0),
                                    arrangeByIndex: true,
                                    labelIntersectAction:
                                        AxisLabelIntersectAction.rotate45,
                                  ),
                                  primaryYAxis: NumericAxis(
                                      name: 'Tareas',
                                      title: AxisTitle(text: 'Tareas'),
                                      minimum: min,
                                      maximum: max,
                                      interval: max / 10),
                                  series: <ChartSeries<dynamic, String>>[
                                AreaSeries<dynamic, String>(
                                  dataSource: data,
                                  xValueMapper: (dynamic data, _) => data.x,
                                  yValueMapper: (dynamic data, _) => data.y,
                                  name: 'Gold',
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: gradientColors,
                                  ),
                                  color: Color.fromRGBO(255, 255, 255, 0.3),
                                )
                              ])),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: Column(
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {
                                  print("uid antes de neviar: ${widget.uid}");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TaskListView(
                                              uid: widget.uid,
                                              profile: profile,
                                              tasks: taskList,
                                              tasksManaged: getsTasksManaged,
                                            )),
                                  );
                                },
                                child: Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        'Ver todas las tareas',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Icon(
                                        Icons.folder_zip,
                                        color: Colors.black,
                                      ),
                                    ],
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
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      color: coloresFiltro[indexFiltro],
                                      width: MediaQuery.of(context).size.width *
                                          0.32,
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Icon(itemIcons[indexFiltro],
                                              color: Colors.black, size: 20.0),
                                          Expanded(
                                            child: DropdownButton(
                                                padding:
                                                    EdgeInsets.only(left: 5),
                                                hint: Text(
                                                  'Filtro',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                dropdownColor: Colors.white
                                                    .withOpacity(0.9),
                                                icon: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Colors.black,
                                                    size: 20),
                                                iconSize: 36,
                                                isExpanded: true,
                                                underline: SizedBox(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                value: filtroSeleccionadoDropd1,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    if (newValue == "Filtros") {
                                                      indexFiltro = 0;
                                                    } else {
                                                      if (newValue ==
                                                          'Pendiente') {
                                                        indexFiltro = 1;
                                                      } else {
                                                        if (newValue ==
                                                            'En proceso') {
                                                          indexFiltro = 2;
                                                        } else {
                                                          if (newValue ==
                                                              'Completado') {
                                                            indexFiltro = 3;
                                                          }
                                                        }
                                                      }
                                                    }
                                                    filtroSeleccionadoDropd1 =
                                                        newValue.toString();
                                                    indexSelected2 =
                                                        filtros.indexOf(newValue
                                                            .toString());
                                                    print(
                                                        indexSelected2); // Actualiza el valor seleccionado
                                                  });
                                                },
                                                items: filtros.map((valueItem) {
                                                  return DropdownMenuItem(
                                                    value: valueItem,
                                                    child: Text(valueItem),
                                                  );
                                                }).toList()),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 15),
                                      child: Text(
                                        'Lista de tareas',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListView.builder(
                                        itemCount: taskList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return SingleChildScrollView(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
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
                                                  'Fecha: ${taskList[index].dueDate}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Container(
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            taskList[index]
                                                                .title,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            taskList[index]
                                                                .description,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  late final int y;
}
