import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedTap extends StatefulWidget {
  AnimatedTap({
    Key key,
    @required this.child,
    this.onReleased,
    this.onPressed,
    this.start = 0.0,
    this.end = 0.05,
    this.duration = const Duration(milliseconds: 90),
    this.giveHapticFeedback = true,
  }) : super(key: key);
  final Widget child;
  final Function(BuildContext) onReleased, onPressed;
  final double start, end;
  final Duration duration;
  final bool giveHapticFeedback;
  @override
  _AnimatedTapState createState() => _AnimatedTapState();
}

class _AnimatedTapState extends State<AnimatedTap> {
  double _end = 0;
  bool _cancelled = false;
  bool _released = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _released = false;
      _cancelled = false;
      _end = widget.end;
    });
    if (widget.onPressed != null) {
      widget.onPressed(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: widget.start, end: _end),
      duration: widget.duration,
      builder: (BuildContext context, double size, Widget child) {
        double _transformScale = 1 - size;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _onTapDown,
          onTapCancel: () => setState(() {
            _cancelled = true;
            _released = true;
            _end = 0;
          }),
          onTapUp: (_) => setState(() {
            _released = true;
            _end = size == widget.end ? 0 : _end;
          }),
          child: Transform.scale(
            scale: _transformScale,
            child: widget.child,
          ),
        );
      },
      child: widget.child,
      onEnd: () {
        // Animation is done and was not cancelled
        if (_end == 0 && !_cancelled) {
          if (widget.giveHapticFeedback) {
            HapticFeedback.lightImpact();
          }
          if (widget.onReleased != null) {
            widget.onReleased(context);
          }
        } else if (_end == widget.end && _released) {
          setState(() => _end = 0);
        }
      },
    );
  }
}
