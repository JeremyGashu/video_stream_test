import 'package:encryption_test/watch_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';

class Videos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print(Theme.of(context).platform);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Stream Demo'),
        ),
        body: FutureBuilder(
          future: parseHLS(),
          builder: (_, snapShot) {
            HlsMasterPlaylist masterPlaylist;
            HlsMediaPlaylist mediaPlaylist;
            if (snapShot.data is HlsMasterPlaylist) {
              masterPlaylist = snapShot.data;
            } else {
              mediaPlaylist = snapShot.data;
            }

            return snapShot.hasData
                ? snapShot.data is HlsMediaPlaylist
                    ? GridView.extent(
                        maxCrossAxisExtent: 400,
                        children: mediaPlaylist.segments.map((segment) {
                          return Card(
                              elevation: 10,
                              child: GestureDetector(
                                onTap: () {
                                  print(segment.url);
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return VideoApp(
                                      videoLink: segment.url,
                                    );
                                  }));
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
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
                                    ],
                                  ),
                                ),
                              ));
                        }).toList(),
                      )
                    : GridView.extent(
                        maxCrossAxisExtent: 400,
                        children: masterPlaylist.mediaPlaylistUrls.map((url) {
                          return Card(
                              elevation: 10,
                              child: GestureDetector(
                                onTap: () {
                                  print(url);
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return VideoApp(
                                      videoLink: url.toString(),
                                    );
                                  }));
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
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
                                    ],
                                  ),
                                ),
                              ));
                        }).toList(),
                      )
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
