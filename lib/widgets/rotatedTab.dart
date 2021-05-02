import 'package:flutter/material.dart';

class RotatedTabBar extends StatelessWidget {
  RotatedTabBar({Key key, this.tabs, this.tabController, this.quarterTurns = 0}) : super(key: key);
  final List<Widget> tabs;
  final TabController tabController;
  final int quarterTurns;

  @override
  Widget build(BuildContext context) {
    final int revertQuarterTurns = 4 - quarterTurns;
    return RotatedBox(
      quarterTurns: quarterTurns,
      child: FocusTraversalOrder(
        order: NumericFocusOrder(0),
        child: TabBar(
          isScrollable: true,
          labelPadding: EdgeInsets.zero,
          tabs: tabs.map((tab) => RotatedBox(
            quarterTurns: revertQuarterTurns,
            child: tab,
          )).toList(),
          controller: tabController,
          indicatorColor: Colors.transparent,
        ),
      ),
    );
  }
}

class RotatedTabView extends StatelessWidget {
  RotatedTabView({Key key, this.tabViews, this.tabController, this.quarterTurns = 0}) : super(key: key);
  final List<Widget> tabViews;
  final TabController tabController;
  final int quarterTurns;

  @override
  Widget build(BuildContext context) {
    final int revertQuarterTurns = 4 - quarterTurns;
    return RotatedBox(
      quarterTurns: quarterTurns,
      child: TabBarView(
        children: tabViews.map((tabView) => RotatedBox(
          quarterTurns: revertQuarterTurns,
          child: tabView,
        )).toList(),
        controller: tabController,
      ),
    );
  }
}

class RotatedTab extends StatefulWidget {
  RotatedTab({
    ThemeData theme,
    IconData iconData,
    String title,
    int tabIndex,
    TabController tabController,
    int quarterTurns,
  }) : titleText = Text(title, style: theme.textTheme.button),
       isExpanded = tabController.index == tabIndex,
       icon = Icon(iconData, semanticLabel: title),
       isVertical = quarterTurns % 2 == 1;

  final Text titleText;
  final Icon icon;
  final bool isExpanded;
  final bool isVertical;

  @override
  _RotatedTabState createState() => _RotatedTabState();
}

class _RotatedTabState extends State<RotatedTab> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

