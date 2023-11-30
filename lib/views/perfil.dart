// ignore_for_file: avoid_print, prefer_const_constructors, no_leading_underscores_for_local_identifiers

import 'package:edusmart/utils/transition.dart';
import 'package:flutter/material.dart';
import '../api/conexion.dart';
import '../constants.dart';
import 'perfiledit.dart';

class ProfileApp extends StatefulWidget {
  const ProfileApp({super.key});

  @override
  State<ProfileApp> createState() => _ProfileAppState();
}

class _ProfileAppState extends State<ProfileApp> {
   bool isLoading= true;
  final Conexion _conexion = Conexion();

  @override
  void initState(){
    super.initState();
    _conexion.getalumnoData();

    Future.delayed(Duration(seconds: 1), () {
    setState(() {
      isLoading = false;
      _conexion.getalumnoData();
    });
  });
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [backgroundColor1, backgroundColor2],
            ),
          ),
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 130.0),
              _conexion.userData == null ? Visibility(
                  visible: isLoading, // Muestra el loading cuando isLoading es true
                  child: const  Center(
                    child: CircularProgressIndicator(), // Puedes personalizar el loading según tus necesidades
                  ),
                ):
                Visibility(
                  visible: !isLoading,
                    child: Row(
                      children:  [
                        CircleAvatar(
                          radius: 60.0,
                          backgroundImage: NetworkImage('http://${_conexion.ip}/get-image/${_conexion.userData!['foto']}'), // Replace with your image path
                        ),
                        const SizedBox(width: 20),
                        Text(
                          '${_conexion.userData!['nombre']} ${_conexion.userData!['app']}\n ${_conexion.userData!['apm']}',
                          style:const TextStyle(
                            fontSize: 18.0,
                            color: blanco,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                     )
                  ),
                     const SizedBox(height:0),
                    Container(
                        padding:
                            const EdgeInsets.only(top: 30.0, left: 0.0, right: 160.0),
                        height: 80.0,
                        width: 300.0,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: blanco,
                                  style: BorderStyle.solid,
                                  width: 1.0),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(40.0)),
                          child: TextButton(
                            //al precionarlo indicamos la ruta al cual se va diriguir
                            onPressed: () {
                              final SizeTransition5 _transition =SizeTransition5(PerfilEdit());
                              Navigator.push(context, _transition);
                              print("Funciona");
                            },
                            child: const Center(
                              child: Text(
                                'Editar',
                                style: TextStyle(
                                    color: blanco,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        )),
            ],
          ),
        ),
        Positioned(
          top: 40,
          left: 16,
          child: IconButton(
            color: blanco,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
               Navigator.pop(context);
            },
          ),
        ),
      ],
    ));
  }
}

