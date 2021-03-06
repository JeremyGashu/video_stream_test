import 'dart:io';

import 'package:encryption_test/local_video_player.dart';
import 'package:encryption_test/utils.dart';
import 'package:flutter/material.dart';

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
            future: getDownloadedFiles(context),
            builder: (_, snapshot) {
              List<File> files = [];
              if (snapshot.hasData) {
                (snapshot.data as List).forEach((file) {
                  if (file.path.split('.').last == 'aes') {
                    files.add(file);
                  }
                });
                // print(snapshot.data[0].path.split('.').last);
                // print(snapshot.data);
              }
              return snapshot.hasData
                  ? snapshot.data.length > 0
                      ? SingleChildScrollView(
                          child: Column(
                            children: files.map((file) {
                              return GestureDetector(
                                onTap: () async {
                                  print('Decrypting in progress...');
                                  File decryptedPath =
                                      await decryptFile(file.path);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LocalVideoPlayer(
                                                  decryptedFile:
                                                      decryptedPath)));
                                },
                                child: Card(
                                  elevation: 5,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(10),
                                          width: 100,
                                          height: 100,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.asset(
                                              'assets/after.jpg',
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                      Expanded(
                                          child: Text(
                                              '${getFileNameFromPath(file.path)}')),
                                      IconButton(
                                          icon: Icon(Icons.more_vert),
                                          onPressed: () {}),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        )
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
