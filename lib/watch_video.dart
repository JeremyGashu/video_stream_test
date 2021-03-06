import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/log.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

final httpClient = new HttpClient();

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
    GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
    var platform = Theme.of(context).platform;
    return Scaffold(
      key: _key,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Movie Name'),
      ),
      body: _controller.value.initialized
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
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
                              platform: platform,
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(
                          //       vertical: 3, horizontal: 10),
                          //   child: IconButton(
                          //     icon: Icon(
                          //       Icons.file_download,
                          //       size: 25,
                          //       color: Colors.redAccent,
                          //     ),
                          //     onPressed: () async {
                          //       File downloadedFile = await _downloadFile(
                          //           widget.videoLink, 'test.ts');
                          //       print(downloadedFile);
                          //     },
                          //   ),
                          // ),
                        ],
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
  final platform;
  final VideoPlayerController controller;

  CustomController({@required this.controller, this.platform});

  @override
  _CustomControllerState createState() => _CustomControllerState();
}

class _TaskInfo {
  final String id;
  final String link;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({this.id, this.link});
}

enum _DownloadStatus {
  Downloading,
  Failed,
  Completed,
  Idle
}

const debug = true;

class _CustomControllerState extends State<CustomController> {
  ReceivePort _port = ReceivePort();
  List<Segment> segments;
  List<_TaskInfo> tasks;
  var _localPath;
  bool _isLoading;
  _DownloadStatus downloadStatus = _DownloadStatus.Idle;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);


    _isLoading = true;

    _prepare();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? CircularProgressIndicator():  Container(
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
              downloadStatus == _DownloadStatus.Downloading ? CircularProgressIndicator() : IconButton(
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
                  _requestDownload(tasks[0]);
                  // var url = "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8";
                  // final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
                  // final FlutterFFmpegConfig _flutterFFmpegConfig = new FlutterFFmpegConfig();
                  // _flutterFFmpegConfig.enableLogCallback(logCallBack);
                  // print('here');
                  // var directory = await getExternalStorageDirectory();
                  // if(!await path.exists()){
                  //   print("path doesn't exist creating path");
                  //   path.create();
                  // }else{
                  //   print("path already exists continuing to download");
                  // }
                  // print("path: ${directory.path}");
                  // _flutterFFmpeg.execute("-i $url -c copy -bsf:a aac_adtstoasc \"${directory.path}/test2.mp4\"");



                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');

    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      print("bind background isolate not successful");
      return;
    }else{
      // print("bind background isolate successful");
    }
    // _port.listen((dynamic data){
    //   print('Ui isolate callback: $data');
    // }).onError((error){
    //   print("error: ${error}");
    // });
    _port.listen((dynamic data) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      print('listening');
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      if (tasks != null && tasks.isNotEmpty) {
        final task = tasks.firstWhere((task) => task.taskId == id);
        if (task != null) {
          // setState(() {
          //   task.status = status;
          //   task.progress = progress;
          // });
          // todo update here
          print("download status: $status");

          if(status == DownloadTaskStatus.complete){
            print("download status: complete");
            var downloadingTaskIndex = tasks.indexWhere((element) => element.taskId == id);
            print("download task index: $downloadingTaskIndex");
            if(downloadingTaskIndex != -1 && downloadingTaskIndex < tasks.length - 2){
              _requestDownload(tasks[downloadingTaskIndex+1]);
            }else if (downloadingTaskIndex == tasks.length-1){
              // _updateDownloadStatus(_DownloadStatus.Completed);
              print("download finished");
            }
          }else if(status == DownloadTaskStatus.failed){
            // _updateDownloadStatus(_DownloadStatus.Failed);
            print("download failed");
          }
        }
      }
    });
  }

  Future<String> _findLocalPath() async {
    final directory = widget.platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort _port =
    IsolateNameServer.lookupPortByName('downloader_send_port');
    print("sending");
    _port.send([id, status, progress]);
    print("sent");
  }

  void _updateDownloadStatus(_DownloadStatus status){
    setState(() {
      downloadStatus = status;
    });
  }

  void _cancelDownload(_TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
  }

  void _pauseDownload(_TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
  }

  void _resumeDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  void _retryDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  Future<bool> _openDownloadedFile(_TaskInfo task) {
    return FlutterDownloader.open(taskId: task.taskId);
  }

  Future<Null> _prepare() async {
    final _tasks = await FlutterDownloader.loadTasks();
    int count = 0;
    tasks = [];
    segments = (await parseHLS()).segments;
    // print("length: ${segments.length}");
    tasks.addAll(segments
        .map((e) => _TaskInfo(id: e.title, link: e.url)));
    // todo added large mp4 file to test progress
    tasks.insert(0, _TaskInfo(id: "some id", link: "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4"));
    _tasks?.forEach((task) {
      for (_TaskInfo info in tasks) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
        // print("infoLink: ${info.link}");
      }
    });

    await checkStoragePermission();

    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'twoftime';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _requestDownload(_TaskInfo task) async {
    task.taskId = await FlutterDownloader.enqueue(
        url: task.link,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: false);
    _updateDownloadStatus(_DownloadStatus.Downloading);
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

Future<HlsMediaPlaylist> parseHLS() async {
  try {
    final String fileData =
        await rootBundle.loadString('assets/play_test.m3u8');
    Uri playlistUri;
    HlsMediaPlaylist playlist;
    playlist =
        await HlsPlaylistParser.create().parseString(playlistUri, fileData);
    List<Segment> segments = playlist.segments;
    // print(segments[0].url);
    return playlist;
  } catch (e) {
    print(e);
  }
}

Future<File> _downloadFile(String url, String filename) async {
  var request = await httpClient.getUrl(Uri.parse(url));
  var response = await request.close();
  var bytes = await consolidateHttpClientResponseBytes(response);
  String dir = (await getApplicationDocumentsDirectory()).path;
  File file = new File('$dir/$filename');
  await file.writeAsBytes(bytes);
  return file;
}
