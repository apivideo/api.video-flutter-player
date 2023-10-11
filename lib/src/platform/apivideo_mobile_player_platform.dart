import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../apivideo_types.dart';
import 'apivideo_player_platform_interface.dart';

/// The implementation of [ApiVideoPlayerPlatform] for mobile (Android and iOS).
class ApiVideoMobilePlayer extends ApiVideoPlayerPlatform {
  final MethodChannel _channel =
      const MethodChannel('video.api.player/controller');

  /// Registers this class as the default instance of [PathProviderPlatform].
  static void registerWith() {
    ApiVideoPlayerPlatform.instance = ApiVideoMobilePlayer();
  }

  @override
  Future<bool> isCreated(int textureId) async {
    final Map<dynamic, dynamic> reply =
        await _channel.invokeMapMethodWithTexture(
            'isCreated', TextureMessage(textureId: textureId)) as Map;
    return reply['isCreated'] as bool;
  }

  @override
  Future<bool> isPlaying(int textureId) async {
    final Map<dynamic, dynamic> reply =
        await _channel.invokeMapMethodWithTexture(
            'isPlaying', TextureMessage(textureId: textureId)) as Map;
    return reply['isPlaying'] as bool;
  }

  @override
  Future<bool> isLive(int textureId) async {
    final Map<dynamic, dynamic> reply =
        await _channel.invokeMapMethodWithTexture(
            'isLive', TextureMessage(textureId: textureId)) as Map;
    return reply['isLive'] as bool;
  }

  @override
  Future<int> getCurrentTime(int textureId) async {
    final Map<dynamic, dynamic> reply =
        await _channel.invokeMapMethodWithTexture(
            'getCurrentTime', TextureMessage(textureId: textureId)) as Map;
    return reply['currentTime'] as int;
  }

  @override
  Future<void> setCurrentTime(int textureId, int currentTime) {
    final Map<String, dynamic> params = <String, dynamic>{
      "currentTime": currentTime
    };
    return _channel.invokeMapMethodWithTexture(
        'setCurrentTime', TextureMessage(textureId: textureId), params);
  }

  @override
  Future<int> getDuration(int textureId) async {
    final Map<dynamic, dynamic> reply =
        await _channel.invokeMapMethodWithTexture(
            'getDuration', TextureMessage(textureId: textureId)) as Map;
    return reply['duration'] as int;
  }

  @override
  Future<VideoOptions> getVideoOptions(int textureId) async {
    final Map<String, dynamic> reply =
        await _channel.invokeMapMethodWithTexture<String, dynamic>(
                'getVideoOptions', TextureMessage(textureId: textureId))
            as Map<String, dynamic>;
    return VideoOptions.fromJson(reply);
  }

  @override
  Future<void> setVideoOptions(int textureId, VideoOptions videoOptions) {
    final Map<String, dynamic> videoParams = <String, dynamic>{
      "videoOptions": videoOptions.toJson()
    };
    return _channel.invokeMapMethodWithTexture<String, dynamic>(
        'setVideoOptions', TextureMessage(textureId: textureId), videoParams);
  }

  @override
  Future<bool> getAutoplay(int textureId) async {
    final Map<dynamic, dynamic> reply =
        await _channel.invokeMapMethodWithTexture(
            'getAutoplay', TextureMessage(textureId: textureId)) as Map;
    return reply['autoplay'] as bool;
  }

  @override
  Future<void> setAutoplay(int textureId, bool autoplay) {
    final Map<String, dynamic> params = <String, dynamic>{"autoplay": autoplay};
    return _channel.invokeMapMethodWithTexture(
        'setAutoplay', TextureMessage(textureId: textureId), params);
  }

  @override
  Future<bool> getIsMuted(int textureId) async {
    final Map<dynamic, dynamic> reply =
        await _channel.invokeMapMethodWithTexture(
            'getIsMuted', TextureMessage(textureId: textureId)) as Map;
    return reply['isMuted'] as bool;
  }

  @override
  Future<void> setIsMuted(int textureId, bool isMuted) {
    final Map<String, dynamic> params = <String, dynamic>{"isMuted": isMuted};
    return _channel.invokeMapMethodWithTexture(
        'setIsMuted', TextureMessage(textureId: textureId), params);
  }

  @override
  Future<bool> getIsLooping(int textureId) async {
    final Map<dynamic, dynamic> reply =
        await _channel.invokeMapMethodWithTexture(
            'getIsLooping', TextureMessage(textureId: textureId)) as Map;
    return reply['isLooping'] as bool;
  }

  @override
  Future<void> setIsLooping(int textureId, bool isLooping) {
    final Map<String, dynamic> params = <String, dynamic>{
      "isLooping": isLooping
    };
    return _channel.invokeMapMethodWithTexture(
        'setIsLooping', TextureMessage(textureId: textureId), params);
  }

  @override
  Future<double> getVolume(int textureId) async {
    final Map<dynamic, dynamic> reply =
        await _channel.invokeMapMethodWithTexture(
            'getVolume', TextureMessage(textureId: textureId)) as Map;
    return reply['volume'] as double;
  }

  @override
  Future<void> setVolume(int textureId, double volume) {
    final Map<String, dynamic> params = <String, dynamic>{"volume": volume};
    return _channel.invokeMapMethodWithTexture(
        'setVolume', TextureMessage(textureId: textureId), params);
  }

  @override
  Future<Size?> getVideoSize(int textureId) async {
    final Map<dynamic, dynamic> reply =
        await _channel.invokeMapMethodWithTexture(
            'getVideoSize', TextureMessage(textureId: textureId)) as Map;
    if (reply.containsKey("width") && reply.containsKey("height")) {
      return Size(reply["width"] as double, reply["height"] as double);
    }
    return null;
  }

  @override
  Future<void> setPlaybackRate(int textureId, double speedRate) {
    final Map<String, dynamic> params = <String, dynamic>{
      "speedRate": speedRate
    };
    return _channel.invokeMapMethodWithTexture(
        'setPlaybackSpeed', TextureMessage(textureId: textureId), params);
  }

  @override
  Future<double> getPlaybackRate(int textureId) async {
    final Map<dynamic, dynamic> reply =
        await _channel.invokeMapMethodWithTexture(
            'getPlaybackSpeed', TextureMessage(textureId: textureId)) as Map;
    return reply['speedRate'] as double;
  }

  @override
  Future<int?> initialize(bool autoplay) async {
    final Map<String, dynamic> params = <String, dynamic>{"autoplay": autoplay};
    final Map<String, dynamic>? reply =
        await _channel.invokeMapMethod<String, dynamic>('initialize', params);
    int textureId = reply!['textureId']! as int;
    return textureId;
  }

  @override
  Future<void> create(int textureId, VideoOptions videoOptions) {
    return setVideoOptions(textureId, videoOptions);
  }

  @override
  Future<void> dispose(int textureId) {
    return _channel.invokeMapMethodWithTexture(
        'dispose', TextureMessage(textureId: textureId));
  }

  @override
  Future<void> play(int textureId) {
    return _channel.invokeMapMethodWithTexture(
        'play', TextureMessage(textureId: textureId));
  }

  @override
  Future<void> pause(int textureId) {
    return _channel.invokeMapMethodWithTexture(
        'pause', TextureMessage(textureId: textureId));
  }

  @override
  Future<void> seek(int textureId, int offset) {
    final Map<String, dynamic> params = <String, dynamic>{"offset": offset};
    return _channel.invokeMapMethodWithTexture(
        'seek', TextureMessage(textureId: textureId), params);
  }

  @override
  Widget buildView(int textureId) {
    return Texture(textureId: textureId);
  }

  @override
  Stream<PlayerEvent> playerEventsFor(int textureId) {
    return _eventChannelFor(textureId)
        .receiveBroadcastStream()
        .map((dynamic map) {
      final Map<dynamic, dynamic> event = map as Map<dynamic, dynamic>;
      switch (event['type']) {
        case 'ready':
          return PlayerEvent(type: PlayerEventType.ready);
        case 'played':
          return PlayerEvent(type: PlayerEventType.played);
        case 'paused':
          return PlayerEvent(type: PlayerEventType.paused);
        case 'seek':
          return PlayerEvent(type: PlayerEventType.seek);
        case 'seekStarted':
          return PlayerEvent(type: PlayerEventType.seekStarted);
        case 'ended':
          return PlayerEvent(type: PlayerEventType.ended);
        default:
          return PlayerEvent(type: PlayerEventType.unknown);
      }
    });
  }

  EventChannel _eventChannelFor(int textureId) {
    return EventChannel('video.api.player/events$textureId');
  }
}

/// Internal extensions on [MethodChannel] to handle [TextureMessage].
extension MethodChannelExtension on MethodChannel {
  Future<Map<K, V>?> invokeMapMethodWithTexture<K, V>(
      String method, TextureMessage textureMessage,
      [dynamic arguments]) async {
    final Map<Object?, Object?> params = <Object?, Object?>{};
    params.addAll(textureMessage.encode() as Map<Object?, Object?>);
    if (arguments != null) {
      params.addAll(arguments);
    }

    return invokeMapMethod<K, V>(method, params);
  }
}

/// Internal message codec for handling texture id for mobile targets.
class TextureMessage {
  TextureMessage({
    required this.textureId,
  });

  int textureId;

  Object encode() {
    final Map<Object?, Object?> paramMap = <Object?, Object?>{};
    paramMap['textureId'] = textureId;
    return paramMap;
  }

  static TextureMessage decode(Object message) {
    final Map<Object?, Object?> paramMap = message as Map<Object?, Object?>;
    return TextureMessage(
      textureId: paramMap['textureId']! as int,
    );
  }
}
