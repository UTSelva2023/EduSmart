import 'package:edusmart/utils/transition.dart';
import 'package:flutter/material.dart';
import '../../api/conexion.dart';
import '../../views/perfil.dart';
import '../appbar/appbar_widget.dart';
import 'widgets/subtema.dart';


class SubtemaPage extends StatefulWidget {
  const SubtemaPage({super.key, required this.titulo, required this.id_tema,});
  final String titulo;
  final int id_tema;
  @override
  State<SubtemaPage> createState()=> _SubtemaPageState();
  }

  class _SubtemaPageState extends State<SubtemaPage>{
   final Conexion _conexion = Conexion();
    bool isLoading = true;
    @override
    void initState(){
      super.initState();
      _conexion.getalumnoData();
      Future.delayed(const Duration(seconds: 2), (){
        setState(() {
        isLoading= false; 
        });
      });
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        titulo: widget.titulo,
        isLoading: isLoading,
        context: context,
        conexion: _conexion,
        boton_regresar: false,
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Subtemas",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              SubtemaScreen(titulo: widget.titulo, id_tema: widget.id_tema),
             
            ],
          ),
        ),
      ),
    )
    );
  }
}
