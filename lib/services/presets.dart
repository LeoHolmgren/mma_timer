import 'package:mma_timer/models/workout.dart';


class Preset {
  final String name;
  final WorkoutModel model;

  Preset(this.name, this.model);
}

final List<Preset> workoutPresets = [
  Preset("Boxing - 3 min rounds", WorkoutModel(
    roundLength: Duration(minutes: 3),
    breakLength: Duration(seconds: 60),
    preparationLength: Duration(seconds: 30),
    numOfRounds: 12,
  )),
  Preset("HIIT - Short", WorkoutModel(
    roundLength: Duration(seconds: 30),
    breakLength: Duration(seconds: 15),
    preparationLength: Duration(seconds: 10),
    numOfRounds: 8,
  )),
  Preset("MMA - Pro", WorkoutModel(
    roundLength: Duration(minutes: 5),
    breakLength: Duration(minutes: 1),
    preparationLength: Duration(seconds: 60),
    numOfRounds: 5,
  )),
];
