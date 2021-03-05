import 'package:encryption_test/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomController extends StatefulWidget {
  final VideoPlayerController controller;
  CustomController({@required this.controller});

  @override
  _CustomControllerState createState() => _CustomControllerState();
}

class _CustomControllerState extends State<CustomController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: double.infinity,
      child: Column(
        children: [
          CustomProgressBarIndicator(
            controller: this.widget.controller,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _customDurationParser(widget.controller.value.position),
                ),
                Text(
                  _customDurationParser(widget.controller.value.duration),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.skip_previous,
                    size: 45,
                    color: Colors.blue,
                  ),
                  onPressed: () async {
                    Duration currentPosition =
                        await this.widget.controller.position;
                    Duration seekTime = Duration(seconds: 10);
                    setState(() {
                      currentPosition.inSeconds - seekTime.inSeconds > 5
                          ? this.widget.controller.seekTo(Duration(
                              seconds: (currentPosition.inSeconds -
                                  seekTime.inSeconds)))
                          : this.widget.controller.seekTo(Duration(seconds: 0));
                    });

                    // DateTime a = DateTime.now();
                  }),
              IconButton(
                  icon: widget.controller.value.isPlaying
                      ? Icon(
                          Icons.pause,
                          size: 45,
                          color: Colors.blue,
                        )
                      : Icon(
                          Icons.play_arrow,
                          size: 45,
                          color: Colors.blue,
                        ),
                  onPressed: () {
                    setState(() {
                      this.widget.controller.value.isPlaying
                          ? this.widget.controller.pause()
                          : this.widget.controller.play();
                    });
                  }),
              IconButton(
                  icon: Icon(
                    Icons.skip_next,
                    size: 45,
                    color: Colors.blue,
                  ),
                  onPressed: () async {
                    Duration currentPosition =
                        await this.widget.controller.position;
                    Duration seekTime = Duration(seconds: 5);

                    setState(() {
                      currentPosition.inSeconds + seekTime.inSeconds <
                              this.widget.controller.value.duration.inSeconds
                          ? this.widget.controller.seekTo(Duration(
                              seconds: (currentPosition.inSeconds +
                                  seekTime.inSeconds)))
                          // ignore: unnecessary_statements
                          : null;
                    });
                  }),
            ],
          ),
        ],
      ),
    );
  }
}

String _customDurationParser(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}
