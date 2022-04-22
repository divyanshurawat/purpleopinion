import 'package:demo_app/services/helper_service.dart';

String? validateEmailAddress(context, String? value) {
  if (value == null) return null;
  if (value.isEmpty) {
    return getTranslate(context, 'EMAIL_CANT_EMPTY');
  }
  // else if (!RegExp(Constants.emailVerification).hasMatch(value)) {
  //   return getTranslate(context, 'PLEASE_ENTER_VALID_EMAIL');
  // }
  else {
    return null;
  }
}

String? validateName(context, String? value) {
  if (value == null) return null;
  if (value.isEmpty) {
    return getTranslate(context, 'NAME_CANT_EMPTY');
  } else {
    return null;
  }
}

String? validatePassword(context, String? value) {
  if (value == null) return null;
  if (value.isEmpty) {
    return getTranslate(context, 'PASSWORD_CANT_EMPTY');
  } else {
    return null;
  }
}

String? validateMobile(context, String? value) {
  if (value == null) return null;
  if (value.isEmpty) {
    return getTranslate(context, 'PLEASE_ENTER_PHONE_NUMBER');
  }
  //  else if (!RegExp(Constants.mobileVerification).hasMatch(value)) {
  //   return getTranslate(context, 'PLEASE_ENTER_VALID_PHONE_NUMBER');
  // }
  return null;
}
