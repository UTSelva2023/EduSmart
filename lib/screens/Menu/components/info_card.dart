import 'package:edusmart/api/conexion.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
    InfoCard({
    Key? key,
    required this.name,
    required this.bio,
    required this.foto,
  }) : super(key: key);

  final String name, bio, foto ;
  final _conexion = Conexion();

  @override
  Widget build(BuildContext context) {
    //Se muestra el nombre y la imágen de perfil
    return ListTile(
      leading:  CircleAvatar(
         backgroundImage: NetworkImage('http://${_conexion.ip}/get-image/${foto}'),
         radius: 30,
        
      ),
      title: Text(
        name,
        style: const TextStyle(color: Colors.white, fontSize: 22),
      ),
      subtitle: Text(
        bio,
        style: const TextStyle(color: Colors.white70, fontSize: 18),
      ),
    );
  }
}
