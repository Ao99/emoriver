import 'package:adaptive_breakpoints/adaptive_breakpoints.dart';
import 'package:flutter/material.dart';

bool isDisplayVertical(BuildContext context) =>
  getWindowType(context) < AdaptiveWindowType.medium &&
  MediaQuery.of(context).orientation == Orientation.portrait;
