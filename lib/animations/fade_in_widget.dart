import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FadeInWidget extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const FadeInWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeIn,
  });

  @override
  Widget build(BuildContext context) {
    return child.animate().fade(duration: duration, curve: curve);
  }
}
