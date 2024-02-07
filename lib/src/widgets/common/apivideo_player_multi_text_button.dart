import 'package:flutter/material.dart';

class MultiTextButton extends StatefulWidget {
  MultiTextButton({
    super.key,
    required this.keysValues,
    required this.onValueChanged,
    this.defaultKey,
    this.size = 15,
    this.style,
  })  : assert(keysValues.isNotEmpty),
        assert(defaultKey == null || keysValues.containsKey(defaultKey));

  final Map<String, dynamic> keysValues;

  final String? defaultKey;

  final ValueChanged<dynamic> onValueChanged;

  final double size;

  final ButtonStyle? style;

  @override
  State<MultiTextButton> createState() => _MultiTextButtonState();
}

class _MultiTextButtonState extends State<MultiTextButton> {
  late String _selectedKey = widget.defaultKey ?? widget.keysValues.keys.first;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        style: widget.style,
        onPressed: () {
          final position =
              widget.keysValues.keys.toList().indexOf(_selectedKey);
          final newKey = widget.keysValues.keys
              .elementAt((position + 1) % widget.keysValues.keys.length);
          if (mounted) {
            setState(() {
              _selectedKey = newKey;
            });
          }
          widget.onValueChanged(widget.keysValues[newKey]);
        },
        icon: Icon(Icons.speed, size: widget.size),
        label: Text(_selectedKey));
  }
}
