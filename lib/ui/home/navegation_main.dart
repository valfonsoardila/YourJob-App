import 'package:flutter/material.dart';
import 'package:yourjobs_app/ui/views/add_task_view.dart';
import 'package:yourjobs_app/ui/views/home_view.dart';
import 'package:yourjobs_app/ui/views/settings_view.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class NavegationMain extends StatefulWidget {
  const NavegationMain({super.key});

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
  late FocusScopeNode _focusScopeNode;
  //LISTAS
  List<int> _selectedIndexList = [0, 1, 2, 3];

  @override
  void initState() {
    super.initState();
    _focusScopeNode = FocusScopeNode();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      HomeView(),
      AddTaskView(),
      SettingsView(),
    ];
    return Scaffold(
      //Estilos para el panel de navegacion inferior de la aplicacion
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _selectedIndexList[_page],
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.show_chart, size: 30, color: Colors.white),
          Icon(Icons.attach_money_sharp, size: 30, color: Colors.white),
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
        title: Text(
          'YourJobs App',
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
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
