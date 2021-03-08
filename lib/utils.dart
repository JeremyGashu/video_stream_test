import 'dart:io';

import 'package:aes_crypt/aes_crypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:path_provider/path_provider.dart';

final httpClient = new HttpClient();
bool check = false;

parseHLS() async {
  try {
    final String fileData = await rootBundle.loadString('assets/test.m3u8');
    Uri playlistUri;
    var playlist;
    playlist =
        await HlsPlaylistParser.create().parseString(playlistUri, fileData);
    return playlist;
  } catch (e) {
    print(e);
  }
}

Future<File> downloadFile(
    String url, String filename, BuildContext context) async {
  print('DOWNLOAD STARTED...');
  var request = await httpClient.getUrl(Uri.parse(url));
  var response = await request.close();
  var bytes = await consolidateHttpClientResponseBytes(response);
  String dir = (Theme.of(context).platform == TargetPlatform.android
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory())
      .path;
  File file = new File('$dir/$filename');
  await file.writeAsBytes(bytes);
  print('DOWNLOAD FINISHED!');
  return file;
}

Future<String> encryptFile(String filePath) async {
  var crypt = AesCrypt('auto_generate_for_later_use');
  crypt.setOverwriteMode(AesCryptOwMode.rename);
  try {
    return await crypt.encryptFile(filePath);
    print('File encrypted...');
  } catch (e) {
    print(e);
  }
}

Future<String> localFilePath() async {
  String dir = (Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory())
      .path;
  return dir;
}

Future<List<FileSystemEntity>> getDownloadedFiles(BuildContext context) async {
  final directory = Theme.of(context).platform == TargetPlatform.android
      ? await getExternalStorageDirectory()
      : await getApplicationDocumentsDirectory();
  var files = directory.listSync();
  return files;
}

String getFileNameFromPath(String path) {
  return path.split('/').last;
}

Future<File> decryptFile(String filePath) async {
  var crypt = AesCrypt('auto_generate_for_later_use');
  crypt.setOverwriteMode(AesCryptOwMode.rename);
  try {
    String decodedFilePath = await crypt.decryptFile(filePath);
    return File(decodedFilePath);
    // print('File Decrypted..');
  } catch (e) {
    print(e);
  }
}

Future<List<String>> getFileNamesFromM3u8(String manifestName) async {
  Uri playListUri;
  String filePath = await localFilePath();
  File m3u8File = File('$filePath/$manifestName');
  String value = await m3u8File.readAsString();
  HlsMediaPlaylist playlist =
      await HlsPlaylistParser.create().parseString(playListUri, value);
  return playlist.segments.map((segment) {
    return segment.url.split('/').last;
  }).toList();
}

Future<bool> decryptMultipleFiles(String manifestName) async {
  List<String> fileNames = await getFileNamesFromM3u8(manifestName);
  print('STARTED DECRYPTING MULTIPLE FILES');
  try {
    String filePath = await localFilePath();
    fileNames.forEach((file) async {
      String fullFilePath = '$filePath/$file.aes';
      print(fullFilePath);
      await decryptFile(fullFilePath);
    });
  } catch (e) {
    // throw e;
    return false;
  }
  return true;
}

Future<bool> allFilesDownloaded(List<String> fileNames) async {
  String localPath = await localFilePath();
  fileNames.forEach((fileName) {
    File file = File('$localPath/$fileName');
    if (!file.existsSync()) {
      return false;
    }
  });
  return true;
}

downloadEncryptDecrypt(context) async {
  // Get the list of the files
  // that must be downloaded
  var playList = await parseHLS();
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
      await downloadFile(segments[i].url, filename, context);
      await encryptFile('$dir/$filename');
      await decryptFile('$dir/$filename.aes');
      check = true;
    }
  }
}
