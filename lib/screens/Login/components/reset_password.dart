import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//bool isAnimating = false;

  late RiveAnimationController _btnAnimationController;
  
  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: true,
    );
    super.initState();
  }
  void _sendEmail() {
    if (_formKey.currentState!.validate()) {
      _btnAnimationController.isActive = true;
      // Enviar el correo electrónico aquí
       Future.delayed(
         const Duration(microseconds: 900),
         (){
          _emailController.clear();
         }
       );
      // Limpiar los campos después de enviar el correo
      
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
          // Contenido principal de la pantalla
          Center(
            child:  Center(
          child: Container(
            color: azul_oscuro,
            padding: EdgeInsets.all(40.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 155,
                    height: 155,
                    child: RiveAnimation.asset(
                      "assets/RiveAssets/mail-send.riv",
                     controllers: [_btnAnimationController],
                    ),
                  ),
                
                 const SizedBox(height: 16.0),

                  const Text(
                    "Recibe un correo electrónico para",
                    style: TextStyle(
                        color: blanco, fontFamily: "Poppins", fontSize: 18),
                  ),
                  const Text(
                    "restablecer la contraseña",
                    style: TextStyle(
                        color: blanco, fontFamily: "Poppins", fontSize: 18),
                  ),
                 const SizedBox(height: 16.0),
                  //Campo email
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 272, 0),
                    child: Text(
                      "Email",
                      style: TextStyle(
                        color: blanco,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: TextFormField(
                      controller: _emailController,
                      cursorColor: blanco,
                      style: const TextStyle(color: blanco),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Por favor, ingrese un correo electrónico.";
                        }
                        final emailRex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          caseSensitive: false,
                          multiLine: false
                        );
                        if (!emailRex.hasMatch(value)){
                          return 'Por favor, ingrese un correo electrónico válido';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        enabledBorder:const UnderlineInputBorder(
                          borderSide: BorderSide(color: blanco)
                        ),
                        focusedBorder:const UnderlineInputBorder(
                          borderSide: BorderSide(color: blanco)
                        ),
                        prefixIcon: Padding(
                          padding:const  EdgeInsets.symmetric(horizontal: 8),
                          child:
                              SvgPicture.asset("assets/icons/correo.svg"),
                        ),
                      ),
                    ),
                  ),
                 const SizedBox(height: 16.0),
                  Padding(
                    padding:const EdgeInsets.only(top: 12, bottom: 0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _sendEmail();
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
                        "Restablecer Contraseña",
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
