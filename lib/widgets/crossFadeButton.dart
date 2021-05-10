import 'package:flutter/material.dart';

class CrossFadeButton extends StatefulWidget {
  CrossFadeButton({
    Key key,
    this.size = 100,
    this.elevation = 8,
    this.padding = 12,
    this.color,
    this.onPressed,
    this.firstChild = '',
    this.secondChild = '',
  }) : super(key: key);

  final double size;
  final double elevation;
  final double padding;
  final Color color;
  final Function onPressed;
  final String firstChild;
  final String secondChild;

  @override
  _CrossFadeButtonState createState() => _CrossFadeButtonState();
}

class _CrossFadeButtonState extends State<CrossFadeButton>
  with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation<double> curveAnimation;
  Animation<Color> topColorAnimation;
  Animation<Color> bottomColorAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    curveAnimation = CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOutQuad
    );
    topColorAnimation = ColorTween(
      begin: widget.color,
      end: Colors.grey.shade400,
    ).animate(curveAnimation);
    bottomColorAnimation = ColorTween(
      begin: Colors.grey.shade800,
      end: widget.color,
    ).animate(curveAnimation);
  }

  @override
  Widget build(BuildContext context) {
    double elevation = widget.elevation;
    Function onPressed = widget.onPressed;
    String firstChild = widget.firstChild;
    String secondChild = widget.secondChild;
    double padding = widget.padding;
    double size = widget.size;

    return AnimatedBuilder(
      animation: curveAnimation,
      builder: (context, widget) => Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomCenter,
              colors: [
                topColorAnimation.value,
                bottomColorAnimation.value,
              ],
            )
        ),
        child: RawMaterialButton(
          elevation: elevation,
          // fillColor: color,
          onPressed: onPressed,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                firstChild,
                // textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(curveAnimation.value),
                ),
              ),
              Text(
                secondChild,
                // textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(1-curveAnimation.value),
                ),
              ),
            ],
          ),
          padding: EdgeInsets.all(padding),
          shape: CircleBorder(),
          constraints: BoxConstraints.tightFor(width: size, height: size),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

