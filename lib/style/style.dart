import 'package:flutter/material.dart';
import 'package:demo_app/services/app_theme.dart';

const primaryColor = Color(0xFF103F54);
const white = Colors.white;
const black = Colors.black;
const green = Colors.green;
const greenLight = Color(0xFF00B09C);
const greyLight = Color(0xFFF1F1F1);
const greyDart = Color(0xFF797979);
const cartB = Color(0xFF051419);

class Styles {
  static ThemeData themeData(bool? isDarkTheme, BuildContext context) {
    return ThemeData(
      brightness: isDarkTheme! ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: isDarkTheme ? black : white,
    );
  }
}

//------------HelveticaBold---------------
TextStyle helveticaFixWhite(context) {
  return TextStyle(
    fontSize: 22,
    color: white,
    fontWeight: FontWeight.w300,
    fontFamily: 'Helvetica',
  );
}

TextStyle helveticaFix(context) {
  return TextStyle(
    fontSize: 22,
    color: getWBColor(context),
    fontWeight: FontWeight.w300,
    fontFamily: 'Helvetica',
  );
}

TextStyle helveticaSBWhite(context) {
  return TextStyle(
    fontSize: 12,
    color: white,
    fontWeight: FontWeight.w300,
    fontFamily: 'Helvetica',
  );
}

TextStyle helveticaWBMediumWhite(context) {
  return TextStyle(
    fontSize: getFontMedium(context),
    color: white,
    fontWeight: FontWeight.w300,
    fontFamily: 'Helvetica',
  );
}

TextStyle helveticaWBMedium(context) {
  return TextStyle(
    fontSize: getFontMedium(context),
    color: getWBColor(context),
    fontWeight: FontWeight.w600,
    fontFamily: 'Helvetica',
  );
}

TextStyle helveticaWMedium(context) {
  return TextStyle(
    fontSize: getFontMedium(context),
    color: white,
    fontWeight: FontWeight.w600,
    fontFamily: 'Helvetica',
  );
}

TextStyle helveticaWBLSmall(context) {
  return TextStyle(
    fontSize: getFontSmall(context),
    color: getWBColor(context),
    fontFamily: 'Helveticalight',
    fontWeight: FontWeight.w500,
  );
}

TextStyle helveticaWBSmall(context) {
  return TextStyle(
    fontSize: getFontSmall(context),
    color: getWBColor(context),
    fontWeight: FontWeight.w300,
    fontFamily: 'Helvetica',
  );
}

TextStyle helveticaWSmall(context) {
  return TextStyle(
    fontSize: getFontSmall(context),
    color: white,
    fontWeight: FontWeight.w300,
    fontFamily: 'Helvetica',
  );
}
