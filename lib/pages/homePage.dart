import 'package:flutter/material.dart';
import 'tabs/tabs.dart';
import '../widgets/rotatedTab.dart';
import '../widgets/radialFab.dart';
import '../widgets/crossFadeButton.dart';
import '../widgets/rowOrColumn.dart';
import '../utils/adaptive.dart';
import '../utils/routes.dart';
import '../services/emotionService.dart';
import '../models/emotion.dart';
import './addPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, RestorationMixin {
  TabController _tabController;
  AnimationController buttonController;
  Animation<double> buttonAnimation;
  RestorableInt tabIndex = RestorableInt(0);
  bool showBlur = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabsInfo.length)
      ..addListener(() {
        setState(() {
          tabIndex.value = _tabController.index;
        });
      });
    buttonController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    buttonAnimation = CurvedAnimation(
      parent: buttonController,
      curve: Curves.easeInOutQuart,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    buttonController.dispose();
    super.dispose();
  }

  @override
  String get restorationId => 'home_page';

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = isDisplayVertical(context);

    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        body: Stack(
          children: [
            FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: _buildTabBarWithViews(isPortrait),
            ),
            _buildFab(),
          ]
        ),
      ),
    );
  }

  Widget _buildTabBarWithViews(bool isVertical) {
    final int quarterTurns = isVertical ? 0 : 1;
    final int revertQuarterTurns = isVertical ? 0 : 4 - quarterTurns;
    final double logoSize = isVertical ? 50 : 50;

    return RowOrColumn(
      isRow: !isVertical,
      children: [
        RowOrColumn(
          isRow: isVertical,
          children: [
            SizedBox(
              width: logoSize,
              height: logoSize,
              child: Icon(Icons.android),
            ),
            RotatedTabBar(
              tabs: buildTabs(
                tabController: _tabController,
                quarterTurns: revertQuarterTurns,
                leftOrTopPadding: logoSize,
              ),
              tabController: _tabController,
              quarterTurns: quarterTurns,
            ),
          ],
        ),
        Expanded(
          child: RotatedBox(
            quarterTurns: quarterTurns,
            child: TabBarView(
              children: buildTabViews(quarterTurns: revertQuarterTurns),
              controller: _tabController,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFab() => FutureBuilder(
    future: EmotionService.getAllEmotions(),
    builder: (BuildContext context,
        AsyncSnapshot<List<Emotion>> snapshot) {
      if(snapshot.hasData) {
        final children = snapshot.data.map(
          (e) => CrossFadeButton(
            onPressed: (){
              Navigator.pushNamed(
                context,
                AppRoute.add,
                arguments: AddPageArguments(emotion: e),
              );
            },
            color: Color(e.color),
            firstChild: e.positive,
            secondChild: e.negative,
            animation: buttonAnimation,
          )
        ).toList();
        return RadialFab(
          radius: 120,
          icon: Icons.add,
          children: children,
        );
      } else if(snapshot.hasError) {
        return Container();
      } else {
        return Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}
