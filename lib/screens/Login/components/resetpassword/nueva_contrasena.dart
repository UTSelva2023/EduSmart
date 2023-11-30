import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../api/conexion.dart';
import '../../../../api/message.dart';
import '../../../../constants.dart';
import '../../../../utils/app_text_styles.dart';

class NuevaContrasena extends StatefulWidget {
  final String correo;
  const NuevaContrasena({
    Key? key,
    required this.correo,
  }) : super(key: key);

  @override
  State<NuevaContrasena> createState() => _NuevaContrasenaState();
}

class _NuevaContrasenaState extends State<NuevaContrasena> {
  final TextEditingController _contrasena = TextEditingController();
  final TextEditingController _contrasenafinal = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Conexion _conexion = Conexion();
  final Message _meessage =Message();
  bool _isLoading = false;
  bool _verPassword = false;
  bool _verPassword2 = false;
  bool _isLenghtValid = false;
  bool _hasNumber = false;
  bool _hasMayus = false;
  @override
  void initState() {
    super.initState();
  }
 void _savecontrasena(){
   if(_formKey.currentState!.validate()){
         if(_isLenghtValid && _hasNumber && _hasMayus){
           _sendContrasena();
          } else{
          _meessage.mostrarBottomSheet(context,
           'Error',
           'Debes de cumplir con los parametros solicitados ',
           Colors.red); 
          }   
  }
 }
  void _sendContrasena() async {
      //Mostrar un indicador al realizar la consulta
      setState(() {
        _isLoading = true;
      });
      // Enviar el correo electrónico aquí y la clave ingresada
      await _conexion.restabelcerContrasena(
          context, _contrasenafinal.text, widget.correo);
      //Ocultamos el indicador
      setState(() {
        _isLoading = false;
      });
      // Limpiar los campos después de enviar la clave
      Future.delayed(const Duration(microseconds: 900), () {
        _contrasena.clear();
        _contrasenafinal.clear();
      });
    }

  void constrasenaSegunra(String value) {
    setState(() {
      _isLenghtValid = value.length >= 8;
      _hasNumber = RegExp(r'\d').hasMatch(value);
      _hasMayus = value.contains(RegExp(r'[A-Z]'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //theme: ThemeData(primarySwatch: Color.fromARGB(0, 63, 81, 181)),
      home: Scaffold(
        body: Stack(
          children: [
            _isLoading
                ? Container(
                   width: double.infinity,
                   height: double.infinity,
                    color: azul_oscuro,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          color: Colors.blue,
                          strokeWidth: 4,
                        ), // Indicador de carga
                        const SizedBox(height: 20),
                        Text(
                          'Guardando contraseña nueva...',
                          style: AppTextStyles.bodyLightGrey15,
                        ), // Mensaje de cierre de sesión
                      ],
                    ))
                // Contenido principal de la pantalla
                : Container(
                    alignment: Alignment.center,
                    height: double.infinity,
                    //width: double.infinity,
                    color: azul_oscuro,
                    padding: const EdgeInsets.all(40.0),
                    child: SingleChildScrollView(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                              alignment: null,
                              width: 140,
                              height: 155,
                              child: const CircleAvatar(
                                backgroundColor: blanco,
                                radius: 50.0,
                                child: Icon(
                                  Icons.lock_person,
                                  size: 60.0,
                                  color: azul_oscuro,
                                ),
                              )),
                        ),
                        const SizedBox(height: 40),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Campo Matricula
                              const Text(
                                "Nueva contraseña",
                                style: TextStyle(
                                  color: blanco,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 16),
                                child: TextFormField(
                                  controller: _contrasena,
                                  obscureText: !this._verPassword,
                                  onChanged: constrasenaSegunra,
                                  cursorColor: blanco,
                                  style: const TextStyle(color: blanco),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Por favor, ingrese una contraseña";
                                    }
                                    return null;

                                    //return null;
                                  },
                                  decoration: InputDecoration(
                                      enabledBorder: const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: blanco)),
                                      focusedBorder: const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: blanco)),
                                      prefixIcon: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Icon(
                                            Icons.lock_open_rounded,
                                            color: blanco,
                                          )),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(
                                            () => this._verPassword =
                                                !this._verPassword,
                                          );
                                        },
                                        icon: Icon(this._verPassword
                                            ? Icons.remove_red_eye
                                            : Icons.visibility_off),
                                        color: this._verPassword
                                            ? blanco
                                            : Colors.grey,
                                      )),
                                ),
                              ),
                              const SizedBox(height: 10),
                              //Campo Password
                              const Text(
                                "Verificar contraseña",
                                style: TextStyle(
                                  color: blanco,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 16),
                                child: TextFormField(
                                  controller: _contrasenafinal,
                                  cursorColor: blanco,
                                  style: const TextStyle(color: blanco),
                                  obscureText: !this._verPassword2,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Por favor, ingrese una contraseña";
                                    } else if (value != _contrasena.text) {
                                      return "La contraseña no coincide con la contraseña anterior";
                                    }

                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      enabledBorder: const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: blanco)),
                                      focusedBorder: const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: blanco)),
                                      prefixIcon: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Icon(
                                            Icons.lock,
                                            color: blanco,
                                          )),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() => this._verPassword2 =
                                              !this._verPassword2);
                                        },
                                        icon: Icon(this._verPassword2
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        color: this._verPassword2
                                            ? blanco
                                            : Colors.grey,
                                      )),
                                ),
                              ),
                              Padding(
                                  padding:
                                      const EdgeInsets.only(top: 12, bottom: 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            _isLenghtValid
                                                ? Icons.check_circle_outline
                                                : Icons.error,
                                            color:
                                                _isLenghtValid ? kGreen : kred,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            'Minimo debe de contar con 8 caracteres',
                                            style:
                                                AppTextStyles.bodyLightGrey15,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            _hasNumber
                                                ? Icons.check_circle_outline
                                                : Icons.error,
                                            color: _hasNumber ? kGreen : kred,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            'Debe contar con al menos un número',
                                            style:
                                                AppTextStyles.bodyLightGrey15,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            _hasMayus
                                                ? Icons.check_circle_outline
                                                : Icons.error,
                                            color: _hasMayus ? kGreen : kred,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            'Debe contar con al menos una letra\n mayúscula',
                                            style:
                                                AppTextStyles.bodyLightGrey15,
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 40, bottom: 0),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _savecontrasena();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: blanco,
                                    minimumSize:
                                        const Size(double.infinity, 56),
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
                                    "Restablecer Contraseña",
                                    style: TextStyle(
                                        color: azul, fontFamily: "Poppins"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
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
      ),
    );
  }
}
