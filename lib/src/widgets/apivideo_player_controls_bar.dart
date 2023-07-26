import 'package:apivideo_player/apivideo_player.dart';
import 'package:apivideo_player/src/style/apivideo_icons.dart';
import 'package:apivideo_player/src/style/apivideo_label.dart';
import 'package:flutter/material.dart';

class ApiVideoPlayerControlsBarController extends ChangeNotifier {
  ControlsBarState _state = ControlsBarState.paused;

  ControlsBarState get state => _state;

  set state(ControlsBarState state) {
    _state = state;
    notifyListeners();
  }
}

enum ControlsBarState {
  playing,
  paused,
  ended;

  bool get isPlaying => this == ControlsBarState.playing;

  bool get isPaused => this == ControlsBarState.paused;

  bool get didEnd => this == ControlsBarState.ended;
}

class ApiVideoPlayerControlsBar extends StatefulWidget {
  const ApiVideoPlayerControlsBar(
      {super.key,
      required this.controller,
      required this.onPlay,
      required this.onPause,
      required this.onReplay,
      required this.onForward,
      required this.onBackward,
      required this.iconsColor});

  final ApiVideoPlayerControlsBarController controller;

  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onReplay;
  final VoidCallback onForward;
  final VoidCallback onBackward;

  final Color? iconsColor;

  @override
  State<ApiVideoPlayerControlsBar> createState() =>
      _ApiVideoPlayerControlsBarState();
}

class _ApiVideoPlayerControlsBarState extends State<ApiVideoPlayerControlsBar> {
  bool _isPlaying = false;
  bool _didEnd = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_didChangeStateValue);
    if (mounted) {
      setState(() {
        _isPlaying = widget.controller._state.isPlaying;
        _didEnd = widget.controller._state.didEnd;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeStateValue);
    widget.controller.dispose();
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
                widget.onBackward();
              },
              iconSize: 30,
              icon: Icon(Icons.replay_10_rounded,
                  color: widget.iconsColor ??
                      ApiVideoPlayerTheme.defaultTheme.iconsColor,
                  semanticLabel: ApiVideoPlayerLabel.backward)),
          buildBtnVideoControl(),
          IconButton(
              onPressed: () {
                widget.onForward();
              },
              iconSize: 30,
              icon: Icon(Icons.forward_10_rounded,
                  color: widget.iconsColor ??
                      ApiVideoPlayerTheme.defaultTheme.iconsColor,
                  semanticLabel: ApiVideoPlayerLabel.forward)),
        ],
      ),
    );
  }

  Widget buildBtnVideoControl() {
    return _didEnd
        ? buildBtnReplay()
        : _isPlaying
            ? buildBtnPause()
            : buildBtnPlay();
  }

  Widget buildBtnPlay() => IconButton(
        onPressed: () {
          widget.onPlay();
        },
        iconSize: 60,
        icon: Icon(
          ApiVideoIcons.playPrimary,
          color:
              widget.iconsColor ?? ApiVideoPlayerTheme.defaultTheme.iconsColor,
          semanticLabel: ApiVideoPlayerLabel.play,
        ),
      );

  Widget buildBtnPause() => IconButton(
        onPressed: () {
          widget.onPause();
        },
        iconSize: 60,
        icon: Icon(
          ApiVideoIcons.pausePrimary,
          color:
              widget.iconsColor ?? ApiVideoPlayerTheme.defaultTheme.iconsColor,
          semanticLabel: ApiVideoPlayerLabel.pause,
        ),
      );

  Widget buildBtnReplay() => IconButton(
      onPressed: () {
        widget.onReplay();
      },
      iconSize: 60,
      icon: Icon(
        ApiVideoIcons.replayPrimary,
        color: widget.iconsColor ?? ApiVideoPlayerTheme.defaultTheme.iconsColor,
        semanticLabel: ApiVideoPlayerLabel.replay,
      ));

  _didChangeStateValue() {
    if (_isPlaying == widget.controller._state.isPlaying &&
        _didEnd == widget.controller._state.didEnd) {
      return;
    }
    if (mounted) {
      setState(() {
        _isPlaying = widget.controller._state.isPlaying;
        _didEnd = widget.controller._state.didEnd;
      });
    }
  }
}
