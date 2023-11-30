import 'dart:convert';
import 'package:edusmart/api/conexion.dart';
import 'package:edusmart/screens/Login/components/resetpassword/enviar_email.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';
import '../../../constants.dart';
import '../../../utils/transition.dart';
import '../../Menu/entry_point.dart';
import 'package:http/http.dart' as http;

class SignInFormDocente extends StatefulWidget {
  const SignInFormDocente({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInFormDocente> createState() => _SignInFormDocenteState();
}

class _SignInFormDocenteState extends State<SignInFormDocente> {
  final Conexion _conexion = Conexion();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _correoController = TextEditingController();
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
  void _mostrarBottomSheet(BuildContext context, String message) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: <Widget>[
          const  Text(
              'Error',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
             Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el BottomSheet
              },
              child: Text('Cerrar'),
            ),
          ],
        ),
      );
    },
  );
}

  //Función para el inicio de sesión
  Future<void> _login(BuildContext context) async {
  String url = 'http://${_conexion.ip}/login_docente';
    setState(() {
      isShowConfetti = true;
      isShowLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'correo': _correoController.text,
          'contrasena': _contrasenaController.text,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      Future.delayed(const Duration(seconds: 1), () {
        if (_formKey.currentState!.validate()) {
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
                   Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EntryPoint(),
                  ),
                );
              });
            },
          );
          print('Autenticación exitosa');
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
                   _mostrarBottomSheet(context, "Credenciales incorrectas");
                  
                },
              );
              print('Credenciales incorrectas');
            } else {
              // Error en el servidor.
              error.fire();
              Future.delayed(
                const Duration(seconds: 2),
                () {
                  setState(() {
                    isShowLoading = false;
                  });
                  reset.fire();
                  _mostrarBottomSheet(context, "Error en el servidor");
                },
              );
              print('Error interno del servidor');
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
                  _mostrarBottomSheet(context, "Error de conexión: $e");
                },
              );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Campo Correo electrónico
              const Text(
                "Correo electrónico",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _correoController,
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
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SvgPicture.asset("assets/icons/user1.svg"),
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
                  controller: _contrasenaController,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Por favor, ingresa una contraseña";
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
                  label: const Text("Iniciar Sesión"),
                ),
              ),
               Padding(
                padding: const EdgeInsets.only(top: 1, bottom: 1),
                child: Center(
                  child:TextButton(
                      onPressed: () {  
                        final SizeTransition5 _transition = SizeTransition5(ResetPassword());
                          Navigator.push(context, _transition);
                      },
                      child:const Text('Olvidé mi contraseña',
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

