import 'package:edusmart/api/conexion.dart';
import 'package:edusmart/utils/transition.dart';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../Quizz/widgets/nextbutton/next_button_widget.dart';
import 'ver_respuestas.dart';
//import '../Quiz/widgets/nextbutton/next_button_widget.dart';

class ResultPage extends StatefulWidget {
  final String title;
  final int length;
  final int rightAnswersCount;
  final int id_alumno;
  final int id_examen;
  final int id_materia;
  final String tipo_examen;

  const ResultPage({
    Key? key,
    required this.title,
    required this.length,
    required this.rightAnswersCount,
    required this.id_alumno,
    required this.id_examen,
    required this.id_materia,
    required this.tipo_examen
  }) : super(key: key);

  @override
  _ResultPageState createState()=> _ResultPageState();
}
class _ResultPageState extends State<ResultPage>{
  final Conexion _conexion = Conexion();
  bool _isLoading = true;
  double puntajeFinal = 0;
  int puntaje = 0;
  String texto = "";
  TextStyle style = TextStyle();
  TextStyle get _bien => AppTextStyles.bien;
  TextStyle get _malo => AppTextStyles.malo;
  TextStyle get _muybien => AppTextStyles.muybien;
  @override
  void initState() {
    super.initState();
    _conexion.fetchRespuestas(widget.id_alumno, widget.id_materia, context);
 

    Future.delayed(const Duration(seconds: 2),(){
      setState(() {
        _isLoading = false;
        calcularPuntaje();
        guardarGamificacion(puntajeFinal, widget.tipo_examen);
      });
    });
  }

  //Calculamos el puntaje cuando la respuesta es correcta se suma 1
  int calcularPuntaje(){
    for(var item in _conexion.respuestas){
        if(item['respuesta'] == item['respuestaAlumno']){
          puntaje ++;
        }
         obtenerMensaje(puntaje, _conexion.respuestas.length);
    }
    return puntaje;
  }
  //Calculamos el porcentaje que se obtuvo de acuerdo a las respuestas correctas
  String obtenerMensaje(int puntaje, int cantiadPregunta){
    double  porcentaje = (puntaje / cantiadPregunta) *100;
    if(porcentaje <= 34){
      texto = 'Malo';
      style = _malo;
    }else if(porcentaje <= 74){
      texto ='Bien!';
      style = _bien;
    }else{
      texto ='Excelente!';
      style = _muybien;
    }
    //Obtenemos el puntaje final para despues almacenarlo
    puntajeFinal = porcentaje;
    return texto;
    
  }
  //Guardamos los datos de acuerdo al tipo de examen que se publica
   void guardarGamificacion(double puntajes, String tipoexamen){
     if(tipoexamen == 'Individual'){
          _conexion.enviarGamificacion(widget.id_examen,widget.id_alumno, widget.id_materia, puntajes);
     }else if(tipoexamen== 'Equipo'){
       print('Gamificacion equipo');

     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.only(
          top: 100,
        ),
        child:Stack(
          children: [
          Visibility(
          visible: !_isLoading,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(children: [
              Text(
                "Resultados!",
                style: AppTextStyles.heading40,
              ),
              const SizedBox(
                height: 40,
              ),
              Image.asset(
              "assets/icons/trophy.png",
            ),
            const SizedBox(
                height: 16,
              ),
              Text(texto, style: style),
              
              
              const SizedBox(
                height: 16,
              ),
              Text(
                "Has concluido el examen de la unidad:",
                style: AppTextStyles.body,
              ),
              Text(
                " ${widget.title} ",
                style: AppTextStyles.bodyBold,
              ),
              Text(
                "con ${puntaje} de  ${widget.length} respuestas correctas.",
                style: AppTextStyles.body,
              ),
            ]),
            Column(
              children: [
               Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: NextButtonWidget.green(
                          label: "Ver respuestas",
                          onTap: () {
                            final SizeTransition5 transition5 = SizeTransition5(VerRespuestas(respuestas: _conexion.respuestas));
                            Navigator.push(context, transition5);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
               const SizedBox(height: 24),
               /* Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: NextButtonWidget.transparent(
                          label: "Volver a inicio",
                          onTap: () {
                           Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                )*/
              ],
            )
          ],
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
      )
      ),
    );
  }
}
