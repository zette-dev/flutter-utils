import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedCardNavigator extends StatefulWidget {
  AnimatedCardNavigator({
    this.child,
    this.onNavigate,
    this.lowerBound = 0.0,
    this.upperBound = 0.05,
    this.duration = const Duration(milliseconds: 200),
    this.giveHapticFeedback = true,
  });
  final Widget child;
  final VoidCallback onNavigate;
  final double lowerBound, upperBound;
  final Duration duration;
  final bool giveHapticFeedback;
  @override
  _AnimatedCardNavigatorState createState() => _AnimatedCardNavigatorState();
}

class _AnimatedCardNavigatorState extends State<AnimatedCardNavigator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      lowerBound: widget.lowerBound,
      upperBound: widget.upperBound,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) async {
    await _controller.reverse().then((value) {
      if (widget.giveHapticFeedback) {
        HapticFeedback.lightImpact();
      }
      widget.onNavigate();
    });
  }

  double get _transformScale => 1 - _controller.value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => _controller.reverse(),
      child: Transform.scale(
        scale: _transformScale,
        child: widget.child,
      ),
    );
  }
}
