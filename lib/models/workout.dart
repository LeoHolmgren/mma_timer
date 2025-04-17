enum WorkoutPhase { prepare, work, rest }

class WorkoutModel {
  Duration roundLength;
  Duration breakLength;
  Duration preparationLength;
  int numOfRounds;

  WorkoutModel({
    required this.roundLength,
    required this.breakLength,
    required this.preparationLength,
    required this.numOfRounds,
  });

  bool isValid() {
    return roundLength.inSeconds > 0 && numOfRounds > 0;
  }

  shouldPrepare() {
    return preparationLength.inSeconds > 0;
  }

  shouldRest() {
    return breakLength.inSeconds > 0;
  }
}
