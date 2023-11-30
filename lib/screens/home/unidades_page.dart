import 'package:flutter/material.dart';
import '../../api/conexion.dart';
import '../../constants.dart';
import '../../utils/app_text_styles.dart';
import '../appbar/appbar_widget.dart';
import 'widgets/tema.dart';

// ignore: must_be_immutable
class UnidadPage extends StatefulWidget {
  UnidadPage({super.key, required this.titulo, required this.id_materia});
  String titulo;
  int id_materia;
  

  @override
  State<UnidadPage> createState() => _UnidadPageState();
}

class _UnidadPageState extends State<UnidadPage> {
  final Conexion _conexion = Conexion();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _conexion.fetchUnidades(widget.id_materia);
    _conexion.getalumnoData();
    Future.delayed(const Duration(milliseconds : 800), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        titulo: widget.titulo,
        isLoading: isLoading,
        context: context, 
        conexion: _conexion,
        boton_regresar: false,
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Unidades Temáticas",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ),
                // Espacio entre el texto y la lista
                const SizedBox(height: 5),
                Visibility(
                  visible: !isLoading,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: _conexion.unidades.length == 0
                        ? 1
                        : _conexion.unidades.length,
                    itemBuilder: (context, index) {
                      if (index >= _conexion.unidades.length) {
                        return Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 16),
                            ),
                            Container(
                              width: 400,
                              height: 200,
                              child:  Text("No hay unidades disponibles",
                                  style: AppTextStyles.bodyLightGrey15,
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        );
                      }
                      final unidad = _conexion.unidades[index];
                      // Lista de las unidades temáticas
                      return Column(
                        children: <Widget>[
                          //Espacio entre los elementos de la lista
                          const SizedBox(height: 15),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF2F6FF),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ExpansionTile(
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.center,
                              title: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: verde,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          height: 55,
                                          width: 55,
                                          child: const Icon(
                                            Icons.book_outlined,
                                            color: kGreen,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          unidad["nombre_unidad"],
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.039,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                    "Temas",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                  ),
                                ),
                                // Mostramos los temas de la unidad
                                TemaScreen(id_unidad: unidad["id_unidad"], idmateria: widget.id_materia, materia: widget.titulo,),
                              ],
                            ),
                          ),
                         const SizedBox(width: 20),
                        ],
                      );
                    },
                  ),
                ),
                Visibility(
                  visible: isLoading, // Muestra el loading cuando isLoading es true
                  child: const Center(
                    child:CircularProgressIndicator(), // Puedes personalizar el loading según tus necesidades
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
