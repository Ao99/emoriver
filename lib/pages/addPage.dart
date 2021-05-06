import 'dart:math';
import 'package:flutter/material.dart';
import 'routes.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: "hero-add",
          child: Stack(
            children: [
              CustomPaint(
                painter: _RingPainter(
                  startAngle: 0,
                  color: Colors.yellowAccent,
                ),
              ),
              CustomPaint(
                painter: _RingPainter(
                  startAngle: pi / 4,
                  color: Colors.blueAccent,
                ),
              ),
              CustomPaint(
                painter: _RingPainter(
                  startAngle: pi / 2,
                  color: Colors.greenAccent,
                ),
              ),
              CustomPaint(
                painter: _RingPainter(
                  startAngle: pi * 3 / 4,
                  color: Colors.redAccent,
                ),
              ),
            ],
          )
        ),
      )
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({this.startAngle, this.color});
  final double startAngle;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawArc(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: 100,
        ),
        startAngle,
        pi / 4,
        true,
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}