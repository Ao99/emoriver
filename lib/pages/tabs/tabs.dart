import 'package:emoriver/widgets/rotatedTab.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'overviewView.dart';
import 'interactionsView.dart';
import 'locationsView.dart';
import 'settingsView.dart';

final List<Tuple2> tabsInfo =
[
  Tuple2<IconData, String>(Icons.date_range, 'Overview'),
  Tuple2<IconData, String>(Icons.people_alt, 'Interactions'),
  Tuple2<IconData, String>(Icons.location_on, 'Locations'),
  Tuple2<IconData, String>(Icons.settings, 'Settings'),
];

final tabViews =
[
  OverviewView(),
  InteractionsView(),
  LocationsView(),
  SettingsView(),
];

List<Widget> buildTabs(
  {TabController tabController, ThemeData theme, int quarterTurns = 0}) =>
    tabsInfo.asMap().entries.map((e) =>
      RotatedTab(
        theme: theme,
        iconData: e.value.item1,
        title: e.value.item2,
        tabIndex: e.key,
        tabCount: tabsInfo.length,
        tabController: tabController,
        quarterTurns: quarterTurns,
    )).toList();

List<Widget> buildTabViews({int quarterTurns = 0}) =>
  tabViews.map((view) =>
    RotatedBox(
      quarterTurns: quarterTurns,
      child: view,
    )
  ).toList();