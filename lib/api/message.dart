import 'package:flutter/material.dart';

import '../constants.dart';

class Message{
 Future <void> mostrarBottomSheet(BuildContext context, String result,  String message, Color color) async {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding:const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: <Widget>[
          Text(
              result,
              style:const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
             Text(
              message,
              style:  TextStyle(fontSize: 15, color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style:  ElevatedButton.styleFrom(
              backgroundColor: azul, // Cambia aquí el color que desees
              textStyle:const TextStyle(fontSize: 18), // Cambia aquí el tamaño del texto
               ),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el BottomSheet
              },
              child:const Text('Cerrar'),
            ),
          ],
        ),
      );
    },
  );
}

}