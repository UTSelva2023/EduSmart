import 'package:flutter/material.dart';
import '../../api/conexion.dart';
import '../../utils/transition.dart';
import '../../views/perfil.dart';

class AppBarWidget extends AppBar {
  final String titulo;
  final Conexion conexion;
  final bool isLoading;
  final BuildContext context;
  final bool boton_regresar;
  AppBarWidget({
    required this.titulo,
    required this.conexion,
    required this.isLoading,
    required this.context,
    required this.boton_regresar
  }) : super(
        automaticallyImplyLeading: boton_regresar,
        title:  Text( titulo, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF17203A),
        iconTheme: const IconThemeData(color: Colors.grey, size: 28),
        actions: [
           conexion.userData == null
              ? Visibility(
                  visible:isLoading, // Muestra el loading cuando isLoading es true
                  child:  Center(
                  child:  Container(
                      margin: const EdgeInsets.only(top: 5, right: 16, bottom: 5),
                      child: const CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/avaters/Avatar Default.jpg"),
                    ),
                    ) // Puedes personalizar el loading según tus necesidades
                  ),
                )
              : Visibility(
                  visible: !isLoading,
                  child: GestureDetector(
                    onTap: (){
                      final SizeTransition5 _transition =SizeTransition5(ProfileApp());
                      Navigator.push(context,_transition);
                    },
                    child: Container(
                    margin: const EdgeInsets.only(top: 5, right: 16, bottom: 5),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'http://${conexion.ip}/get-image/${conexion.userData!['foto']}'),
                    ),
                  ),
                  )
                )
        ],
        );
}

