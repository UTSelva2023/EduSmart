import 'package:flutter/material.dart';
import '../views/perfil.dart';
import 'rive_model.dart';

int idMateria = 0;
class Menu {
  final String title;
  final RiveModel rive;
  final String? ruta;
  final Widget? page;

  Menu({required this.title, 
  required this.rive,
   this.ruta,
   this.page,
  });
  void idmateria(int id){
    idMateria = id;
  }
}


List<Menu> sidebarMenus = [
  Menu(
    title: "Perfil",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "USER",
        stateMachineName: "USER_Interactivity"),
    page:const  ProfileApp(), 
  ),
];
List<Menu>menu2=[
  Menu(
    title: "Acerca de",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "CHAT",
        stateMachineName: "CHAT_Interactivity"),
        ruta: "",
  ),
 Menu(
    title: "Cerrar Sesión",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "TIMER",
        stateMachineName: "TIMER_Interactivity"),
    ruta: "/"
  ),
];
List<Menu>home=[
   Menu(
    title: "Home",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "HOME",
        stateMachineName: "HOME_interactivity"),
        ruta: '/home'
  ),
];
List<Menu>ranking=[
   Menu(
    title: "Ranking",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "LIKE/STAR",
        stateMachineName: "STAR_Interactivity"),
  ),
];


