import 'dart:ui';
import 'package:edusmart/main.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../../constants.dart';
import 'components/btn_animado.dart';
import 'components/sign_in_dialog.dart';

//Pantalla principal de la aplicación
class OnbodingScreen extends StatefulWidget {
  const OnbodingScreen({super.key});

  @override
  State<OnbodingScreen> createState() => _OnbodingScreenState();
}

class _OnbodingScreenState extends State<OnbodingScreen> {
  late RiveAnimationController _btnAnimationController;

  bool isShowSignInDialog = false;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
          AnimatedPositioned(
            top: isShowSignInDialog ? -50 : 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            duration: const Duration(milliseconds: 260),
            child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 70),
                    ),
                     const Text(
                            "Bienvenido a",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Poppins",
                              height: 1.2,
                            ),
                          ),
                     const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                    ),
                        Image.asset(
                        'assets/logo.png',
                        width: 325, // Ajusta el ancho de la imagen según tus necesidades
                        height: 325, // Ajusta la altura de la imagen según tus necesidades
                        fit: BoxFit.contain, // Ajusta el modo de ajuste de la imagen según tus necesidades
                      ),
                   const Spacer(flex: 1),
                    AnimatedBtn(
                      btnAnimationController: _btnAnimationController,
                      press: () {
                        _btnAnimationController.isActive = true;

                        Future.delayed(
                          const Duration(milliseconds: 800),
                          () {
                            setState(() {
                              isShowSignInDialog = true;
                            });
                            showCustomDialog(
                              context,
                              onValue: (_) {
                                setState(() {
                                  isShowSignInDialog = false;
                                });
                              },
                            );
                          },
                        );
                      },
                    ),
                    Padding(
                      padding:const EdgeInsets.symmetric(vertical: 25),
                      child: TextButton(
                                onPressed: () {  
                                },
                                child:const Text('Terminos y condiciones',
                                    style: TextStyle(
                                        color: azul,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline)),
                              ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
void main(){
  runApp(MyApp());
}
