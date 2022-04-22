import 'package:flutter/material.dart';

import 'app_localization.dart';

getTranslate(context, key) {
  return AppLocalization.of(context).translate(key);
}

backNavigator(context) {
  Navigator.of(context).pop();
}

pushNavigator(context, route) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => route,
    ),
  );
}

pushAndRemoveUntilNavigator(context, route) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => route,
      ),
      (Route<dynamic> route) => false);
}
