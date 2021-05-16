import 'package:emoriver/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/appUserService.dart';
import 'models/appUser.dart';
import 'utils/routes.dart';
import 'pages/homePage.dart';
import 'pages/loginPage.dart';
import 'pages/recordPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp firebaseApp = await Firebase.initializeApp();
  runApp(EmoriverApp(firebaseApp: firebaseApp));
}

class EmoriverApp extends StatefulWidget {
  EmoriverApp({Key key, this.firebaseApp}) : super(key: key);
  final FirebaseApp firebaseApp;

  @override
  _EmoriverAppState createState() => _EmoriverAppState();
}

class _EmoriverAppState extends State<EmoriverApp> {
  String userDocId = '9t9D2s4i32rk0zsrWf4A';
  Future<AppUser> userFuture;
  ThemeMode themeMode = ThemeMode.dark;


  @override
  void initState() {
    super.initState();
    userFuture = UserService.getUserByDocId(userDocId);
  }

  void setThemeMode(ThemeMode themeMode) => setState(() => this.themeMode = themeMode);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emoriver',
      debugShowCheckedModeBanner: false,
      // theme: AppTheme.buildTheme(),
      darkTheme: AppTheme.buildDarkTheme(),
      themeMode: themeMode,
      initialRoute: AppRoute.home,
      routes: {
        AppRoute.home: (context) => HomePage(
          userFuture: userFuture,
          themeMode: themeMode,
            setThemeMode: setThemeMode,
        ),
        AppRoute.login: (context) => LoginPage(),
        AppRoute.record: (context) => RecordPage(userFuture: userFuture),
      },
    );
  }
}