import 'package:flutter/material.dart';
import 'tabs/tabs.dart';
import '../widgets/rotatedTab.dart';
import '../widgets/radialMenu.dart';
import '../widgets/crossFadeButton.dart';
import '../widgets/rowOrColumn.dart';
import '../utils/adaptive.dart';
import '../utils/routes.dart';
import '../utils/randomString.dart';
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
  AnimationController radialMenuController;
  Animation<double> radialMenuAnimation;
  AnimationController buttonController;
  Animation<double> buttonAnimation;
  RestorableInt tabIndex = RestorableInt(0);
  bool isRadialMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabsInfo.length)
      ..addListener(() {
        setState(() {
          tabIndex.value = _tabController.index;
        });
      });
    radialMenuController = AnimationController(
        duration: Duration(milliseconds: 500),
        vsync: this
    );
    radialMenuAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: radialMenuController,
    );
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
  String get restorationId => 'home_page';

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  toggleRadialMenu() {
    setState(() => isRadialMenuOpen = !isRadialMenuOpen);
    isRadialMenuOpen
      ? radialMenuController.forward()
      : radialMenuController.reverse();
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
            buildRadialMenu(
              isOpen: isRadialMenuOpen,
              toggle: toggleRadialMenu,
              menuAnimation: radialMenuAnimation,
              buttonAnimation: buttonAnimation,
            ),
          ]
        ),
        floatingActionButton: AnimatedCrossFade(
          firstChild: FloatingActionButton(
            heroTag: 'fab-'+getRandString(5),
            onPressed: toggleRadialMenu,
            backgroundColor: Theme.of(context).errorColor,
            child: Icon(Icons.close),
          ),
          secondChild: FloatingActionButton(
            heroTag: 'fab-'+getRandString(5),
            onPressed: toggleRadialMenu,
            child: Icon(Icons.add),
          ),
          crossFadeState: isRadialMenuOpen ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: Duration(milliseconds: 500),
          firstCurve: Curves.fastOutSlowIn,
          secondCurve: Curves.easeOutQuad,
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

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    radialMenuController.dispose();
    buttonController.dispose();
    super.dispose();
  }
}
