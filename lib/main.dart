import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:encryption_test/audioplayer/home.dart';
import 'package:encryption_test/audioplayer/music_service.dart';
import 'package:encryption_test/one_m3u8.dart';
import 'package:encryption_test/play_from_file.dart';
import 'package:encryption_test/videos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'utils.dart';

void main() async {
  runApp(ChangeNotifierProvider(
      create: (context) => MusicService(), child: MyApp()));
  _writeFile();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Widget> _widgets = [
    Videos(),
    // MusicPage(),
    FromFile(),
    OneFile(),
    AudioServiceWidget(
      child: AudioScreen(),
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgets[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.ondemand_video_sharp,
                color: Colors.blue,
              )),
          // BottomNavigationBarItem(
          //     label: '',
          //     icon: Icon(
          //       Icons.music_note,
          //     )),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.file_download,
                color: Colors.blue,
              )),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.video_collection,
                color: Colors.blue,
              )),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.play_circle_outline,
                color: Colors.blue,
              ))
        ],
        currentIndex: _currentIndex,
      ),
    );
  }
}

_writeFile() async {
  final fileData = await rootBundle.load('assets/index_0_av.m3u8');
  var fileDir =
      '/storage/emulated/0/Android/data/com.example.encryption_test/files/index_0_av.m3u8';
  File f = File(fileDir);
  if (!f.existsSync()) {
    writeToFile(fileData, fileDir);
  }
}
