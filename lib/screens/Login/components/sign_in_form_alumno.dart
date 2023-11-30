import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';
import '../../../api/conexion.dart';
import '../../../api/message.dart';
import '../../../constants.dart';
import '../../../utils/transition.dart';
import '../../Menu/entry_point.dart';
import 'resetpassword/enviar_email.dart';
import 'package:http/http.dart' as http;

class SignInForm extends StatefulWidget {
  const SignInForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Conexion _conexion = Conexion();
  final Message _message =Message();
  final TextEditingController _matriculaController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  bool isShowLoading = false;
  bool isShowConfetti = false;
  late SMITrigger error;
  late SMITrigger success;
  late SMITrigger reset;

  late SMITrigger confetti;

  void _onCheckRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');

    artboard.addController(controller!);
    error = controller.findInput<bool>('Error') as SMITrigger;
    success = controller.findInput<bool>('Check') as SMITrigger;
    reset = controller.findInput<bool>('Reset') as SMITrigger;
  }

  void _onConfettiRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);

    confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger;
  }
  //Funcion que valida los datos ante un caracter malisioso
  bool validarEntrada(String entrada){
    List<String> caracteresMaliciosos =["'", ";", "--", "/* ", "%", "=", "*", "/"];
    return caracteresMaliciosos.any((caracter) => entrada.contains(caracter));
  }
  //Función para el inicio de sesión
  Future<void> _login(BuildContext context) async {
    String url = 'http://${_conexion.ip}/login';
    setState(() {
      isShowConfetti = true;
      isShowLoading = true;
    });
    try {
      Future.delayed(const Duration(seconds: 1), ()async {
        if (_formKey.currentState!.validate()) {

           final response = await http.post(
              Uri.parse(url),
              body: jsonEncode({
                'matricula': _matriculaController.text,
                'contrasena': _contrasenaController.text,
              }),
              headers: {'Content-Type': 'application/json'},
            );
          if (response.statusCode == 200) {
          // Éxito en la autenticación.
          success.fire();
          Future.delayed(
            const Duration(seconds: 2),
            () {
              setState(() {
                isShowLoading = false;
              });
              confetti.fire();
              // Navigate & hide confetti
              Future.delayed(const Duration(seconds: 1), () {
                // Navigator.pop(context);
                   Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EntryPoint(),
                      ),
                      (Route<dynamic> route) => false, // Predicado para eliminar todas las rutas anteriores
                    );
              });
            },
          );
          final matrucula = _matriculaController.text.trim();
          _conexion.saveUserData(matrucula);
          //print('Autenticación exitosa');
          } else if (response.statusCode == 401) {
              // Credenciales incorrectas.      
              error.fire();
              Future.delayed(
                const Duration(seconds: 2),
                () {
                  setState(() {
                    isShowLoading = false;
                  });
                  reset.fire();
                   _message.mostrarBottomSheet(context,
                    "Error",
                   "Credenciales Incorrectas",
                   Colors.red
                   );
                  
                },
              );

              //print('Credenciales incorrectas');
            } else if(response.statusCode == 404) {
              // Error en el servidor.
              error.fire();
              Future.delayed(
                const Duration(seconds: 2),
                () {
                  setState(() {
                    isShowLoading = false;
                  });
                  reset.fire();
                  _message.mostrarBottomSheet(context,
                   "Error",
                   "Matrícula no encontrada",
                   Colors.red
                   );
                },
              );
              //print('Error interno del servidor');
            }else{
              error.fire();
              Future.delayed(
                const Duration(seconds: 2),
                () {
                  setState(() {
                    isShowLoading = false;
                  });
                  reset.fire();
                },
              );

            }
          
        }else{
          error.fire();
              Future.delayed(
                const Duration(seconds: 2),
                () {
                  setState(() {
                    isShowLoading = false;
                  });
                  reset.fire();
                },
              );
        }
      });
    } catch (e) {
      // Error de conexión.
      error.fire();
              Future.delayed(
                const Duration(seconds: 2),
                () {
                  setState(() {
                    isShowLoading = false;
                  });
                  reset.fire();
                  _message.mostrarBottomSheet(context,
                   "Error",
                   "Error de conexión: $e",
                   Colors.red);
                },
              );
    }
  }
//Cuerpo del login
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Campo Matricula
              const Text(
                "Matricula",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                   key: const Key('username'),
                  controller: _matriculaController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Por favor, ingrese una matricula";
                    }if(validarEntrada(value)){
                        return "Algun caracter ingresado es inválido";

                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SvgPicture.asset("assets/icons/user-graduat.svg"),
                    ),
                  ),
                ),
              ),
              //Campo Password
              const Text(
                "Password",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                   key: const Key('password'),
                  controller: _contrasenaController,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Por favor, ingrese una contraseña";
                    }
                    if(validarEntrada(value)){
                      return "Algun caracter ingresado es inválido";

                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SvgPicture.asset("assets/icons/lock-solid.svg"),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    _login(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: azul,
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
                    color: blanco,
                  ),
                  key:const Key('login_button'),
                  label: const Text("Iniciar Sesión"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1, bottom: 1),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      final SizeTransition5 _transition = SizeTransition5(ResetPassword());
                      Navigator.push(context, _transition);
                    },
                    child: const Text('Olvidé mi contraseña',
                        style: TextStyle(
                          color: azul,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
        isShowLoading
            ? CustomPositioned(
                child: RiveAnimation.asset(
                  'assets/RiveAssets/check.riv',
                  fit: BoxFit.cover,
                  onInit: _onCheckRiveInit,
                ),
              )
            : const SizedBox(),
        isShowConfetti
            ? CustomPositioned(
                scale: 6,
                child: RiveAnimation.asset(
                  "assets/RiveAssets/confetti.riv",
                  onInit: _onConfettiRiveInit,
                  fit: BoxFit.cover,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, this.scale = 1, required this.child});

  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: 100,
            width: 100,
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}


