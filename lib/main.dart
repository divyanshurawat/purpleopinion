import 'package:demo_app/screen/home/home.dart';
import 'package:demo_app/screen/profile/edit_profile.dart';
import 'package:demo_app/style/style.dart';
import 'package:demo_app/widget/bottom_nav_bar/bottom_navbar_md.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:demo_app/screen/auth/login_page.dart';
import 'package:demo_app/services/cache_service.dart';
import 'package:provider/provider.dart';
import 'package:demo_app/constants.dart';
import 'package:demo_app/services/app_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  FontProvider fontChangeProvider = new FontProvider();
  String? language;
  bool isCheckData = false;
  Map? data;
  @override
  void initState() {
    getData();
    fcm();
    getCurrentAppTheme();
    super.initState();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
    fontChangeProvider.fontTheme =
        await fontChangeProvider.fontPreference.fontThemeValue() ?? 'SMALL';
  }

  fcm() async {
    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        CacheService.setFCMToken(value!);
      });
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });
  }

  getData() {
    setState(() {
      isCheckData = true;
    });
    CacheService.getAllData().then((value) {
      setState(() {
        if (value.isNotEmpty) {
          data = value;
        } else {
          data = {};
          CacheService.setAllData({});
        }
        isCheckData = false;
      });
    }).catchError((onError) {
      setState(() {
        isCheckData = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        FocusScope.of(context).unfocus();
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<DarkThemeProvider>(
              create: (_) => themeChangeProvider),
          ChangeNotifierProvider<FontProvider>(
              create: (_) => fontChangeProvider),
        ],
        child: Consumer<DarkThemeProvider>(
          builder: (BuildContext context, value, child) {
            return MaterialApp(
              locale: Locale('en'),
              localizationsDelegates: [
                AppLocalization.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate
              ],
              theme: Styles.themeData(themeChangeProvider.darkTheme, context),
              supportedLocales: [Locale('en', '')],
              debugShowCheckedModeBanner: false,
              title: Constants.appName,
              home: (isCheckData == true
                  ? Center(child: CircularProgressIndicator())
                  : data != null && data!.isNotEmpty
                      ? (data!['UserEmail'] != null &&
                              data!['Photo'] != null &&
                              data!['CountryCode'] != null &&
                              data!['Phone'] != null &&
                              data!['Password'] != null)
                          ? BottomNavigationBarWithMD()
                          : EditProfile(isHomePage: true)
                      : LoginPage()),
            );
          },
        ),
      ),
    );
  }
}

class DarkThemePreference {
  static const THEME_STATUS = "THEME STATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}

class FontPreference {
  static const THEME_STATUS = "font";

  setFontTheme(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(THEME_STATUS, value);
  }

  fontThemeValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(THEME_STATUS);
  }
}

class FontProvider with ChangeNotifier {
  FontPreference fontPreference = FontPreference();
  String _fontTheme = 'SMALL';

  String get fontTheme => _fontTheme;

  set fontTheme(String value) {
    _fontTheme = value;
    fontPreference.setFontTheme(value);
    notifyListeners();
  }
}
