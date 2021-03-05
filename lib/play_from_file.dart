import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FromFile extends StatefulWidget {
  @override
  _FromFileState createState() => _FromFileState();
}

class _FromFileState extends State<FromFile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Downloads'),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: _getDownloadedFiles(context),
            builder: (_, snapshot) {
              List<File> files = [];
              // if (snapshot.hasData) {
              //   (snapshot.data as List).forEach((file) {
              //     if (file.path.split('.').last.equals('ts')) {
              //       files.add(file);
              //       //use it to display
              //     }
              //   });
              //   print(snapshot.data[0].path.split('.').last);
              //   print(snapshot.data);
              // }
              return snapshot.hasData
                  ? snapshot.data.length > 0
                      ? Text('List of files')
                      : Center(
                          child: Text(
                            'No files!',
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        )
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            }),
      ),
    );
  }
}

Future<String> _localFilePath() async {
  String dir = (Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory())
      .path;
  return dir;
}

Future<List<FileSystemEntity>> _getDownloadedFiles(BuildContext context) async {
  final directory = Theme.of(context).platform == TargetPlatform.android
      ? await getExternalStorageDirectory()
      : await getApplicationDocumentsDirectory();
  var files = directory.listSync();

  return files;
}
