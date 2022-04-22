import 'package:demo_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/style/style.dart';
import 'package:provider/provider.dart';

getWBColor(context) {
  return Theme.of(context).brightness == Brightness.dark ? white : black;
}

getBWColor(context) {
  return Theme.of(context).brightness == Brightness.dark ? black : white;
}

getCarBackColor(context) {
  return Theme.of(context).brightness == Brightness.dark ? cartB : white;
}

getFontSmall(context) {
  final fontChange = Provider.of<FontProvider>(context);
  return (fontChange.fontTheme == 'SMALL'
      ? 16.0
      : fontChange.fontTheme == 'MEDIUM'
          ? 18.0
          : 20.0);
}

getFontMedium(context) {
  final fontChange = Provider.of<FontProvider>(context);

  return (fontChange.fontTheme == 'SMALL'
      ? 18.0
      : fontChange.fontTheme == 'MEDIUM'
          ? 20.0
          : 22.0);
}

getFontBig(context) {
  final fontChange = Provider.of<FontProvider>(context);

  return (fontChange.fontTheme == 'SMALL'
      ? 20.0
      : fontChange.fontTheme == 'MEDIUM'
          ? 22.0
          : 24.0);
}
