import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  String? _currentAudioUrl;

  /// 播放音频
  Future<void> play(String audioUrl) async {
    if (_currentAudioUrl != audioUrl) {
      _currentAudioUrl = audioUrl;
      await _player.setAudioSource(AudioSource.uri(Uri.parse(audioUrl)));
    }
    await _player.play();
  }

  /// 暂停播放
  Future<void> pause() async {
    await _player.pause();
  }

  /// 停止播放
  Future<void> stop() async {
    await _player.stop();
  }

  /// 跳转到指定位置
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  /// 获取当前播放位置
  Stream<Duration> get positionStream => _player.positionStream;

  /// 获取音频总时长
  Stream<Duration?> get durationStream => _player.durationStream;

  /// 获取播放状态
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  /// 获取当前播放状态是否为播放中
  Stream<bool> get isPlayingStream => _player.playingStream;

  /// 释放资源
  void dispose() {
    _player.dispose();
  }

  /// 获取当前播放进度
  Duration get currentPosition => _player.position;

  /// 获取音频总时长
  Duration? get duration => _player.duration;

  /// 是否正在播放
  bool get isPlaying => _player.playing;
}