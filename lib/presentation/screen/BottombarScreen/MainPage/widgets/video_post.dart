import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class VideoPost extends StatefulWidget {
  const VideoPost({Key? key, required this.videoUrl}) : super(key: key);
final Uri videoUrl;
  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.networkUrl(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9, // You can adjust this based on your video aspect ratio
      autoInitialize: true,
      looping: false,
      allowedScreenSleep: false,
    );    super.initState();
  }
  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 300,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }
}
