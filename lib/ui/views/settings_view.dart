import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  final uid;
  final profile;
  final tasks;
  const SettingsView({super.key, this.profile, this.tasks, this.uid});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // Oculta la flecha de retroceso
        centerTitle: true, // Centra el título
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.settings,
                  color: Color.fromARGB(255, 46, 155, 73), size: 30.0),
              Text(
                'Ajustes',
                style: TextStyle(
                  color: Color.fromARGB(255, 46, 155, 73),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      body: Container(),
    );
  }
}
