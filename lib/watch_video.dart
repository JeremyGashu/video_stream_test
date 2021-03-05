import 'dart:async';
import 'dart:io';

import 'package:aes_crypt/aes_crypt.dart';
import 'package:encryption_test/custom_video_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:path_provider/path_provider.dart';
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
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 10),
                            child: IconButton(
                              icon: Icon(
                                Icons.file_download,
                                size: 25,
                                color: Colors.redAccent,
                              ),
                              onPressed: () async {
                                String newFileName =
                                    widget.videoLink.split('/').last;

                                print('Download started');
                                File downloadedFile = await _downloadFile(
                                    widget.videoLink, newFileName, context);
                                //do the encryption here
                                print(
                                    'Download finished and encryption started');
                                await encryptFile(downloadedFile.path);

                                await downloadedFile.delete();

                                print(
                                    'File Downloaded, Encrypted and Deleted...');
                              },
                            ),
                          ),
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

parseHLS() async {
  try {
    final String fileData =
        await rootBundle.loadString('assets/play_test.m3u8');
    Uri playlistUri;
    var playlist;
    playlist =
        await HlsPlaylistParser.create().parseString(playlistUri, fileData);
    return playlist;
  } catch (e) {
    print(e);
  }
}

Future<File> _downloadFile(
    String url, String filename, BuildContext context) async {
  var request = await httpClient.getUrl(Uri.parse(url));
  var response = await request.close();
  var bytes = await consolidateHttpClientResponseBytes(response);
  String dir = (Theme.of(context).platform == TargetPlatform.android
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory())
      .path;
  File file = new File('$dir/$filename');
  await file.writeAsBytes(bytes);
  return file;
}

encryptFile(String filePath) async {
  var crypt = AesCrypt('auto_generate_for_later_use');
  crypt.setOverwriteMode(AesCryptOwMode.rename);
  try {
    await crypt.encryptFile(filePath);
    print('File encrypted...');
  } catch (e) {
    print(e);
  }
}

decryptFile(String filePath) async {
  var crypt = AesCrypt('auto_generate_for_later_use');
  crypt.setOverwriteMode(AesCryptOwMode.rename);
  try {
    await crypt.decryptFile(filePath);
    print('File Decrypted..');
  } catch (e) {
    print(e);
  }
}
