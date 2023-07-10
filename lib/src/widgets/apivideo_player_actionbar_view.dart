import 'package:apivideo_player/apivideo_player.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_time_slider_view.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ApiVideoPlayerActionbarView extends StatefulWidget {
  ApiVideoPlayerActionbarView(
      {super.key,
      required this.controller,
      required this.onSelected,
      required this.isOverlayVisible,
      required this.theme});

  final ApiVideoPlayerController controller;
  final Function() onSelected;
  bool isOverlayVisible;
  final PlayerTheme theme;

  @override
  State<ApiVideoPlayerActionbarView> createState() =>
      _ApiVideoPlayerActionbarViewState();
}

class _ApiVideoPlayerActionbarViewState
    extends State<ApiVideoPlayerActionbarView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.only(right: 1),
      child: Column(
        children: [
          buildBottomAction(),
          buildTimeSlider(),
        ],
      ),
    );
  }

  Widget buildBottomAction() => Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                widget.onSelected();
              },
              iconSize: 30,
              icon: Icon(
                Icons.speed,
                color: widget.theme.controlsColor,
              ),
            ),
          ],
        ),
      );

  Widget buildTimeSlider() => ApiVideoPlayerTimeSliderView(
        controller: widget.controller,
        theme: widget.theme,
      );
}
