import 'dart:async';

import 'package:apivideo_player/apivideo_player.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_controls_bar.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_time_slider.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_volume_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import 'common/apivideo_player_multi_text_button.dart';

/// The overlay of the video player.
/// It displays the controls, time slider and the action bar.
class ApiVideoPlayerOverlay extends StatefulWidget {
  const ApiVideoPlayerOverlay(
      {super.key,
      required this.controller,
      required this.theme,
      this.onItemPress});

  /// The controller for the player.
  final ApiVideoPlayerController controller;

  /// The theme for the player.
  final ApiVideoPlayerTheme theme;

  /// The callback to be called when an item (play, pause,...) is clicked (used to show the overlay).
  final VoidCallback? onItemPress;

  @override
  State<ApiVideoPlayerOverlay> createState() => _ApiVideoPlayerOverlayState();
}

class _ApiVideoPlayerOverlayState extends State<ApiVideoPlayerOverlay>
    with TickerProviderStateMixin {
  final _lowBarController = ApiVideoPlayerTimeSliderController();
  final _controlsBarController = ApiVideoPlayerControlsBarController();
  final _volumeSliderController = ApiVideoPlayerVolumeSliderController();

  Timer? _timeSliderTimer;

  late final ApiVideoPlayerEventsListener _playerEvents =
      ApiVideoPlayerEventsListener(
    onReady: () async {
      _updateDuration();
      _updateCurrentTime();
    },
    onPlay: () async {
      _onPlay();
    },
    onPause: () async {
      _onPause();
    },
    onSeek: () async {
      _updateCurrentTime();
    },
    onSeekStarted: () async {
      if (_controlsBarController.state.didEnd) {
        _controlsBarController.state = ControlsBarState.paused;
      }
    },
    onEnd: () async {
      _stopRemainingTimeUpdates();
      _controlsBarController.state = ControlsBarState.ended;
    },
  );

  @override
  void initState() {
    super.initState();
    widget.controller.addEventsListener(_playerEvents);
    // In case controller is already created
    widget.controller.isCreated.then((bool isCreated) async => {
          if (isCreated)
            {
              _updateCurrentTime(),
              _updateDuration(),
              _updateVolume(),
              _updateMuted(),
              widget.controller.isPlaying.then((isPlaying) => {
                    if (isPlaying) {_onPlay()}
                  })
            }
        });
  }

  @override
  void dispose() {
    widget.controller.removeEventsListener(_playerEvents);
    _stopRemainingTimeUpdates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PointerInterceptor(
        child: buildOverlay(),
      );

  Widget buildOverlay() => Stack(
        children: [
          Positioned(
              top: 0,
              right: 0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    kIsWeb
                        ? ApiVideoPlayerVolumeSlider(
                            controller: _volumeSliderController,
                            onVolumeChanged: (volume) {
                              widget.controller.setVolume(volume);
                              if (widget.onItemPress != null) {
                                widget.onItemPress!();
                              }
                            },
                            onToggleMute: () async {
                              final isMuted = await widget.controller.isMuted;
                              widget.controller.setIsMuted(!isMuted);
                              if (widget.onItemPress != null) {
                                widget.onItemPress!();
                              }
                            },
                            iconsColor: widget.theme.iconsColor,
                            activeVolumeSliderColor:
                                widget.theme.volumeSliderActiveColor,
                            inactiveVolumeSliderColor:
                                widget.theme.volumeSliderInactiveColor,
                            thumbVolumeSliderColor:
                                widget.theme.volumeSliderThumbColor,
                          )
                        : Container(),
                    ApiVideoPlayerMultiTextButton(
                      keysValues: const {
                        '0.5x': 0.5,
                        '1.0x': 1.0,
                        '1.2x': 1.2,
                        '1.5x': 1.5,
                        '2.0x': 2.0,
                      },
                      defaultKey: "1.0x",
                      onValueChanged: (speed) {
                        widget.controller.setSpeedRate(speed);
                        if (widget.onItemPress != null) {
                          widget.onItemPress!();
                        }
                      },
                      textColor: widget.theme.iconsColor,
                    ),
                  ])),
          Center(
            child: ApiVideoPlayerControlsBar(
              controller: _controlsBarController,
              onBackward: () {
                widget.controller.seek(const Duration(seconds: -10));
                if (widget.onItemPress != null) {
                  widget.onItemPress!();
                }
              },
              onForward: () {
                widget.controller.seek(const Duration(seconds: 10));
                if (widget.onItemPress != null) {
                  widget.onItemPress!();
                }
              },
              onPause: () {
                widget.controller.pause();
                _onPause();
                if (widget.onItemPress != null) {
                  widget.onItemPress!();
                }
              },
              onPlay: () {
                widget.controller.play();
                _onPlay();
                if (widget.onItemPress != null) {
                  widget.onItemPress!();
                }
              },
              onReplay: () {
                widget.controller.setCurrentTime(const Duration(seconds: 0));
                widget.controller.play();
                if (widget.onItemPress != null) {
                  widget.onItemPress!();
                }
              },
              iconsColor: widget.theme.iconsColor,
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: ApiVideoPlayerTimeSlider(
                controller: _lowBarController,
                onChanged: (Duration value) {
                  widget.controller.setCurrentTime(value);
                  if (widget.onItemPress != null) {
                    widget.onItemPress!();
                  }
                },
              )),
        ],
      );

  void _onPlay() {
    _startRemainingTimeUpdates();
    _controlsBarController.state = ControlsBarState.playing;
  }

  void _onPause() {
    _stopRemainingTimeUpdates();
    _controlsBarController.state = ControlsBarState.paused;
  }

  void _startRemainingTimeUpdates() {
    _timeSliderTimer?.cancel();
    _timeSliderTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => _updateCurrentTime(),
    );
  }

  void _stopRemainingTimeUpdates() {
    _timeSliderTimer?.cancel();
    _timeSliderTimer = null;
  }

  void _updateCurrentTime() async {
    Duration currentTime = await widget.controller.currentTime;
    _lowBarController.currentTime = currentTime;
  }

  void _updateDuration() async {
    Duration duration = await widget.controller.duration;
    _lowBarController.duration = duration;
  }

  void _updateVolume() async {
    double volume = await widget.controller.volume;
    _volumeSliderController.volume = volume;
  }

  void _updateMuted() async {
    bool isMuted = await widget.controller.isMuted;
    _volumeSliderController.isMuted = isMuted;
  }
}
