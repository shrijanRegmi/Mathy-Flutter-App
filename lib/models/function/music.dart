import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class PlayMusic {
  AudioCache _audioCache = AudioCache(prefix: "music/");

  Future playMusic() async {
    AudioPlayer _player = await _audioCache.loop("epic.mp3", volume: 0.3);
    return _player;
  }

  Future pauseMusic(AudioPlayer _player) async {
    await _player.pause();
  }

  Future resumeMusic(AudioPlayer _player) async {
    await _player.resume();
  }

  Future stopMusic(AudioPlayer _player) async {
    await _player.stop();
  }

  void disposeMusic(AudioPlayer _player) {
    _player.dispose();
  }
}
