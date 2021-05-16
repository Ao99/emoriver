import 'package:emoriver/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  const EmoriverApp({Key key, this.firebaseApp}) : super(key: key);
  final FirebaseApp firebaseApp;

  @override
  _EmoriverAppState createState() => _EmoriverAppState();
}

class _EmoriverAppState extends State<EmoriverApp> {
  ThemeMode themeMode = ThemeMode.dark;

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
        AppRoute.home: (context) => HomePage(themeMode: themeMode, setThemeMode: setThemeMode),
        AppRoute.login: (context) => LoginPage(),
        AppRoute.add: (context) => RecordPage(),
      },
    );
  }
}