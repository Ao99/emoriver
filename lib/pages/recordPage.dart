import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:location/location.dart';
import '../services/emotionService.dart';
import '../services/recordService.dart';
import '../models/emotion.dart';
import '../models/appUser.dart';
import '../models/record.dart';
import '../utils/adaptive.dart';
import '../utils/colors.dart';
import '../utils/location.dart';
import '../utils/showSnackBar.dart';
import '../widgets/crossFadeButton.dart';
import '../widgets/radialMenu.dart';

enum SavingStage {
  pre_saving,
  saving,
}

class RecordPageArguments {
  RecordPageArguments({this.record});
  final Record record;
}

class RecordPage extends StatefulWidget {
  RecordPage({Key key, this.userFuture}) : super(key: key);

  final Future<AppUser> userFuture;

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage>
    with TickerProviderStateMixin {
  Record record;
  Map<Emotion, double> emotionsToSave = Map();
  List<String> savedObjects;
  List<String> savedActivities;
  TextEditingController objectTextController;
  TextEditingController activityTextController;
  AnimationController radialMenuController;
  Animation<double> radialMenuAnimation;
  AnimationController buttonController;
  Animation<double> buttonAnimation;
  bool isRadialMenuOpen = false;
  SavingStage savingStage = SavingStage.pre_saving;

  @override
  void initState() {
    super.initState();
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
    final RecordPageArguments arguments =
    ModalRoute.of(context).settings.arguments as RecordPageArguments;
    record = arguments != null
      ? arguments.record
      : Record(
          userDocId: null,
          emotions: null,
          time: Timestamp.now(),
          location: null,
          objects: <String>[],
          activities: <String>[],
          updatedAt: <Timestamp>[],
        );

    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(title: Text('Add a new Emo record')),
        body: Stack(
          children: [
            _buildAddView(context),
            _buildRadialMenu(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: savingStage == SavingStage.pre_saving
            ? () => _saveRecord(record)
            : () {},
          child: savingStage == SavingStage.pre_saving
              ? Icon(Icons.save_outlined)
              : CircularProgressIndicator(),
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
    return Scrollbar(
      child: ListView(
        padding: EdgeInsets.all(8),
        children: [
          /*--- emotions ---*/
          Text('Emotions'),
          ..._buildEmotionSliders(),
          DottedBorder(
            color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.5),
            borderType: BorderType.RRect,
            radius: Radius.circular(8),
            padding: EdgeInsets.zero,
            strokeWidth: 3,
            dashPattern: [6,6],
            child: Container(
              height: 50,
              child: InkWell(
                onTap: toggleRadialMenu,
                child: SizedBox.expand(
                  child: Icon(Icons.add, size: 50),
                ),
              ),
            )),

          SizedBox(height: 50),

          Row(
            children: [
              /*--- time ---*/
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Text('Time'),
                    Container(
                      height: 50,
                      color: Colors.grey.shade700,
                      child: InkWell(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: record.time.toDate(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                          ).then((date) {
                            if(date == null) return;
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(record.time.toDate()),
                            ).then((time) {
                              if(time == null) return;
                              setState(() {
                                record.time = Timestamp.fromDate(
                                    DateTime(date.year,date.month,date.day,time.hour,time.minute)
                                );
                              });
                            });
                          });
                        },
                        child: Center(
                          child: Text(record.time.toDate().toIso8601String()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /*--- location ---*/
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Text('Location'),
                    FutureBuilder(
                        future: getLocation(),
                        builder: (BuildContext context, AsyncSnapshot<LocationData> snapshot) {
                          if(snapshot.hasData) {
                            record.location = GeoPoint(snapshot.data.latitude, snapshot.data.longitude);
                            return Container(
                              height: 50,
                              color: Colors.grey.shade700,
                              child: InkWell(
                                onTap: () {
                                },
                                child: Center(
                                  child: Text('${record.location.latitude}, '
                                      '${record.location.longitude}'),
                                ),
                              ),
                            );
                          }
                          if(snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          return Center(child: CircularProgressIndicator());
                        }
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 50),

          Row(
            children: [
              /*--- objects ---*/
              Flexible(
                flex: 1,
                child: Column(
                  children: _buildTextFieldWithChips('object'),
                ),
              ),

              /*--- activities ---*/
              Flexible(
                flex: 1,
                child: Column(
                  children: _buildTextFieldWithChips('activity'),
                ),
              ),
            ],
          ),

          SizedBox(height: 50),
        ],
      ),
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
              flex: 5,
              child: SizedBox.expand(child: Align(
                alignment: Alignment.centerRight,
                child: Text(e.key.negative),
              )),
            ),
            Flexible(
              flex: 15,
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
              flex: 5,
              child: SizedBox.expand(child: Align(
                alignment: Alignment.centerLeft,
                child: Text(e.key.positive),
              )),
            ),
            Flexible(
              flex: 2,
              child: SizedBox.expand(child: IconButton(
                alignment: Alignment.centerLeft,
                icon: Icon(Icons.remove_circle_outline),
                onPressed: () => setState(() => emotionsToSave.remove(e.key)),
              )),
            ),
          ],
        ),
      )).toList();
  }

  _buildTextFieldWithChips(String objectOrActivity) {
    List<String> toSave = objectOrActivity == 'object' ? record.objects : record.activities;
    List<String> saved = objectOrActivity == 'object' ? savedObjects : savedActivities;
    TextEditingController textController = objectOrActivity == 'object' ? objectTextController : activityTextController;
    String hint = objectOrActivity == 'object' ? 'person or object' : 'activity';

    return <Widget>[
      Wrap(
        children: toSave.map((str) =>
            InputChip(
              label: Text(str),
              onPressed: () {},
              onDeleted: () => setState(() => toSave.remove(str)),
            )).toList(),
      ),
      TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          controller: textController,
          onSubmitted: (text)  => setState(() {
            toSave.add(text);
            textController.clear();
          }),
          decoration: InputDecoration(
              hintText: 'Enter a related $hint',
              border: OutlineInputBorder()
          ),
        ),
        hideOnEmpty: true,
        suggestionsCallback: (pattern) async {
          if (saved == null) {
            AppUser user = await widget.userFuture;
            Map<String, dynamic> rawObjects = objectOrActivity == 'object'
              ? user.savedObjects
              : user.savedActivities;
            saved = rawObjects.keys.toList()..sort(
              (k1, k2) => rawObjects[k2].seconds - rawObjects[k1].seconds);
          }
          return pattern == ''
            ? saved.where((str) => !toSave.contains(str))
            : saved.where(
              (str) => !toSave.contains(str) && str.contains(pattern));
        },
        itemBuilder: (context, suggestion) => ListTile(title: Text(suggestion)),
        onSuggestionSelected: (suggestion)  => setState(() {
          toSave.add(suggestion);
          textController.clear();
        }),
      ),
      Text(toSave.toString()),
    ];
  }

  Widget _buildRadialMenu() => FutureBuilder(
    future: EmotionService.getAllEmotions(),
    builder: (BuildContext context, AsyncSnapshot<List<Emotion>> snapshot) {
      if(snapshot.hasData) {
        final children = snapshot.data.map(
          (e) => CrossFadeButton(
            onPressed: (){
              setState(() {
                emotionsToSave.putIfAbsent(e, () => 0);
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
        return Text(snapshot.error.toString());
      } else {
        return isRadialMenuOpen
          ? Center(child: CircularProgressIndicator())
          : SizedBox.shrink();
      }
    },
  );

  void _saveRecord(Record record) async {
    if(emotionsToSave.length == 0) {
      showSnackBar(context, 'Please add at least one emotion.', showDismiss: true);
      return;
    }

    AppUser user = await widget.userFuture;
    record.userDocId = user.docId;
    record.emotions = emotionsToSave.map(
      (key, value) => MapEntry(key.docId, value));
    record.updatedAt.add(Timestamp.now());

    setState(() => savingStage = SavingStage.saving);
    RecordService.addRecord(record)
      .then((_) {
        showSnackBar(context, 'Successfully saved a record.', showDismiss: false);
        Navigator.of(context).pop();
      })
      .catchError((error) {
        setState(() => savingStage = SavingStage.pre_saving);
        showSnackBar(context, error.toString(), showDismiss: true);
      });
  }
}
