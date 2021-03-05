import 'dart:async';

import 'package:encryption_test/custom_video_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  final String videoLink;
  VideoApp({this.videoLink});
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  bool controllersDisplayed = false;
  VideoPlayerController _controller;

  @override
  void initState() {
    _controller = widget.videoLink != null
        ? VideoPlayerController.network(widget.videoLink)
        : VideoPlayerController.asset('assets/play_test.m3u8')
      //if we allow read access to external file we can play videos from file, this feature will be useful
      //when download feature is added
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.setLooping(true);
        });

        // if (!mounted) return;

        Timer.periodic(Duration(seconds: 1), (timer) {
          mounted ? setState(() {}) : timer.cancel();
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video'),
      ),
      body: _controller.value.initialized
          ? FutureBuilder(
              future: parseHLS(),
              builder: (ctx, snapShot) {
                //check if the data is available before displaying it on the screen
                if (snapShot.hasData) {
                  // print(snapShot.data.segments.length);
                  // print(snapShot.data.segments[4].url);

                  // _controller
                }
                //todo it must be null aware in all the conditions
                return snapShot.hasData
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                ),
                                CustomController(
                                  controller: _controller,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Wrap(
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('Link ===>')),
                                Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('${widget.videoLink}')),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Center(child: CircularProgressIndicator());
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

parseHLS() async {
  try {
    final String fileData =
        await rootBundle.loadString('assets/master_playlist.m3u8');
    Uri playlistUri;
    var playlist;
    playlist =
        await HlsPlaylistParser.create().parseString(playlistUri, fileData);
    return playlist;
  } catch (e) {
    print(e);
  }
}
