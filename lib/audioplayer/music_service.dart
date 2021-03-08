import 'dart:collection';

import 'package:encryption_test/audioplayer/data.dart';
import 'package:encryption_test/audioplayer/music_model.dart';
import 'package:flutter/material.dart';

class MusicService extends ChangeNotifier {
  final List<MusicModel> _items = [];

  UnmodifiableListView<MusicModel> get items => UnmodifiableListView(_items);

  MusicService() {
    _fetchMusicCatalog();
  }

  void _fetchMusicCatalog() {
    addAll(musicList);
  }

  void add(MusicModel item) {
    _items.add(item);
    notifyListeners();
  }

  void addAll(List<MusicModel> items) {
    _items.addAll(items);
    notifyListeners();
  }

  void removeAll() {
    _items.clear();
    notifyListeners();
  }
}
