import 'dart:io';

import 'package:aes_crypt/aes_crypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:path_provider/path_provider.dart';

final httpClient = new HttpClient();

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
