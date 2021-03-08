import 'dart:async';

import 'package:encryption_test/audioplayer/audio_player_task.dart';
import 'package:encryption_test/audioplayer/bottom_player.dart';
import 'package:encryption_test/audioplayer/music_list.dart';
import 'package:encryption_test/audioplayer/music_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audio_service/audio_service.dart';

backgroundTaskEntryPoint() {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class AudioScreen extends StatefulWidget {
  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  StreamSubscription playbackStateStream;
  
  bool isStopped(PlaybackState state) =>
      state != null && state.processingState == AudioProcessingState.stopped;

  void reloadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
  }

  @override
  void initState() {
    super.initState();
    playbackStateStream =
        AudioService.playbackStateStream.where(isStopped).listen((_) {
      reloadPrefs();
    });
  }

  @override
  void dispose() {
    playbackStateStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Example")),
      body: Consumer<MusicService>(
        builder: (context, catalog, child) {
          if (catalog.items.isNotEmpty) {
            return ListView.separated(
              itemCount: catalog.items.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                return MusicList(catalog.items, index);
              },
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: MiniPlayer(),
    );
  }
}