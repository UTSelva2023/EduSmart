// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/Login/components/resetpassword/nueva_contrasena.dart';
import '../screens/Login/components/resetpassword/verificar_clave.dart';
import '../utils/transition.dart';
import 'message.dart';


class Conexion with ChangeNotifier {
  List<dynamic> materias =[];
  List<dynamic> unidades=[];
  List<dynamic> temas=[];
  List<dynamic> subtemas=[];
  List<dynamic> infografias=[];
  List<dynamic> videos=[];
  List<dynamic> preguntas=[];
  List<dynamic> respuestas= [];
  List<dynamic> ranking =[];
  Map<String, dynamic>? userData;
  String? matricula;
  List<dynamic> activo = [];
  List<dynamic> idExamen =[];
  int? _id;
  String ip ="192.168.1.90:3000"; 
  final Message _meessage =Message();
//Método para poder extraer a los alumnos autenticados
  Future<void> _getUserData(String matricula) async {
    final String url = 'http://$ip/user/$matricula';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        
          userData = jsonDecode(response.body);
          _id=userData!["id_alumno"];
         //Le pasamos el id del alumno autenticado para poder cargar las materias
          fetchMaterias(_id!);
        
      } else if (response.statusCode == 404) {
        // Usuario no encontrado.
        //print('Usuario no encontrado');
      } else {
        // Error en el servidor.
        //print('Error interno del servidor');
      }
    } catch (e) {
      // Error de conexión.
      //print('Error de conexión: $e');
    }
  }
  //Método para poder extraer las materias a las que se encuetra inscrito el alumno
Future<void> fetchMaterias(int id) async {
    final response = await http.get(Uri.parse('http://$ip/api/materias/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        materias = data;
    } else {
      print('Error al obtener las materias');
    }
  }

  //Método para poder extraer todas las unidades por materia
Future<void> fetchUnidades(int id_materia) async {
    final response = await http.get(Uri.parse('http://$ip/api/unidades/$id_materia'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        unidades = data;
    } else {
      //print('Error al obtener las unidades');
    }
  }
    //Método para poder extraer todos los  temas por unidad
Future<void> fetchTemas(int idUnidad) async {
    final response = await http.get(Uri.parse('http://$ip/api/temas/$idUnidad'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        temas = data;
    } else {
      //print('Error al obtener los temas');
    }
  }
      //Método para poder extraer todos los  subtemas por tema
Future<void> fetchSubtemas(int idTema) async {
    final response = await http.get(Uri.parse('http://$ip/api/subtema/$idTema'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        subtemas = data;
    } else {
      //print('Error al obtener los subtemas');
    }
  }
//Método para poder extraer todos las infografías por subtema
Future<void> fetchInfografia(int idSubtema) async {
    final response = await http.get(Uri.parse('http://$ip/api/infografia/$idSubtema'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        infografias = data;
    } else {
      //print('Error al obtener las infografías');
    }
  }
  //Método para poder extraer todos los videos por subtema
Future<void> fetchVideo(int idSubtema) async {
    final response = await http.get(Uri.parse('http://$ip/api/video/$idSubtema'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        videos = data;
    } else {
      print('Error al obtener los videos');
    }
  }
  //Método para verificar los examenes activos
  Future<void> fetchExamenActivo(int idMateria) async{
    final response = await http.get(Uri.parse('http://$ip/api/examenActivo?idMateria=$idMateria'));
    if(response.statusCode == 200){
      final data = json.decode(response.body);
      activo = data;
    }else{
      print('Error al obtener la consulta');
    }

  }
  //Método para poder consultar las preguntas por materia
Future<void> fetchPregunta(int idAlumno, int idMateria) async {
    final response = await http.get(Uri.parse('http://$ip/api/preguntas?id_alumno=$idAlumno&id_materia=$idMateria'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        preguntas = data;
    } else {
      print('Error al obtener las preguntas');
    }
  }
  //Función para poder almacenar la respuesta de los alumnos
Future<void> guardarRespuestas(
  int idPregunta,
  int idAlumno,
  int idEquipo,
  String respuestas,
  BuildContext context
) async{
  final String serverUrl ='http://$ip/api/enviar_respuestas';

  try{
    final response = await http.post(
      Uri.parse(serverUrl),
      body: jsonEncode({
        'id_pregunta':idPregunta,
        'id_alumno': idAlumno,
        'id_equipo': idEquipo,
        'respuestas': respuestas

      }),
      headers: {'Content-Type': 'application/json'},
    );
    if(response.statusCode == 200){
      
    } else{
      _meessage.mostrarBottomSheet(context,
       'Error',
       'No fue posible guardar las respuestas',
       Colors.red 
       );
    }
  }catch(e){
    _meessage.mostrarBottomSheet(context,
        "Error",
        "Ocurrio un error: $e",
         Colors.red
        );
  }

}
//Función para obtenre las respuestas del alumno y las respeutas de las preguntas
Future<void> fetchRespuestas(int idAlumno, int idMateria, BuildContext context) async{
    final response = await http.get(Uri.parse('http://$ip/api/respuestas?alumnoId=$idAlumno&materiaId=$idMateria'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        respuestas = data;
    } else {
      print('Error al obtener las respusetas');
    }
  
}
//Función para almacenar la gamificación
Future<void> enviarGamificacion(
  int idExamen,
  int idAlumno,
  int idMateria,
  double puntaje
)async{
    final String serverUrl ='http://$ip/api/enviar_gamificacion';
    try{
      final response = await http.post(Uri.parse(serverUrl),
      body: jsonEncode({
        'id_examen':idExamen,
        'id_alumno': idAlumno,
        'id_materia': idMateria,
        'puntajes': puntaje
      }),
      headers: {'Content-Type': 'application/json'},
      
      );
      if(response.statusCode == 200){
        print('Se insertaron los daros de manera correcta');

      }else{
        print('No se inserttaron los datod de gamificación');
      }


    }catch(e){
      print('Error de inserción: $e');

    }
  
}
//Función para obtener el id del exámen en la tabla de gamificación  por materia y alumnos inscritos en esa materia
Future<dynamic> fetchIdExamen(int idMateria, int idAlumno)async{
  final response = await http.get(Uri.parse('http://$ip/api/idexamen?idMateria=$idMateria&idAlumno=$idAlumno'));
    if(response.statusCode == 200){
      final data = json.decode(response.body);
      idExamen = data;
      print('IdExamen es:$idExamen');
    }else{
      print("Error al obter el id de exámen");
    }
}
//Función para obtener los datos de gamificación
Future<dynamic> fetchGamificacion(int idMateria, int idExamen) async{
   final response = await http.get(Uri.parse('http://$ip/api/gamificacion?idMateria=$idMateria&idExamen=$idExamen'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        ranking = data;
    } else {
      print('Error al obtener los datos de gamificación');
    }
    return ranking;

}
// Función para enviar la solicitud PUT al servidor para actualizar los datos del alumno.
Future<void> actualizarDatosAlumno(
  String telefono,
  String correoElectronico,
  String nombre,
  String app,
  String apm,
  int id,
  BuildContext context
) async {
  final String serverUrl = 'http://$ip/edit/';
  final String url = '$serverUrl$id';
      try {
      final response = await http.put(
        Uri.parse(url),
        body: {
          'telefono': telefono,
          'correo': correoElectronico,
          'nombre': nombre,
          'app': app,
          'apm': apm,
        },
      );
      if (response.statusCode == 200) {
         notificarOyentes();
         Navigator.of(context).pop();
           _meessage.mostrarBottomSheet(context,
        "Success",
        "Datos del alumno actualizados correctamente",
         Colors.green
         );
      } else {
        _meessage.mostrarBottomSheet(context,
        "Error", "Error al actualizar datos del alumno",
        Colors.red
        );
      }
      } catch (e) {
        _meessage.mostrarBottomSheet(context,
        "Error",
        "Error de conexion: $e",
         Colors.red
        );
      }
  }
  Future uploadImage(File image, String matricula,) async {
    if (image == null) return;

    String apiUrl = 'http://$ip/actualizar-foto';
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields['matricula'] =matricula;
    request.files.add(await http.MultipartFile.fromPath('foto', image.path));

    var response = await request.send();

    if (response.statusCode == 200) {
       notificarOyentes();
    } else {
  
    }
  }
  //Función para recuperar la contraseña
  Future<void> resetPassword(BuildContext context, String correo) async{
    String serverUrl ='http://$ip/recuperar-contrasena';

    try{
      final response = await http.post(Uri.parse(serverUrl),
        body: jsonEncode({
          'correo':correo
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if(response.statusCode == 200){
        final SizeTransition5 _transition = SizeTransition5( VerificarClave(correo: correo));
        Navigator.push(context, _transition);
        Future.delayed(const Duration(seconds: 2),(){
          _meessage.mostrarBottomSheet(context,
         'Success',
         'Código de verificación enviado con éxito a $correo',
          Colors.green
          );
        
        });
      }else if(response.statusCode == 400){
       _meessage.mostrarBottomSheet(context,
        'Error',
       'El correo $correo no esta registrado',
       Colors.red); 
      }else{
         _meessage.mostrarBottomSheet(context,
        'Error',
       'Error al enviar el correo de recuperación de contraseña',
       Colors.red);
      }

    }catch(e){
      _meessage.mostrarBottomSheet(context,
        'Error',
       'Ocurrio un error ${e}',
       Colors.red); 
    }

  }
  //Función para recuperar la contraseña
  Future<void> verificarClave(BuildContext context, String correo, String clave) async{
    String serverUrl ='http://$ip/verificar-clave-recuperacion';
    try{
      final response = await http.post(Uri.parse(serverUrl),
        body: jsonEncode({
          'correo':correo,
          'claveUsuario':clave
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if(response.statusCode == 200){
        Navigator.popUntil(context, ModalRoute.withName('/'));
        final SizeTransition5 _transition = SizeTransition5( NuevaContrasena(correo: correo));
        Navigator.push(context, _transition);

      }else if(response.statusCode == 400){
       _meessage.mostrarBottomSheet(context,
        'Error',
       'Clave no válida o tiempo de expiración ha concluido ',
       Colors.red); 
      }else{
         
      }

    }catch(e){
      _meessage.mostrarBottomSheet(context,
        'Error',
       'Ocurrio un error ${e}',
       Colors.red); 
    }

  }
  //Función para poder restablcer la contraseña en la base de datos
    Future<void> restabelcerContrasena(BuildContext context, String contrasena, String correo)async{
      String serverUrl ='http://$ip/actualizar-contrasena?correo=$correo';
      try {
      final response = await http.put(
        Uri.parse(serverUrl),
        body: {
          'nuevaContrasena': contrasena,
          },
      );
      if (response.statusCode == 200) {
        Navigator.pop(context);
          _meessage.mostrarBottomSheet(context,
           "Success",
          "La contraseña se reesablecio de manera exitosa",
           Colors.green
         );
       
      } else {
        _meessage.mostrarBottomSheet(context,
        "Error", "No se pudo restablcer la contraseña",
        Colors.red
        );
      }
      } catch (e) {
        _meessage.mostrarBottomSheet(context,
        "Error",
        "Error de conexion: $e",
         Colors.red
        );
      }

    }
   //Función para guardar los datos del usuario en SharedPreferences.
    Future<void> saveUserData(String matricula,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('matricula', matricula);
     notificarOyentes();
    //print('Matricula guardada $matricula');
  }
//Función para mostrar los datos del usuario con SharedPreferences
  Future<String?>getalumnoData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    matricula =prefs.getString('matricula');
    _getUserData("$matricula");
     notificarOyentes();
    return matricula;
  }
  void notificarOyentes(){
    notifyListeners();
  }


}
