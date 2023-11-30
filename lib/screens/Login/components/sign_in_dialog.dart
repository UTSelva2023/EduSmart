import 'package:edusmart/constants.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'sign_in_form_docente.dart';
import 'sign_in_form_alumno.dart';
void showCustomDialog(BuildContext context, {required ValueChanged onValue}) {
   int selectIndex =0;
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return  StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Center(
        child: Container(
          //Tamaño del showdialog
          height: 500,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 30),
                blurRadius: 60,
              ),
              const BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 30),
                blurRadius: 60,
              ),
            ],
          ),
           //Formulario
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body:  Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children:  [
                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    //Toglee-Switch
                    ToggleSwitch(
                      minWidth: 125.0,
                      cornerRadius: 20.0,
                      activeBgColors: [[azul], [azul]],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      initialLabelIndex: selectIndex,
                      totalSwitches: 2,
                      labels: ['Alumno', 'Docente'],
                      radiusStyle: true,
                      onToggle: (index) { 
                        setState(() {
                          selectIndex = index!;
                        });
                        }
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      //Switch
                    ),
                     
                   //Formulario docente.
                    Visibility(
                      visible: selectIndex==1,
                        child:const SignInFormDocente(), 
                      ),
                   //Formulario alumno.
                    Visibility(
                      visible: selectIndex==0,
                        child:const  SignInForm() ,
                      )
                  ],
                ),
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: -48,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      
        );
      }
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      // if (anim.status == AnimationStatus.reverse) {
      //   tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
      // } else {
      //   tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      // }

      tween = Tween(begin: const Offset(0, -1), end: Offset.zero);

      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: anim, curve: Curves.easeInOut),
        ),
        // child: FadeTransition(
        //   opacity: anim,
        //   child: child,
        // ),
        child: child,
      );
    },
  ).then(onValue);
}


