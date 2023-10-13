import 'dart:async';

import 'package:apivideo_player/apivideo_player.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

/// The overlay of the video player.
/// It displays the controls, time slider and the action bar.
class PlayerOverlay extends StatefulWidget {
  const PlayerOverlay(
      {super.key, required this.controller, this.style, this.onItemPress});

  /// The controller for the player.
  final ApiVideoPlayerController controller;

  /// The style of the player.
  final PlayerStyle? style;

  /// The callback to be called when an item (play, pause,...) is clicked (used to show the overlay).
  final VoidCallback? onItemPress;

  @override
  State<PlayerOverlay> createState() => _PlayerOverlayState();
}

class _PlayerOverlayState extends State<PlayerOverlay>
    with TickerProviderStateMixin {
  final _timeSliderController = TimeSliderController();
  final _controlsBarController = ControlsBarController();
  final _settingsBarController = SettingsBarController();

  Timer? _timeSliderTimer;

  late final ApiVideoPlayerControllerEventsListener _listener =
      ApiVideoPlayerControllerEventsListener(
    onReady: () async {
      _updateTimes();
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
    widget.controller.addListener(_listener);
    // In case controller is already created
    widget.controller.isCreated.then((bool isCreated) async => {
          if (isCreated)
            {
              _updateTimes(),
              _updateVolume(),
              _updateMuted(),
              widget.controller.isPlaying.then((isPlaying) => {
                    if (isPlaying) {_onPlay()}
                  })
            }
        });
  }

  @override
  void didUpdateWidget(PlayerOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.controller.removeListener(_listener);
    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    _stopRemainingTimeUpdates();
    widget.controller.removeListener(_listener);

    _timeSliderController.dispose();
    _controlsBarController.dispose();
    _settingsBarController.dispose();

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
              child: SettingsBar(
                  controller: _settingsBarController,
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
                  onSpeedRateChanged: (speed) {
                    widget.controller.setSpeedRate(speed);
                    if (widget.onItemPress != null) {
                      widget.onItemPress!();
                    }
                  },
                  style: widget.style?.settingsBarStyle)),
          Center(
            child: ControlsBar(
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
              style: widget.style?.controlsBarStyle,
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: TimeSlider(
                controller: _timeSliderController,
                style: widget.style?.timeSliderStyle,
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
    if (mounted) {
      _controlsBarController.state = ControlsBarState.playing;
    }
  }

  void _onPause() {
    _stopRemainingTimeUpdates();
    if (mounted) {
      _controlsBarController.state = ControlsBarState.paused;
    }
  }

  void _startRemainingTimeUpdates() {
    _timeSliderTimer?.cancel();
    _timeSliderTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) async {
        final isLive = await widget.controller.isLive;
        if (isLive) {
          _updateTimes();
        } else {
          _updateCurrentTime();
        }
      },
    );
  }

  void _stopRemainingTimeUpdates() {
    _timeSliderTimer?.cancel();
    _timeSliderTimer = null;
  }

  void _updateTimes() async {
    Duration currentTime = await widget.controller.currentTime;
    Duration duration = await widget.controller.duration;
    if (mounted) {
      _timeSliderController.setTime(currentTime, duration);
    }
  }

  void _updateCurrentTime() async {
    Duration currentTime = await widget.controller.currentTime;
    if (mounted) {
      _timeSliderController.currentTime = currentTime;
    }
  }

  void _updateVolume() async {
    double volume = await widget.controller.volume;
    if (mounted) {
      _settingsBarController.volume = volume;
    }
  }

  void _updateMuted() async {
    bool isMuted = await widget.controller.isMuted;
    if (mounted) {
      _settingsBarController.isMuted = isMuted;
    }
  }
}
