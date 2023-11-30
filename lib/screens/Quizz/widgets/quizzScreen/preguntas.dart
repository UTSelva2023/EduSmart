import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../api/conexion.dart';
import '../../../../utils/app_colors.dart';
import '../videoScreen/video.dart';
import 'respuestas.dart';

class PreguntasScreen extends StatefulWidget {
  final List<dynamic> preguntas;
  final int index;
  final PageController pageController;
  final ValueChanged<bool> onSelect;
  final ValueChanged<String> onSelectRespuesta;
  final int id_alumno;
  final int idMateria;
  const PreguntasScreen({
    Key? key,
    required this.preguntas,
    required this.index,
    required this.pageController,
    required this.onSelect,
    required this.onSelectRespuesta,
    required this.id_alumno,
    required this.idMateria
  }): super(key: key);
  @override
  _PreguntasScreenState createState() => _PreguntasScreenState();
}

class _PreguntasScreenState extends State<PreguntasScreen> {
  final Conexion _conexion =Conexion();
  String tiempo_respuesta = "";
  Duration _duration = const Duration();
  Timer? _timer;
  // ignore: non_constant_identifier_names
  bool _color_red = false;
  bool _isDisable = false;
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _conexion.fetchPregunta(widget.id_alumno, widget.idMateria);
    _startTimer();
    //Dividimos el tiempo de respuesta en horas, minutos y segundos
    tiempo_respuesta = widget.preguntas[widget.index]["tiempo_respuesta"];
    List<String> tiempo = tiempo_respuesta.split(":");
    int horas = int.parse(tiempo[0]);
    int minutos = int.parse(tiempo[1]);
    int segundos = int.parse(tiempo[2]);
    _duration = Duration(hours: horas, minutes: minutos,seconds: segundos);

  }
   //Iniciar el cronometro del tiempo de respuesta
   void _startTimer(){
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(_duration.inSeconds > 0){
        setState(() {
          _duration -= const Duration(seconds: 1);
          //Indicamos que si la duraciion es igual 59 segundos, cambie de color
          if(_duration.inSeconds == 59){
            _color_red= true;
          }
          if(_duration.inSeconds == 00){
            _isDisable = true;
          }
        });
        //Cuando llega a cero se detiene el tiempo avanza a la siguiente pregunta de manera automatica
      }else{
        _timer?.cancel();
        goToNextPage();
      }
     });
  }
//Avanzar a la siguiente pregunta del examen
    void goToNextPage() {
      widget.pageController.nextPage(
        duration:const  Duration(
          milliseconds: 100,
        ),
        curve: Curves.linear,
      );
    }
    
    void onSelect(int index){
      setState(() {
      if (selectedIndex == index) {
        // Deselecciona la respuesta si se selecciona nuevamente
        // ignore: unnecessary_null_comparison
        selectedIndex != null;
      } else {
        selectedIndex = index;
      }
    });
    }

  @override
  Widget build(BuildContext context) {
    final pregunta = widget.preguntas[widget.index];
    //Convertimos los incisos en un arrlego para mostrarlos en el examen, idicamos que se aceptan valores NULL
    final List<String?> incisos=[
     pregunta["inciso_a"],
     pregunta["inciso_b"],
     pregunta["inciso_c"],
     pregunta["inciso_d"]
     ];
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Padding(padding:  const EdgeInsets.fromLTRB(0, 0, 20, 20),
              child:Align(
              alignment: Alignment.centerRight,
              child: Container(
                  width: 104,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    // Color de fondo
                    color: _color_red ? AppColors.darkRed : AppColors.limon, 
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time_filled_outlined, // Ícono de tiempo
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8), 
                      //Se muestra el Tiempo
                      Text(
                        "${_duration.inHours}:${_duration.inMinutes %60}:${_duration.inSeconds %60}", 
                        style:const TextStyle(
                          color: Colors.white, 
                        ),
                      ),
                    ],
                  ),
                ),
              ), 
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child:Text(
                pregunta["enunciado"],
                style: const TextStyle(
                 fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ), 
              ),
              const SizedBox(height: 15),
              mostrarVideo(pregunta['multimedia']),
              //Mostramos las respuetas haciendo uso del arreglo inciso
             const SizedBox(height: 10),
             //Se recorre una lista de incisos y solo procesar aquellos que no sean NULL
             for (var i = 0; i < incisos.length; i++)
              if (incisos[i] != null)
                Respuestas(
                  incisos: incisos[i]!, 
                  isDisable: _isDisable,
                  isSelected: selectedIndex == i,
                  onTap: (value) {
                    setState(() {
                      onSelect(i);
                      widget.onSelect(value);
                    });
                  },
                   onTapRespuesta: (value) {
                    setState(() {
                      onSelect(i);
                      widget.onSelectRespuesta(value);
                    });
                  },
                ),
            ],
          ) 
        ),
      ],
    );
  }
  Widget mostrarVideo(url){
  final imageFileName = url;
  final RegExp regExp = RegExp(r'^https:\/\/www\.youtube\.com\/watch\?v=.+');
    if (url != null && regExp.hasMatch(url)) {
      // Es un enlace de YouTube, muestra el video
      return VerVideoExamen(filePath: url);
    }else if(imageFileName != null && (imageFileName.endsWith('.jpg')|| imageFileName.endsWith('png') ||imageFileName.endsWith('gif'))){
      return Image.asset(
                        'assets/box/${imageFileName}',
                        width: 320, 
                        height: 200, 
                        fit: BoxFit.contain,
              );
    }else if(url == null){
      return Text('');

    }else{
      return Text('Archivo no valido');

    }
  }
  
  //Detiene el tiempo para dar inicio al siguiente registro
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}