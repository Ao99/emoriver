import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/circleButton.dart';

class OverviewView extends StatelessWidget {
  final IconData tabIcon = Icons.date_range;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
        CircleButton(
          color: ThemeColors.happy,
          onTap: () {print('happy');},
          child: Text("Happy"),
        ),
      ),
    );
  }
}