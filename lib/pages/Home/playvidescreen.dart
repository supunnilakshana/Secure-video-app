import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class PlayVideoScreen extends StatefulWidget {
  final File file;
  final String name;
  const PlayVideoScreen({Key? key, required this.file, required this.name})
      : super(key: key);

  @override
  _PlayVideoScreenState createState() => _PlayVideoScreenState();
}

class _PlayVideoScreenState extends State<PlayVideoScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent.shade100,
      appBar: AppBar(
        title: Center(child: Text("Picked your video")),
        backgroundColor: Colors.deepPurpleAccent.shade100,
        elevation: 0,
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(_controller.value.isPlaying ? "Pause" : "Play"),
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        icon: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
