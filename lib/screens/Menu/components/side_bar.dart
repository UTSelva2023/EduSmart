import 'package:edusmart/constants.dart';
import 'package:edusmart/utils/transition.dart';
import 'package:flutter/material.dart';
import '../../../api/conexion.dart';
import '../../../model/menu.dart';
import '../../../utils/rive_utils.dart';
import '../../../views/ranking.dart';
import '../../Quizz/quizz_page.dart';
import 'info_card.dart';
import 'side_menu.dart';
class SideBar extends StatefulWidget {
  const SideBar({
    super.key, 
    required this.idmateria,
    required this.tituloMateria
  });
  final int idmateria;
  final String tituloMateria;


  @override
  State<SideBar> createState() => _SideBarState();
}
class _SideBarState extends State<SideBar> {
  bool _isLoggingOut = false;
  bool isLoading= true;
  final Conexion _conexion = Conexion();
  Menu selectedSideMenu= home[0];
  bool isEnabled = true;
  int idalumno =0;
  int idExamen =0;
  
  @override
  void initState(){
    _conexion.fetchExamenActivo(widget.idmateria);
    super.initState();
    _conexion.getalumnoData();
    toggleButton();

    Future.delayed(const Duration(milliseconds: 900), () {
        setState(() {
         isLoading = false;
         idalumno = _conexion.userData!['id_alumno'];
         //Le pasamos el valor coparando el estado en el que se encuetra, para habilitar el bóton de exámen
         isEnabled = (_conexion.activo[0]['activo'] == 'true') ? true : false;
         Future.delayed(const Duration(milliseconds: 1000),(){
           _conexion.fetchIdExamen(widget.idmateria, idalumno);
           Future.delayed(const Duration(milliseconds: 1100),(){
           //Le pasamos el id del examen
           setState(() {
              idExamen = _conexion.idExamen[0]['id_examen'];
           });
           
         });
         });
        });
    });
    
  }

  //Función para verificar el estado del botón examen
   void toggleButton() {
    setState(() {
      isEnabled = !isEnabled;
    });
  }

  // Función para simular el cierre de sesión
  Future<void> _logout(String ruta) async {
      setState(() {
        _isLoggingOut = true;
      });
    // Esperar unos segundos antes de redirigir al usuario al inicio
      await Future.delayed(const Duration(seconds: 2));

      Navigator.of(context).pushNamedAndRemoveUntil(ruta, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Container(
        width: 288,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF17203A),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child:_isLoggingOut? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:const [
                  CircularProgressIndicator(), // Indicador de carga
                  SizedBox(height: 20),
                  Text('Cerrando sesión...', 
                  style: TextStyle(color: blanco, fontFamily: "Poppins"),
                  ), // Mensaje de cierre de sesión
                ],
              ) :
         DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _conexion.userData == null ? Visibility( 
                  visible: isLoading, // Muestra el loading cuando isLoading es true
                  child: const  Center(
                    child: CircularProgressIndicator(), // Puedes personalizar el loading según tus necesidades
                  ),
                ):
              Visibility(
                visible: !isLoading,
                child: InfoCard(
                  name: "Hola",
                  bio: '${_conexion.userData!['nombre']} ${_conexion.userData!['app']} ',
                  foto: '${_conexion.userData!['foto']}',
                ),
              ),
              
              const Padding(
                padding: EdgeInsets.only(left: 24, top: 10, bottom: 0),
              ),
              Center(
                 child:Container(
                 padding: EdgeInsets.zero,
                 height: 40.0,
                 width: 200,
                  child: ElevatedButton(
                    onPressed: isEnabled ? () {
                        final SizeTransition5 _transition =SizeTransition5(QuizzPage(idalumno: idalumno, idmateria: widget.idmateria));
                        Navigator.push(context, _transition);
                    } : null,
                    child:  Text('Examen',
                        style:  TextStyle(color: blanco, fontSize: 19),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // Borde redondeado
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Color(0xFF818181); // Color cuando el botón está deshabilitado
                          }
                          return Color(0xFFFA744B); // Color cuando el botón está habilitado
                        },
                      ),
                    )
                  ),
                )
              ),
              const Padding(
                padding: EdgeInsets.only(left: 24, top: 30, bottom: 0),
              ),
              //Se muestra la opción de home para navegar a la ruta home
               ...home
                  .map((menu) => SideMenu(
                        menu: menu,
                        selectedMenu: selectedSideMenu,
                        //Indicamos la ruta que alcualmente esta gurardada en nuestro modelo de datos del menú
                        press: () {
                          RiveUtils.chnageSMIBoolState(menu.rive.status!);
                          setState(() {
                            selectedSideMenu = menu;
                            Future.delayed(const Duration(seconds: 2),(){
                              //Navegamos a la ruta inicio
                              Navigator.of(context).pushNamedAndRemoveUntil(menu.ruta!, (route) => false);
                            });
                          });
                        },
                        riveOnInit: (artboard) {
                          menu.rive.status = RiveUtils.getRiveInput(artboard,
                              stateMachineName: menu.rive.stateMachineName);
                        },
                      ))
                  .toList(),
                  //Mostramos las demas opciones para el menú perfil, rankong, Acerca de
              ...sidebarMenus
                  .map((menu) => SideMenu(
                        menu: menu,
                        selectedMenu: selectedSideMenu,
                        //Indicamos la ruta a la cual se va navegar que previamente ya se tiene en el modelo de Menú
                        press: () {
                          RiveUtils.chnageSMIBoolState(menu.rive.status!);
                          setState(() {
                            //final String titulo = tema[menu.index].text;
                            selectedSideMenu = menu;
                            final SizeTransition5 transition5 = SizeTransition5(menu.page!);
                            Future.delayed(const Duration(seconds: 2),(){
                              //Navigator.pushNamed(context, menu.ruta);
                             Navigator.push(context, transition5);
                             //Despúes de naegar restablecemos el idicador de nuevo a home
                             setState(() {
                                  selectedSideMenu = home[0];
                             });
                            });
                            
                            /* Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubtemaMenu(subtemas: tema[menu.index].subtemas, titulo: titulo,),
                            ),
                            );*/
                          });
                        },
                        riveOnInit: (artboard) {
                          menu.rive.status = RiveUtils.getRiveInput(artboard,
                              stateMachineName: menu.rive.stateMachineName);
                        },
                      ))
                  .toList(),
                  ...ranking
                  .map((menu) => SideMenu(
                  menu: menu,
                  selectedMenu: selectedSideMenu,
                   press: () {
                          RiveUtils.chnageSMIBoolState(menu.rive.status!);
                          setState(() {
                            //final String titulo = tema[menu.index].text;
                            selectedSideMenu = menu;
                            final SizeTransition5 transition5 = SizeTransition5(Ranking(idMateria: widget.idmateria,
                                idAlumno: idalumno,
                                materia: widget.tituloMateria,
                                idExamen: idExamen
                                ));
                            menu.idmateria(widget.idmateria);
                            Future.delayed(const Duration(seconds: 2),(){
                              //Navigator.pushNamed(context, menu.ruta);
                             Navigator.push(context, transition5);
                             //Despúes de naegar restablecemos el idicador de nuevo a home
                             setState(() {
                                  selectedSideMenu = home[0];
                             });
                            });
                            
                          });
                        }, 
                        riveOnInit: (artboard) {
                          menu.rive.status = RiveUtils.getRiveInput(artboard,
                              stateMachineName: menu.rive.stateMachineName);
                        }, 
                  )
                   ).toList(),
                  ...menu2
                  .map((menu) => SideMenu(
                        menu: menu,
                        selectedMenu: selectedSideMenu,
                        //Indicamos la ruta, y le pasamos un número que relacione a los subtemas
                        press: () {
                          RiveUtils.chnageSMIBoolState(menu.rive.status!);
                          setState(() {
                            //final String titulo = tema[menu.index].text;
                            selectedSideMenu = menu;
                            Future.delayed(const Duration(seconds: 2),(){
                              _logout(menu.ruta!);
                            });
                           
                            /* Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubtemaMenu(subtemas: tema[menu.index].subtemas, titulo: titulo,),
                            ),
                            );*/
                          });
                        },
                        riveOnInit: (artboard) {
                          menu.rive.status = RiveUtils.getRiveInput(artboard,
                              stateMachineName: menu.rive.stateMachineName);
                        },
                      )).toList(),
              const Padding(
                padding: EdgeInsets.only(left: 24, top: 8, bottom: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

