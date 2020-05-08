import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveMyValues with ChangeNotifier {
  bool _playingMusic = false;

  initValue() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _playingMusic = _preferences.get("playingMusic") ?? true;
    print(_playingMusic);
    notifyListeners();
  }

  void saveMusicState(bool _newPlayingMusic) async {
    _playingMusic = _newPlayingMusic;
    notifyListeners();

    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setBool("playingMusic", _newPlayingMusic);
  }

  bool get playingMusic => _playingMusic;
}
