import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';

class VerRespuestas extends StatefulWidget {
  //final List<dynamic> respuestas;
  final List<dynamic> respuestas;
  const VerRespuestas({
    Key? key,
    //required this.respuestas,
    required this.respuestas
  }) : super(key: key);

  @override
  _VerRespuestasState createState() => _VerRespuestasState();
}

class _VerRespuestasState extends State<VerRespuestas> {
  bool _isLoading = true;
     // Cambiar a verdadero cuando se selecciona
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  //Refrescar el estado para volver a mostrar los datos
  Future<void> _refreshData() async {
    // Mostrar el indicador de carga
    setState(() {
      _isLoading = true;
    });
    //Esperamos a una respuesta de las preguntas
    await Future.delayed(const Duration(seconds: 3), () {
      //_conexion.fetchPregunta();
    });
    //Ocultar indicador de carga
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget build(BuildContext context) {
    final respuestas = widget.respuestas;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom:  PreferredSize(
            child:  Container(
                  color: azul,
                  height: 2.0,
            ),
            preferredSize:const Size.fromHeight(4.0)),
            centerTitle: true,
            backgroundColor: azul_oscuro,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close),
              color: AppColors.white,
              onPressed: (){
                Navigator.pop(context);
              },
              ),
            title: Text(
              'Respuestas',
              style: AppTextStyles.titleBold,
            ),
        ),
        //Vista para la pantalla de preguntas
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: Stack(
            children: [
              Visibility(
                  visible: !_isLoading,
                  child: SingleChildScrollView(
                    child: Column(
                      children: respuestas.map((item){
                        final isCorrect = item['respuestaAlumno'] == item['respuesta'];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          textDirection: TextDirection.rtl,
                          children: [
                          Padding(padding:const EdgeInsets.symmetric(horizontal: 12),
                          child:Text('${item['enunciado']}',
                          style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          ),
                          )
                        ),
                         isCorrect? const Text(''):
                          ExpansionTile(
                           title: Text('Ver Respuesta'),
                           children: [
                             respuesta(item['respuesta']),
                              const SizedBox(height: 10)

                           ],
                           ), 
                          Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isCorrect ? AppColors.lightGreen : AppColors.lightRed,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.fromBorderSide(
                                BorderSide(
                                  color: isCorrect? AppColors.green : AppColors.red,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item['respuestaAlumno']}',
                                    style: isCorrect? AppTextStyles.bodyDarkGreen : AppTextStyles.bodyDarkRed,
                                  ),
                                ),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color:  isCorrect ? AppColors.darkGreen : AppColors.darkRed,
                                    borderRadius: BorderRadius.circular(500),
                                    border: Border.fromBorderSide(
                                      BorderSide(
                                        color: isCorrect ? AppColors.lightGreen : AppColors.lightRed,
                                      ),
                                    ),
                                  ),
                                  child: Icon(
                                              isCorrect ? Icons.check : Icons.close,
                                              color: AppColors.white,
                                              size: 16,
                                            )
                                          ,
                                )
                              ],
                            ),
                          ),
                        ),
                          const SizedBox(
                          height: 10,
                        ),
                          ],
                        );

                      }).toList(),
                    ),
                  )),
              Visibility(
                visible:
                    _isLoading, // Muestra el loading cuando isLoading es true
                child: Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.darkGreen),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget respuesta(String respCorrect){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.lightGreen,
          borderRadius: BorderRadius.circular(10),
          border: Border.fromBorderSide(
            BorderSide(
              color: AppColors.green,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "${respCorrect}",
                style: AppTextStyles.bodyDarkGreen,
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.darkGreen,
                borderRadius: BorderRadius.circular(500),
                border: Border.fromBorderSide(
                  BorderSide(
                    color: AppColors.lightGreen,
                  ),
                ),
              ),
              child: Icon(
                Icons.check,
                color: AppColors.white,
                size: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
