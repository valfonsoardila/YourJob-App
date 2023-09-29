import 'package:flutter/material.dart';
import 'package:yourjobs_app/ui/models/task.dart';
import 'package:yourjobs_app/ui/views/add_task_view.dart';
import 'package:yourjobs_app/ui/views/home_view.dart';
import 'package:yourjobs_app/ui/views/settings_view.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class NavegationMain extends StatefulWidget {
  final uid;
  final profile;
  final tasks;
  const NavegationMain({super.key, this.profile, this.tasks, this.uid});

  @override
  State<NavegationMain> createState() => _NavegationMainState();
}

class _NavegationMainState extends State<NavegationMain> {
  //VARIABLE GLOBAL KEY
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  //VARIABLES DE CONTROL
  int _page = 0;
  double tamano = 0.0;
  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;
  String concepto = '';
  String uid = '';
  late FocusScopeNode _focusScopeNode;
  //LISTAS
  List<int> _selectedIndexList = [0, 1, 2];
  List<dynamic> tasks = [];
  List<TaskModel> taskList = [];
  Future<void> getAllTask() async {
    taskList = widget.tasks;
  }

  getsTasksManaged(List<TaskModel> tasks) {
    this.taskList = tasks;
  }

  @override
  void initState() {
    super.initState();
    _focusScopeNode = FocusScopeNode();
    uid = widget.uid;
    getAllTask();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      HomeView(
          uid: uid,
          tasks: taskList,
          profile: widget.profile,
          tasksManaged: getsTasksManaged),
      AddTaskView(
          uid: uid,
          tasks: taskList,
          profile: widget.profile,
          isEdit: false,
          tasksManaged: getsTasksManaged),
      SettingsView(uid: uid, tasks: taskList, profile: widget.profile),
    ];
    return Scaffold(
      //Estilos para el panel de navegacion inferior de la aplicacion
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _selectedIndexList[_page],
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.assignment, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
        color: Color.fromARGB(255, 72, 143, 202),
        buttonBackgroundColor: Color.fromARGB(255, 72, 143, 202),
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      //Estilos del panel superior de la aplicacion
      appBar: AppBar(
        leading: Container(
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.transparent,
            backgroundImage: Image.asset('assets/icons/icon.png').image,
          ),
        ),
        title: Text(
          'YourJobs App',
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        automaticallyImplyLeading: false, // Oculta la flecha de retroceso
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 72, 143, 202),
        elevation: 0,
      ),
      //Estilos para el contenido de la aplicacion
      body: Container(
        color: Colors.white,
        child: _widgetOptions[_page],
      ),
    );
  }
}
