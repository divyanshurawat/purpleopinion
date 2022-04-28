import 'package:flutter/material.dart';

class Constants {
  static const String appName = "Opinion";
  static const String opionRequest = "Opinion Request";

  static const apiUrl = "http://Purpleopinions.co.in:3000";

  static String mobileVerification = r'(^(?:[+0]9)?[0-9]{10,12}$)';

  static String emailVerification = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
  static Color themeColor = Color(0xff103f53);
}

class KeyConstants {
  static const String googleDisplayName = "displayName";
  static const String googleEmail = "email";
  static const String googleId = "id";
  static const String googlePhotoUrl = "photoUrl";
  static const String googleToken = "token";
  static const String facebookUserDataFields =
      "name,email,picture.width(200),birthday,friends,gender,link";
  static const String emailKey = 'email';
}

class SizeConstants {
  static const double socialButtonSize = 50.0;
  static const double socialButtonTextSize = 16.0;
  static const double socialButtonLogoSize = 50.0;
  static const double horizontalPadding20 = 20.0;
  static const double verticalPadding10 = 10.0;
  static const double circularRadius = 20.0;
  static const double circularBorderRadius = 15.0;
}
