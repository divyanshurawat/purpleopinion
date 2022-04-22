import 'package:demo_app/screen/auth/login_page.dart';
import 'package:demo_app/services/alert.dart';
import 'package:demo_app/services/app_theme.dart';
import 'package:demo_app/services/helper_service.dart';
import 'package:demo_app/widget/appBar.dart';
import 'package:demo_app/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/services/api_service.dart';
import 'package:demo_app/widget/button.dart';
import 'package:demo_app/widget/text_form_fields.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isLoading = false, isOpenPass = true, isOpenPass1 = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? email;

  forgotPassword() async {
    FocusScope.of(context).unfocus();
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      setState(() {
        isLoading = true;
      });

      Map body = {'UserEmail': email};
      ApiService.forgotPassword(body, context).then((value) {
        setState(() {
          isLoading = false;
          if (value['status'] == 1) {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20),
                      showYesNo(context,
                          '${getTranslate(context, 'PASSWORD_LINK_SEND_TO_YOUR_MAIN_ID')}'),
                      SizedBox(height: 20),
                      Divider(color: getWBColor(context)),
                      SizedBox(height: 10),
                      GestureDetector(
                          onTap: () {
                            pushAndRemoveUntilNavigator(context, LoginPage());
                          },
                          child: showYesNo(context, "LOGIN")),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          } else {
            showNormalAlert(context, value['message'] ?? 'ENTER_VALID_DATA');
          }
        });
      }).catchError((onError) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, 'FORGOT_PASSWORD'),
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
              primaryBotton(context, 'SUBMIT', forgotPassword, isLoading),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
