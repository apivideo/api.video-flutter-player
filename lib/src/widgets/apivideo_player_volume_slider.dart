import 'package:apivideo_player/src/style/apivideo_theme.dart';
import 'package:flutter/material.dart';

class ApiVideoPlayerVolumeSliderController extends ChangeNotifier {
  double _value = 1.0;

  double get volume => _value;

  set volume(double newVolume) {
    _value = newVolume;
    notifyListeners();
  }

  bool _isMuted = false;

  bool get isMuted => _isMuted;

  set isMuted(bool newIsMuted) {
    _isMuted = newIsMuted;
    notifyListeners();
  }
}

class ApiVideoPlayerVolumeSlider extends StatefulWidget {
  const ApiVideoPlayerVolumeSlider({
    super.key,
    required this.controller,
    required this.onVolumeChanged,
    required this.onToggleMute,
    this.iconsColor,
    this.activeVolumeSliderColor,
    this.inactiveVolumeSliderColor,
    this.thumbVolumeSliderColor,
  });

  final ApiVideoPlayerVolumeSliderController controller;

  final Function(double) onVolumeChanged;
  final VoidCallback onToggleMute;

  final Color? iconsColor;
  final Color? activeVolumeSliderColor;
  final Color? inactiveVolumeSliderColor;
  final Color? thumbVolumeSliderColor;

  @override
  State<ApiVideoPlayerVolumeSlider> createState() =>
      _ApiVideoPlayerVolumeSliderState();
}

class _ApiVideoPlayerVolumeSliderState extends State<ApiVideoPlayerVolumeSlider>
    with TickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  double _volume = 1.0;
  bool _isMuted = false;

  void _animateExpand({required bool open}) {
    if (open) {
      expandController.forward();
    } else {
      expandController.animateBack(0, duration: const Duration(seconds: 1));
    }
  }

  @override
  initState() {
    super.initState();
    widget.controller.addListener(_didChangeVolumeSliderValue);
    if (mounted) {
      setState(() {
        _isMuted = widget.controller.isMuted;
        _volume = widget.controller.volume;
      });
    }
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
    widget.controller.removeListener(_didChangeVolumeSliderValue);
    widget.controller.dispose();
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _animateExpand(open: true),
      onExit: (_) => _animateExpand(open: false),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
              icon: Icon(
                _volume <= 0 || _isMuted ? Icons.volume_off : Icons.volume_up,
                color: widget.iconsColor ??
                    ApiVideoPlayerTheme.defaultTheme.iconsColor,
              ),
              onPressed: () {
                widget.controller.isMuted = !_isMuted;
                widget.onToggleMute();
              }),
          SizeTransition(
            sizeFactor: animation,
            axis: Axis.horizontal,
            child: SizedBox(
              height: 30.0,
              width: 80.0,
              child: SliderTheme(
                data: SliderThemeData(
                    activeTrackColor: widget.activeVolumeSliderColor ??
                        ApiVideoPlayerTheme
                            .defaultTheme.volumeSliderActiveColor,
                    trackHeight: 2.0,
                    thumbColor: widget.thumbVolumeSliderColor ??
                        ApiVideoPlayerTheme.defaultTheme.volumeSliderThumbColor,
                    overlayShape: SliderComponentShape.noOverlay,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6.0,
                    )),
                child: Slider(
                  activeColor: widget.activeVolumeSliderColor ??
                      ApiVideoPlayerTheme.defaultTheme.volumeSliderActiveColor,
                  inactiveColor: widget.inactiveVolumeSliderColor ??
                      ApiVideoPlayerTheme
                          .defaultTheme.volumeSliderInactiveColor,
                  value: _isMuted ? 0 : _volume,
                  onChanged: (value) {
                    if (_isMuted) {
                      widget.controller.isMuted = false;
                    }
                    widget.controller.volume = value;
                    widget.onVolumeChanged(value);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _didChangeVolumeSliderValue() {
    if (_isMuted != widget.controller.isMuted ||
        _volume != widget.controller.volume) {
      setState(() {
        _isMuted = widget.controller.isMuted;
        _volume = widget.controller.volume;
      });
    }
  }
}
