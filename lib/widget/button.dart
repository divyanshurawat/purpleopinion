import 'package:flutter/material.dart';
import 'package:demo_app/services/helper_service.dart';
import 'package:demo_app/style/style.dart';

primaryBotton(context, text, Function() press, isLoading) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: primaryColor,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
    ),
    onPressed: press,
    child: isLoading == true
        ? Container(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(color: white))
        : Text(
            getTranslate(context, text ?? ''),
            style: helveticaWBMediumWhite(context),
          ),
  );
}

primarySmallBotton(context, text, Function() press, isLoading) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: primaryColor,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
    ),
    onPressed: press,
    child: isLoading == true
        ? Container(
            height: 12,
            width: 12,
            child: CircularProgressIndicator(color: white))
        : Text(
            getTranslate(context, text ?? ''),
            style: helveticaSBWhite(context),
          ),
  );
}
