import 'dart:async';
import 'dart:io';

import 'package:encryption_test/custom_video_controller.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LocalVideoPlayer extends StatefulWidget {
  final File decryptedFile;
  LocalVideoPlayer({@required this.decryptedFile});
  @override
  _LocalVideoPlayerState createState() => _LocalVideoPlayerState();
}

class _LocalVideoPlayerState extends State<LocalVideoPlayer> {
  VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.file(widget.decryptedFile)
      ..initialize().then((_) {
        setState(() {
          _controller.setLooping(true);
        });

        Timer.periodic(Duration(seconds: 1), (timer) {
          mounted ? setState(() {}) : timer.cancel();
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_controller.value.initialized);
    return _controller.value.initialized
        ? SafeArea(
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomController(
                        controller: _controller,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
