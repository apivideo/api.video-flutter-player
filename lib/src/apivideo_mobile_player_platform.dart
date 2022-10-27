import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'apivideo_player_platform_interface.dart';
import 'apivideo_types.dart';

class ApiVideoMobilePlayer extends ApiVideoPlayerPlatform {
  final MethodChannel _channel =
      const MethodChannel('video.api.player/controller');

  /// Registers this class as the default instance of [PathProviderPlatform].
  static void registerWith() {
    ApiVideoPlayerPlatform.instance = ApiVideoMobilePlayer();
  }

  @override
  Future<bool> isPlaying(int textureId) async {
    final Map<dynamic, dynamic> reply =
        await _channel.invokeMapMethodWithTexture(
            'isPlaying', TextureMessage(textureId: textureId)) as Map;
    return reply['isPlaying'] as bool;
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
  Future<int?> initialize() async {
    final Map<String, dynamic>? reply =
        await _channel.invokeMapMethod<String, dynamic>('initialize');
    int textureId = reply!['textureId']! as int;
    return textureId;
  }

  @override
  Future<void> create(int textureId, VideoOptions videoOptions) {
    final Map<String, dynamic> videoParams = <String, dynamic>{
      "videoOptions": videoOptions.toJson()
    };

    return _channel.invokeMapMethodWithTexture<String, dynamic>(
        'create', TextureMessage(textureId: textureId), videoParams);
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
