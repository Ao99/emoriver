import 'package:flutter/material.dart';
import '../models/emotion.dart';
import '../utils/adaptive.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final Map<double, String> valueDict = {
    -3: 'Strong',
    -2: 'Moderate',
    -1: 'Mild',
    0: 'Slide left or right',
    1: 'Mild',
    2: 'Moderate',
    3: 'Strong',
  };
  Map<Emotion, double> emotionStrengths = Map();

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDisplayVertical(context);
    final AddPageArguments arguments =
        ModalRoute.of(context).settings.arguments as AddPageArguments;
    if(arguments != null) emotionStrengths.putIfAbsent(arguments.emotion, () => 2);

    return SafeArea(
      top: !isDesktop,
      bottom: !isDesktop,
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 64),
              ...emotionStrengths.entries.map((e) => Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Text(e.key.negative),
                    ),
                    Flexible(
                      flex: 6,
                      child: Slider(
                        value: e.value,
                        min: -3,
                        max: 3,
                        divisions: 6,
                        label: valueDict[e.value] +
                          (e.value == 0
                            ? ''
                            : e.value > 0
                              ? ' '+e.key.positive
                              : ' '+e.key.negative),
                        onChanged: (double sliderValue) {
                          setState(() {
                            emotionStrengths.update(e.key, (value) => sliderValue);
                          });
                        },
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(e.key.positive),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.topRight,
                      stops: [0.2,1],
                      colors: [Colors.grey.shade800, Color(e.key.color)],
                    )
                ),
              )).toList(),
              // FloatingActionButton(onPressed: onPressed),
              Text(emotionStrengths.toString()),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {Navigator.of(context).pop();},
          backgroundColor: Theme.of(context).errorColor,
          child: Icon(Icons.close),
        ),
      ),
    );
  }
}

class AddPageArguments {
  AddPageArguments({this.emotion});
  final Emotion emotion;
}