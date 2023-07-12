import 'package:apivideo_player/apivideo_player.dart';
import 'package:apivideo_player/src/controllers/apivideo_player_overlay_controller.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_actionbar_view.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_selectable_list_view.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_controls_view.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_volume_slider_view.dart';
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
  late ApiVideoPlayerOverlayController _overlayController;
  bool _isOverlayVisible = true;
  bool _isSelectedSpeedRateListViewVisible = false;
  @override
  initState() {
    super.initState();
    _overlayController = ApiVideoPlayerOverlayController(
      controller: widget.controller,
      isOverlayVisible: _isOverlayVisible,
      isSelectedSpeedRateListViewVisible: _isSelectedSpeedRateListViewVisible,
    );
    _overlayController.addListener(() {
      setState(() {
        _isOverlayVisible = _overlayController.isOverlayVisible;
        _isSelectedSpeedRateListViewVisible =
            _overlayController.isSelectedSpeedRateListViewVisible;
      });
    });
    _overlayController.showOverlayForDuration();
  }

  @override
  void dispose() {
    _overlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => _overlayController.showOverlay(),
        onExit: (_) => _overlayController.showOverlayForDuration(),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _overlayController.showOverlayForDuration();
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
              _overlayController.showOverlayForDuration();
            },
            toggleMute: () {
              _overlayController.showOverlayForDuration();
            },
          ),
          ApivideoPlayerControlsView(
            controller: widget.controller,
            theme: widget.theme,
            onSelected: () {
              _overlayController.showOverlayForDuration();
            },
          ),
          ApiVideoPlayerActionbarView(
            controller: widget.controller,
            theme: widget.theme,
            isOverlayVisible: _overlayController.isOverlayVisible,
            onSelected: () {
              _overlayController.showOverlayForDuration();
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
