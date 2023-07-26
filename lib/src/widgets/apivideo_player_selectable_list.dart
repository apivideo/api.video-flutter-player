import 'package:apivideo_player/src/style/apivideo_theme.dart';
import 'package:flutter/material.dart';

class ApiVideoPlayerSelectableList extends StatefulWidget {
  const ApiVideoPlayerSelectableList({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onSelected,
    this.selectedColor,
  });

  final List<Object> items;
  final Object selectedItem;
  final ValueChanged<Object>? onSelected;

  final Color? selectedColor;

  @override
  State<ApiVideoPlayerSelectableList> createState() =>
      _ApiVideoPlayerSelectableListState();
}

class _ApiVideoPlayerSelectableListState
    extends State<ApiVideoPlayerSelectableList> {
  late Object _selectedItem = widget.selectedItem;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = widget.items[index];
        bool isSelected = item == _selectedItem;
        return ListTile(
          title: Text('$item'),
          selected: isSelected,
          selectedColor: widget.selectedColor ??
              ApiVideoPlayerTheme.defaultTheme.selectedColor,
          trailing: isSelected ? const Icon(Icons.check) : null,
          onTap: () {
            if (isSelected) {
              return;
            }
            if (mounted) {
              setState(() {
                _selectedItem = item;
              });
            }
            if (widget.onSelected != null) {
              widget.onSelected!(item);
            }
          },
        );
      },
    );
  }
}
