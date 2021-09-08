import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class ShakeView extends StatelessWidget {
  final Widget child;
  final ShakeController controller;
  final Animation _anim;

  ShakeView(
      {required this.child,
      required this.controller,
      double begin = 50,
      double end = 150})
      : _anim = Tween<double>(begin: begin, end: end).animate(controller);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: child,
      builder: (context, child) => Transform(
        child: child,
        transform: Matrix4.translation(_shake(_anim.value)),
      ),
    );
  }

  Vector3 _shake(double progress) {
    double offset = sin(progress * pi * 10.0);
    return Vector3(offset * 4, 0.0, 0.0);
  }
}

class ShakeController extends AnimationController {
  ShakeController({
    required TickerProvider vsync,
    Duration duration = const Duration(milliseconds: 10000),
  }) : super(vsync: vsync, duration: duration);

  Future shake() async {
    if (status == AnimationStatus.completed) {
      return await this.reverse();
    } else {
      return await this.forward();
    }
  }
}
