import 'package:flutter/material.dart';

class ApiVideoPlayerVolumeSliderController extends ChangeNotifier {
  double _volume = 1.0;

  double get volume => _volume;

  set volume(double newVolume) {
    _volume = newVolume;
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
  const ApiVideoPlayerVolumeSlider.raw({
    super.key,
    required this.controller,
    required this.onVolumeChanged,
    required this.onToggleMute,
    required this.style,
  });

  final ApiVideoPlayerVolumeSliderController controller;

  final Function(double) onVolumeChanged;
  final VoidCallback onToggleMute;

  final ApiVideoPlayerVolumeSliderStyle style;

  factory ApiVideoPlayerVolumeSlider({
    required ApiVideoPlayerVolumeSliderController controller,
    required Function(double) onVolumeChanged,
    required VoidCallback onToggleMute,
    ApiVideoPlayerVolumeSliderStyle? style,
  }) {
    style ??= ApiVideoPlayerVolumeSliderStyle();

    return ApiVideoPlayerVolumeSlider.raw(
      controller: controller,
      onVolumeChanged: onVolumeChanged,
      onToggleMute: onToggleMute,
      style: style,
    );
  }

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
              style: widget.style.buttonStyle,
              icon: Icon(
                _volume <= 0 || _isMuted ? Icons.volume_off : Icons.volume_up,
                size: 18,
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
                data: widget.style.sliderTheme.copyWith(trackHeight: 2.0),
                child: Slider(
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

class ApiVideoPlayerVolumeSliderStyle {
  const ApiVideoPlayerVolumeSliderStyle.raw({
    this.buttonStyle,
    required this.sliderTheme,
  });

  final ButtonStyle? buttonStyle;
  final SliderThemeData sliderTheme;

  factory ApiVideoPlayerVolumeSliderStyle({
    ButtonStyle? buttonStyle,
    SliderThemeData? sliderTheme,
  }) {
    sliderTheme ??= const SliderThemeData();

    return ApiVideoPlayerVolumeSliderStyle.raw(
      buttonStyle: buttonStyle,
      sliderTheme: sliderTheme,
    );
  }

  ApiVideoPlayerVolumeSliderStyle copyWith({
    ButtonStyle? buttonStyle,
    SliderThemeData? sliderTheme,
  }) =>
      ApiVideoPlayerVolumeSliderStyle.raw(
        buttonStyle: buttonStyle ?? this.buttonStyle,
        sliderTheme: sliderTheme ?? this.sliderTheme,
      );
}
