import 'dart:async';
import 'package:apivideo_player/apivideo_player.dart';
import 'package:apivideo_player/src/views/apivideo_player_actionbar_view.dart';
import 'package:apivideo_player/src/views/apivideo_player_selectable_list_view.dart';
import 'package:apivideo_player/src/views/apivideo_player_controls_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class ApiVideoPlayerOverlay extends StatefulWidget {
  const ApiVideoPlayerOverlay({
    super.key,
    required this.controller,
    this.hideControls = false,
    required this.theme,
  });

  final ApiVideoPlayerController controller;
  final bool hideControls;
  final PlayerTheme theme;

  @override
  State<ApiVideoPlayerOverlay> createState() => _ApiVideoPlayerOverlayState();
}

class _ApiVideoPlayerOverlayState extends State<ApiVideoPlayerOverlay>
    with TickerProviderStateMixin {
  bool _isOverlayVisible = true;
  Timer? _overlayVisibilityTimer;

  double _volume = 0.0;
  bool _isMuted = false;

  bool _isSelectedSpeedRateListViewVisible = false;

  late AnimationController expandController;
  late Animation<double> animation;

  @override
  initState() {
    super.initState();
    _showOverlayForDuration();
    // In case controller is already created
    widget.controller.isCreated.then((bool isCreated) async => {
          if (isCreated)
            {
              _updateVolume(),
              _updateMuted(),
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
    _overlayVisibilityTimer?.cancel();
    super.dispose();
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
    if (_isSelectedSpeedRateListViewVisible) {
      _hideSpeedRateListView();
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
      _isSelectedSpeedRateListViewVisible = false;
    });
  }

  void _hideSpeedRateListView() {
    setState(() {
      _isSelectedSpeedRateListViewVisible = false;
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
          child: PointerInterceptor(
            child: Stack(
                children: <Widget>[buildOverlay(), buildSpeedRateSelector()]),
          ),
        ),
      );

  Widget buildOverlay() => Visibility(
      visible: _isOverlayVisible && !widget.hideControls,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildVolumeSlider(),
          ApivideoPlayerControlsView(
            controller: widget.controller,
            theme: widget.theme,
            onSelected: () {
              _showOverlayForDuration();
            },
          ),
          ApiVideoPlayerActionbarView(
            controller: widget.controller,
            theme: widget.theme,
            isOverlayVisible: _isOverlayVisible,
            onSelected: () {
              _showOverlayForDuration();
              setState(() {
                _isSelectedSpeedRateListViewVisible = true;
              });
            },
          ),
        ],
      ));

  Widget buildSpeedRateSelector() {
    return FutureBuilder(
        future: widget.controller.speedRate,
        builder:
            (BuildContext context, AsyncSnapshot<double> speedRateSnapshot) {
          return Positioned(
            bottom: 70,
            left: 20,
            child: Visibility(
                visible:
                    _isSelectedSpeedRateListViewVisible && _isOverlayVisible,
                child: SizedBox(
                  width: 120,
                  height: 110,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: widget.theme.boxDecorationColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ApiVideoPlayerSelectableListView(
                        items: const [0.5, 1.0, 1.25, 1.5, 2.0],
                        selectedItem: speedRateSnapshot.data ?? 1.0,
                        onSelected: (Object value) {
                          if (value is double) {
                            widget.controller.setSpeedRate(value);
                          }
                          setState(() {
                            _isSelectedSpeedRateListViewVisible = false;
                          });
                        },
                        theme: widget.theme,
                      )),
                )),
          );
        });
  }

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
                        color: widget.theme.controlsColor,
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
                              activeTrackColor:
                                  widget.theme.activeVolumeSliderColor,
                              trackHeight: 2.0,
                              thumbColor: Colors.white,
                              overlayShape: SliderComponentShape.noOverlay,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6.0,
                              )),
                          child: Slider(
                            activeColor: widget.theme.activeVolumeSliderColor,
                            inactiveColor:
                                widget.theme.inactiveVolumeSliderColor,
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

class ApiVideoColors {
  static const MaterialColor orange = MaterialColor(
    0xFFFA5B30,
    <int, Color>{
      100: Color(0xFFFBDDD4),
      200: Color(0xFFFFD1C5),
      300: Color(0xFFFFB39E),
      400: Color(0xFFFA5B30),
      500: Color(0xFFE53101),
    },
  );
}
