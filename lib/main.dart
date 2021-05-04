import 'package:emoriver/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/routes.dart';
import 'pages/homePage.dart';
import 'pages/loginPage.dart';
import 'pages/addPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp firebaseApp = await Firebase.initializeApp();
  runApp(EmoriverApp(firebaseApp: firebaseApp));
}

class EmoriverApp extends StatelessWidget {
  EmoriverApp({Key key, this.firebaseApp}) : super(key: key);

  final FirebaseApp firebaseApp;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emoriver',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildTheme(),
      initialRoute: AppRoute.home,
      routes: {
        AppRoute.home: (context) => HomePage(),
        AppRoute.login: (context) => LoginPage(),
        AppRoute.add: (context) => AddPage(),
      },
    );
  }
}