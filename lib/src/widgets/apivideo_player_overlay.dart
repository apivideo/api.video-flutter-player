import 'dart:async';

import 'package:apivideo_player/src/apivideo_player_controller.dart';
import 'package:apivideo_player/src/style/apivideo_theme.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_controls_bar.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_selectable_list.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_volume_slider.dart';
import 'package:apivideo_player/src/widgets/low_bar/apivideo_player_low_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

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
  bool _isSelectedSpeedRateListViewVisible = false;

  final _lowBarController = ApiVideoPlayerLowBarController();
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
        child:
            Stack(children: <Widget>[buildOverlay(), buildSpeedRateSelector()]),
      );

  Widget buildOverlay() => Stack(
        children: [
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: kIsWeb
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
                  : Container()),
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
              child: ApiVideoPlayerLowBar(
                controller: _lowBarController,
                onSpeedRatePress: () {
                  if (mounted) {
                    setState(() {
                      _isSelectedSpeedRateListViewVisible =
                          !_isSelectedSpeedRateListViewVisible;
                    });
                  }
                  if (widget.onItemPress != null) {
                    widget.onItemPress!();
                  }
                },
                onTimeSliderChanged: (Duration value) {
                  widget.controller.setCurrentTime(value);
                  if (widget.onItemPress != null) {
                    widget.onItemPress!();
                  }
                },
              )),
        ],
      );

  Widget buildSpeedRateSelector() {
    return FutureBuilder(
        future: widget.controller.speedRate,
        builder:
            (BuildContext context, AsyncSnapshot<double> speedRateSnapshot) {
          return Positioned(
            bottom: 70,
            left: 20,
            child: Visibility(
                visible: _isSelectedSpeedRateListViewVisible,
                child: SizedBox(
                  width: 120,
                  height: 110,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: widget.theme.boxDecorationColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ApiVideoPlayerSelectableList(
                        items: const [0.5, 1.0, 1.25, 1.5, 2.0],
                        selectedItem: speedRateSnapshot.data ?? 1.0,
                        onSelected: (Object value) {
                          if (value is double) {
                            widget.controller.setSpeedRate(value);
                          }
                        },
                        selectedColor: widget.theme.selectedColor,
                      )),
                )),
          );
        });
  }

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
