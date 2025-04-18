import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../widgets/stopwatch_button.dart';

class AnimatedCountdown extends StatefulWidget {
  final Duration duration;
  final VoidCallback onComplete;
  final String title;
  final String subtitle;
  final Color color;

  const AnimatedCountdown({
    Key? key,
    required this.duration,
    required this.onComplete,
    required this.title,
    required this.subtitle,
    required this.color,
  }) : super(key: key);

  @override
  _AnimatedCountdownState createState() => _AnimatedCountdownState();
}

class _AnimatedCountdownState extends State<AnimatedCountdown>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  bool isRunning = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _controller.addStatusListener(statusListener);
    _controller.forward();
  }

  void statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onComplete();
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(statusListener);
    _controller.dispose();
    super.dispose();
  }

  void onPause() {
    if (_controller.isAnimating) {
      _controller.stop(canceled: false);
      setState(() => isRunning = false);
    } else {
      _controller.forward();
      setState(() => isRunning = true);
    }
  }

  void onReset() {
    _controller.reset();
    setState(() => isRunning = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subtitle, style: const TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 56),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 40),
                  child: Countdown(
                    duration: widget.duration,
                    animation: StepTween(
                      begin: widget.duration.inMilliseconds,
                      end: 0,
                    ).animate(_controller),
                    color: widget.color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 140,
                          height: 40,
                          child: StopwatchButton(
                            icon: isRunning ? Icons.pause : Icons.play_arrow,
                            label: isRunning ? 'PAUSE' : 'RESUME',
                            onPressed: onPause,
                          ),
                        ),
                        const SizedBox(width: 24.0),
                        SizedBox(
                          width: 140,
                          height: 40,
                          child: StopwatchButton(
                            icon: Icons.restore,
                            label: 'RESET',
                            onPressed: onReset,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Countdown extends AnimatedWidget {
  final Duration duration;
  final Animation<int> animation;
  final Color color;

  const Countdown({
    Key? key,
    required this.duration,
    required this.animation,
    required this.color,
  }) : super(key: key, listenable: animation);

  String _timerText() {
    Duration clockTimer = Duration(milliseconds: animation.value);
    String min = clockTimer.inMinutes.remainder(60).toString();
    String sec = clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double circleRadius = screenWidth > 600 ? 300 : screenWidth * 0.8;
    final double fontSize = screenWidth > 600 ? 80 : 48;

    return Center(
      child: CircularPercentIndicator(
        radius: circleRadius,
        animation: true,
        animateFromLastPercent: true,
        addAutomaticKeepAlive: false,
        lineWidth: 20.0,
        percent:
            (duration.inMilliseconds - animation.value) / duration.inMilliseconds,
        center: Text(
          _timerText(),
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: fontSize),
        ),
        backgroundColor: Colors.grey[300]!,
        circularStrokeCap: CircularStrokeCap.round,
        linearGradient: LinearGradient(
          colors: [const Color.fromRGBO(190, 130, 255, 1.0), color],
        ),
      ),
    );
  }
}
