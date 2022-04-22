import 'package:demo_app/screen/home/home.dart';
import 'package:demo_app/services/alert.dart';
import 'package:demo_app/services/helper_service.dart';
import 'package:demo_app/widget/appBar.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/services/api_service.dart';
import 'package:demo_app/services/cache_service.dart';
import 'package:demo_app/widget/button.dart';
import 'package:demo_app/widget/text_form_fields.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isLoading = false,
      isOpenPass = true,
      isOpenPass1 = true,
      isOpenPass2 = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? oldPassword, newPassword, confirmPassword;

  changePassword() async {
    FocusScope.of(context).unfocus();
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      if (confirmPassword == newPassword) {
        setState(() {
          isLoading = true;
        });
        Map userData;
        CacheService.getAllData().then((value) {
          userData = value;
          Map body = {
            'UserEmail': userData['UserEmail'],
            'oldPword': oldPassword,
            'NewPword': newPassword
          };
          ApiService.changePassword(body, context).then((value) {
            setState(() {
              isLoading = false;
              if (value['status'] == 1) {
                userData['Password'] = newPassword;
                CacheService.setAllData(userData);
                showNormalAlert(context, 'PASSWORD_CHANGE_SUCCESSFULLY');
                Future.delayed(Duration(seconds: 3), () {
                  pushAndRemoveUntilNavigator(context, HomePage());
                });
              } else {
                showNormalAlert(context, 'ENTER_VALID_PASSWORD');
              }
            });
          }).catchError((onError) {
            setState(() {
              isLoading = false;
            });
          });
        });
      } else {
        showNormalAlert(
            context, 'NEW_PASSWORD_AND_CONFIRM_PASSWORD_NOT_MATCHED');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, 'CHANGE_PASSWORD'),
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
              textFormFieldPassword(context, 'OLD_PASSWORD', isOpenPass, () {
                setState(() {
                  isOpenPass = !isOpenPass;
                });
              }, (value) {
                oldPassword = value;
              }),
              SizedBox(height: 30),
              textFormFieldPassword(context, 'NEW_PASSWORD', isOpenPass1, () {
                setState(() {
                  isOpenPass1 = !isOpenPass1;
                });
              }, (value) {
                newPassword = value;
              }),
              SizedBox(height: 30),
              textFormFieldPassword(context, 'CONFIRM_PASSWORD', isOpenPass2,
                  () {
                setState(() {
                  isOpenPass2 = !isOpenPass2;
                });
              }, (value) {
                confirmPassword = value;
              }),
              SizedBox(height: 30),
              primaryBotton(context, 'SUBMIT', changePassword, isLoading),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
