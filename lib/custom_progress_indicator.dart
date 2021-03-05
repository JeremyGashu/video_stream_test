import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomProgressBarIndicator extends StatefulWidget {
  final VideoPlayerController controller;
  CustomProgressBarIndicator({this.controller});
  @override
  _CustomProgressBarIndicatorState createState() =>
      _CustomProgressBarIndicatorState();
}

class _CustomProgressBarIndicatorState
    extends State<CustomProgressBarIndicator> {
  double value = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Slider(
            value: widget.controller.value.position.inSeconds.toDouble(),
            min: 0,
            max: widget.controller.value.duration.inSeconds.toDouble(),
            onChanged: (val) {
              setState(() {
                int a = val.roundToDouble().toInt();
                widget.controller.seekTo(Duration(seconds: a));
              });
            }));
  }
}
