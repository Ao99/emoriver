import 'package:flutter/material.dart';
import 'tabs/tabs.dart';
import '../utils/colors.dart';
import '../widgets/rotatedTab.dart';
import '../widgets/expandableFab.dart';
import '../widgets/circleButton.dart';
import '../utils/adaptive.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, RestorationMixin {
  TabController _tabController;
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  String get restorationId => "home_page";

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, "tab_index");
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
            ExpandableFab(
              radius: 100,
              icon: Icon(Icons.add),
              children: _buildFabChildren(),
            ),
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

  _buildFabChildren() {
    return [
      CircleButton(
        color: ThemeColors.happy,
        onTap: () {
          print("happy");
        },
        child: Text("happy"),
      ),
      CircleButton(
        color: ThemeColors.sad,
        onTap: () {
          print("sad");
        },
        child: Text("sad"),
      ),
      CircleButton(
        color: ThemeColors.calm,
        onTap: () {
          print("calm");
        },
        child: Text("calm"),
      ),
      CircleButton(
        color: ThemeColors.angry,
        onTap: () {
          print("angry");
        },
        child: Text("angry"),
      ),
      CircleButton(
        color: ThemeColors.intrigued,
        onTap: () {
          print("intrigued");
        },
        child: Text("intrigued"),
      ),
      CircleButton(
        color: ThemeColors.bored,
        onTap: () {
          print("bored");
        },
        child: Text("bored"),
      ),
    ];
  }
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
