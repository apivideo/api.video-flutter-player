import 'package:flutter/material.dart';

class ApiVideoPlayerMultiTextButton extends StatefulWidget {
  ApiVideoPlayerMultiTextButton({
    Key? key,
    required this.keysValues,
    required this.onValueChanged,
    this.defaultKey,
    this.size = 15,
    this.textColor,
    this.iconColor,
  })  : assert(keysValues.isNotEmpty),
        assert(defaultKey == null || keysValues.containsKey(defaultKey)),
        super(key: key);

  final Map<String, dynamic> keysValues;

  final String? defaultKey;

  final ValueChanged<dynamic> onValueChanged;

  final double size;

  final Color? textColor;
  final Color? iconColor;

  @override
  State<ApiVideoPlayerMultiTextButton> createState() =>
      _ApiVideoPlayerMultiTextButtonState();
}

class _ApiVideoPlayerMultiTextButtonState
    extends State<ApiVideoPlayerMultiTextButton> {
  late String _selectedKey = widget.defaultKey ?? widget.keysValues.keys.first;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: widget.textColor,
        textStyle: TextStyle(fontSize: widget.size),
      ),
      onPressed: () {
        final position = widget.keysValues.keys.toList().indexOf(_selectedKey);
        final newKey = widget.keysValues.keys
            .elementAt((position + 1) % widget.keysValues.keys.length);
        if (mounted) {
          setState(() {
            _selectedKey = newKey;
          });
        }
        widget.onValueChanged(widget.keysValues[newKey]);
      },
      icon: Icon(Icons.speed, color: widget.iconColor, size: widget.size),
      label: Text(_selectedKey),
    );
  }
}
