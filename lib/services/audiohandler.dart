import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:theologia_app_1/services/audio_analytics_service.dart';

class TheologiaAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {

  final AudioPlayer _player = AudioPlayer();

  String? _currentAudioId;

  bool _completionTracked = false;

  /// 🎧 SESSION TRACKING
  DateTime? _listenStartTime;

  TheologiaAudioHandler() {
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    /// 🔥 Playback state
    _player.playbackEventStream.listen(_broadcastState);

    /// 🔥 Duration updates
    _player.durationStream.listen((duration) {
      final current = mediaItem.value;
      if (current != null && duration != null) {
        mediaItem.add(current.copyWith(duration: duration));
      }
    });

    /// 🔥 POSITION LISTENER (COMPLETION)
    _player.positionStream.listen((position) {
      final duration = _player.duration;

      if (duration != null &&
          position.inSeconds >= duration.inSeconds * 0.9 &&
          !_completionTracked &&
          _currentAudioId != null) {

        _completionTracked = true;

        AudioAnalyticsService.incrementAudioCompleted(_currentAudioId!);
      }
    });
  }

  /// 🎧 START SESSION
  void _startSession() {
    _listenStartTime = DateTime.now();
  }

  /// 🎧 END SESSION
  Future<void> _endSession() async {
    if (_currentAudioId == null || _listenStartTime == null) return;

    final seconds =
        DateTime.now().difference(_listenStartTime!).inSeconds;

    if (seconds < 2) return;

    final bucket = _getBucket(seconds);

    await AudioAnalyticsService.trackListenSession(
      id: _currentAudioId!,
      seconds: seconds,
      bucket: bucket,
    );

    _listenStartTime = null;
  }

  /// 🧠 BUCKET
  String _getBucket(int seconds) {
    if (seconds <= 10) return "0_10";
    if (seconds <= 30) return "10_30";
    if (seconds <= 60) return "30_60";
    return "60_plus";
  }

  /// 🔥 PLAY MEDIA
  Future<void> playMedia({
    required String id,
    required String title,
    required String url,
    String? imageUrl,
  }) async {
    _currentAudioId = id;
    _completionTracked = false;

    await _player.setUrl(url);

    final artworkUri = (imageUrl != null && imageUrl.isNotEmpty)
        ? Uri.parse(imageUrl)
        : Uri.parse(
            "https://theologia.in/wp-content/uploads/2026/02/For-Website.png",
          );

    mediaItem.add(
      MediaItem(
        id: id,
        title: title,
        artist: "Theologia",
        duration: _player.duration,
        artUri: artworkUri,
        playable: true,
      ),
    );

    /// 🔥 TRACK PLAY
    await AudioAnalyticsService.incrementAudioPlay(id);

    /// 🔥 START SESSION
    _startSession();

    await _player.play();
  }

  /// ▶️ PLAY / RESUME
  @override
  Future<void> play() async {
    await _player.play();

    if (_currentAudioId != null) {
      await AudioAnalyticsService.incrementAudioResume(_currentAudioId!);
      _startSession();
    }
  }

  /// ⏸ PAUSE
  @override
  Future<void> pause() async {
    await _player.pause();

    if (_currentAudioId != null) {
      await AudioAnalyticsService.incrementAudioPause(_currentAudioId!);
      await _endSession();
    }
  }

  /// ⏭ SEEK
  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  /// ⏹ STOP
  @override
  Future<void> stop() async {
    if (_currentAudioId != null) {
      await _endSession();
    }

    await _player.stop();
    await super.stop();
  }

  /// 🔄 STATE BROADCAST
  void _broadcastState(PlaybackEvent event) {
    playbackState.add(
      PlaybackState(
        controls: [
          if (_player.playing)
            MediaControl.pause
          else
            MediaControl.play,
          MediaControl.stop,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: _player.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      ),
    );
  }
}