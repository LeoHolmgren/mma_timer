import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

import 'models/workout.dart';
import 'screens/timer.dart';
import 'widgets/filled_button.dart' as custom;
import 'widgets/blink.dart';

void main() {
  runApp(BoxingTimer());
}

class BoxingTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boxing Timer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        primaryColor: const Color.fromRGBO(22, 100, 253, 1),
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<int> _characterCount;
  String _currentString = 'Minimalist Boxing Timer';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _characterCount = StepTween(begin: 0, end: _currentString.length).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();

    Timer(
      const Duration(seconds: 4),
      () => Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, _, __) => TimerSettings(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: Colors.black,
      decoration: TextDecoration.none,
    );

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _characterCount,
            builder: (context, child) {
              String text = _currentString.substring(0, _characterCount.value);
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(text, style: textStyle),
                  Blink(
                    child: Text(
                      '_',
                      style: textStyle.apply(color: const Color(0xFF007AFF)),
                    ),
                    duration: const Duration(milliseconds: 250),
                  )
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          const Icon(Icons.timer, size: 64),
        ],
      ),
    );
  }
}

class TimerSettings extends StatefulWidget {
  @override
  _TimerSettingsState createState() => _TimerSettingsState();
}

class _TimerSettingsState extends State<TimerSettings> {
  Duration _roundLength = const Duration(minutes: 2);
  Duration _breakLength = const Duration(seconds: 30);
  Duration _preparationLength = const Duration(seconds: 30);
  int _numOfRounds = 12;

  void _pickRoundLength(BuildContext context) {
    Picker(
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(
          begin: 0,
          end: 10,
          initValue: _roundLength.inMinutes.remainder(60),
          jump: 1,
        ),
        NumberPickerColumn(
          begin: 0,
          end: 45,
          initValue: _roundLength.inSeconds.remainder(60),
          jump: 15,
        ),
      ]),
      delimiter: [
        PickerDelimiter(
          child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: const Icon(Icons.more_vert),
          ),
        )
      ],
      hideHeader: true,
      title: const Text('Round Length'),
      onConfirm: (Picker picker, List value) {
        final List<int> values = picker.getSelectedValues().cast<int>();
        setState(() {
          _roundLength = Duration(minutes: values[0], seconds: values[1]);
        });
      },
    ).showDialog(context);
  }

  void _pickBreakLength(BuildContext context) {
    Picker(
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(
          begin: 0,
          end: 10,
          initValue: _breakLength.inMinutes.remainder(60),
          jump: 1,
        ),
        NumberPickerColumn(
          begin: 0,
          end: 55,
          initValue: _breakLength.inSeconds.remainder(60),
          jump: 5,
        ),
      ]),
      delimiter: [
        PickerDelimiter(
          child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: const Icon(Icons.more_vert),
          ),
        )
      ],
      hideHeader: true,
      title: const Text('Break Length'),
      onConfirm: (Picker picker, List value) {
        final List<int> values = picker.getSelectedValues().cast<int>();
        setState(() {
          _breakLength = Duration(minutes: values[0], seconds: values[1]);
        });
      },
    ).showDialog(context);
  }

  void _pickGetReadyLength(BuildContext context) {
    Picker(
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(begin: 0, end: 0),
        NumberPickerColumn(
          begin: 0,
          end: 60,
          initValue: _preparationLength.inSeconds.remainder(60),
          jump: 5,
        ),
      ]),
      delimiter: [
        PickerDelimiter(
          child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: const Icon(Icons.more_vert),
          ),
        )
      ],
      hideHeader: true,
      title: const Text('Get Ready'),
      onConfirm: (Picker picker, List value) {
        final List<int> values = picker.getSelectedValues().cast<int>();
        setState(() {
          _preparationLength =
              Duration(minutes: values[0], seconds: values[1]);
        });
      },
    ).showDialog(context);
  }

  void _pickNumOfRounds(BuildContext context) {
    Picker(
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(
          begin: 1,
          end: 100,
          initValue: _numOfRounds,
          jump: 1,
        ),
      ]),
      hideHeader: true,
      title: const Text('Number Of Rounds'),
      onConfirm: (Picker picker, List value) {
        setState(() {
          _numOfRounds = picker.getSelectedValues()[0];
        });
      },
    ).showDialog(context);
  }

  String _formatTime(Duration time) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String mm = twoDigits(time.inMinutes.remainder(60));
    String ss = twoDigits(time.inSeconds.remainder(60));
    return "$mm:$ss";
  }

  String _workoutLengthLabel() {
    final int workoutLengthInSeconds = _preparationLength.inSeconds +
        _roundLength.inSeconds * _numOfRounds +
        _breakLength.inSeconds * (_numOfRounds - 1);
    return _formatTime(Duration(seconds: workoutLengthInSeconds));
  }

  String _secondaryLabel() {
    final rest = _breakLength.inSeconds > 0
        ? "${_breakLength.inSeconds} seconds rest"
        : 'No rest';
    final rounds = "$_numOfRounds ${_numOfRounds == 1 ? 'round' : 'rounds'}";
    return "$rest, $rounds";
  }

  void startWorkout() {
    final workout = WorkoutModel(
      roundLength: _roundLength,
      breakLength: _breakLength,
      preparationLength: _preparationLength,
      numOfRounds: _numOfRounds,
    );

    if (!workout.isValid()) {
      Widget okButton = TextButton(
        child: const Text('OK'),
        onPressed: () => Navigator.pop(context),
      );

      AlertDialog alert = AlertDialog(
        title: const Text('Round Length'),
        content: const Text('Please select round length'),
        actions: [okButton],
      );

      showDialog(context: context, builder: (_) => alert);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimerScreen(workout),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Boxing Timer',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            buildSettingRow('Round Length', _formatTime(_roundLength),
                () => _pickRoundLength(context)),
            buildSettingRow('Break Length', _formatTime(_breakLength),
                () => _pickBreakLength(context)),
            buildSettingRow('Preparation Time',
                _formatTime(_preparationLength), () => _pickGetReadyLength(context)),
            buildSettingRow('Number Of Rounds', '$_numOfRounds',
                () => _pickNumOfRounds(context)),
            const Spacer(),
            const Text('Workout',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
            Text(_workoutLengthLabel(),
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 80)),
            Text(_secondaryLabel(), style: const TextStyle(fontSize: 20)),
            const Spacer(),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: custom.FilledButton(
                  label: 'START',
                  color: Theme.of(context).primaryColor,
                  onPressed: startWorkout,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSettingRow(String label, String value, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        PickerButton(onPressed: onPressed, child: Text(value)),
      ],
    );
  }
}

const labelStyle = TextStyle(
  fontSize: 18,
  color: Colors.black,
);

class PickerButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const PickerButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0,
      ),
    );
  }
}
