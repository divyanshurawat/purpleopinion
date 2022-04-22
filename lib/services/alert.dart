import 'package:demo_app/services/app_theme.dart';
import 'package:demo_app/services/helper_service.dart';
import 'package:demo_app/widget/text.dart';
import 'package:flutter/material.dart';

showNormalAlert(context, title) {
  return showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            showYesNo(context, getTranslate(context, title)),
            SizedBox(height: 20),
            Divider(color: getWBColor(context)),
            SizedBox(height: 10),
            GestureDetector(
                onTap: () {
                  backNavigator(context);
                },
                child: showYesNo(context, getTranslate(context, 'OK'))),
            SizedBox(height: 10),
          ],
        ),
      ),
    ),
  );
}

showNormalAlertPress(context, title, {Function()? onPress}) {
  return showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            showYesNo(context, getTranslate(context, title)),
            SizedBox(height: 20),
            Divider(color: getWBColor(context)),
            SizedBox(height: 10),
            GestureDetector(
                onTap: onPress,
                child: showYesNo(context, getTranslate(context, 'OK'))),
            SizedBox(height: 10),
          ],
        ),
      ),
    ),
  );
}
