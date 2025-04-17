import 'package:flutter/material.dart';

class Blink extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const Blink({
    Key? key,
    required this.child,
    required this.duration,
  }) : super(key: key);

  @override
  BlinkState createState() => BlinkState();
}

class BlinkState extends State<Blink> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    final CurvedAnimation curve = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );

    animation = Tween<double>(begin: 1.0, end: 0.0).animate(curve);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: widget.child,
    );
  }
}
