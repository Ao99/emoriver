import 'package:flutter/material.dart';
import 'tabs/tabs.dart';
import '../widgets/rotatedTab.dart';
import '../widgets/rowOrColumn.dart';
import '../utils/adaptive.dart';
import '../utils/routes.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, RestorationMixin {
  TabController _tabController;
  RestorableInt tabIndex = RestorableInt(0);

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
        body: FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: _buildTabBarWithViews(isPortrait),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){Navigator.of(context).pushNamed(AppRoute.add);},
          child: Icon(Icons.add),
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
    super.dispose();
  }
}
