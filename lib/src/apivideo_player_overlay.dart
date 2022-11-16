import 'dart:async';
import 'dart:math';

import 'package:apivideo_player/src/presentation/apivideo_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../apivideo_player.dart';

class ApiVideoPlayerOverlay extends StatefulWidget {
  final ApiVideoPlayerController controller;
  final bool hideControls;

  const ApiVideoPlayerOverlay({
    super.key,
    required this.controller,
    this.hideControls = false,
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
          _didEnd = false;
        });
      },
      onPause: () {
        _stopRemainingTimeUpdates();
        setState(() {
          _isPlaying = false;
        });
      },
      onSeek: () async {
        await _updateCurrentTime();
        if (_currentTime.inSeconds < _duration.inSeconds) {
          setState(() {
            _didEnd = false;
          });
        }
      },
      onEnd: () {
        _stopRemainingTimeUpdates();
        setState(() {
          _isPlaying = false;
          _didEnd = true;
        });
      },
    );
  }
  bool _isPlaying = false;
  bool _didEnd = false;

  late ApiVideoPlayerEventsListener _listener;

  Timer? _timeSliderTimer;

  bool _isOverlayVisible = true;
  Timer? _overlayVisibilityTimer;

  Duration _currentTime = const Duration(seconds: 0);
  Duration _duration = const Duration(seconds: 0);
  double _volume = 0.0;
  bool _isMuted = false;

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
              _updateMuted(),
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

  void replay() async {
    await widget.controller.setCurrentTime(const Duration(seconds: 0));
    play();
  }

  void seek(Duration duration) {
    widget.controller.seek(duration);
    _showOverlayForDuration();
  }

  Future<void> setCurrentTime(Duration duration) async {
    widget.controller.setCurrentTime(duration);
    _showOverlayForDuration();
  }

  void setVolume(double volume) async {
    await widget.controller.setVolume(volume);
    _updateVolume();
    _showOverlayForDuration();
  }

  void toggleMuted() async {
    final bool muted = await widget.controller.isMuted;
    await widget.controller.setIsMuted(!muted);
    _updateMuted();
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

  Future<void> _updateCurrentTime() async {
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

  void _updateMuted() async {
    bool muted = await widget.controller.isMuted;
    setState(() {
      _isMuted = muted;
    });
  }

  void _animateExpand({required bool open}) {
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
      visible: _isOverlayVisible && !widget.hideControls,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildVolumeSlider(),
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
                icon: const Icon(Icons.replay_10_rounded, color: Colors.white)),
            buildBtnVideoControl(),
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

  Widget buildBtnVideoControl() {
    return _didEnd ? buildBtnReplay() : buildBtnPlay();
  }

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

  Widget buildBtnReplay() {
    return IconButton(
        onPressed: () {
          replay();
        },
        iconSize: 60,
        icon: const Icon(ApiVideoIcons.replay_primary, color: Colors.white));
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

  Widget buildVolumeSlider() => kIsWeb
      ? Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            MouseRegion(
              onEnter: (_) => _animateExpand(open: true),
              onExit: (_) => _animateExpand(open: false),
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        _volume <= 0 || _isMuted
                            ? Icons.volume_off
                            : Icons.volume_up,
                        color: Colors.white,
                      ),
                      onPressed: () => toggleMuted(),
                    ),
                    SizeTransition(
                      sizeFactor: animation,
                      axis: Axis.horizontal,
                      child: SizedBox(
                        height: 30.0,
                        width: 80.0,
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
                            value: _isMuted ? 0 : _volume,
                            onChanged: (value) => setVolume(value),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      : const SizedBox(height: 30);
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
