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

File localFile;

class _LocalVideoPlayerState extends State<LocalVideoPlayer>
    with WidgetsBindingObserver {
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
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('handling delete from pause state...');
    if (state == AppLifecycleState.paused) {
      try {
        if (widget.decryptedFile.path.split('.').last == 'ts') {
          widget.decryptedFile.deleteSync();
        }
        Navigator.pop(context);
      } catch (e) {}
    }
  }

  @override
  void dispose() {
    print('handling delete from changing route and dispose...');
    try {
      if (widget.decryptedFile.path.split('.').last == 'ts') {
        widget.decryptedFile.deleteSync();
      }
    } catch (e) {}
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.initialized
        ? Scaffold(
            body: Column(
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
                Wrap(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(10), child: Text('Path ===>')),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('${widget.decryptedFile.path}')),
                  ],
                ),
              ],
            ),
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
