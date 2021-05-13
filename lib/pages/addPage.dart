import 'package:emoriver/utils/colors.dart';
import 'package:flutter/material.dart';
import '../services/emotionService.dart';
import '../models/emotion.dart';
import '../utils/adaptive.dart';
import '../utils/routes.dart';
import '../widgets/crossFadeButton.dart';
import '../widgets/radialMenu.dart';

final Map<double, String> valueDict = {
  -3: 'Strong',
  -2: 'Moderate',
  -1: 'Mild',
  0: 'Slide to left or right',
  1: 'Mild',
  2: 'Moderate',
  3: 'Strong',
};

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage>
    with TickerProviderStateMixin {
  Map<Emotion, double> emotionsToSave = Map();
  AnimationController radialMenuController;
  Animation<double> radialMenuAnimation;
  AnimationController buttonController;
  Animation<double> buttonAnimation;
  bool isRadialMenuOpen = true;

  @override
  void initState() {
    super.initState();

    radialMenuController = AnimationController(
        duration: Duration(milliseconds: 500),
        vsync: this
    );
    radialMenuAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: radialMenuController,
    );
    radialMenuController.forward();
    buttonController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    buttonAnimation = CurvedAnimation(
      parent: buttonController,
      curve: Curves.easeInOutQuart,
    );
  }

  toggleRadialMenu() {
    setState(() => isRadialMenuOpen = !isRadialMenuOpen);
    isRadialMenuOpen
      ? radialMenuController.forward()
      : radialMenuController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDisplayVertical(context);

    return SafeArea(
      top: !isDesktop,
      bottom: !isDesktop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeColors.buttonColor,
        ),
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 64),
                  ...emotionsToSave.entries.map((e) => Container(
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
                                emotionsToSave.update(e.key, (value) => sliderValue);
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
                  Container(
                    height: 200,
                    // color: Colors.deepOrange,
                    child: InkWell(
                      onTap: toggleRadialMenu,


                    ),
                  ),
                  Text(emotionsToSave.toString()),
                ],
              ),
            ),
            buildRadialMenu(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {print('save');},
          child: Icon(Icons.save_outlined, size: 36),
        ),
      ),
    );
  }

  @override
  void dispose() {
    buttonController.dispose();
    radialMenuController.dispose();
    super.dispose();
  }

  Widget buildRadialMenu() => FutureBuilder(
    future: EmotionService.getAllEmotions(),
    builder: (BuildContext context,
        AsyncSnapshot<List<Emotion>> snapshot) {
      if(snapshot.hasData) {
        final children = snapshot.data.map(
          (e) => CrossFadeButton(
            onPressed: (){
              setState(() {
                emotionsToSave.putIfAbsent(e, () => 2);
              });
            },
            color: Color(e.color),
            firstChild: e.positive,
            secondChild: e.negative,
            animation: buttonAnimation,
          )
        ).toList();
        return RadialMenu(
          isOpen: isRadialMenuOpen,
          toggle: toggleRadialMenu,
          animation: radialMenuAnimation,
          radius: 120,
          children: children,
        );
      } else if(snapshot.hasError) {
        return Container();
      } else {
        return isRadialMenuOpen
            ? Center(child: CircularProgressIndicator())
            : Container();
      }
    },
  );
}
