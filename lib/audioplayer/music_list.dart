import 'dart:io';

import 'package:encryption_test/audioplayer/music_model.dart';
import 'package:encryption_test/audioplayer/music_service.dart';
import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:provider/provider.dart';

import 'package:aes_crypt/aes_crypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:path_provider/path_provider.dart';

import 'home.dart';

final httpClient = new HttpClient();

bool check = false;

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
                // image: NetworkImage(
                //   data[index].image,
                // ),
                image: AssetImage('assets/after.jpg'),
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
  String dir = (Theme.of(context).platform == TargetPlatform.android
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory())
      .path;

  if (AudioService.running) {
    AudioService.playFromMediaId(id);
  } else {
    if (await AudioService.start(
      backgroundTaskEntrypoint: backgroundTaskEntryPoint,
      androidNotificationChannelName: 'Playback',
      androidNotificationColor: 0xFF2196f3,
      androidStopForegroundOnPause: true,
      androidEnableQueue: true,
    )) {
      final queue = catalog.items.map((catalog) {
        String filename = getFileNameFromPath(catalog.source);
        String filepath = dir + '/' + filename;
        return MediaItem(
            id: catalog.id,
            album: catalog.album,
            title: catalog.title,
            artist: catalog.artist,
            duration: Duration(seconds: catalog.duration),
            genre: catalog.genre,
            artUri: catalog.image,
            // extras: {'source': catalog.source},
            extras: {'source': filepath});
      }).toList();

      await AudioService.updateMediaItem(queue[index]);
      await AudioService.updateQueue(queue);

      _downloadEncryptDecrypt(
          context, 'assets/tears-of-steel-audio_eng=64008.m3u8');

      while (!check) {
        await Future.delayed(Duration(milliseconds: 300));
        print('checking, wait for a second . . .');
      }

      AudioService.playFromMediaId(id);

      if (position != null) AudioService.seekTo(position);
    }
  }
}

_downloadEncryptDecrypt(context, m3u8String) async {
  // Get the list of the files
  // that must be downloaded
  var playList = await parseHLS(m3u8String);
  List<Segment> segments = playList.segments;

  // get the directory to store the downloaded files
  String dir = (Theme.of(context).platform == TargetPlatform.android
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory())
      .path;

  // Then give the list to the downloader
  for (int i = 0; i < segments.length; i++) {
    var filename = getFileNameFromPath(segments[i].url);

    if (File('$dir/$filename.aes').existsSync()) {
      await decryptFile('$dir/$filename.aes');
      check = true;
    } else {
      await downloadFile(segments[i].url, dir, filename, context);
      await encryptFile('$dir/$filename');
      await decryptFile('$dir/$filename.aes');
      check = true;
    }
  }
}

Future<File> decryptFile(String filePath) async {
  var crypt = AesCrypt('auto_generate_for_later_use');
  crypt.setOverwriteMode(AesCryptOwMode.rename);
  try {
    String decodedFilePath = await crypt.decryptFile(filePath);
    print('///////////////////File Decrypted');
    return File(decodedFilePath);
  } catch (e) {
    print('From the decrypt function ' + e.toString());
    return null;
  }
}

Future<String> encryptFile(String filePath) async {
  var crypt = AesCrypt('auto_generate_for_later_use');
  crypt.setOverwriteMode(AesCryptOwMode.rename);
  try {
    String encrypted = await crypt.encryptFile(filePath);
    print('///////////////////File Encrypted');
    return encrypted;
  } catch (e) {
    print('From the Encrypt function ' + e.toString());
    return null;
  }
}

/// download the file and stores it in the path
/// dir + filename
Future<File> downloadFile(
    String url, String dir, String filename, BuildContext context) async {
  print('DOWNLOAD STARTED from $url. . .');
  var request = await httpClient.getUrl(Uri.parse(url));
  var response = await request.close();
  var bytes = await consolidateHttpClientResponseBytes(response);

  File file = new File('$dir/$filename');
  await file.writeAsBytes(bytes);
  print('///////////////////DOWNLOAD FINISHED!');

  return file;
}

/// this function returns the name of the
/// file from given path argument
String getFileNameFromPath(String path) {
  return path.split('/').last;
}

//// this function parses the .m3u8 file
/// takes the string of the .m3u8 file
/// as an argument
parseHLS(String m3u8String) async {
  try {
    final String fileData = await rootBundle.loadString(m3u8String);
    Uri playlistUri;
    var playlist;
    playlist =
        await HlsPlaylistParser.create().parseString(playlistUri, fileData);
    return playlist;
  } catch (e) {
    print('From the hls parser function ' + e.toString());
  }
}
