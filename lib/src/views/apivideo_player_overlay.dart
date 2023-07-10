import 'dart:async';
import 'package:apivideo_player/apivideo_player.dart';
import 'package:apivideo_player/src/views/apivideo_player_actionbar_view.dart';
import 'package:apivideo_player/src/views/apivideo_player_selectable_list_view.dart';
import 'package:apivideo_player/src/views/apivideo_player_controls_view.dart';
import 'package:apivideo_player/src/views/apivideo_player_volume_slider_view.dart';
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

class _ApiVideoPlayerOverlayState extends State<ApiVideoPlayerOverlay> {
  bool _isOverlayVisible = true;
  Timer? _overlayVisibilityTimer;

  bool _isSelectedSpeedRateListViewVisible = false;

  late AnimationController expandController;
  late Animation<double> animation;

  @override
  initState() {
    super.initState();
    _showOverlayForDuration();
  }

  @override
  void dispose() {
    _overlayVisibilityTimer?.cancel();
    super.dispose();
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
          ApiVideoPlayerVolumeSliderView(
            controller: widget.controller,
            theme: widget.theme,
            volumeDidSet: () {
              _showOverlayForDuration();
            },
            toggleMute: () {
              _showOverlayForDuration();
            },
          ),
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
