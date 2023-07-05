import 'package:apivideo_player/apivideo_player.dart';
import 'package:apivideo_player/src/presentation/apivideo_icons.dart';
import 'package:flutter/material.dart';

class ApivideoPlayerControlsView extends StatefulWidget {
  const ApivideoPlayerControlsView(
      {super.key,
      required this.controller,
      required this.onSelected,
      required this.theme});

  final ApiVideoPlayerController controller;
  final Function() onSelected;
  final PlayerTheme theme;

  @override
  State<ApivideoPlayerControlsView> createState() =>
      _ApivideoPlayerControlsViewState();
}

class _ApivideoPlayerControlsViewState
    extends State<ApivideoPlayerControlsView> {
  _ApivideoPlayerControlsViewState() {
    _listener = ApiVideoPlayerEventsListener(
      onReady: () async {},
      onPlay: () {
        setState(() {
          _isPlaying = true;
          _didEnd = false;
        });
      },
      onPause: () {
        setState(() {
          _isPlaying = false;
        });
      },
      onSeek: () {},
      onSeekStarted: () {
        if (_didEnd) {
          setState(() {
            _didEnd = false;
          });
        }
      },
      onEnd: () {
        setState(() {
          _isPlaying = false;
          _didEnd = true;
        });
      },
    );
  }

  late ApiVideoPlayerEventsListener _listener;
  bool _isPlaying = false;
  bool _didEnd = false;

  void pause() {
    widget.controller.pause();
  }

  void play() {
    widget.controller.play();
  }

  void replay() async {
    await widget.controller.setCurrentTime(const Duration(seconds: 0));
    play();
  }

  void seek(Duration duration) {
    widget.controller.seek(duration);
  }

  void _onPlay() {
    setState(() {
      _isPlaying = true;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addEventsListener(_listener);

    widget.controller.isCreated.then((bool isCreated) async => {
          if (isCreated)
            {
              widget.controller.isPlaying.then((isPlaying) => {
                    if (isPlaying) {_onPlay()}
                  })
            }
        });
  }

  @override
  void dispose() {
    widget.controller.removeEventsListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () {
                seek(const Duration(seconds: -10));
                widget.onSelected;
              },
              iconSize: 30,
              icon: Icon(
                Icons.replay_10_rounded,
                color: widget.theme.controlsColor,
              )),
          buildBtnVideoControl(),
          IconButton(
              onPressed: () {
                seek(const Duration(seconds: 10));
                widget.onSelected;
              },
              iconSize: 30,
              icon: Icon(
                Icons.forward_10_rounded,
                color: widget.theme.controlsColor,
              )),
        ],
      ),
    );
  }

  Widget buildBtnVideoControl() {
    return _didEnd ? buildBtnReplay() : buildBtnPlay();
  }

  Widget buildBtnPlay() => IconButton(
        onPressed: () {
          _isPlaying ? pause() : play();
          widget.onSelected;
        },
        iconSize: 60,
        icon: _isPlaying
            ? Icon(
                ApiVideoIcons.pausePrimary,
                color: widget.theme.controlsColor,
              )
            : Icon(
                ApiVideoIcons.playPrimary,
                color: widget.theme.controlsColor,
              ),
      );

  Widget buildBtnReplay() => IconButton(
      onPressed: () {
        replay();
        widget.onSelected;
      },
      iconSize: 60,
      icon: Icon(
        ApiVideoIcons.replayPrimary,
        color: widget.theme.controlsColor,
      ));
}
