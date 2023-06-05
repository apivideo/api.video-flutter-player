import 'package:flutter/material.dart';

class ApiVideoPlayerSelectableListView extends StatefulWidget {
  const ApiVideoPlayerSelectableListView({
    super.key,
    required this.items,
    required this.selectedElement,
    required this.onSelected,
  });

  final List<Object> items;
  final Object selectedElement;
  final ValueChanged<Object> onSelected;

  @override
  State<ApiVideoPlayerSelectableListView> createState() =>
      _ApiVideoPlayerSelectableListViewState();
}

class _ApiVideoPlayerSelectableListViewState
    extends State<ApiVideoPlayerSelectableListView> {
  _ApiVideoPlayerSelectableListViewState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = widget.items[index];
        bool isSelected = item == widget.selectedElement;
        return ListTile(
          title: Text('$item'),
          trailing: isSelected
              ? const Icon(
                  Icons.check,
                  color: Colors.lightGreen,
                )
              : null,
          onTap: () {
            isSelected = true;
            widget.onSelected(item);
          },
        );
      },
    );
  }
}
