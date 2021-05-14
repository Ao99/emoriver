import 'dart:ui';
import 'dart:math';
import 'package:emoriver/utils/randomString.dart';
import 'package:flutter/material.dart';

class RadialMenu extends StatelessWidget {
  RadialMenu({
    Key key,
    this.isOpen,
    this.toggle,
    this.animation,
    this.radius = 100,
    this.duration = const Duration(milliseconds: 500),
    this.children,
  }) : super(key: key);

  final bool isOpen;
  final Function toggle;
  final Animation<double> animation;
  final double radius;
  final Duration duration;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.center,
        children: [
          isOpen
            ? SizedBox.expand(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(color: Colors.transparent),
                ),
              )
            : SizedBox.shrink(),
          AnimatedSwitcher(
            duration: duration,
            child: isOpen
              ? AnimatedBuilder(
                  animation: animation,
                  builder: (context, widget) {
                    return SizedBox.expand(
                      child: Stack(
                          alignment: Alignment.center,
                          children: _buildExpandingButtons(context)
                      ),
                    );
                  },
                )
              : SizedBox.shrink(),
          ),
        ]
    );
  }

  List<Widget> _buildExpandingButtons(BuildContext context) {
    int count = children.length;
    double step = 2 * pi / count;
    double rad = count % 2 == 0 ? pi : -pi/2;
    double maxDistance = radius;
    int i = 0;
    List<Widget> buttons = children.map(
      (widget) => Transform.translate(
          offset: Offset.fromDirection(
              rad + (i++) * step,
              animation.value * maxDistance
          ),
          child: Transform.rotate(
            angle: 2 * pi * animation.value,
            child: widget,
          )
      )
    ).toList();

    buttons.add(Transform.scale(
      scale: animation.value,
      child: Transform.rotate(
        angle: 2 * pi * animation.value,
        child: FloatingActionButton(
          heroTag: 'fab-'+getRandString(5),
          onPressed: toggle,
          backgroundColor: Theme.of(context).errorColor,
          child: Icon(Icons.close),
        ),
      ),
    ));

    return buttons;
  }
}