import 'package:emoriver/widgets/rotatedTab.dart';
import 'package:flutter/material.dart';

final tabCount = 4;

List<Widget> buildTabs(
  {TabController tabController, ThemeData theme, int quarterTurns = 0}) =>
  [
    RotatedTab(
      theme: theme,
      iconData: Icons.date_range,
      title: 'Records',
      tabIndex: 0,
      tabCount: tabCount,
      tabController: tabController,
      quarterTurns: quarterTurns,
    ),
    RotatedTab(
      theme: theme,
      iconData: Icons.location_on,
      title: 'Locations',
      tabIndex: 1,
      tabCount: tabCount,
      tabController: tabController,
      quarterTurns: quarterTurns,
    ),
    RotatedTab(
      theme: theme,
      iconData: Icons.people_alt,
      title: 'Interactions',
      tabIndex: 2,
      tabCount: tabCount,
      tabController: tabController,
      quarterTurns: quarterTurns,
    ),
    RotatedTab(
      theme: theme,
      iconData: Icons.settings,
      title: 'Settings',
      tabIndex: 3,
      tabCount: tabCount,
      tabController: tabController,
      quarterTurns: quarterTurns,
    ),
  ];

List<Widget> buildTabViews({int quarterTurns = 0}) =>
  [
    Icon(Icons.directions_car),
    Icon(Icons.directions_transit),
    Icon(Icons.directions_bike),
    Icon(Icons.directions_bike),
  ].map((tabView) =>
    RotatedBox(
      quarterTurns: quarterTurns,
      child: tabView,
    )
  ).toList();