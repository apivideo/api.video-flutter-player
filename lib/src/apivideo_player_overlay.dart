import 'dart:async';
import 'dart:math';

import 'package:apivideo_player/src/presentation/apivideo_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../apivideo_player.dart';

class ApiVideoPlayerOverlay extends StatefulWidget {
  final ApiVideoPlayerController controller;

  const ApiVideoPlayerOverlay({
    super.key,
    required this.controller,
  });

  @override
  State<ApiVideoPlayerOverlay> createState() => _ApiVideoPlayerOverlayState();
}

class _ApiVideoPlayerOverlayState extends State<ApiVideoPlayerOverlay>
    with TickerProviderStateMixin {
  _ApiVideoPlayerOverlayState() {
    _listener = ApiVideoPlayerEventsListener(
      onReady: () async {
        _updateCurrentTime();
        _updateDuration();
      },
      onPlay: () {
        _startRemainingTimeUpdates();
        setState(() {
          _isPlaying = true;
        });
      },
      onPause: () {
        _stopRemainingTimeUpdates();
        setState(() {
          _isPlaying = false;
        });
      },
      onSeek: () {
        _updateCurrentTime();
      },
      onEnd: () {
        _stopRemainingTimeUpdates();
        setState(() {
          _isPlaying = false;
        });
      },
    );
  }

  bool _isPlaying = false;

  late ApiVideoPlayerEventsListener _listener;

  Timer? _timeSliderTimer;

  bool _isOverlayVisible = true;
  Timer? _overlayVisibilityTimer;

  Duration _currentTime = const Duration(seconds: 0);
  Duration _duration = const Duration(seconds: 0);
  double _volume = 0.0;

  late AnimationController expandController;
  late Animation<double> animation;

  @override
  initState() {
    super.initState();
    widget.controller.addEventsListener(_listener);
    _showOverlayForDuration();
    // In case controller is already created
    widget.controller.isCreated.then((bool isCreated) => {
          if (isCreated)
            {
              _updateCurrentTime(),
              _updateDuration(),
              _updateVolume(),
              widget.controller.isPlaying.then((isPlaying) => {
                    if (isPlaying) {_onPlay()}
                  })
            }
        });

    expandController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  @override
  void dispose() {
    widget.controller.removeEventsListener(_listener);
    _overlayVisibilityTimer?.cancel();
    _stopRemainingTimeUpdates();
    super.dispose();
  }

  void pause() {
    widget.controller.pause();
    _showOverlayForDuration();
  }

  void play() {
    widget.controller.play();
    _showOverlayForDuration();
  }

  void seek(Duration duration) {
    widget.controller.seek(duration);
    _showOverlayForDuration();
  }

  void setCurrentTime(Duration duration) async {
    await widget.controller.setCurrentTime(duration);
    setState(() {
      _currentTime = duration;
    });
    _showOverlayForDuration();
  }

  void setVolume(double volume) async {
    await widget.controller.setVolume(volume);
    _updateVolume();
    _showOverlayForDuration();
  }

  void _showOverlayForDuration() {
    if (!_isOverlayVisible) {
      showOverlay();
    }
    _overlayVisibilityTimer?.cancel();
    _overlayVisibilityTimer = Timer(const Duration(seconds: 5), hideOverlay);
  }

  void showOverlay() {
    setState(() {
      _isOverlayVisible = true;
    });
  }

  void hideOverlay() {
    setState(() {
      _isOverlayVisible = false;
    });
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
  }

  void _onPlay() {
    _startRemainingTimeUpdates();
    setState(() {
      _isPlaying = true;
    });
  }

  void _updateCurrentTime() async {
    Duration currentTime = await widget.controller.currentTime;
    setState(() {
      _currentTime = currentTime;
    });
  }

  void _updateDuration() async {
    Duration duration = await widget.controller.duration;
    setState(() {
      _duration = duration;
    });
  }

  void _updateVolume() async {
    double volume = await widget.controller.volume;
    setState(() {
      _volume = volume;
    });
  }

  void _toggleExpand({required bool open}) {
    if (open) {
      expandController.forward();
    } else {
      expandController.animateBack(0, duration: const Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => showOverlay(),
        onExit: (_) => _showOverlayForDuration(),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _showOverlayForDuration();
          },
          child: PointerInterceptor(child: buildOverlay()),
        ),
      );

  Widget buildOverlay() => Visibility(
      visible: _isOverlayVisible,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          kIsWeb
              ? const SizedBox.shrink()
              : Container(
                  height: 30,
                ),
          kIsWeb ? buildVolumeSlider() : const SizedBox.shrink(),
          buildControls(),
          buildSlider(),
        ],
      ));

  Widget buildControls() => Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  seek(const Duration(seconds: -10));
                },
                iconSize: 30,
                icon: const Icon(
                  Icons.replay_10_rounded,
                  color: Colors.white,
                )),
            buildBtnPlay(),
            IconButton(
                onPressed: () {
                  seek(const Duration(seconds: 10));
                },
                iconSize: 30,
                icon: const Icon(
                  Icons.forward_10_rounded,
                  color: Colors.white,
                )),
          ],
        ),
      );

  Widget buildBtnPlay() {
    return IconButton(
        onPressed: () {
          _isPlaying ? pause() : play();
        },
        iconSize: 60,
        icon: _isPlaying
            ? const Icon(ApiVideoIcons.pause_primary, color: Colors.white)
            : const Icon(ApiVideoIcons.play_primary, color: Colors.white));
  }

  Widget buildSlider() => Container(
        height: 60,
        padding: const EdgeInsets.only(right: 5),
        child: Row(
          children: [
            Expanded(
              child: Slider(
                value: min(
                  _currentTime.inMilliseconds,
                  _duration.inMilliseconds,
                ).toDouble(), // Ensure that the slider doesn't go over the duration
                max: _duration.inMilliseconds.toDouble(),
                activeColor: Colors.orangeAccent,
                inactiveColor: Colors.grey,
                onChanged: (value) {
                  setCurrentTime(Duration(milliseconds: value.toInt()));
                },
              ),
            ),
            Text((_duration - _currentTime).toPlayerString(),
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      );

  Widget buildVolumeSlider() => MouseRegion(
        onEnter: (_) => _toggleExpand(open: true),
        onExit: (_) => _toggleExpand(open: false),
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  _volume > 0 ? Icons.volume_up : Icons.volume_off,
                  color: Colors.white,
                ),
                onPressed: () => setVolume(_volume > 0 ? 0 : 1),
              ),
              SizeTransition(
                sizeFactor: animation,
                axis: Axis.horizontal,
                child: SizedBox(
                  height: 30.0,
                  width: 120.0,
                  child: SliderTheme(
                    data: SliderThemeData(
                        activeTrackColor: Colors.white,
                        trackHeight: 2.0,
                        thumbColor: Colors.white,
                        overlayShape: SliderComponentShape.noOverlay,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6.0,
                        )),
                    child: Slider(
                      value: _volume,
                      onChanged: (value) => setVolume(value),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

extension DurationDisplay on Duration {
  String toPlayerString() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    if (inHours > 0) {
      return "$inHours:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }
}
