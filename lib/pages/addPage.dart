import 'package:flutter/material.dart';
import 'routes.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        height: 500.0,
        width: 500.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () => Navigator.of(context)
                .restorablePushNamed(AppRoute.home),
            heroTag: 'hero-add',
            child: Icon(Icons.add),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
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