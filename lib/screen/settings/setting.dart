import 'package:demo_app/main.dart';
import 'package:demo_app/screen/auth/change_password.dart';
import 'package:demo_app/screen/auth/login_page.dart';
import 'package:demo_app/services/alert.dart';
import 'package:demo_app/services/api_service.dart';
import 'package:demo_app/services/app_theme.dart';
import 'package:demo_app/services/cache_service.dart';
import 'package:demo_app/services/helper_service.dart';
import 'package:demo_app/style/style.dart';
import 'package:demo_app/widget/appBar.dart';
import 'package:demo_app/widget/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDeleteAccountLoading = false, isLogout = false;

  deleteUser() async {
    setState(() {
      isDeleteAccountLoading = true;
    });
    CacheService.getAllData().then((profileValue) {
      setState(() {
        if (profileValue.isNotEmpty) {
          Map body = {
            "UserEmail": profileValue['UserEmail'],
            "Pword": profileValue['Password'],
          };
          ApiService.removeUser(body, context).then((value) {
            setState(() {
              isDeleteAccountLoading = false;
              if (value['status'] == 1) {
                CacheService.deleteAllData();
                showNormalAlert(context, 'ACCOUNT_DELETED_SUCCESSFULLY');
                pushAndRemoveUntilNavigator(context, LoginPage());
              }
            });
          }).catchError((onError) {
            setState(() {
              isDeleteAccountLoading = false;
            });
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final fontChange = Provider.of<FontProvider>(context);
    return Scaffold(
      appBar: normalAppBar(context, "SETTINGS"),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                getTranslate(context, 'CHOOSE_THEME'),
                                style: helveticaWBSmall(context),
                              ),
                              Divider(color: getWBColor(context)),
                              InkWell(
                                onTap: () {
                                  if (themeChange.darkTheme) {
                                    setState(() {
                                      themeChange.darkTheme = false;
                                      CacheService.setTheme(false);
                                      backNavigator(context);
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    showYesNo(context, 'LIGHT'),
                                    !themeChange.darkTheme
                                        ? Icon(
                                            Icons.done_outline_rounded,
                                            color: getWBColor(context),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              InkWell(
                                onTap: () {
                                  if (!themeChange.darkTheme) {
                                    setState(() {
                                      themeChange.darkTheme = true;
                                      CacheService.setTheme(true);
                                      backNavigator(context);
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    showYesNo(context, 'DARK'),
                                    themeChange.darkTheme
                                        ? Icon(
                                            Icons.done_outline_rounded,
                                            color: getWBColor(context),
                                          )
                                        : Container(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: ListTile(
                leading: Icon(
                  Icons.settings,
                  color: getWBColor(context),
                ),
                title: Text(
                  getTranslate(context, 'THEME'),
                  style: helveticaWBSmall(context),
                ),
                subtitle: Text(
                  getTranslate(
                      context,
                      Theme.of(context).brightness == Brightness.light
                          ? 'LIGHT'
                          : 'DARK'),
                  style: helveticaWBLSmall(context),
                ),
              ),
            ),
            Divider(color: getWBColor(context)),
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                getTranslate(context, 'CHOOSE_FONT'),
                                style: helveticaWBSmall(context),
                              ),
                              Divider(color: getWBColor(context)),
                              InkWell(
                                onTap: () {
                                  if (fontChange.fontTheme != 'SMALL') {
                                    setState(() {
                                      CacheService.setFont('SMALL');
                                      fontChange.fontTheme = 'SMALL';
                                      pushAndRemoveUntilNavigator(
                                          context, MyApp());
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    showYesNo(context, 'SMALL'),
                                    fontChange.fontTheme == 'SMALL'
                                        ? Icon(Icons.done_outline_rounded,
                                            color: getWBColor(context))
                                        : Container(),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              InkWell(
                                onTap: () {
                                  if (fontChange.fontTheme != 'MEDIUM') {
                                    setState(() {
                                      CacheService.setFont('MEDIUM');
                                      fontChange.fontTheme = 'MEDIUM';
                                      pushAndRemoveUntilNavigator(
                                          context, MyApp());
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    showYesNo(context, 'MEDIUM'),
                                    fontChange.fontTheme == 'MEDIUM'
                                        ? Icon(Icons.done_outline_rounded,
                                            color: getWBColor(context))
                                        : Container(),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              InkWell(
                                onTap: () {
                                  if (fontChange.fontTheme != 'BIG') {
                                    setState(() {
                                      CacheService.setFont('BIG');
                                      fontChange.fontTheme = 'BIG';
                                      pushAndRemoveUntilNavigator(
                                          context, MyApp());
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    showYesNo(context, 'BIG'),
                                    fontChange.fontTheme == 'BIG'
                                        ? Icon(Icons.done_outline_rounded,
                                            color: getWBColor(context))
                                        : Container(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: ListTile(
                leading: Icon(
                  Icons.font_download,
                  color: getWBColor(context),
                ),
                title: Text(
                  getTranslate(context, 'FONT'),
                  style: helveticaWBSmall(context),
                ),
                subtitle: Text(
                  getTranslate(
                      context,
                      (fontChange.fontTheme == 'MEDIUM'
                          ? 'MEDIUM'
                          : fontChange.fontTheme == 'SMALL'
                              ? 'SMALL'
                              : 'BIG')),
                  style: helveticaWBLSmall(context),
                ),
              ),
            ),
            Divider(color: getWBColor(context)),
            InkWell(
              onTap: () {
                pushNavigator(context, ChangePassword());
              },
              child: ListTile(
                leading: Icon(
                  Icons.password,
                  color: getWBColor(context),
                ),
                title: Text(
                  getTranslate(context, 'CHANGE_PASSWORD'),
                  style: helveticaWBSmall(context),
                ),
              ),
            ),
            Divider(color: getWBColor(context)),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10),
                          showYesNo(
                              context, 'ARE_YOU_SURE_DELETE_YOUR_ACCOUNT'),
                          Divider(color: getWBColor(context)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 10),
                              GestureDetector(
                                  onTap: () {
                                    deleteUser();
                                    backNavigator(context);
                                  },
                                  child: showYesNo(context, "YES")),
                              SizedBox(width: 10),
                              GestureDetector(
                                  onTap: () {
                                    backNavigator(context);
                                  },
                                  child: showYesNo(context, "NO")),
                              SizedBox(width: 10),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: ListTile(
                leading: Icon(
                  Icons.delete,
                  color: getWBColor(context),
                ),
                title: isDeleteAccountLoading == true
                    ? Container(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator())
                    : Text(
                        getTranslate(context, 'DELETE_ACCOUNT'),
                        style: helveticaWBSmall(context),
                      ),
              ),
            ),
            Divider(color: getWBColor(context)),
            InkWell(
              onTap: () {
                setState(() {
                  isLogout = true;
                  CacheService.deleteAllData();
                  backNavigator(context);
                  pushAndRemoveUntilNavigator(context, LoginPage());
                  isLogout = false;
                });
              },
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: getWBColor(context),
                ),
                title: isLogout == true
                    ? Container(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator())
                    : Text(
                        getTranslate(context, 'LOGOUT'),
                        style: helveticaWBSmall(context),
                      ),
              ),
            ),
            Divider(color: getWBColor(context)),
          ],
        ),
      ),
    );
  }
}
