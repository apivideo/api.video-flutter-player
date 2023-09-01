import 'package:flutter/material.dart';

class ApiVideoPlayerMultiTextButton extends StatefulWidget {
  ApiVideoPlayerMultiTextButton({
    Key? key,
    required this.keysValues,
    required this.onValueChanged,
    this.defaultKey,
    this.textColor,
  })  : assert(keysValues.isNotEmpty),
        assert(defaultKey == null || keysValues.containsKey(defaultKey)),
        super(key: key);

  final Map<String, dynamic> keysValues;

  final String? defaultKey;

  final ValueChanged<dynamic> onValueChanged;

  final Color? textColor;

  @override
  State<ApiVideoPlayerMultiTextButton> createState() =>
      _ApiVideoPlayerMultiTextButtonState();
}

class _ApiVideoPlayerMultiTextButtonState
    extends State<ApiVideoPlayerMultiTextButton> {
  late String _selectedKey = widget.defaultKey ?? widget.keysValues.keys.first;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: widget.textColor,
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
      child: Text(_selectedKey),
    );
  }
}
