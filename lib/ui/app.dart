import 'package:flutter/material.dart';
import 'package:select_job/ui/anim/introSimple_app.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YourJob App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        "/": (context) => IntroSimple(),
        // "/login": (context) => Login(),
        // "/principal": (context) => AccountView(),
      },
    );
  }
}
