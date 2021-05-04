import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'hero-add',
          child: _createHeroContainer(
            size: 100.0,
            color: Colors.white,
          ),
        )
      ),
    );
  }
}

StatelessWidget _createHeroContainer({
  double size,
  Color color,
}) {
  return Container(
    height: size,
    width: size,
    padding: EdgeInsets.all(10.0),
    margin: size < 100.0 ? EdgeInsets.all(10.0) : EdgeInsets.all(0),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
    ),
    child: FlutterLogo(),
  );
}