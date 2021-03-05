import 'dart:async';

import 'package:encryption_test/custom_video_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/log.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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

class CustomProgressBarIndicator extends StatefulWidget {
  final VideoPlayerController controller;
  CustomProgressBarIndicator({this.controller});
  @override
  _CustomProgressBarIndicatorState createState() =>
      _CustomProgressBarIndicatorState();
}

class _CustomProgressBarIndicatorState
    extends State<CustomProgressBarIndicator> {
  double value = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: FutureBuilder(
        builder: (_, durationData) {
          return FutureBuilder(
            future: widget.controller.position,
            builder: (_, snapShot) {
              return snapShot.hasData
                  ? Slider(
                      value: snapShot.data.inSeconds.toDouble(),
                      min: 0,
                      max:
                          widget.controller.value.duration.inSeconds.toDouble(),
                      onChanged: (val) {
                        setState(() {
                          int a = val.roundToDouble().toInt();
                          widget.controller.seekTo(Duration(seconds: a));
                        });
                      })
                  : Slider(
                      min: 0,
                      max:
                          widget.controller.value.duration.inSeconds.toDouble(),
                      value: value,
                      onChanged: (val) {
                        setState(() {
                          value = val;
                        });
                      });
            },
          );
        },
      ),
    );
  }
}

class CustomController extends StatefulWidget {
  final VideoPlayerController controller;
  CustomController({@required this.controller});

  @override
  _CustomControllerState createState() => _CustomControllerState();
}

class _CustomControllerState extends State<CustomController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      child: Column(
        children: [
          CustomProgressBarIndicator(
            controller: this.widget.controller,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.skip_previous,
                    size: 45,
                    color: Colors.blue,
                  ),
                  onPressed: () async {
                    Duration currentPosition =
                        await this.widget.controller.position;
                    Duration seekTime = Duration(seconds: 10);
                    setState(() {
                      currentPosition.inSeconds - seekTime.inSeconds > 5
                          ? this.widget.controller.seekTo(Duration(
                              seconds: (currentPosition.inSeconds -
                                  seekTime.inSeconds)))
                          : this.widget.controller.seekTo(Duration(seconds: 0));
                    });

                    // DateTime a = DateTime.now();
                  }),
              IconButton(
                  icon: widget.controller.value.isPlaying
                      ? Icon(
                          Icons.pause,
                          size: 45,
                          color: Colors.blue,
                        )
                      : Icon(
                          Icons.play_arrow,
                          size: 45,
                          color: Colors.blue,
                        ),
                  onPressed: () {
                    setState(() {
                      this.widget.controller.value.isPlaying
                          ? this.widget.controller.pause()
                          : this.widget.controller.play();
                    });
                  }),
              IconButton(
                  icon: Icon(
                    Icons.skip_next,
                    size: 45,
                    color: Colors.blue,
                  ),
                  onPressed: () async {
                    Duration currentPosition =
                        await this.widget.controller.position;
                    Duration seekTime = Duration(seconds: 5);

                    setState(() {
                      currentPosition.inSeconds + seekTime.inSeconds <
                              this.widget.controller.value.duration.inSeconds
                          ? this.widget.controller.seekTo(Duration(
                              seconds: (currentPosition.inSeconds +
                                  seekTime.inSeconds)))
                          // ignore: unnecessary_statements
                          : null;
                    });
                  }),
              IconButton(
                icon: Icon(
                  Icons.file_download,
                  size: 35,
                  color: Colors.redAccent,
                ),
                onPressed: () async {
                  //download task will be added here
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Downloading...'),
                    duration: Duration(
                      milliseconds: 600,
                    ),
                  ));

                  // Todo: start download here
                  checkStoragePermission();
                  var url = "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8";
                  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
                  final FlutterFFmpegConfig _flutterFFmpegConfig = new FlutterFFmpegConfig();
                  _flutterFFmpegConfig.enableLogCallback(logCallBack);
                  print('here');
                  var directory = await getExternalStorageDirectory();
                  // if(!await path.exists()){
                  //   print("path doesn't exist creating path");
                  //   path.create();
                  // }else{
                  //   print("path already exists continuing to download");
                  // }
                  print("path: ${directory.path}");
                  _flutterFFmpeg.execute("-i $url -c copy -bsf:a aac_adtstoasc \"${directory.path}/test2.mp4\"");
                  },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

checkStoragePermission()async{
  var status = await Permission.storage.status;
  if(status.isUndetermined){
    if (await Permission.storage.request().isGranted){
    }else{
      checkStoragePermission();
    }
  }
}

logCallBack(Log log){
  print("${log.executionId}:${log.message}");

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
