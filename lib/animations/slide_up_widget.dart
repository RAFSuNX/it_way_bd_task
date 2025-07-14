import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SlideUpWidget extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double offsetY;

  const SlideUpWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 450),
    this.curve = Curves.easeOut,
    this.offsetY = 0.15,
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .slide(
          begin: Offset(0, offsetY),
          end: Offset.zero,
          curve: curve,
          duration: duration,
        )
        .fadeIn(curve: curve, duration: duration);
  }
}
