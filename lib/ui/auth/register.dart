import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nombre = TextEditingController();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool _controllerconectivity = false;
  void _initConnectivity() async {
    // Obtiene el estado de la conectividad al inicio
    final connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);

    // Escucha los cambios en la conectividad y actualiza el estado en consecuencia
    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      _updateConnectionStatus(connectivityResult);
    });
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    setState(() {
      _controllerconectivity = connectivityResult != ConnectivityResult.none;
    });
  }

  void registerUser() async {
    if (nombre.text.isEmpty || user.text.isEmpty || pass.text.isEmpty) {
      Get.snackbar("Todos los campos son obligatorios",
          "por favor llene todos los campos",
          colorText: Colors.white,
          duration: Duration(seconds: 2),
          backgroundColor: Color.fromARGB(255, 73, 73, 73));
    } else {
      if (_controllerconectivity) {
        var data = {
          "name": nombre.text,
          "email": user.text,
          "password": pass.text
        };
        final response = await http.post(
            Uri.parse(
                'http://192.168.100.3:3000/users'), // Reemplaza con la URL de tu backend
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(data));
        if (response.statusCode == 200) {
          print("Entro al if");
          final responseData = json.decode(response.body);
          final token = responseData['token'];
          // Guarda el token en las preferencias compartidas
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('token', token);
          // También puedes redirigir al usuario a otra pantalla aquí
          Get.toNamed('/login');
        } else {
          Get.snackbar("Error al registrar", "por favor intente de nuevo",
              colorText: Colors.white,
              duration: Duration(seconds: 2),
              backgroundColor: Color.fromARGB(255, 73, 73, 73));
        }
      } else {
        Get.snackbar(
            "No hay conexión a internet", "por favor conectese a internet",
            colorText: Colors.white,
            duration: Duration(seconds: 2),
            backgroundColor: Color.fromARGB(255, 73, 73, 73));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              Get.toNamed('/login');
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(children: [
              Container(
                padding: EdgeInsets.only(left: 80, top: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.person, color: Colors.black, size: 40),
                    SizedBox(height: 10),
                    Text(
                      "Crear una Cuenta",
                      style: TextStyle(color: Colors.black, fontSize: 33),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    right: 35,
                    left: 35,
                    top: MediaQuery.of(context).size.height * 0.27),
                child: Column(children: [
                  TextFormField(
                    controller: nombre,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 72, 143, 202)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'Nombre completo',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.supervised_user_circle,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: user,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 72, 143, 202)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'Correo electrónico',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.email, color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: pass,
                    obscureText: true,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 72, 143, 202)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.lock, color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Registrarse',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Color.fromARGB(255, 72, 143, 202),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () {
                              registerUser();
                            },
                            icon: Icon(Icons.arrow_forward),
                          ),
                        ),
                      ]),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/login');
                          },
                          child: Text(
                            'Inicio',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
