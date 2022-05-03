import 'package:demo_app/screen/auth/add_mail.dart';
import 'package:demo_app/screen/auth/forgot_password.dart';
import 'package:demo_app/screen/home/home.dart';
import 'package:demo_app/screen/profile/edit_profile.dart';
import 'package:demo_app/services/alert.dart';
import 'package:demo_app/widget/bottom_nav_bar/bottom_navbar_md.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/services/api_service.dart';
import 'package:demo_app/services/cache_service.dart';
import 'package:demo_app/services/helper_service.dart';
import 'package:demo_app/widget/button.dart';
import 'package:demo_app/widget/text.dart';
import 'package:demo_app/widget/text_form_fields.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../login_methods.dart';
import '../../model/login_model.dart';
import '../../widget/log_utils.dart';
import '../../widget/social_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoginLoading = false, isOpenPass = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? email, password;

  loginMethod() async {
    FocusScope.of(context).unfocus();
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      setState(() {
        isLoginLoading = true;
      });
      Map body = {'UserSingUpId': email, 'pWord': password};
      ApiService.userProfile(body, context).then((value) {
        setState(() {
          isLoginLoading = false;
          Map body = {
            'Photo': value['photo'],
            'UserEmail': value['emailId'],
            'UserName': value['name'],
            'CountryCode': value['country'],
            'Phone': value['phoneNumber'],
            'Password': password,
          };
          if (value['status'] == 1) {
            if (value['photo'] != null &&
                value['emailId'] != null &&
                value['name'] != null &&
                value['country'] != null &&
                value['phoneNumber'] != null) {
              CacheService.setAllData(body);
              pushAndRemoveUntilNavigator(context, BottomNavigationBarWithMD());
            } else {
              CacheService.setAllData(body);
              pushAndRemoveUntilNavigator(
                  context, EditProfile(isHomePage: true));
            }
          } else {
            showNormalAlert(context, value['message']);
          }
        });
      }).catchError((onError) {
        setState(() {
          isLoginLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: ListView(
            children: [
              SizedBox(height: 80),
              Image.asset(
                'lib/assets/logo.png',
                height: 80,
                width: 80,
              ),
              SizedBox(height: 40),
              textFormFieldEmail(context, 'EMAIL', (value) {
                email = value;
              }),
              SizedBox(height: 30),
              textFormFieldPassword(context, 'PASSWORD', isOpenPass, () {
                setState(() {
                  isOpenPass = !isOpenPass;
                });
              }, (value) {
                password = value;
              }),
              SizedBox(height: 30),
              primaryBotton(context, 'SIGN_IN', loginMethod, isLoginLoading),
              SizedBox(height: 40),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  textHelveticaBoldPrimary(context, "FORGOT_PASSWORD_LOGIN",
                      onPress: () {
                    pushNavigator(context, ForgotPassword());
                  }),
                  SizedBox(height: 30),
                  textLatoGreyDart(context, 'DONT_HAVE_ACCOUNT', onPress: () {
                    pushNavigator(context, AddMailPage());
                  }),
                  SizedBox(height: 10),
                  textHelveticaBoldPrimary(context, "SIGN_UP", onPress: () {
                    pushNavigator(context, AddMailPage());
                  }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SocialButton(
                    onPressed: () {
                      initiateSocialLogin(context, "Google");
                    },
                    loginIcon: FontAwesomeIcons.google,
                    providerName: 'lib/assets/googlelogin.png',
                    buttonColor: Colors.white,
                    buttonTextColor: Colors.white,
                    height: 80,
                  ),
                  SocialButton(
                    onPressed: () {
                      initiateSocialLogin(context, "Facebook");
                    },
                    providerName: 'lib/assets/facebook.png',
                    loginIcon: FontAwesomeIcons.facebook,
                    buttonColor: Colors.white,
                    buttonTextColor: Colors.white,
                    height: 80,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
