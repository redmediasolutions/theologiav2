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

  TheologiaAudioHandler() {
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    /// 🔥 Listen to playback events
    _player.playbackEventStream.listen(_broadcastState);

    /// 🔥 Listen to duration changes (IMPORTANT for seek bar)
    _player.durationStream.listen((duration) {
      final current = mediaItem.value;
      if (current != null && duration != null) {
        mediaItem.add(
          current.copyWith(duration: duration),
        );
      }
    });

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

  /// 🔥 Fallback logic
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
      artUri: artworkUri, // 👈 ALWAYS set something
      playable: true,
    ),
  );

  await _player.play();
}

  /// 🔥 PLAY
  @override
  Future<void> play() => _player.play();

  /// 🔥 PAUSE
  @override
  Future<void> pause() => _player.pause();

  /// 🔥 SEEK (THIS WAS MISSING)
  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  /// 🔥 STOP
  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  /// 🔥 BROADCAST STATE (CRITICAL FOR SEEK BAR)
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