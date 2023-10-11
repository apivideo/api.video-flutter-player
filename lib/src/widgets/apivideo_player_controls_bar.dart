import 'package:apivideo_player/src/style/apivideo_icons.dart';
import 'package:apivideo_player/src/style/apivideo_label.dart';
import 'package:flutter/material.dart';

class ControlsBarController extends ChangeNotifier {
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

class ControlsBar extends StatefulWidget {
  const ControlsBar(
      {super.key,
      required this.controller,
      required this.onPlay,
      required this.onPause,
      required this.onReplay,
      required this.onForward,
      required this.onBackward,
      this.playIcon = ApiVideoIcons.playPrimary,
      this.pauseIcon = ApiVideoIcons.pausePrimary,
      this.rewindIcon = ApiVideoIcons.replayPrimary,
      this.forwardIcon = Icons.forward_10_rounded,
      this.backwardIcon = Icons.replay_10_rounded,
      this.style});

  final ControlsBarController controller;

  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onReplay;
  final VoidCallback onForward;
  final VoidCallback onBackward;

  /// The main icons to display.
  final IconData playIcon;
  final IconData pauseIcon;
  final IconData rewindIcon;

  final IconData? forwardIcon;
  final IconData? backwardIcon;

  final ControlsBarStyle? style;

  @override
  State<ControlsBar> createState() => _ControlsBarState();
}

class _ControlsBarState extends State<ControlsBar> {
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
  void didUpdateWidget(ControlsBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.controller.removeListener(_didChangeStateValue);
    widget.controller.addListener(_didChangeStateValue);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeStateValue);
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
              icon: Icon(widget.backwardIcon,
                  semanticLabel: ApiVideoLabels.backward),
              style: widget.style?.seekBackwardControlButtonStyle),
          buildBtnVideoControl(),
          IconButton(
              onPressed: () {
                widget.onForward();
              },
              iconSize: 30,
              icon: Icon(widget.forwardIcon,
                  semanticLabel: ApiVideoLabels.forward),
              style: widget.style?.seekForwardControlButtonStyle),
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
        widget.playIcon,
        semanticLabel: ApiVideoLabels.play,
      ),
      style: widget.style?.mainControlButtonStyle);

  Widget buildBtnPause() => IconButton(
      onPressed: () {
        widget.onPause();
      },
      iconSize: 60,
      icon: Icon(
        widget.pauseIcon,
        semanticLabel: ApiVideoLabels.pause,
      ),
      style: widget.style?.mainControlButtonStyle);

  Widget buildBtnReplay() => IconButton(
      onPressed: () {
        widget.onReplay();
      },
      iconSize: 60,
      icon: Icon(
        widget.rewindIcon,
        semanticLabel: ApiVideoLabels.replay,
      ),
      style: widget.style?.mainControlButtonStyle);

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

class ControlsBarStyle {
  const ControlsBarStyle(
      {this.mainControlButtonStyle,
      this.seekForwardControlButtonStyle,
      this.seekBackwardControlButtonStyle});

  final ButtonStyle? mainControlButtonStyle;
  final ButtonStyle? seekForwardControlButtonStyle;
  final ButtonStyle? seekBackwardControlButtonStyle;

  /// Applies the style to all buttons
  ///
  /// If [sideControlButtonStyle] is null, it will be the same as [mainControlButtonStyle].
  static ControlsBarStyle styleFrom(
      {ButtonStyle? mainControlButtonStyle,
      ButtonStyle? sideControlButtonStyle}) {
    sideControlButtonStyle ??= mainControlButtonStyle;

    return ControlsBarStyle(
        mainControlButtonStyle: mainControlButtonStyle,
        seekForwardControlButtonStyle: mainControlButtonStyle,
        seekBackwardControlButtonStyle: mainControlButtonStyle);
  }

  ControlsBarStyle copyWith({
    ButtonStyle? mainControlButtonStyle,
    ButtonStyle? seekForwardControlButtonStyle,
    ButtonStyle? seekBackwardControlButtonStyle,
  }) {
    return ControlsBarStyle(
        mainControlButtonStyle:
            mainControlButtonStyle ?? this.mainControlButtonStyle,
        seekForwardControlButtonStyle:
            seekForwardControlButtonStyle ?? this.seekForwardControlButtonStyle,
        seekBackwardControlButtonStyle: seekBackwardControlButtonStyle ??
            this.seekBackwardControlButtonStyle);
  }

  /// Applies the [Theme.iconButtonTheme] to all buttons
  static ControlsBarStyle of(BuildContext context) {
    final iconButtonTheme = Theme.of(context).iconButtonTheme;

    return styleFrom(mainControlButtonStyle: iconButtonTheme.style);
  }
}
