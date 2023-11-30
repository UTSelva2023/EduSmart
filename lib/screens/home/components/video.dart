import 'package:edusmart/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import '../../../api/conexion.dart';
import '../../../constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../utils/transition.dart';
import '../../../views/perfil.dart';
import '../../appbar/appbar_widget.dart';

class VerVideo extends StatefulWidget {
  const VerVideo({
    Key? key,
    required this.filePath,
    required this.titulo,
  }) : super(key: key);
  final String filePath;
  final String titulo;
  @override
  _VerVideo createState() => _VerVideo();
}

class _VerVideo extends State<VerVideo> {
  bool isLoading = true;
  final Conexion _conexion = Conexion();
  final _txtController = TextEditingController();

  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _txtController.text = widget.filePath;
    _conexion.getalumnoData();
    _getVideoId();
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        isLoading = false;
      });
    });
    final videoId = _getVideoId();
  
   _controller = YoutubePlayerController(
    initialVideoId: videoId.toString(),
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
      hideControls: false,
      controlsVisibleAtStart: true,
      enableCaption: false,
      isLive: false,
    ),
  );
  }

  String? _getVideoId(){
   if(_txtController.text.startsWith('https://www.youtu.be/')){
     return _txtController.text.substring('https://www.youtu.be.'.length);
   }else if(_txtController.text.startsWith('https://www.youtube.com/watch?v=')){
     return _txtController.text.substring('https://www.youtube.com/watch?v='.length);

   }
   return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
            ),
          ),
          
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.transparent, // Puedes ajustar el color de fondo según tus necesidades
              height: 120,
              width: 100, // Altura similar a la de un AppBar
              child: Center(
                child: Text(
                  widget.titulo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: azul_oscuro, // Color del texto
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top: 40,
              right: 10,
              child: _conexion.userData == null
                  ? Visibility(
                      visible:
                          isLoading, // Muestra el loading cuando isLoading es true
                      child: Center(
                        child:Container(
                          margin: const EdgeInsets.only(top: 5, right: 16, bottom: 5),
                          child: const CircleAvatar(
                          backgroundImage:
                          AssetImage("assets/avaters/Avatar Default.jpg"),
                          ),
                        )  ,
                      ),
                    )
                  : Visibility(
                      visible: !isLoading,
                      child:GestureDetector(
                        onTap: (){
                          final SizeTransition5 _transition = SizeTransition5(ProfileApp());
                          Navigator.push(context, _transition);
                        },
                        child: Container(
                        margin:const EdgeInsets.only(top: 5, right: 16, bottom: 5),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'http://${_conexion.ip}/get-image/${_conexion.userData!['foto']}'),
                        ),
                      ),
                      )
                    )),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              color: azul_oscuro,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key, required this.titulo, required this.id_subtema})
      : super(key: key);
  final String titulo;
  final int id_subtema;
  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  bool isLoading = true;
  final Conexion _conexion = Conexion();

  @override
  void initState() {
    super.initState();
    _conexion.fetchVideo(widget.id_subtema);
    _conexion.getalumnoData();
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(
        titulo: widget.titulo,
        isLoading: isLoading,
        context: context,
        conexion: _conexion,
        boton_regresar: true,
        ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Videos",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Stack(
                children: [
                  Visibility(
                    visible: !isLoading,
                    child: //Se muestra la lista de videos
                        GridView.builder(
                            itemCount: _conexion.videos.length == 0
                                ? 1
                                : _conexion.videos.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 16 / 4,
                                    crossAxisCount: 1,
                                    mainAxisSpacing: 20),
                            itemBuilder: (context, index) {
                              if (index >= _conexion.videos.length) {
                                return Column(
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 16),
                                    ),
                                    Container(
                                      width: 400,
                                      height: 50,
                                      child: Text(
                                          "No hay videos disponibles",
                                          style: AppTextStyles.bodyLightGrey15,
                                          textAlign: TextAlign.center),
                                    ),
                                  ],
                                );
                              }
                              final videos = _conexion.videos[index];
                              //Le pasamos la ruta y nombre a la siguiente vista
                              return GestureDetector(
                                  onTap: () async {
                                    final String titulo = videos["nombre_video"];
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                      context,
                                      ScaleTransition5(
                                         VerVideo(
                                          filePath: videos["url"],
                                          titulo: titulo,
                                        ),
                                      ),
                                    );
                                    //print(videos["url"]);
                                  },
                                  child: Container(
                                    // color: Colors.grey,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffF7F7F7),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: verde,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                height: 55,
                                                width: 55,
                                                child: const Icon(
                                                    Icons.play_circle_fill,
                                                    color: kGreen),
                                              )
                                            ],
                                          ),
                                          const SizedBox(width: 20),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                videos["nombre_video"],
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.035,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                              Text(
                                                videos["descripcion"],
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.03,
                                                ),
                                              )
                                            ],
                                          ),
                                          const Spacer(),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(
                                                Icons.more_vert,
                                                color: Colors.grey,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                            }),
                  ),
                  Visibility(
                    visible:
                        isLoading, // Muestra el loading cuando isLoading es true
                    child: const Center(
                      child:
                          CircularProgressIndicator(), // Puedes personalizar el loading según tus necesidades
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
