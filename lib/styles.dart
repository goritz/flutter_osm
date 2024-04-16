import 'package:flutter/material.dart';

class Styles {
  static const TextStyle gigantic = TextStyle(fontSize: 36, color: Colors.white);
  static const TextStyle huge = TextStyle(fontSize: 18, color: Colors.white);
  static const TextStyle big = TextStyle(fontSize: 14, color: Colors.white);
  static const TextStyle normal = TextStyle(fontSize: 12, color: Colors.white);
  static const TextStyle small = TextStyle(fontSize: 10, color: Colors.white);
  static const TextStyle tiny = TextStyle(fontSize: 9, color: Colors.white);
  static const TextStyle attribution = TextStyle(fontSize: 10, color: Colors.white);

  static IconButton buildIconButton(
      {required IconData iconData,
      required VoidCallback onPressed,
      bool enabled = true,
      double padding = 4,
      String? tooltip,
      Color? color = Colors.black,
      Color? disabledColor = Colors.black54,
      bool dense = false,
      double iconSize = 20}) {
    return IconButton(
        onPressed: onPressed,
        icon: Icon(iconData, color: !enabled ? disabledColor : color),
        tooltip: tooltip,
        padding: EdgeInsets.all(padding),
        iconSize: iconSize,

        // visualDensity: VisualDensity.compact,
        splashRadius: iconSize + iconSize / 4,
        constraints: !dense ? null : BoxConstraints.tight(Size(iconSize, iconSize)));
  }

  static buildBackgroundGradient(BuildContext context, {List<Color>? colors}) {
    ThemeData theme = Theme.of(context);
    List<Color> cols = colors ??
        [
          theme.colorScheme.background,
          theme.primaryColor,
          theme.primaryColor,
        ];

    return LinearGradient(begin: Alignment(0, -1), end: Alignment(-0.5, 2), colors: cols);
  }

  static void showSnack(BuildContext context, String text, {Duration duration = const Duration(seconds: 2)}) {
    ScaffoldMessenger.of(context).showSnackBar(createSnack(text, duration: duration));
  }

  static SnackBar createSnack(String text, {Duration duration = const Duration(seconds: 2)}) {
    return SnackBar(
      content: Text(text, style: Styles.normal),
      duration: duration,
      backgroundColor: Colors.white70,
    );
  }
}
