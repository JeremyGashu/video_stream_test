import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'audio_metadata.dart';

final playControl = MediaControl(
  androidIcon: 'drawable/ic_action_play_arrow',
  label: 'Play',
  action: MediaAction.play,
);
final pauseControl = MediaControl(
  androidIcon: 'drawable/ic_action_pause',
  label: 'Pause',
  action: MediaAction.pause,
);
final skipToPreviousControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_previous',
  label: 'Skip Previous',
  action: MediaAction.skipToPrevious,
);
final skipToNextControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_next',
  label: 'Skip Next',
  action: MediaAction.skipToNext,
);

class AudioPlayerTask extends BackgroundAudioTask {
  AudioPlayer _audioPlayer = AudioPlayer();
  int _queueIndex = -1;
  static int clickDelay = 0;

  List<MediaItem> _queue = [];
  StreamSubscription playerEventSubscription;
  // bool _interrupted = false;
  SharedPreferences prefs;

  bool get hasNext => _queueIndex + 1 < _queue.length;

  bool get hasPrevious => _queueIndex > 0;

  MediaItem get _mediaItem => _queue[_queueIndex];

  // HlsAudioSource _hlsAudioSource = HlsAudioSource(
  //     Uri.parse("http://demo.unified-streaming.com/video/tears-of-steel/" +
  //         "tears-of-steel.ism/.m3u8/tears-of-steel-audio_eng=64008.m3u8"),
  //     tag: AudioMetadata(
  //       album: "Sample Album",
  //       title: "Sample Audio",
  //       artwork: "https://vgywm.com/wp-content/uploads/2019/07/" +
  //           "apple-music-note-800x420.jpg",
  //     ));

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    // Get the shared preferences instance.
    prefs = await SharedPreferences.getInstance();

    // await _audioPlayer.setAudioSource(_hlsAudioSource);
    // _audioPlayer.play();

    // Audio playback event listener.
    playerEventSubscription = _audioPlayer.playbackEventStream.listen((event) {
      switch (event.processingState) {
        case ProcessingState.ready:
          _setState(state: AudioProcessingState.ready);
          break;
        case ProcessingState.buffering:
          _setState(state: AudioProcessingState.buffering);
          break;
        case ProcessingState.completed:
          _handlePlaybackCompleted();
          break;
        default:
          break;
      }
    });
  }

  void _handlePlaybackCompleted() => hasNext ? onSkipToNext() : onStop();

  void playPause() => _audioPlayer.playing ? onPause() : onPlay();

  @override
  Future<void> onPlay() => _audioPlayer.play();

  @override
  Future<void> onPause() async {
    if (_audioPlayer.processingState == ProcessingState.loading ||
        _audioPlayer.playing) {
      _audioPlayer.pause();
      // Save the current player position in seconds.
      await prefs.setInt('position', _audioPlayer.position.inSeconds);
    }
  }

  @override
  Future<void> onSkipToNext() => skip(1);

  @override
  Future<void> onSkipToPrevious() => skip(-1);

  Future<void> skip(int offset) async {
    final newIndex = _queueIndex + offset;
    if (!(newIndex >= 0 && newIndex < _queue.length)) return;

    await _audioPlayer.stop();

    _queueIndex = newIndex;
    // Broadcast that we're skipping.
    _setState(
      state: offset == -1
          ? AudioProcessingState.skippingToPrevious
          : AudioProcessingState.skippingToNext,
    );

    if (_mediaItem.extras['source'].toString().startsWith('assets')) {
      await _audioPlayer.setAsset(_mediaItem.extras['source']);
    } else if (_mediaItem.extras['source'].toString().startsWith('/')) {
      await _audioPlayer.setFilePath(_mediaItem.extras['source']);
    } else {
      await _audioPlayer.setUrl(_mediaItem.extras['source']);
    }

    onUpdateMediaItem(_mediaItem);
    onPlay();
  }

  @override
  Future<void> onSeekTo(Duration position) async {
    // Save the current player position in seconds.
    await prefs.setInt('position', position.inSeconds);

    // Seek to given position.
    _audioPlayer.seek(position);

    // Broadcast that we're seeking.
    _setState(state: AudioServiceBackground.state.processingState);
  }

  @override
  Future<void> onClick(MediaButton button) async {
    switch (button) {
      case MediaButton.media:
        // Implemented 'double click to skip' feature for headset
        // using a click delay.
        clickDelay++;
        if (clickDelay == 1)
          Future.delayed(Duration(milliseconds: 250), () {
            if (clickDelay == 1) playPause();
            if (clickDelay == 2) onSkipToNext();
            clickDelay = 0;
          });
        break;
      case MediaButton.next:
        onSkipToNext();
        break;
      case MediaButton.previous:
        onSkipToPrevious();
        break;
      default:
    }
  }

  @override
  Future<void> onPlayFromMediaId(String mediaId) async {
    await _audioPlayer.stop();
    // Get queue index by mediaId.
    _queueIndex = _queue.indexWhere((test) => test.id == mediaId);
    // Set url source to _audioPlayer.

    if (_mediaItem.extras['source'].toString().startsWith('assets')) {
      await _audioPlayer.setAsset(_mediaItem.extras['source']);
    } else if (_mediaItem.extras['source'].toString().startsWith('/')) {
      await _audioPlayer.setFilePath(_mediaItem.extras['source']);
    } else {
      await _audioPlayer.setUrl(_mediaItem.extras['source']);
    }

    onUpdateMediaItem(_mediaItem);
    onPlay();
  }

  @override
  Future<void> onStop() async {
    await _audioPlayer.stop();

    // Save the current media item details.
    await save();

    // Broadcast that we've stopped.
    await AudioServiceBackground.setState(
      controls: [],
      processingState: AudioProcessingState.stopped,
      playing: false,
    );
    // Clean up resources
    _queue = null;
    playerEventSubscription.cancel();
    await _audioPlayer.dispose();
    // Shutdown background task
    await super.onStop();
  }

  @override
  Future<void> onUpdateMediaItem(MediaItem mediaItem) async {
    AudioServiceBackground.setMediaItem(mediaItem);
  }

  @override
  Future<void> onUpdateQueue(List<MediaItem> mediaItems) async {
    _queue = mediaItems;
    AudioServiceBackground.setQueue(_queue);
  }

  /// Helper method to set background state with ease.
  void _setState({@required AudioProcessingState state}) {
    AudioServiceBackground.setState(
      controls: getControls(),
      systemActions: [MediaAction.seekTo],
      processingState: state,
      playing: _audioPlayer.playing,
      position: _audioPlayer.position,
      bufferedPosition: _audioPlayer.bufferedPosition,
    );
  }

  List<MediaControl> getControls() {
    return [
      skipToPreviousControl,
      // switch the controls to play/pause.
      _audioPlayer.playing ? pauseControl : playControl,
      skipToNextControl
    ];
  }

  /// Save the current media item into shared preferences.
  Future<void> save() async {
    await prefs.setString('id', _mediaItem.id);
    await prefs.setString('album', _mediaItem.album);
    await prefs.setString('title', _mediaItem.title);
    await prefs.setString('artist', _mediaItem.artist);
    await prefs.setString('genre', _mediaItem.genre);
    await prefs.setString('artUri', _mediaItem.artUri);
    await prefs.setInt('duration', _mediaItem.duration.inSeconds);
    await prefs.setString('source', _mediaItem.extras['source']);
  }
}

// <MediaItem>[
//     MediaItem(
//       id: "http://demo.unified-streaming.com/video/tears-of-steel/" +
//           "tears-of-steel.ism/.m3u8/tears-of-steel-audio_eng=64008.m3u8",
//       album: "Sample Album",
//       title: "The first title",
//       artist: "The artisit",
//       duration: Duration(milliseconds: 5739820),
//       artUri: "https://vgywm.com/wp-content/uploads/2019/07/" +
//           "apple-music-note-800x420.jpg",
//     ),
//     MediaItem(
//       id: "http://demo.unified-streaming.com/video/tears-of-steel/" +
//           "tears-of-steel.ism/.m3u8/tears-of-steel-audio_eng=64008.m3u8",
//       album: "Sample Album",
//       title: "The second title",
//       artist: "The artist",
//       duration: Duration(milliseconds: 2856950),
//       artUri: "https://vgywm.com/wp-content/uploads/2019/07/" +
//           "apple-music-note-800x420.jpg",
//     ),
//   ];
