import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  CircleButton({
    Key key,
    this.size = 80,
    this.color,
    this.onTap,
    this.child
  }) : super(key: key);

  final double size;
  final Color color;
  final Function onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 8.0,
      fillColor: color,
      onPressed: onTap,
      child: child,
      padding: EdgeInsets.all(15.0),
      shape: CircleBorder(),
      constraints: BoxConstraints.tightFor(width: size, height: size),
    );
  }
}
