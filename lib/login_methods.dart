import 'package:demo_app/widget/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'constants.dart';
import 'model/login_model.dart';

void _googleSignInProcess(BuildContext context) async {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  String? token = googleAuth?.idToken;
  ResGoogleSignInModel _socialGoogleUser = ResGoogleSignInModel(
      displayName: googleUser?.displayName,
      email: googleUser?.email,
      photoUrl: googleUser?.photoUrl,
      id: googleUser?.id,
      token: token);
  Fluttertoast.showToast(
      msg: googleUser!.email,
      backgroundColor: Colors.blue,
      textColor: Colors.white);
  LogUtils.showLog("${_socialGoogleUser.toJson()}");
}
void _facebookSignInProcess(BuildContext context) async {
  LoginResult result = await FacebookAuth.instance.login();
  if (result.status == LoginStatus.success) {
    AccessToken accessToken = result.accessToken!;
    Map<String, dynamic> userData = await FacebookAuth.i.getUserData(
      fields: KeyConstants.facebookUserDataFields,
    );
    Fluttertoast.showToast(
        msg: userData[KeyConstants.emailKey],
        backgroundColor: Colors.blue,
        textColor: Colors.white);
    LogUtils.showLog("${accessToken.userId}");
    LogUtils.showLog("$userData");
  } else {
  }
}

Future initiateSocialLogin(BuildContext context, String provider) async {
  try {
    if (provider == "Google") {
      _googleSignInProcess(context);
    } else if (provider == "Facebook") {
      _facebookSignInProcess(context);
    }
  } on Exception catch (e) {
    LogUtils.showLog("$e");
  }
}
