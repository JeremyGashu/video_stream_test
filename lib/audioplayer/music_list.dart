import 'package:encryption_test/audioplayer/music_model.dart';
import 'package:encryption_test/audioplayer/music_service.dart';
import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class MusicList extends StatelessWidget {
  final List<MusicModel> data;
  final int index;

  const MusicList(this.data, this.index);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem>(
      stream: AudioService.currentMediaItemStream,
      builder: (context, snapshot) {
        return ListTile(
          selected:
              snapshot.hasData ? (snapshot.data.id == data[index].id) : false,
          leading: AspectRatio(
              aspectRatio: 1.0,
              child: Image(
                image: NetworkImage(
                  data[index].image,
                ),
              )),
          title: Text(data[index].title),
          subtitle: Text(data[index].artist),
          ///////
          onTap: () => playAudioByIndex(context, index),
        );
      },
    );
  }
}

void playAudioByIndex(BuildContext context, int index,
    [Duration position]) async {
  final catalog = Provider.of<MusicService>(context, listen: false);
  final id = catalog.items[index].id;
  print('\n$id\n\n');
  if (AudioService.running) {
    AudioService.playFromMediaId(id);
  } else {
    if (
      await AudioService.start(
      backgroundTaskEntrypoint: backgroundTaskEntryPoint,
      androidNotificationChannelName: 'Playback',
      androidNotificationColor: 0xFF2196f3,
      androidStopForegroundOnPause: true,
      androidEnableQueue: true,
    )) {
      final queue = catalog.items.map((catalog) {
        return MediaItem(
          id: catalog.id,
          album: catalog.album,
          title: catalog.title,
          artist: catalog.artist,
          duration: Duration(seconds: catalog.duration),
          genre: catalog.genre,
          artUri: catalog.image,
          extras: {'source': catalog.source},
        );
      }).toList();

      print(queue.toString());

      await AudioService.updateMediaItem(queue[index]);
      await AudioService.updateQueue(queue);

      AudioService.playFromMediaId(id);

      if (position != null) AudioService.seekTo(position);
    }
  }
}
