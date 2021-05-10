import 'dart:math';
import 'package:flutter/material.dart';

class CrossFadeButton extends StatefulWidget {
  CrossFadeButton({
    Key key,
    this.size = 100,
    this.elevation = 8,
    this.padding = 12,
    this.duration = const Duration(seconds: 3),
    this.color,
    this.onPressed,
    this.firstChild = '',
    this.secondChild = '',
    this.animation,
  }) : super(key: key);

  final double size;
  final double elevation;
  final double padding;
  final Duration duration;
  final Color color;
  final Function onPressed;
  final String firstChild;
  final String secondChild;
  final Animation<double> animation;

  @override
  _CrossFadeButtonState createState() => _CrossFadeButtonState();
}

class _CrossFadeButtonState extends State<CrossFadeButton> {
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animation = widget.animation;
  }

  @override
  Widget build(BuildContext context) {
    double elevation = widget.elevation;
    Function onPressed = widget.onPressed;
    String firstChild = widget.firstChild;
    String secondChild = widget.secondChild;
    double padding = widget.padding;
    double size = widget.size;
    Color color = widget.color;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, widget) => Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..rotateY(pi * animation.value),
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomCenter,
                colors: animation.value<0.5
                  ? [Colors.grey.shade400, color]
                  : [color, Colors.grey.shade800],
              )
          ),
          child: RawMaterialButton(
            elevation: elevation,
            // fillColor: color,
            onPressed: onPressed,
            child: Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.identity()
                ..rotateY(pi * animation.value),
              child: Text(
                animation.value<0.5 ? firstChild : secondChild,
                textAlign: TextAlign.center,
              ),
            ),
            padding: EdgeInsets.all(padding),
            shape: CircleBorder(),
            constraints: BoxConstraints.tightFor(width: size, height: size),
          ),
        ),
      ),
    );
  }
}

