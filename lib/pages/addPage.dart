import 'package:flutter/material.dart';
import '../models/emotion.dart';
import '../utils/routes.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    AddPageArguments arguments =
        ModalRoute.of(context).settings.arguments as AddPageArguments;

    return Scaffold(
      body: Center(
        child: arguments == null
          ? Container()
          : Text(
              '${arguments.docId}\n${arguments.emotion.toJson().toString()}',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {Navigator.of(context).pop();},
        backgroundColor: Theme.of(context).errorColor,
        child: Icon(Icons.close),
      ),
    );
  }
}

class AddPageArguments {
  AddPageArguments({this.docId, this.emotion});
  final String docId;
  final Emotion emotion;
}