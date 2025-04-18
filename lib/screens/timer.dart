import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../services/audio.dart';
import '../widgets/countdown.dart';
import '../screens/done.dart';

enum WorkoutPhase { prepare, work, rest }

class TimerScreen extends StatefulWidget {
  final WorkoutModel workout;

  TimerScreen(this.workout);

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int currentRound = 1;
  late WorkoutPhase activePhase;
  late Audio audio;

  @override
  void initState() {
    audio = Audio();

    activePhase = widget.workout.shouldPrepare()
        ? WorkoutPhase.prepare
        : WorkoutPhase.work;

    super.initState();
  }

  @override
  void dispose() {
    audio.dispose();
    super.dispose();
  }

  nextPhase() {
    if (activePhase == WorkoutPhase.work &&
        currentRound == widget.workout.numOfRounds) {
      audio.play(Audio.RING_BELL_3);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => DoneScreen(),
          ),
          (route) => route.isFirst);
      return;
    }

    switch (activePhase) {
      case WorkoutPhase.prepare:
        setState(() {
          activePhase = WorkoutPhase.work;
        });
        break;
      case WorkoutPhase.work:
        setState(() {
          if (widget.workout.shouldRest()) {
            activePhase = WorkoutPhase.rest;
          } else {
            currentRound++;
          }
        });
        break;
      case WorkoutPhase.rest:
        setState(() {
          currentRound++;
          activePhase = WorkoutPhase.work;
        });
        break;
    }
  }

  String _timeLeft() {
    final totalTimeInSeconds =
        (widget.workout.numOfRounds * widget.workout.roundLength.inSeconds) +
            ((widget.workout.numOfRounds - 1) *
                widget.workout.breakLength.inSeconds) +
            widget.workout.preparationLength.inSeconds;
    final totalDuration = Duration(seconds: totalTimeInSeconds);

    String min = totalDuration.inMinutes.remainder(60).toString();
    String sec =
        totalDuration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  @override
  Widget build(BuildContext context) {
    if (activePhase == WorkoutPhase.prepare) {
      return AnimatedCountdown(
        key: UniqueKey(),
        duration: widget.workout.preparationLength,
        title: 'Get ready',
        subtitle: '',
        color: Colors.amber,
        onComplete: () {
          audio.play(Audio.RING_BELL_1);
          this.nextPhase();
        },
      );
    }

    if (activePhase == WorkoutPhase.work) {
      return AnimatedCountdown(
        key: UniqueKey(),
        duration: widget.workout.roundLength,
        title: 'Work it',
        subtitle: "Round $currentRound of ${widget.workout.numOfRounds}",
        color: Colors.blue,
        onComplete: () {
          audio.play(Audio.RING_BELL_2);
          this.nextPhase();
        },
      );
    }

    if (activePhase == WorkoutPhase.rest) {
      return AnimatedCountdown(
        key: UniqueKey(),
        duration: widget.workout.breakLength,
        title: 'Rest',
        subtitle: "Time left ${_timeLeft()}",
        color: Colors.green,
        onComplete: () {
          audio.play(Audio.RING_BELL_1);
          this.nextPhase();
        },
      );
    }

    return Center();
  }
}
