import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:encryption_test/watch_video.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
const debug = true;
enum _DownloadStatus {
  Downloading,
  Failed,
  Completed,
  Idle,
  Paused
}
class _TaskInfo {
  final String id;
  final String link;
  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;
  _TaskInfo({this.id, this.link});
}

class TestDownload extends StatefulWidget{
  final platform;
  TestDownload({this.platform});
  @override
  _TestDownloadState createState() {
    // TODO: implement createState
    return _TestDownloadState();
  }
}

class _TestDownloadState extends State<TestDownload>{
  ReceivePort _port = ReceivePort();
  List<Segment> segments;
  List<_TaskInfo> tasks;
  int progress = 0;
  var _localPath;
  bool _isLoading;
  _DownloadStatus downloadStatus = _DownloadStatus.Idle;
  _TaskInfo _currentTask;

  @override
  void initState() {
    super.initState();
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    _isLoading = true;

    _prepare();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: _isLoading ? SizedBox(
            width: 25,
            height: 25,
            child: LinearProgressIndicator(),
          ) : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              downloadStatus == _DownloadStatus.Downloading ? Column(
                children: [
                  IconButton(icon: Icon(Icons.pause), onPressed: (){
                    _pauseDownload(_currentTask);
                    setState(() {
                      downloadStatus = _DownloadStatus.Paused;
                    });
                  }),
                  Slider(
                    value: progress.toDouble(),
                    min: 0,
                    max: tasks.length.toDouble(),
                    onChanged: (value){
                      print("value changed");
                    },
                  ),
                  Text('progress $progress')
                ],
              ) : downloadStatus == _DownloadStatus.Paused ? IconButton(icon: Icon(Icons.play_arrow), onPressed: (){_resumeDownload(_currentTask);}):
              IconButton(icon: Icon(Icons.file_download), onPressed: (){
                // todo trigger download
                setState(() {
                  downloadStatus = _DownloadStatus.Downloading;
                });
                _requestDownload(tasks[0]);
              })
            ],
          ),
        ),
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
      print("bind background isolate successful");
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
        _currentTask = task;
        if (task != null) {
          setState(() {
            task.status = status;
            task.progress = progress;
          });
          // todo update here
          print("download status: $status");

          if(status == DownloadTaskStatus.complete){
            print("download status: complete");
            // filepath is _localpath + filename(parsed from the url)
            // todo do encryption for a single file here
            // todo add file to m3u8
            var downloadingTaskIndex = tasks.indexWhere((element) => element.taskId == id);
            print("download task index: $downloadingTaskIndex");
            if(downloadingTaskIndex != -1 && downloadingTaskIndex < tasks.length - 2){
              setState(() {
                this.progress += 1;
              });
              _requestDownload(tasks[downloadingTaskIndex+1]);

            }else if (downloadingTaskIndex == tasks.length-1){
              _updateDownloadStatus(_DownloadStatus.Completed);
              print("download finished");
            }
          }else if(status == DownloadTaskStatus.failed){
            _updateDownloadStatus(_DownloadStatus.Failed);
            print("download failed");
            // todo delete all downloaded files from here when failed
            // currently since we are downloading to a single path call delete to _localPath to delete all files

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
    // tasks.insert(0, _TaskInfo(id: "some id", link: "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4"));
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