import 'package:flutter/material.dart';

final tabCount = 3;

List<Widget> buildTabs(
  {BuildContext context, ThemeData theme, int quarterTurns = 0}) =>
  [
    Tab(icon: Icon(Icons.directions_car)),
    Tab(icon: Icon(Icons.directions_transit)),
    Tab(icon: Icon(Icons.directions_bike)),
  ];

List<Widget> buildTabViews() =>
  [
    Icon(Icons.directions_car),
    Icon(Icons.directions_transit),
    Icon(Icons.directions_bike),
  ];