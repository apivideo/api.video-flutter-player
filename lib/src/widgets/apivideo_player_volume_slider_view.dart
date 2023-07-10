import 'package:apivideo_player/apivideo_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ApiVideoPlayerVolumeSliderView extends StatefulWidget {
  const ApiVideoPlayerVolumeSliderView({
    super.key,
    required this.controller,
    required this.theme,
    required this.volumeDidSet,
    required this.toggleMute,
  });

  final ApiVideoPlayerController controller;
  final PlayerTheme theme;
  final Function() volumeDidSet;
  final Function() toggleMute;

  @override
  State<ApiVideoPlayerVolumeSliderView> createState() =>
      _ApiVideoPlayerVolumeSliderViewState();
}

class _ApiVideoPlayerVolumeSliderViewState
    extends State<ApiVideoPlayerVolumeSliderView>
    with TickerProviderStateMixin {
  double _volume = 0.0;
  bool _isMuted = false;
  late AnimationController expandController;
  late Animation<double> animation;

  void setVolume(double volume) async {
    await widget.controller.setVolume(volume);
    _updateVolume();
    widget.volumeDidSet();
  }

  void toggleMuted() async {
    final bool muted = await widget.controller.isMuted;
    await widget.controller.setIsMuted(!muted);
    _updateMuted();
    widget.toggleMute();
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
  initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return kIsWeb
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
}
