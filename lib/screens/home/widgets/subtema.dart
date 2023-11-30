import 'package:edusmart/utils/transition.dart';
import 'package:flutter/material.dart';
import 'package:edusmart/screens/home/widgets/contenido.dart';
import '../../../api/conexion.dart';
import '../../../constants.dart';
//import 'contenido.dart';

class SubtemaScreen extends StatefulWidget {
  const SubtemaScreen(
      {Key? key,
      required this.titulo,
      required this.id_tema})
      : super(key: key);
  final String titulo;
  final int id_tema;
  @override
  State<SubtemaScreen> createState() => _SubtemaScreenState();
}

class _SubtemaScreenState extends State<SubtemaScreen> {
  bool isLoading = true;
  final Conexion _conexion = Conexion();
  @override
  void initState() {
    super.initState();
    _conexion.fetchSubtemas(widget.id_tema);
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Se muestra la lista de subtemas
    return Stack(
      children: [
        Visibility(
          visible: !isLoading,
          child: GridView.builder(
              itemCount: _conexion.subtemas.length == 0
                  ? 1
                  : _conexion.subtemas.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 16 / 4,
                  crossAxisCount: 1,
                  mainAxisSpacing: 20),
              itemBuilder: (context, index) {
                if (index >= _conexion.subtemas.length) {
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 16),
                      ),
                      Container(
                        width: 300,
                        height: 50,
                        child: const Text("No hay subtemas disponibles",
                            textAlign: TextAlign.center),
                      ),
                    ],
                  );
                }
                final subtema = _conexion.subtemas[index];
                return GestureDetector(
                    onTap: () {
                      final String titulo = subtema["nombre_subtema"];
                      Navigator.push(
                        context,
                          ScaleTransition5( Contenido(
                            titulo: titulo, id_subtema: subtema["id_subtema"],
                            lenght: _conexion.subtemas.length, 
                          ),
                          
                        ),
                      );
                    },
                    child: Container(
                      // color: Colors.grey,
                      decoration: BoxDecoration(
                          color: const Color(0xffF7F7F7),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: kLightBlue,
                                      borderRadius: BorderRadius.circular(10)),
                                  height: 55,
                                  width: 55,
                                  child: const Icon(
                                    Icons.menu_book_outlined,
                                    color: kDarkBlue,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  subtema["nombre_subtema"],
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.more_vert,
                                  color: Colors.grey,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ));
              }),
        ),
        Visibility(
          visible: isLoading, // Muestra el loading cuando isLoading es true
          child: const Center(
            child:
                CircularProgressIndicator(), // Puedes personalizar el loading según tus necesidades
          ),
        ),
      ],
    );
  }
}
