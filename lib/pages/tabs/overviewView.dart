import 'package:flutter/material.dart';

class OverviewView extends StatelessWidget {
  final IconData tabIcon = Icons.date_range;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(tabIcon),
      ),
    );
  }
}