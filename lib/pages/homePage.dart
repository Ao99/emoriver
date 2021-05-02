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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabCount);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = isDisplayDesktop(context);
    
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
                      context: context, theme: theme, quarterTurns: 1),
                  tabController: _tabController,
                  quarterTurns: 1,
                ),
              ],
            ),
          ),
          Expanded(
            child: RotatedTabView(
              tabViews: buildTabViews(),
              tabController: _tabController,
              quarterTurns: 1,
            ),
          ),
        ],
      );
    } else {
      tabBarView = Column(
        children: [
          Expanded(
            child: RotatedTabView(
              tabViews: buildTabViews(),
              tabController: _tabController,
            ),
          ),
          RotatedTabBar(
            tabs: buildTabs(context: context, theme: theme),
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
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}