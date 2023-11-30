import 'package:edusmart/api/conexion.dart';
import 'package:flutter/material.dart';
import 'package:edusmart/screens/Login/principal_screen.dart';
import 'package:provider/provider.dart';
import 'screens/Menu/entry_point.dart';



void main() {
  runApp(
    ChangeNotifierProvider(
    create:(context) => Conexion(),
    child:  MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute:'/',
      routes: {
        //Rutas 
      '/': ( BuildContext context) =>const OnbodingScreen(), 
      '/home': (BuildContext context )=> const EntryPoint(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);
