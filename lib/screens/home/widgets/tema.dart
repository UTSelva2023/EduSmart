import 'package:edusmart/api/conexion.dart';
import 'package:edusmart/constants.dart';
import 'package:edusmart/utils/transition.dart';
import 'package:flutter/material.dart';
import '../../Menu/subtema_menu.dart';
class TemaScreen extends StatefulWidget {
const TemaScreen({super.key,
 required this.id_unidad,
 required this.idmateria,
 required this.materia

 });
  final int id_unidad;
  final int idmateria;
  final String materia;
  @override
  State<TemaScreen> createState() => _TemaScreenState();
}
class _TemaScreenState extends State<TemaScreen>{
  bool isLoading = true;
  final Conexion _conexion = Conexion();
  @override
  void initState(){
    super.initState();
    _conexion.fetchTemas(widget.id_unidad);
     Future.delayed(const Duration(milliseconds: 800), () {
    setState(() {
      isLoading = false; 
    });
  });

  }
  Widget build(BuildContext context) {
    //Se muestran los  temas del que contiene cada unidad
    return Stack(
      children: [
        Visibility(
        visible: !isLoading,
        child:GridView.builder( 
        itemCount: _conexion.temas.length ==0 ? 1: _conexion.temas.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //Tamaño del container para mostrar los temas
            childAspectRatio: 25 / 7, crossAxisCount: 1, mainAxisSpacing: 20),
        itemBuilder: (context, index) {
          if(index >= _conexion.temas.length){
             return Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 16),
                            ),
                            Container(
                              width: 200,
                              height: 50,
                              child: const Text("No hay temas disponibles",
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        );
          }
          final temas = _conexion.temas[index];
          return GestureDetector(
            onTap: (){
              final String titulo = temas["nombre_tema"];
              Navigator.push(
              context,
              ScaleTransition5(
               SubtemaMenu(titulo: titulo, id_tema: temas["id_tema"], idMateria: widget.idmateria, materia: widget.materia),
              ),
              );
            },
            child:Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              /*image: DecorationImage(
                  image: AssetImage(tema[index].backImage),
                   fit: BoxFit.fill),*/
                color: backgroundColor2
            ),
            child: Padding(
              //Alineación del texto
              padding: const EdgeInsets.all(22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        temas["nombre_tema"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                          ),
                      ),
                    ],
                  ),
                 /* Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        tema[index].imageUrl,
                        height: 60,
                      )
                    ],
                  )*/
                ],
              ),
            ),

            )
            
          );
        }) ,
        ),
         Visibility(
          visible: isLoading, // Muestra el loading cuando isLoading es true
          child: const  Center(
            widthFactor: 4,
            heightFactor: 2,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ), // Puedes personalizar el loading según tus necesidades
          ),
        ),
      ],
    );
    
     
  }
}
