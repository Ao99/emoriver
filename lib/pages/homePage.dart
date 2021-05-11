import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'tabs/tabs.dart';
import '../widgets/rotatedTab.dart';
import '../widgets/radialFab.dart';
import '../widgets/crossFadeButton.dart';
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
    final bool isDesktop = isDisplayDesktop(context);

    return Scaffold(
      body: SafeArea(
        top: !isDesktop,
        bottom: !isDesktop,
        child: Stack(
          children: [
            FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: _buildTabBarWithViews(isDesktop),
            ),
            _buildFab(),
          ]
        ),
      ),
    );
  }

  Widget _buildTabBarWithViews(bool isDesktop) {
    final int quarterTurns = isDesktop ? 1 : 0;
    final int revertQuarterTurns = isDesktop ? 4 - quarterTurns : 0;
    final double logoSize = isDesktop ? 80 : 50;

    return _RowOrColumn(
      isRow: isDesktop,
      children: [
        _RowOrColumn(
          isRow: !isDesktop,
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
        AsyncSnapshot<QuerySnapshot<Emotion>> snapshot) {
      if(snapshot.hasData) {
        final children = snapshot.data.docs.map(
          (doc) => CrossFadeButton(
            onPressed: (){
              Navigator.pushNamed(
                context,
                AppRoute.add,
                arguments: AddPageArguments(
                  docId: doc.id,
                  emotion: doc.data(),
                ),
              );
            },
            color: Color(doc.data().color),
            firstChild: doc.data().positive,
            secondChild: doc.data().negative,
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

class _RowOrColumn extends StatelessWidget {
  const _RowOrColumn({Key key, this.isRow, this.children}) : super(key: key);
  final bool isRow;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return isRow
      ? Row(children: children)
      : Column(children: children);
  }
}
