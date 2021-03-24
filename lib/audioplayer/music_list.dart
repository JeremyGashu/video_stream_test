import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:encryption_test/audioplayer/music_model.dart';
import 'package:encryption_test/audioplayer/music_service.dart';
import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_aes_ecb_pkcs5/flutter_aes_ecb_pkcs5.dart';

import 'package:aes_crypt/aes_crypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:path_provider/path_provider.dart';

import 'home.dart';

final httpClient = new HttpClient();

bool check = false;

String processState;

class MusicList extends StatefulWidget {
  static _MusicListState of(BuildContext context) =>
      context.findAncestorStateOfType<_MusicListState>();
  final List<MusicModel> data;
  final int index;

  const MusicList(this.data, this.index);

  @override
  _MusicListState createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  @override
  void initState() {
    processState = 'idle';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem>(
      stream: AudioService.currentMediaItemStream,
      builder: (context, snapshot) {
        return Column(
          children: [
            ListTile(
              selected: snapshot.hasData
                  ? (snapshot.data.id == widget.data[widget.index].id)
                  : false,
              leading: AspectRatio(
                  aspectRatio: 1.0,
                  child: Image(
                    image: AssetImage('assets/after.jpg'),
                  )),
              title: Text(widget.data[widget.index].title),
              subtitle: Text(widget.data[widget.index].artist),
              ///////
              onTap: () => playAudioByIndex(context, widget.index),
            ),
            SizedBox(
              height: 60,
            ),
            processState.length < 8
                ? SingleChildScrollView(child: Text(''))
                : SingleChildScrollView(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        print('///////////////$processState /// ' +
                            processState
                                .split(' ')
                                .last
                                .split('.')
                                .first
                                .substring(4));
                        bool checkIndex = (int.parse(processState
                                .split(' ')
                                .last
                                .split('.')
                                .first
                                .substring(4)) ==
                            index);
                        return ListTile(
                          tileColor: Colors.amber[200],
                          title: checkIndex ? Text(processState) : Text('idle'),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                    ),
                  ),
          ],
        );
      },
    );
  }

  void updateState(String currentProcess) {
    setState(() {
      processState = currentProcess;
    });
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
        // String filename = getFileNameFromPath(catalog.source);
        String filepath = dir + '/' + 'tears-of-steel-audio_eng=64008.m3u8';
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
          context, 'assets/_tears-of-steel-audio_eng=64008.m3u8');

      while (!check) {
        await Future.delayed(Duration(milliseconds: 200));
        print('checking, wait for a second . . .');
      }

      AudioService.playFromMediaId(id);

      if (position != null) AudioService.seekTo(position);
    }
  }
}

_downloadEncryptDecrypt(context, m3u8String) async {
  // get the directory to store the downloaded files
  String dir = (Theme.of(context).platform == TargetPlatform.android
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory())
      .path;

  // write the .m3u8 file to local storage
  final fileData =
      await rootBundle.load('assets/tears-of-steel-audio_eng=64008.m3u8');
  var fileDir = '$dir/tears-of-steel-audio_eng=64008.m3u8';
  writeToFile(fileData, fileDir);

  // write the .key file to local storage
  final fileKey = '$dir/1.key';
  Uint8List key1 = Uint8List.fromList([
    248,
    92,
    124,
    156,
    203,
    141,
    195,
    249,
    112,
    141,
    132,
    238,
    59,
    194,
    90,
    25
  ]);
  var file = File(fileKey);
  file.writeAsBytes(key1);

  // Get the list of the files
  // that must be downloaded
  var playList = await parseHLS(m3u8String);
  List<Segment> segments = playList.segments;

  // Then give the list to the downloader
  for (int i = 0; i < segments.length; i++) {
    var filename = getFileNameFromPath(segments[i].url);

    if (File('$dir/$filename.aes').existsSync()) {
      MusicList.of(context).updateState('.decrypting $filename');
      // await decryptFile('$dir/$filename.aes');
      check = true;
    } else {
      MusicList.of(context).updateState('downloading $filename');
      await downloadFile(segments[i].url, dir, filename, context);
      MusicList.of(context).updateState('.encrypting $filename');
      await encryptFile('$dir/$filename');
      check = true;
    }
  }
}

void writeToFile(ByteData data, String path) {
  final buffer = data.buffer;
  return new File(path).writeAsBytesSync(
      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
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
  // var crypt = AesCrypt('auto_generate_for_later_use');
  // crypt.setOverwriteMode(AesCryptOwMode.rename);
  // try {
  //   String encrypted = await crypt.encryptFile(filePath);
  //   print('///////////////////File Encrypted');
  //   return encrypted;
  // } catch (e) {
  //   print('From the Encrypt function ' + e.toString());
  //   return null;
  // }
  AesCrypt aesCrypt = AesCrypt();
  Uint8List key = Uint8List.fromList([
    248,
    92,
    124,
    156,
    203,
    141,
    195,
    249,
    112,
    141,
    132,
    238,
    59,
    194,
    90,
    25
  ]);
  Uint8List iv = Uint8List.fromList([
    46,
    223,
    139,
    95,
    209,
    124,
    115,
    157,
    24,
    235,
    39,
    57,
    255,
    16,
    75,
    201
  ]);

  aesCrypt.aesSetKeys(key, iv);
  aesCrypt.setOverwriteMode(AesCryptOwMode.rename);
  try {
    String encrypted = await aesCrypt.encryptFile(filePath);
    var oldfile = File(filePath);
    await oldfile.delete();
    var file = File('$filePath.aes');
    await file.rename(filePath);
    return encrypted;
  } catch (e, st) {
    print(e.toString());
    print(st);
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
