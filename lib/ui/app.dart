import 'package:flutter/material.dart';
import 'package:yourjobs_app/ui/anim/introSimple_app.dart';
import 'package:yourjobs_app/ui/auth/login.dart';
import 'package:yourjobs_app/ui/auth/profile.dart';
import 'package:yourjobs_app/ui/auth/register.dart';
import 'package:yourjobs_app/ui/auth/restore.dart';
import 'package:yourjobs_app/ui/home/navegation_main.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YourJob App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        "/": (context) => IntroSimple(),
        "/login": (context) => Login(),
        "/register": (context) => Register(),
        "/restore": (context) => Restore(),
        "/profile": (context) => Profile(),
        "/main": (context) => NavegationMain(),
      },
    );
  }
}
