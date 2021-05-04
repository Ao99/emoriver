import 'package:flutter/material.dart';
import 'tabs/tabs.dart';
import '../widgets/rotatedTab.dart';
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
    final ThemeData theme = Theme.of(context);
    final bool isDesktop = isDisplayDesktop(context);
    final int quarterTurns = 1;
    final int revertQuarterTurns = 4 - quarterTurns;

    Widget tabBarView;
    if(isDesktop) {
      tabBarView = Row(
        children: [
          Container(
            // width: ,
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                SizedBox(height: 24),
                ExcludeSemantics(
                  child: SizedBox(
                    height: 80,
                    child: Icon(Icons.add),
                  ),
                ),
                SizedBox(height: 24),
                RotatedTabBar(
                  tabs: buildTabs(
                      tabController: _tabController,
                      theme: theme,
                      quarterTurns: revertQuarterTurns),
                  tabController: _tabController,
                  quarterTurns: quarterTurns,
                ),
              ],
            ),
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
    } else {
      tabBarView = Column(
        children: [
          Expanded(
            child: TabBarView(
              children: buildTabViews(),
              controller: _tabController,
            ),
          ),
          RotatedTabBar(
            tabs: buildTabs(tabController: _tabController, theme: theme),
            tabController: _tabController,
          ),
        ],
      );
    }
    return Scaffold(
      body: SafeArea(
        top: !isDesktop,
        bottom: !isDesktop,
        child: FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: tabBarView,
        ),
      ),
    );
  }
}