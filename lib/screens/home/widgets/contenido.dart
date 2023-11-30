import 'package:edusmart/utils/transition.dart';
import 'package:flutter/material.dart';
import '../../../api/conexion.dart';
import '../../../constants.dart';
import '../../appbar/appbar_widget.dart';
import '../components/infografia.dart';
import '../components/video.dart';

class   Contenido extends StatefulWidget {
  
  const Contenido({Key? key,
  required this.titulo, 
  required this.id_subtema,
  required this.lenght
  }) : super(key: key);
   //final List<Contenido> contenido;
   final String titulo;
   final int id_subtema;
   final int lenght;

   @override
   State<Contenido> createState() => _ContenidoState();
}
class _ContenidoState extends State<Contenido>{
  bool isLoading = true;
  final Conexion _conexion = Conexion();

  @override
  void initState() {
    super.initState();
    _conexion.getalumnoData();
    _conexion.fetchVideo(widget.id_subtema);
    _conexion.fetchInfografia(widget.id_subtema);
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        isLoading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(
        titulo: widget.titulo,
        isLoading: isLoading, 
        context: context, 
        conexion: _conexion,
        boton_regresar: true
      ),
      //drawer: const SideMenu(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
             
              const Text(
                "Contenido",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              //Se muestra los contenidos de cada subtema
                  GridView.count(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                  GestureDetector(
                       onTap: () {
                          Navigator.push( 
                          context,
                          ScaleTransition5(
                             InfografiaScreen(titulo: widget.titulo, id_subtema: widget.id_subtema,),
                          ),
                        );
                       },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: kLightBlue,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             const Text(
                              "Documentos",
                              maxLines: 2,
                              softWrap: true,
                              style:  TextStyle(
                                fontSize: 17,
                                color: Color(0xff8EA3B7),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40,
                                  width: 7,
                                  decoration: BoxDecoration(
                                      color: kDarkBlue,
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                                  _conexion.infografias == null ?
                                    const Text(
                                      "00",
                                    style:TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff006ED3),
                                    ),
                                  
                                  ):Text(
                                          _conexion.infografias.length <= 9
                                          ? '0${_conexion.infografias.length}'
                                          : '${_conexion.infografias.length}',
                                      style:const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff006ED3),
                                      ),
                                    )
                                
                                  
                              ],
                            )
                          ],
                        ),
                      ),
                    ) ,
                    ),
                     GestureDetector(
                       onTap: () {
                          Navigator.push( 
                          context,
                          ScaleTransition5(
                           VideoScreen(titulo: widget.titulo, id_subtema:widget.id_subtema),
                          ),
                        );
                       },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: kLightBlue,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Videos",
                              maxLines: 2,
                              softWrap: true,
                              style:  TextStyle(
                                fontSize: 17,
                                color: Color(0xff8EA3B7),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40,
                                  width: 7,
                                  decoration: BoxDecoration(
                                      color: kDarkBlue,
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                                _conexion.videos == null ? 
                                  const Text(
                                  "00",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff006ED3),
                                  ),
                                )
                                :Text(
                                       _conexion.videos.length <= 9
                                        ? '0${_conexion.videos.length}'
                                        : '${_conexion.videos.length}',
                                      style:const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff006ED3),
                                      ),
                                    ) 
                              ],
                            )
                          ],
                        ),
                      ),
                    ) ,
                    ),
                  ],
                ),
              const SizedBox(
                height: 15,
              ),
              /*const ActivityHeader(),
              const ChartContainer(chart: BarChartContent())*/
            ],
          ),
        ),
      ),
    );
  }
}
