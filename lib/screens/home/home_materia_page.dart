import 'package:edusmart/screens/home/widgets/materia.dart';
import 'package:flutter/material.dart';



class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: true,
        child: Stack(
          children: [
            Positioned(
                  right:20,
                  left: 20,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.transparent
                ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
                  height: 110,
                child:Text(
                      "Materias",
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
                        textAlign: TextAlign.center,
                ),
              )
            ),
            const Positioned(
              child:Padding(padding:  EdgeInsets.fromLTRB(16.0, 83, 16.0, 5),
                  child:MateriaScreen(),
              )
            )
           
          ]
        ),
      )        
    );
  }
}
