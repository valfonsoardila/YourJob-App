import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:yourjobs_app/ui/views/home_view.dart';
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
  bool _isLogin = false;

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

  Future<void> iniciarSesion() async {
    if (user.text.isEmpty || pass.text.isEmpty) {
      Get.snackbar("Todos los campos son obligatorios",
          "por favor llene todos los campos",
          colorText: Colors.white,
          duration: Duration(seconds: 2),
          backgroundColor: Color.fromARGB(255, 73, 73, 73));
    } else {
      if (_controllerconectivity != false) {
        var data = {
          "email": user.text,
          "password": pass.text,
        };
        print(data);
        var response = await http.post(
            Uri.parse("http://192.168.100.3:3000/auth/login"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(data));
        var message = jsonDecode(response.body);
        print("mensaje: $message");
        if (message['message'] != 'Usuario no encontrado' &&
            message['message'] != 'Contraseña incorrecta') {
          String token = message['token'];
          guardarDatos(token);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeView()),
          );
        } else {
          Get.snackbar(
              "Error al iniciar sesión", "por favor verifique sus credenciales",
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

  void guardarDatos(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', user.text);
    prefs.setString('pass', pass.text);
    prefs.setString('token', token);
  }

  void cargarTokens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    print(token);
    if (token != '') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeView()),
      );
    }
  }

  void cargarDatos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    user.text = prefs.getString('user') ?? '';
    pass.text = prefs.getString('pass') ?? '';
    cargarTokens();
  }

  // _getPermission() async => await [
  //       Permission.sms,
  //       Permission.location,
  //       Permission.storage,
  //     ].request();

  @override
  void initState() {
    super.initState();
    cargarDatos();
    _initConnectivity();

    // _getPermission();
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
