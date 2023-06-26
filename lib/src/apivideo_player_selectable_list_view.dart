import 'package:apivideo_player/apivideo_player.dart';
import 'package:flutter/material.dart';

class ApiVideoPlayerSelectableListView extends StatelessWidget {
  const ApiVideoPlayerSelectableListView({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onSelected,
    required this.theme,
  });

  final List<Object> items;
  final Object selectedItem;
  final ValueChanged<Object> onSelected;
  final PlayerTheme theme;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];
        bool isSelected = item == selectedItem;
        return ListTile(
          title: Text('$item'),
          trailing: isSelected
              ? Icon(
                  Icons.check,
                  color: theme.checkIconColor,
                )
              : null,
          onTap: () {
            onSelected(item);
          },
        );
      },
    );
  }
}
