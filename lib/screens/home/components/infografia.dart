import 'package:edusmart/utils/transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../api/conexion.dart';
import '../../../constants.dart';
import '../../../utils/app_text_styles.dart';
import '../../appbar/appbar_widget.dart';


class PDFScreen extends StatefulWidget {
  final String filePath;
  final String titulo;

  const PDFScreen({Key? key, required this.filePath, required this.titulo}) : super(key: key);
  @override
  State<PDFScreen> createState()=> _PDFScreenState();
  }
  class _PDFScreenState extends State<PDFScreen>{
    bool isLoading = true;
  final Conexion _conexion = Conexion();

  @override
  void initState() {
    super.initState();
    _conexion.getalumnoData();
    Future.delayed(const Duration(milliseconds: 800), () {
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
         boton_regresar: true,
       ),
      //Se muestra el pdf
      body:Center(
        child: PDFView(
        filePath: widget.filePath,
        enableSwipe: true,
        pageSnap: false,
        swipeHorizontal: true,
      ),
      )
      
      
       
    );
  }
}

class InfografiaScreen extends StatefulWidget {
  const InfografiaScreen({Key? key,required this.titulo, required this.id_subtema}) : super(key: key);
   final String titulo;
   final int id_subtema;
   @override
   State<InfografiaScreen> createState() => _InfografiaScreenState();
}
class _InfografiaScreenState extends State<InfografiaScreen>{
  bool isLoading = true;
  final Conexion _conexion = Conexion();
  //Función para cargar el pdf de acuerdo al nombre y la ruta
  Future<String> loadPDF(String folder,String fileName,) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$fileName';
  final File file = File(filePath);

  if (!file.existsSync()) {
    final ByteData data = await rootBundle.load('$folder/$fileName');
    final List<int> bytes = data.buffer.asUint8List();
    await file.writeAsBytes(bytes, flush: true);
  }

  return filePath;
}
   @override
  void initState() {
    super.initState();
    _conexion.fetchInfografia(widget.id_subtema);
    _conexion.getalumnoData();
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
         boton_regresar: true,
       ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Recursos Didácticos",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),

              Stack(
                children: [
                Visibility(
                 visible: !isLoading,
                 //Se muestra la lista de contenido
                 child:GridView.builder(
                itemCount: _conexion.infografias.length == 0 ? 1: _conexion.infografias.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 16 / 4, crossAxisCount: 1, mainAxisSpacing: 20),
                itemBuilder: (context, index) {
                  if(index >= _conexion.infografias.length){
                    return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 16),
                      ),
                      Container(
                        width: 400,
                        height: 50,
                        child: Text("No hay recursos disponibles",
                        style: AppTextStyles.bodyLightGrey15,
                            textAlign: TextAlign.center),
                      ),
                    ],
                  );
                  }
                  //Le pasamos la ruta y nombre a la siguiente vista
                  final infografias = _conexion.infografias[index];
                  const String ruta ="assets/pdf/tema1/conceptos";

                  return  GestureDetector(
                    onTap: ()async {
                      final String titulo = infografias["nombre_infografia"];
                      final String  nombre = await loadPDF(ruta, infografias["nombre_archivo"]);
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        ScaleTransition5(
                         PDFScreen(
                            filePath:nombre, titulo: titulo ,

                          ),
                        ),
                      
                      );
                       print("Ruta: $nombre");
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
                                child: const Icon(Icons.picture_as_pdf, color: kred),
                              )
                            ],
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                infografias["nombre_infografia"],
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.035,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Text(
                               infografias["descripcion"],
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: MediaQuery.of(context).size.width * 0.03,
                                ),
                              )
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
                    )
                  
                  );
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
              ),
             
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


