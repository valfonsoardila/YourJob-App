import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:yourjobs_app/ui/home/main_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool _controllerconectivity = false;
  String token = '';

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

  void iniciarSesion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (user.text == '' && pass.text == '') {
      Get.snackbar("No ha llenado su usuario y contraseña",
          "por favor llene todos los campos",
          colorText: Colors.white,
          duration: Duration(seconds: 2),
          backgroundColor: Color.fromARGB(255, 73, 73, 73));
    } else {
      if (user.text == '' || pass.text == '') {
        Get.snackbar("Su usuario o contraseña esta vacio",
            "por favor llene todos los campos",
            colorText: Colors.white,
            duration: Duration(seconds: 2),
            backgroundColor: Color.fromARGB(255, 73, 73, 73));
      } else {
        if (_controllerconectivity) {
          var response = await http.get(
            Uri.parse('http://192.168.100.3:3000/users'),
            headers: {"Content-Type": "application/json"},
          );
          print(response.body);
          if (response.statusCode == 200) {
            print("Entro al if");
            final responseData = json.decode(response.body);
            print(responseData);
            bool tieneCorreo =
                responseData.any((element) => element['email'] == user.text);
            bool tienePass =
                responseData.any((element) => element['password'] == pass.text);
            if (tieneCorreo && tienePass) {
              var profile;
              for (var i = 0; i < responseData.length; i++) {
                if (responseData[i]['email'] == user.text &&
                    responseData[i]['password'] == pass.text) {
                  profile = {
                    "token": prefs.getString('token') ?? '',
                    "id": responseData[i]['id'],
                    "name": responseData[i]['name'],
                    "email": responseData[i]['email'],
                    "password": responseData[i]['password'],
                  };
                  guardarDatos();
                }
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MainProvider(
                          profile: profile,
                        )),
              );
            } else {
              Get.snackbar("Autenticacion", "Este usuario no esta registrado",
                  colorText: Colors.white,
                  duration: Duration(seconds: 2),
                  backgroundColor: Color.fromARGB(255, 73, 73, 73));
            }
          } else {
            Get.snackbar("Autenticacion", "Usuario o contraseña incorrectos",
                colorText: Colors.white,
                duration: Duration(seconds: 2),
                backgroundColor: Color.fromARGB(255, 73, 73, 73));
          }
        }
      }
    }
  }

  void guardarDatos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', user.text);
    prefs.setString('pass', pass.text);
  }

  void cargarDatos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user.text = prefs.getString('user') ?? '';
    pass.text = prefs.getString('pass') ?? '';
    token = prefs.getString('token') ?? '';
  }

  @override
  void initState() {
    super.initState();
    cargarDatos();
    _initConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        'assets/icons/icon_design.png',
                        width:
                            130, // Ajusta el ancho de la imagen según tus necesidades
                        height:
                            130, // Ajusta la altura de la imagen según tus necesidades
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'YourJob App',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Color.fromARGB(255, 57, 181, 54),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 40.0),
                      TextFormField(
                        controller: user,
                        enableSuggestions: true,
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
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: pass,
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
                        obscureText: true,
                      ),
                      SizedBox(height: 40.0),
                      ElevatedButton(
                        onPressed: () {
                          //Proceso de validación de usuario
                          iniciarSesion();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          textStyle: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        child: Text(
                          'Iniciar sesión',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.toNamed("/register");
                              },
                              child: Text(
                                'Registrarse',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed("/restore");
                              },
                              child: Text(
                                'Restaurar contraseña',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
