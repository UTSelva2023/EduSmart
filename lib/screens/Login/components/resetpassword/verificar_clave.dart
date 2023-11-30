import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../api/conexion.dart';
import '../../../../constants.dart';
import '../../../../utils/app_text_styles.dart';

class VerificarClave extends StatefulWidget {
 final String correo;
   const VerificarClave({
        Key? key,
        required this.correo,
      }): super (key: key);

  @override
  State<VerificarClave> createState() => _VerificarClaveState();
}

class _VerificarClaveState extends State<VerificarClave> {
  final TextEditingController _clave = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Conexion _conexion =Conexion();
  bool _isLoading = false;
  //bool isAnimating = false;

  @override
  void initState() {
    super.initState();
  }
  void _sendClave() async {
    if (_formKey.currentState!.validate()) {
      //Mostrar un indicador al realizar la consulta
        setState(() {
          _isLoading = true;
        });
      // Enviar el correo electrónico aquí y la clave ingresada
      await _conexion.verificarClave(context, widget.correo, _clave.text,);
      //Ocultamos el indicador 
          setState(() {
            _isLoading = false;
          });
      // Limpiar los campos después de enviar la clave
       Future.delayed(
         const Duration(microseconds: 900),
         (){
          _clave.clear();
         }
       );
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //theme: ThemeData(primarySwatch: Color.fromARGB(0, 63, 81, 181)),
      home: Scaffold(
        body:Stack(
        children: [
           _isLoading ?
          Container(
            color: azul_oscuro,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                const CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      color: Colors.blue,
                      strokeWidth: 4,
                    ), // Indicador de carga
                const SizedBox(height: 20),
                Text(
                      'Validadndo clave...',
                      style: AppTextStyles.bodyLightGrey15,
                  ), // Mensaje de cierre de sesión
                ],
              )
          )
          // Contenido principal de la pantalla
          : Center(
          child:  Center(
          child: Container(
            color: azul_oscuro,
            padding: const EdgeInsets.all(40.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Container(
                    width: 155,
                    height: 155,
                    child: const CircleAvatar(
                      backgroundColor: blanco,
                      radius: 50.0,
                      child: Icon(Icons.password_rounded,
                                  size: 60.0,
                                  color:azul_oscuro,
                                  ),
                    )
                  ),
                
                 const SizedBox(height: 16.0),

                  const Text(
                    "Introduce la clave que recibiste en tu correo",
                    style: TextStyle(
                        color: blanco, fontFamily:
                         "Poppins", fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                  ),
                 const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _clave,
                      cursorColor: blanco,
                      style: const TextStyle(color: blanco),
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Por favor, ingrese la clave.";
                        }
                        return null;
                      },
                      decoration:const InputDecoration(
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: blanco)
                        ),
                        focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: blanco)
                        ),
                        counterStyle: TextStyle(color: blanco),
                        prefixIcon: Icon(Icons.key_sharp, color: blanco),
                      ),
                    ),
                  ),
                  Padding(
                    padding:const EdgeInsets.only(top: 12, bottom: 0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _sendClave();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blanco,
                        minimumSize: const Size(double.infinity, 56),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
                          ),
                        ),
                      ),
                      icon: const Icon(
                        CupertinoIcons.arrow_right,
                        color: azul,
                      ),
                      label: const Text(
                        "Verificar Clave",
                        style: TextStyle(color: azul, fontFamily: "Poppins"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ),
          // Botón de regreso
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              color: blanco,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    ) 
    );
  }
}
