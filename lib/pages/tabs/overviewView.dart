import 'package:flutter/material.dart';
import '../routes.dart';

class OverviewView extends StatelessWidget {
  final IconData tabIcon = Icons.date_range;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Icon(tabIcon)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .restorablePushNamed(AppRoute.add),
        heroTag: 'hero-add',
        child: Icon(Icons.add),
      ),
    );
  }
}