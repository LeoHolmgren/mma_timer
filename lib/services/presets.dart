import 'package:mma_timer/models/workout.dart';


class Preset {
  final String name;
  final WorkoutModel model;

  Preset(this.name, this.model);
}

final List<Preset> workoutPresets = [

  Preset("MMA - Pro", WorkoutModel(
    roundLength: Duration(minutes: 5),
    breakLength: Duration(minutes: 1),
    preparationLength: Duration(seconds: 60),
    numOfRounds: 5,
  )),
  Preset("Preset - 30sec/5", WorkoutModel(
    roundLength: Duration(seconds: 30),
    breakLength: Duration(seconds: 5),
    preparationLength: Duration(seconds: 5),
    numOfRounds: 5,
  )),
  Preset("Preset - 60sec/5", WorkoutModel(
    roundLength: Duration(seconds: 60),
    breakLength: Duration(seconds: 5),
    preparationLength: Duration(seconds: 5),
    numOfRounds: 5,
  )),
  Preset("Preset - 2min/30", WorkoutModel(
    roundLength: Duration(minutes: 2),
    breakLength: Duration(seconds: 30),
    preparationLength: Duration(seconds: 5),
    numOfRounds: 5,
  )),
  Preset("Preset - 3min/30", WorkoutModel(
    roundLength: Duration(minutes: 3),
    breakLength: Duration(seconds: 30),
    preparationLength: Duration(seconds: 5),
    numOfRounds: 5,
  )),
  Preset("Preset - 3min/60", WorkoutModel(
    roundLength: Duration(minutes: 3),
    breakLength: Duration(seconds: 60),
    preparationLength: Duration(seconds: 5),
    numOfRounds: 5,
  )),
  Preset("Preset - 5min/60", WorkoutModel(
    roundLength: Duration(minutes: 5),
    breakLength: Duration(seconds: 60),
    preparationLength: Duration(seconds: 5),
    numOfRounds: 5,
  )),
];
