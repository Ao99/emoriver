import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key key,
    this.initialOpen = false,
    this.radius,
    this.icon = const Icon(Icons.menu),
    this.children,
  }) : super(key: key);

  final bool initialOpen;
  final double radius;
  final Icon icon;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin{
  bool _open;
  AnimationController _controller;
  Animation<double> _expandAnimation;
  Widget _button;
  Widget _actionButtons;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen;
    _button = _open ? _buildCloseButton() : _buildOpenButton();
    _actionButtons = _open ? _buildExpandingActionButtons() : Container();
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }


  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
        _button = _buildCloseButton();
        _actionButtons = _buildExpandingActionButtons();
      } else {
        _controller.reverse();
        _button = _buildOpenButton();
        _actionButtons = Container();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      clipBehavior: Clip.none,
      children: [
        _open
          ? SizedBox.expand(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(color: Colors.transparent),
              ),
            )
          : Container(),
        // ..._buildExpandingActionButtons(),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 250),
          child: _actionButtons,
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 250),
          child: Container(
            padding: EdgeInsets.all(16),
            child: _button,
          ),
        ),
      ],
    );
  }

  Widget _buildCloseButton() {
    return FloatingActionButton(
      onPressed: _toggle,
      backgroundColor: Theme.of(context).accentColor,
      child: Icon(Icons.close),
    );
  }

  Widget _buildOpenButton() {
    return FloatingActionButton(
      onPressed: _toggle,
      child: widget.icon,
    );
  }

  Widget _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 2 * pi / count;
    for (var i = 0, angle = 0.0; i < count; i++, angle += step) {
      children.add(
        _ExpandingActionButton(
          direction: angle,
          maxDistance: widget.radius,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return Stack(children: children, alignment: Alignment.bottomRight,);
  }
}

class _ExpandingActionButton extends StatelessWidget {
  _ExpandingActionButton({
    Key key,
    this.direction,
    this.maxDistance,
    this.progress,
    this.child,
  }) : super(key: key);

  final double direction;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: progress,
      builder: (BuildContext context, Widget child) {
        final offset = Offset.fromDirection(
          direction,
          progress.value * maxDistance,
        );
        return Positioned(
          right: screenSize.width * 0.4 + offset.dx,
          bottom: screenSize.height * 0.4 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * pi,
            child: child,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}
