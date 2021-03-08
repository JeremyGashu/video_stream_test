import 'dart:async';
import 'dart:io';

import 'package:encryption_test/local_video_player.dart';
import 'package:encryption_test/utils.dart';
import 'package:flutter/material.dart';

class OneFile extends StatefulWidget {
  @override
  _OneFileState createState() => _OneFileState();
}

File localFile;

class _OneFileState extends State<OneFile> {
  String textState = '';
  @override
  void initState() {
    try {
      // initializePlay();
    } catch (e) {}
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: 200,
          height: 200,
          child: Card(
              elevation: 10,
              child: GestureDetector(
                onTap: () async {
                  //todo generate the m3u8 file here

                  // HlsMediaPlaylist media = await parseHLS();
                  // print('DOWNLOAD STARTED');
                  // try {
                  //   media.segments.forEach((segment) async {
                  //     File f = await downloadFile(segment.url,
                  //         getFileNameFromPath(segment.url), context);
                  //   });
                  // } catch (e) {
                  //   print(e);
                  // }
                  // print('DOWNLOAD FINISHED');
                  // //todo after download is finished, play from local
                  // //todo push to localVideoPlayer providing the m3u8 file
                  //
                  // var files = await getFileNamesFromM3u8('index_0_av.m3u8');
                  // var downloaded = await getDownloadedFiles(context);
                  //
                  // File m3u8File = File(
                  //     '/storage/emulated/0/Android/data/com.example.encryption_test/files/index_0_av.m3u8');

                  setState(() {
                    textState = 'Downloading/Decrypting';
                  });
                  downloadEncryptDecrypt(context);

                  while (!check) {
                    await Future.delayed(Duration(milliseconds: 300));
                    print('checking, wait for a second . . .');
                  }

                  setState(() {
                    textState = '';
                  });

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LocalVideoPlayer(
                              decryptedFile: File(
                                  '/storage/emulated/0/Android/data/com.example.encryption_test/files/index_0_av.m3u8'))));
                  // if(check) {
                  //
                  // }

                  // Timer.periodic(Duration(seconds: 1), (timer) async {
                  //   var downloadedFiles = await getDownloadedFiles(context);
                  //   var downloaded = downloadedFiles.map((dFiles) {
                  //     return dFiles.path.split('/').last;
                  //   });
                  //   bool isDownloaded =
                  //       files.every((file) => downloaded.contains(file));
                  //   if (isDownloaded) {
                  //     timer.cancel();
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) =>
                  //                 LocalVideoPlayer(decryptedFile: m3u8File)));
                  //   }
                  //
                  //   // var dFiles = await getDownloadedFiles(context);
                  //   // List<String> downloadedFileNames = dFiles.map((file) {
                  //   //   return getFileNameFromPath(file.path);
                  //   // }).toList();
                  //   // files.forEach((file) {
                  //   //   print(!downloadedFileNames.contains(file));
                  //   //   // if () {
                  //   //   //   return false;
                  //   //   // }
                  //   // });
                  //   // print(downloaded);
                  //   // if (downloaded) {
                  //   //   timer.cancel();
                  //
                  //   // }
                  // });
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        child: Expanded(
                          child: Image.asset(
                            'assets/after.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Movie Title'),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text('$textState'),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
