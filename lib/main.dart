import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'services/presets.dart';
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _characterCount,
                  builder: (context, child) {
                    String text =
                        _currentString.substring(0, _characterCount.value);
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
          ),
        ),
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
  Preset? _selectedPreset;

  void _showDurationPicker({
    required String title,
    required Duration initial,
    required int maxMinutes,
    required int secondStep,
    required Function(Duration) onConfirm,
  }) {
    int selectedMinutes = initial.inMinutes;
    int selectedSeconds = initial.inSeconds % 60;

    showModalBottomSheet(
      context: context,
      builder: (_) => SizedBox(
        height: 300,
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 40,
                      scrollController: FixedExtentScrollController(initialItem: selectedMinutes),
                      onSelectedItemChanged: (value) {
                        selectedMinutes = value;
                      },
                      children: List.generate(maxMinutes + 1, (i) => Text('$i min')),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 40,
                      scrollController: FixedExtentScrollController(initialItem: selectedSeconds ~/ secondStep),
                      onSelectedItemChanged: (value) {
                        selectedSeconds = value * secondStep;
                      },
                      children: List.generate(60 ~/ secondStep, (i) => Text('${i * secondStep} sec')),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              child: const Text('Confirm'),
              onPressed: () {
                if (!mounted) return;
                onConfirm(Duration(minutes: selectedMinutes, seconds: selectedSeconds));
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  void _pickRoundLength(BuildContext context) {
    _showDurationPicker(
      title: 'Round Length',
      initial: _roundLength,
      maxMinutes: 10,
      secondStep: 15,
      onConfirm: (duration) => setState(() => _roundLength = duration),
    );
  }

  void _pickBreakLength(BuildContext context) {
    _showDurationPicker(
      title: 'Break Length',
      initial: _breakLength,
      maxMinutes: 10,
      secondStep: 5,
      onConfirm: (duration) => setState(() => _breakLength = duration),
    );
  }

  void _pickGetReadyLength(BuildContext context) {
    _showDurationPicker(
      title: 'Get Ready',
      initial: _preparationLength,
      maxMinutes: 0,
      secondStep: 5,
      onConfirm: (duration) => setState(() => _preparationLength = duration),
    );
  }

  void _pickNumOfRounds(BuildContext context) {
    int selected = _numOfRounds;

    showModalBottomSheet(
      context: context,
      builder: (_) => SizedBox(
        height: 250,
        child: Column(
          children: [
            const Text('Number of Rounds'),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 40,
                scrollController: FixedExtentScrollController(initialItem: selected - 1),
                onSelectedItemChanged: (value) {
                  selected = value + 1;
                },
                children: List.generate(100, (i) => Text('${i + 1}')),
              ),
            ),
            ElevatedButton(
              child: const Text('Confirm'),
              onPressed: () {
                if (!mounted) return;
                setState(() => _numOfRounds = selected);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  String _formatTime(Duration time) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String mm = twoDigits(time.inMinutes.remainder(60));
    String ss = twoDigits(time.inSeconds.remainder(60));
    return "$mm:$ss";
  }

  String _workoutLengthLabel() {
    final int totalSeconds = _preparationLength.inSeconds +
        _roundLength.inSeconds * _numOfRounds +
        _breakLength.inSeconds * (_numOfRounds - 1);
    return _formatTime(Duration(seconds: totalSeconds));
  }

  String _secondaryLabel() {
    final rest = _breakLength.inSeconds > 0 ? "${_breakLength.inSeconds} seconds rest" : 'No rest';
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
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Round Length'),
          content: const Text('Please select round length'),
          actions: [TextButton(child: const Text('OK'), onPressed: () => Navigator.pop(context))],
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TimerScreen(workout)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boxing Timer', style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.w600)),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: DropdownButtonFormField<Preset>(
                      value: _selectedPreset,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: "Select a preset",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      items: [
                        const DropdownMenuItem<Preset>(
                          value: null,
                          child: Text("Custom"),
                        ),
                        ...workoutPresets.map((preset) {
                          return DropdownMenuItem<Preset>(
                            value: preset,
                            child: Text(preset.name),
                          );
                        }),
                      ],
                      onChanged: (preset) {
                        setState(() {
                          _selectedPreset = preset;
                          if (preset != null) {
                            _roundLength = preset.model.roundLength;
                            _breakLength = preset.model.breakLength;
                            _preparationLength = preset.model.preparationLength;
                            _numOfRounds = preset.model.numOfRounds;
                          }
                        });
                      },
                    ),
                  ),
                  buildSettingRow('Round Length', _formatTime(_roundLength), () => _pickRoundLength(context)),
                  buildSettingRow('Break Length', _formatTime(_breakLength), () => _pickBreakLength(context)),
                  buildSettingRow('Preparation Time', _formatTime(_preparationLength), () => _pickGetReadyLength(context)),
                  buildSettingRow('Number Of Rounds', '$_numOfRounds', () => _pickNumOfRounds(context)),
                  const SizedBox(height: 32),
                  const Text('Workout', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
                  Text(_workoutLengthLabel(), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 80)),
                  Text(_secondaryLabel(), style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 32),
                  SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: custom.FilledButton(
                        label: 'START',
                        color: Theme.of(context).primaryColor,
                        onPressed: startWorkout,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 0,
      ),
    );
  }
}
