import 'package:edusmart/utils/transition.dart';
import 'package:flutter/material.dart';
import '../../api/conexion.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../QuizzResult/result_page.dart';
import 'challenge_controller.dart';
import 'widgets/nextbutton/next_button_widget.dart';
import 'widgets/questionindicator/question_indicator_widget.dart';
import 'widgets/quizzScreen/preguntas.dart';

class QuizzPage extends StatefulWidget {
  int idalumno;
  final int idmateria;
   QuizzPage({
    required this.idalumno,
    required this.idmateria,
    Key? key,
  }) : super(key: key);

  @override
  QuizzPageState createState() => QuizzPageState();
}

class QuizzPageState extends State<QuizzPage> {
  final challengeController = ChallengeController();
  final pageController = PageController();
  final Conexion _conexion = Conexion();
  bool _isLoading = true;
  String? titulo;
  int? id_pregunta;
  int _idalumno = 0;
  int _id_equipo = 4;
  int id_examen= 0;
  int id_materia= 0;
  String tipoexamen ="";
  String? respuesta;
    @override
  void initState() {
    pageController.addListener(() {
      challengeController.currentPage = pageController.page!.toInt() + 1;
    });

    super.initState();
    _conexion.fetchPregunta(widget.idalumno, widget.idmateria);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _idalumno = widget.idalumno;
      });
    });

  }
  //Función para avanzar a la siguiente vista de la siguiente pregunta
  void goToNextPage(){
    pageController.nextPage(
      duration: const Duration(
        milliseconds: 100,
      ),
      curve: Curves.linear,
    );
  }
  void guardarRespuesta(){
    if(respuesta != null){
       _conexion.guardarRespuestas(id_pregunta!, _idalumno, _id_equipo, "$respuesta", context);
        respuesta = null;
    } else {
         _conexion.guardarRespuestas(id_pregunta!,_idalumno, _id_equipo, "No se selecciono respuesta", context);
    }
  }
 //Refrescar el estado para volver a mostrar los datos
  Future<void> _refreshData() async {
    // Mostrar el indicador de carga
    setState(() {
      _isLoading = true;
    });
    //Esperamos a una respuesta de las preguntas
    await Future.delayed(const Duration(seconds: 3),() {
        _conexion.fetchPregunta(_idalumno, widget.idmateria);
    });
    //Ocultar indicador de carga
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }
  //Levar el conteo de las preguntas que son true para sumar 1 si es falso se suma 0
   void onSelect( value) {
    if (value) {
      challengeController.rightAnswersCount++;
    }
  }
  //Recibir la respuesta seleccionada para almacenarla
   void onSelectRespuesta( value) {
      respuesta = value;
    }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          //Espacio entre la barra indicadora y las preguntas
          preferredSize: const Size.fromHeight(100),
          child: SafeArea(
            top: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                _conexion.preguntas.length == 0 ? Visibility(
                  visible: _isLoading,
                  child:Center(
                    child: Text("Cargando...", style: AppTextStyles.body11),
                  )
                  
                  ):
                  Visibility(
                  visible: !_isLoading,
                  child: ValueListenableBuilder<int>(
                  valueListenable: challengeController.currentPageNotifier,
                  builder: (context, value, child) => QuestionIndicatorWidget(
                    currentPage: value,
                    length: _conexion.preguntas.length,
                  ),
                ),
                )
                
              ],
            ),
          ),
        ),
        //Vista para la pantalla de preguntas
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: Stack(
            children: [
              Visibility(
                visible: !_isLoading,
                child: PageView.builder(
                  itemCount: _conexion.preguntas.length == 0
                      ? 1
                      : _conexion.preguntas.length,
                  physics: NeverScrollableScrollPhysics(),
                  controller: pageController,
                  itemBuilder: (context, index) {
                    if (index >= _conexion.preguntas.length) {
                      return Scaffold(
                        body: Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Text("Ocurrio un error",
                                style: AppTextStyles.bodyLightGrey20,
                                textAlign: TextAlign.center),
                            const SizedBox(height: 20),
                            NextButtonWidget.white(
                                label: "Reintentar",
                                onTap: () {
                                  _refreshData();
                                })
                          ],
                        )
                      ),
                      );
                    }
                    //Mostramos la vista para  el examen
                    final preguntas = _conexion.preguntas[index];
                     titulo = preguntas['nombre_unidad'];
                     id_pregunta = preguntas['id_pregunta'];
                     id_examen= preguntas['id_examen'];
                     id_materia = preguntas['id_materia'];
                     tipoexamen = preguntas['tipo_examen'];

                    return PreguntasScreen(
                      preguntas: _conexion.preguntas,
                      index: index,
                      pageController: pageController,
                      onSelect: onSelect,
                      onSelectRespuesta: onSelectRespuesta,
                      id_alumno: _idalumno,
                      idMateria: widget.idmateria,

                    );
                  },
                ),
              ),
              Visibility(
                visible: _isLoading, // Muestra el loading cuando isLoading es true
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
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ValueListenableBuilder<int>(
              valueListenable: challengeController.currentPageNotifier,
              builder: (context, value, child) => value != _conexion.preguntas.length
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: NextButtonWidget.white(
                            label: 'Saltar',
                            onTap: (){
                              goToNextPage();
                              guardarRespuesta();
                            }
                          ),
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: NextButtonWidget.green(
                            label: 'Siguiente',
                            onTap:(){
                                goToNextPage();
                                guardarRespuesta();
                              }
                            
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(width: 7),
                        Expanded(
                          child: NextButtonWidget.green(
                            label: 'Finish',
                            onTap: () {
                             guardarRespuesta();
                              final SizeTransition5 sizeTransition5 =SizeTransition5(ResultPage(
                                            title: "$titulo" ,
                                            length: _conexion.preguntas.length,
                                            rightAnswersCount: challengeController
                                                    .rightAnswersCount,
                                            id_alumno:_idalumno,
                                            id_examen: id_examen,
                                            id_materia:id_materia,
                                            tipo_examen: tipoexamen,
                                          ));
                              Navigator.pushReplacement(
                                  context, sizeTransition5
                                  );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
