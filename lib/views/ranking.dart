import 'package:edusmart/api/conexion.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../screens/Quizz/widgets/nextbutton/next_button_widget.dart';

class Ranking extends StatefulWidget {
  const Ranking(
      {super.key,
      required this.idMateria,
      required this.idAlumno,
      required this.materia,
      required this.idExamen
      });
  final int idMateria;
  final int idAlumno;
  final String materia;
  final int idExamen;

  @override
  State<Ranking> createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  final Conexion _conexion = Conexion();
  List<dynamic> names = [];
  List<dynamic> scores = [];
  List<Object> username = [];
  List<dynamic> avatar = [];
  List<dynamic> idAlumnos = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _conexion.fetchGamificacion(widget.idMateria, widget.idExamen);

    Future.delayed(const Duration(milliseconds: 900), () {
      setState(() {
        obtenerLista();
      });
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  void obtenerLista() {
    var data = _conexion;
    setState(() {
      names = data.ranking.map((item) => item['nombre']).toList();
      scores = data.ranking.map((item) => item['puntaje']).toList();
      avatar = data.ranking.map((item) => item['foto']).toList();
      idAlumnos = data.ranking.map((item) => item['id_alumno']).toList();
    });
  }

  Future<void> _refreshData() async {
    //Esperamos a una respuesta de las preguntas
    await Future.delayed(const Duration(milliseconds: 800), () {
      _conexion.fetchGamificacion(widget.idMateria, widget.idExamen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: _conexion.fetchGamificacion(widget.idMateria, widget.idExamen),
        builder: (context, snapshot) {
          //Esperamos una respuesta de los datos
          if (!snapshot.hasData) {
            return Container(
                color: azul_oscuro,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.blue,
                  strokeWidth: 4,
                ));
            //Si ocurre un error  se muestra la siguiente mensaje
          } else if (snapshot.hasError) {
            return Container(
                color: azul_oscuro,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Ocurrio un error ${snapshot.error}",
                        style: AppTextStyles.bodyLightGrey20,
                        textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    NextButtonWidget.white(
                        label: "Reintentar",
                        onTap: () {
                          _refreshData();
                        })
                  ],
                ));
            //Si no existe ni un dato almacenado se muestra lo siguiente
          } /*else if (_conexion.ranking.isEmpty) {
            return Container(
                decoration: const BoxDecoration(color: azul_oscuro),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: buildAppBar(context),
                  body: Center(
                    child: Text(
                      'Ranking no disponible',
                      style: AppTextStyles.bodyLightGrey15,
                    ),
                  ),
                ));
            //Si el alumno ingresado entra a la vista y no ha realizado ni un exámen se muestra lo siguiente
          } */else if (!idAlumnos.contains(widget.idAlumno)) {
            return Container(
                decoration: const BoxDecoration(color: azul_oscuro),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: buildAppBar(context),
                  body: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Visibility(
                          visible: !isLoading,
                          child: Column(
                            children: [
                              Text(
                                  'Aún no has completado ningún exámen en la materia',
                                  style: AppTextStyles.bodyLightGrey15,
                                  textAlign: TextAlign.center),
                              Text(widget.materia,
                                  style: AppTextStyles.bodyLightGrey20,
                                  textAlign: TextAlign.center),
                            ],
                          )),
                      Visibility(
                          visible: isLoading,
                          child: Container(
                              color: azul_oscuro,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                color: Colors.blue,
                                strokeWidth: 4,
                              )))
                    ],
                  )),
                ));
          }

          /*else if(_conexion.ranking.length <3){
            return Container(
              decoration: const BoxDecoration(color: azul_oscuro),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: buildAppBar(context),
                body: Center(
                  child: Text('Ranking aún no esta  disponible', style: AppTextStyles.bodyLightGrey15,),
                ) ,
                
                )
              );
          }*/
          return Container(
            decoration: const BoxDecoration(color: azul_oscuro),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: buildAppBar(context),
              body: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FirstPlayer(names, scores, avatar, _conexion)
                            ],
                          ),
                          Positioned(
                            top: 100,
                            left: .0,
                            right: .0,
                            child: Row(
                              children: [
                                const Spacer(),
                                SecondPlayer(names, scores, avatar, _conexion),
                                const Spacer(
                                  flex: 2,
                                ),
                                ThirdPlayer(names, scores, avatar, _conexion),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _conexion.ranking.length - 3,
                        itemBuilder: (BuildContext context, int index) {
                          final data = snapshot.data![index + 3];
                          return Column(
                            children: [
                              data['id_alumno'] == widget.idAlumno
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFF04D361),
                                                  Color(0xFF595CFF),
                                                ],
                                                begin:
                                                    FractionalOffset(0.0, 0.0),
                                                end: FractionalOffset(0.0, 1.0),
                                                stops: [0.0, 1.0],
                                                tileMode: TileMode.clamp),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30))),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 68,
                                        child: Row(
                                          children: [
                                            const Spacer(),
                                            Text('#${(index + 4).toString()}',
                                                style:
                                                    AppTextStyles.rakinNombre),
                                            const Spacer(),
                                            CircleAvatar(
                                              radius: 27,
                                              backgroundColor:
                                                  Color(0xffA6BAFC),
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    'http://${_conexion.ip}/get-image/${data['foto']}'),
                                                radius: 21,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "${data['nombre']}",
                                              style: GoogleFonts.openSans(
                                                  color: Color(0xffE8E8E8),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20),
                                            ),
                                            const Spacer(
                                              flex: 5,
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Text('${data['puntaje']}',
                                                  style:
                                                      AppTextStyles.titleBold),
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 68,
                                      color: const Color(0xff060718)
                                          .withOpacity(0.8),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  '#${(index + 4).toString()}',
                                                  style:
                                                      AppTextStyles.rakinNombre,
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                CircleAvatar(
                                                  radius: 27,
                                                  backgroundColor:
                                                      const Color(0xffA6BAFC),
                                                  child: CircleAvatar(
                                                    backgroundImage: NetworkImage(
                                                        'http://${_conexion.ip}/get-image/${data['foto']}'),
                                                    radius: 21,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Text("${data['nombre']}",
                                                    style: AppTextStyles.title),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: Text(
                                                "${data['puntaje']}",
                                                style:
                                                    AppTextStyles.bodyWhite20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

Expanded FirstPlayer(names, scores, avatar, conexion) {
  return Expanded(
    child: Column(
      children: [
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: CircleAvatar(
                radius: 68,
                backgroundColor: const Color(0xffFFE54D),
                child: CircleAvatar(
                    radius: 65,
                    backgroundColor: const Color(0xff86A0FA),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'http://${conexion.ip}/get-image/${avatar[0]}'),
                      radius: 50,
                    )),
              ),
            ),
            Positioned(
                top: .0,
                left: .0,
                right: .0,
                child: Center(
                    child: CircleAvatar(
                        backgroundColor: const Color(0xffFFCC4D),
                        radius: 19,
                        child: CircleAvatar(
                          radius: 15,
                          child: Text(
                            "1",
                            style: GoogleFonts.openSans(
                                fontSize: 20,
                                color: Color(0xffF99D26),
                                fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: const Color(0xffFDE256),
                        ))))
          ],
        ),
        Text(
          '${names[0]}',
          style: GoogleFonts.openSans(
              color: Color(0xffE8E8E8),
              fontWeight: FontWeight.w700,
              fontSize: 20),
        ),
        Text(
          '${scores[0]}',
          style: GoogleFonts.openSans(
              color: Color(0xffE8E8E8),
              fontWeight: FontWeight.w700,
              fontSize: 20),
        ),
      ],
    ),
  );
}

Column ThirdPlayer(names, scores, avatar, conexion) {
  return Column(
    children: [
      Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: CircleAvatar(
              radius: 48,
              backgroundColor: Color(0xff8B5731),
              child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Color.fromARGB(255, 252, 166, 166),
                  child: CircleAvatar(
                      radius: 33,
                      backgroundImage: NetworkImage(
                          'http://${conexion.ip}/get-image/${avatar[2]}'))),
            ),
          ),
          Positioned(
              top: .0,
              left: .0,
              right: .0,
              child: Center(
                  child: CircleAvatar(
                      radius: 19,
                      backgroundColor: Color(0xff8B5731),
                      child: CircleAvatar(
                        radius: 15,
                        child: Text(
                          "3",
                          style: GoogleFonts.openSans(
                              fontSize: 20,
                              color: Color(0xff8B5731),
                              fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: Color(0xffBF7540),
                      ))))
        ],
      ),
      Text(
        '${names[2]}',
        style: GoogleFonts.openSans(
            color: Color(0xffE8E8E8),
            fontWeight: FontWeight.w700,
            fontSize: 20),
      ),
      Text(
        '${scores[2]}',
        style: GoogleFonts.openSans(
            color: Color(0xffE8E8E8),
            fontWeight: FontWeight.w700,
            fontSize: 20),
      ),
    ],
  );
}

Column SecondPlayer(names, scores, avatar, conexion) {
  return Column(
    children: [
      Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: CircleAvatar(
              radius: 48,
              backgroundColor: Color(0xffCED5E0),
              child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Color(0xff26CE55),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'http://${conexion.ip}/get-image/${avatar[1]}'),
                    radius: 33,
                  )),
            ),
          ),
          Positioned(
              top: .0,
              left: .0,
              right: .0,
              child: Center(
                  child: CircleAvatar(
                      backgroundColor: Color(0xffCED5E0),
                      radius: 19,
                      child: CircleAvatar(
                        radius: 15,
                        child: Text(
                          "2",
                          style: GoogleFonts.openSans(
                              fontSize: 20,
                              color: Color(0xffB3BAC3),
                              fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: Color(0xffEFF1F4),
                      ))))
        ],
      ),
      Text(
        '${names[1]}',
        style: GoogleFonts.openSans(
            color: Color(0xffE8E8E8),
            fontWeight: FontWeight.w700,
            fontSize: 20),
      ),
      Text(
        '${scores[1]}',
        style: GoogleFonts.openSans(
            color: Color(0xffE8E8E8),
            fontWeight: FontWeight.w700,
            fontSize: 20),
      ),
    ],
  );
}

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    automaticallyImplyLeading: false,
    bottom: PreferredSize(
        child: Container(
          color: Color(0xff595CFF),
          height: 2.0,
        ),
        preferredSize: const Size.fromHeight(4.0)),
    centerTitle: true,
    backgroundColor: Color(0xff14154F),
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.close),
      color: AppColors.white,
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    title: Text(
      'Ranking',
      style: AppTextStyles.titleBold,
    ),
  );
}
