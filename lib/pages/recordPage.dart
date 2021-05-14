import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import '../services/emotionService.dart';
import '../models/emotion.dart';
import '../models/user.dart';
import '../services/userService.dart';
import '../utils/adaptive.dart';
import '../utils/colors.dart';
import '../utils/location.dart';
import '../widgets/crossFadeButton.dart';
import '../widgets/radialMenu.dart';

class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage>
    with TickerProviderStateMixin {
  Map<Emotion, double> emotionsToSave = Map();
  Timestamp timeToSave = Timestamp.now();
  GeoPoint locationToSave;
  Set<String> objectsToSave = HashSet();
  Set<String> activitiesToSave = HashSet();
  Set<String> savedObjects;
  Set<String> savedActivities;
  int numSavedDataToShow = 3;
  Future<User> userFuture;
  TextEditingController objectTextController;
  TextEditingController activityTextController;
  AnimationController radialMenuController;
  Animation<double> radialMenuAnimation;
  AnimationController buttonController;
  Animation<double> buttonAnimation;
  bool isRadialMenuOpen = true;

  @override
  void initState() {
    super.initState();
    userFuture = UserService.getUserByDocId('9t9D2s4i32rk0zsrWf4A');
    objectTextController = TextEditingController();
    activityTextController = TextEditingController();
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
    final bool isPortrait = isDisplayPortrait(context);

    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(title: Text('Record My Emo')),
        body: Stack(
          children: [
            _buildAddView(context),
            _buildRadialMenu(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {print('save');},
          child: Icon(Icons.save_outlined),
        ),
      ),
    );
  }

  @override
  void dispose() {
    objectTextController.dispose();
    buttonController.dispose();
    radialMenuController.dispose();
    super.dispose();
  }

  Widget _buildAddView(BuildContext context) {
    final List<Widget> emotionSliders = _buildEmotionSliders();

    return ListView(
      children: [
        /*--- emotions ---*/
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: min(emotionsToSave.length.toDouble() * 50 + 15, 180),
          child: Scrollbar(
            child: ListView(
              padding: EdgeInsets.all(8),
              children: emotionSliders,
            ),
          ),
        ),
        Container(
          height: 50,
          color: Theme.of(context).buttonColor,
          child: InkWell(
            onTap: toggleRadialMenu,
            child: SizedBox.expand(
              child: Icon(Icons.add, size: 50),
            ),
          ),
        ),

        /*--- time ---*/
        Text(timeToSave.toDate().toString()),
        Container(
          height: 50,
          color: Colors.grey.shade700,
          child: InkWell(
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: timeToSave.toDate(),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              ).then((date) {
                if(date == null) return;
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(timeToSave.toDate()),
                ).then((time) {
                  if(time == null) return;
                  setState(() {
                    timeToSave = Timestamp.fromDate(
                        DateTime(date.year,date.month,date.day,time.hour,time.minute)
                    );
                  });
                });
              });
            },
            child: SizedBox.expand(
              child: Icon(Icons.add, size: 50),
            ),
          ),
        ),

        /*--- location ---*/
        FutureBuilder(
            future: getLocation(),
            builder: (BuildContext context, AsyncSnapshot<LocationData> snapshot) {
              if(snapshot.hasData) {
                locationToSave = GeoPoint(snapshot.data.latitude, snapshot.data.longitude);
                return Text('${locationToSave.latitude}-${locationToSave.longitude}');
              }
              if(snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            }
        ),

        /*--- objects ---*/
        ..._buildTextFieldWithChips(
          toSave: objectsToSave,
          saved: savedObjects,
          textController: objectTextController,
          hint: 'person or object'
        ),

        /*--- activities ---*/
        ..._buildTextFieldWithChips(
            toSave: activitiesToSave,
            saved: savedActivities,
            textController: activityTextController,
            hint: 'activity'
        ),
      ],
    );
  }

  List<Widget> _buildEmotionSliders() {
    final Map<double, String> valueDict = {
      -3: 'Strong',
      -2: 'Moderate',
      -1: 'Mild',
      0: 'Slide to left or right',
      1: 'Mild',
      2: 'Moderate',
      3: 'Strong',
    };
    return emotionsToSave.entries.map((e) =>
      Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: ThemeColors.primaryColor),
            bottom: BorderSide(color: ThemeColors.primaryColor),
            left: BorderSide(color: ThemeColors.primaryColor),
            right: BorderSide(color: ThemeColors.primaryColor),
          ),
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.topRight,
            stops: [0.2, 1],
            colors: [Colors.grey.shade800, Color(e.key.color)],
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: SizedBox.expand(child: Align(
                alignment: Alignment.centerRight,
                child: Text(e.key.negative),
              )),
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
                      ? ' ' + e.key.positive
                      : ' ' + e.key.negative),
                onChanged: (double sliderValue) {
                  setState(() =>
                      emotionsToSave.update(e.key, (value) => sliderValue)
                  );
                },
              ),
            ),
            Flexible(
              flex: 2,
              child: SizedBox.expand(child: Align(
                alignment: Alignment.centerLeft,
                child: Text(e.key.positive),
              )),
            ),
          ],
        ),
      )).toList();
  }

  Future<void> _prepareSavedData() async {
    User user = await userFuture;
    if(savedObjects == null) {
      Map<String,dynamic> rawObjects = user.savedObjects;
      List<String> keys = rawObjects.keys.toList()
        ..sort((k1, k2) => rawObjects[k1].seconds - rawObjects[k2].seconds)
        ..sublist(0,min(numSavedDataToShow, rawObjects.length));
      setState(() => savedObjects = keys.toSet());
    }
    if(savedActivities == null) {
      Map<String,dynamic> rawActivities = user.savedActivities;
      List<String> keys = rawActivities.keys.toList()
        ..sort((k1, k2) => rawActivities[k1].seconds - rawActivities[k2].seconds)
        ..sublist(0,min(numSavedDataToShow, rawActivities.length));
      setState(() => savedActivities = keys.toSet());
    }
  }

  Widget _buildRadialMenu() => FutureBuilder(
    future: EmotionService.getAllEmotions(),
    builder: (BuildContext context, AsyncSnapshot<List<Emotion>> snapshot) {
      if(snapshot.hasData) {
        final children = snapshot.data.map(
          (e) => CrossFadeButton(
            onPressed: (){
              setState(() {
                emotionsToSave.putIfAbsent(e, () => 2);
                toggleRadialMenu();
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
        return SizedBox.shrink();
      } else {
        return isRadialMenuOpen
          ? Center(child: CircularProgressIndicator())
          : SizedBox.shrink();
      }
    },
  );

  _buildTextFieldWithChips({
    Set<String> toSave,
    Set<String> saved,
    TextEditingController textController,
    String hint
  }) => <Widget>[
    Wrap(
      children: toSave.map((str) => InputChip(
        label: Text(str),
        onPressed: () {},
        onDeleted: () => setState(() => toSave.remove(str)),
      )).toList(),
    ),
    TextField(
      controller: textController,
      onSubmitted: (text) {
        setState(() {
          toSave.add(text);
          textController.clear();
        });
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter a related $hint',
        suffixIcon: IconButton(
          color: Theme.of(context).errorColor,
          onPressed: textController.clear,
          icon: Icon(Icons.clear),
        ),
      ),
    ),
    FutureBuilder(
      future: _prepareSavedData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return Wrap(
              children: [
                Text('Suggestions: '),
                ...saved
                  .where((str) => !toSave.contains(str))
                  .map((str) => InputChip(
                    selectedColor: Theme.of(context).buttonColor,
                    label: Text(str),
                    onPressed: () => setState(() => toSave.add(str)),
                  )).toList(),
              ]
          );
        }
        if(snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    ),
    Text(toSave.toString()),
  ];
}
