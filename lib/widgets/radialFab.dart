import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math';

class RadialFab extends StatefulWidget {
  RadialFab({
    Key key,
    this.radius = 100,
    this.padding = 16,
    this.alignment = Alignment.bottomRight,
    this.icon = Icons.menu,
    this.children,
  }) : super(key: key);

  final double radius;
  final double padding;
  final Alignment alignment;
  final IconData icon;
  final List<Widget> children;

  createState() => _RadialFabState();
}

class _RadialFabState extends State<RadialFab>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> expandAnimation;
  bool open;

  @override
  void initState() {
    super.initState();
    open = false;
    controller = AnimationController(
        duration: Duration(milliseconds: 500),
        vsync: this
    );
    expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
        children: [
          open
            ? SizedBox.expand(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(color: Colors.transparent),
                ),
              )
            : Container(),
          AnimatedBuilder(
            animation: expandAnimation,
            builder: (context, widget) {
              return Transform.scale(
                scale: expandAnimation.value,
                child: Transform.rotate(
                  angle: 2 * pi * expandAnimation.value,
                  child: SizedBox.expand(
                    child: Stack(
                        alignment: Alignment.center,
                        children: _buildExpandingButtons()
                    ),
                  ),
                )
              );
            }
          ),
          Container(
            padding: EdgeInsets.all(widget.padding),
            alignment: widget.alignment,
            child: AnimatedCrossFade(
              firstChild: FloatingActionButton(
                onPressed: _toggle,
                backgroundColor: Theme.of(context).accentColor,
                child: Icon(Icons.close),
              ),
              secondChild: FloatingActionButton(
                onPressed: _toggle,
                child: Icon(widget.icon),
              ),
              crossFadeState: open ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 250)
            ),
          )
    ]
    );
  }

  _toggle() {
    setState(() => open = !open);
    open
      ? controller.forward()
      : controller.reverse();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<Widget> _buildExpandingButtons() {
    int count = widget.children.length;
    double step = 2 * pi / count;
    double rad = count % 2 == 0 ? pi : -pi/2;
    double maxDistance = widget.radius;
    return widget.children.map(
      (widget) {
        Widget res = Transform.translate(
          offset: Offset.fromDirection(
            rad,
            expandAnimation.value * maxDistance
          ),
          child: widget,
        );
        rad += step;
        return res;
      }
    ).toList();
  }
}