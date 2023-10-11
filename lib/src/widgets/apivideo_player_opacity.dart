import 'dart:async';

import 'package:flutter/widgets.dart';

class TimedOpacityController extends ChangeNotifier {
  TimedOpacityController({
    this.duration = const Duration(seconds: 4),
  });

  /// The duration to wait before hiding the overlay.
  final Duration duration;
  bool _isVisible = false;

  Timer? _opacityTimer;

  @override
  void dispose() {
    _opacityTimer?.cancel();
    _opacityTimer = null;
    super.dispose();
  }

  void showForDuration() {
    if (!_isVisible) {
      show();
    }
    _opacityTimer?.cancel();
    _opacityTimer = Timer(duration, hide);
  }

  void show() {
    _isVisible = true;
    notifyListeners();
  }

  void hide() {
    _opacityTimer?.cancel();
    _opacityTimer = null;

    _isVisible = false;
    notifyListeners();
  }
}

/// A widget that automatically hides its [child] after a given duration.
class TimedOpacity extends StatefulWidget {
  const TimedOpacity(
      {super.key, required this.controller, required this.child});

  /// The controller for the opacity.
  final TimedOpacityController controller;

  /// The child widget
  final Widget child;

  @override
  State<TimedOpacity> createState() => _TimedOpacityState();
}

class _TimedOpacityState extends State<TimedOpacity> {
  bool _isVisible = false;

  @override
  initState() {
    super.initState();
    if (mounted) {
      setState(() {
        _isVisible = widget.controller._isVisible;
      });
    }
    widget.controller.addListener(_didChangeOpacityValue);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeOpacityValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        // If the widget is visible, animate to 0.0 (invisible).
        // If the widget is hidden, animate to 1.0 (fully visible).
        opacity: _isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        child: MouseRegion(
          onEnter: (_) => widget.controller.show(),
          onExit: (_) => widget.controller.showForDuration(),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              widget.controller.showForDuration();
            },
            child: _isVisible ? widget.child : Container(),
          ),
        ));
  }

  void _didChangeOpacityValue() {
    if (_isVisible == widget.controller._isVisible) {
      return;
    }
    if (mounted) {
      setState(() {
        _isVisible = widget.controller._isVisible;
      });
    }
  }
}
