import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VerVideoExamen extends StatefulWidget {
  const VerVideoExamen({
    Key? key,
    required this.filePath,
  }) : super(key: key);
  final String filePath;
  @override
  _VerVideo createState() => _VerVideo();
}

class _VerVideo extends State<VerVideoExamen> {
  final _txtController = TextEditingController();
  String videoId = '';
  late final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: videoId,
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
      hideControls: false,
      controlsVisibleAtStart: false,
      enableCaption: false,
      isLive: false,
    ),
  );

  @override
  void initState() {
       _txtController.text = widget.filePath;
       _getVideoId();
       videoId= _getVideoId().toString();
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
    });
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
    return YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
   
    );
  }
}




