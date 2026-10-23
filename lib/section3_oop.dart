// SECTION 3: Object-Oriented Programming
// Classes, getters/setters, inheritance, abstract classes and mixins.

import 'input_helper.dart';

// ---------------------------------------------------------------
// Part 3: Abstract class
// It only says WHAT every activity must be able to do.
// ---------------------------------------------------------------
abstract class ActivityBase {
  void displayActivity();

  // Estimated calories burned (minutes * calories per minute).
  double calculateCalories();

  // Total minutes in a month if the activity is done every day.
  int calculateMonthlyActivity();
}

// ---------------------------------------------------------------
// Part 4: Mixin
// Extra helper methods that can be added to any class with "with".
// ---------------------------------------------------------------
mixin ActivityHelper {
  // Daily limit in minutes.
  static const int dailyLimit = 120;

  // Prints a warning when the daily minutes are over the limit.
  void showWarning(int minutes) {
    if (minutes > dailyLimit) {
      print('Warning: $minutes min is more than the daily limit '
          'of $dailyLimit min. Take a rest!');
    } else {
      print('OK: $minutes min is within the daily limit of $dailyLimit min.');
    }
  }

  // Prints a simple tip.
  void showTip() {
    print('Tip: Drink water and stretch before and after your activity.');
  }

  // Returns the average duration (minutes) of a list of activities.
  double calculateAverageDuration(List<Activity> activities) {
    if (activities.isEmpty) return 0;
    int total = 0;
    for (final activity in activities) {
      total += activity.duration;
    }
    return total / activities.length;
  }
}

// ---------------------------------------------------------------
// Part 1: Activity class
// ---------------------------------------------------------------
class Activity extends ActivityBase with ActivityHelper {
  String activityName;
  int _duration; // minutes
  double _calories; // kcal
  DateTime _date;

  // Normal constructor.
  Activity(this.activityName, this._duration, this._calories, this._date);

  // Named constructor with default values.
  Activity.withDefaults()
      : activityName = 'General Exercise',
        _duration = 30,
        _calories = 150.0,
        _date = DateTime.now();

  // Getters and setters for the private fields.
  int get duration => _duration;
  set duration(int value) => _duration = value;

  double get calories => _calories;
  set calories(double value) => _calories = value;

  DateTime get date => _date;
  set date(DateTime value) => _date = value;

  // Formats the date as yyyy-mm-dd.
  String get formattedDate {
    final month = _date.month.toString().padLeft(2, '0');
    final day = _date.day.toString().padLeft(2, '0');
    return '${_date.year}-$month-$day';
  }

  @override
  void displayActivity() {
    print('Activity: $activityName');
    print('  Duration: $_duration min');
    print('  Calories: ${_calories.toStringAsFixed(1)} kcal');
    print('  Date:     $formattedDate');
  }

  // General activity: about 5 kcal per minute.
  @override
  double calculateCalories() => _duration * 5.0;

  @override
  int calculateMonthlyActivity() => _duration * 30;
}

// ---------------------------------------------------------------
// Part 2: Inheritance
// Each subclass adds one extra field and reuses the parent display.
// ---------------------------------------------------------------
class WalkingActivity extends Activity {
  int _steps;

  WalkingActivity(super.activityName, super.duration, super.calories,
      super.date, this._steps);

  int get steps => _steps;
  set steps(int value) => _steps = value;

  @override
  void displayActivity() {
    super.displayActivity();
    print('  Steps:    $_steps');
  }

  // Walking: about 4 kcal per minute.
  @override
  double calculateCalories() => duration * 4.0;
}

class RunningActivity extends Activity {
  double _distance; // km

  RunningActivity(super.activityName, super.duration, super.calories,
      super.date, this._distance);

  double get distance => _distance;
  set distance(double value) => _distance = value;

  @override
  void displayActivity() {
    super.displayActivity();
    print('  Distance: ${_distance.toStringAsFixed(1)} km');
  }

  // Running: about 10 kcal per minute.
  @override
  double calculateCalories() => duration * 10.0;
}

class SwimmingActivity extends Activity {
  int _laps;

  SwimmingActivity(super.activityName, super.duration, super.calories,
      super.date, this._laps);

  int get laps => _laps;
  set laps(int value) => _laps = value;

  @override
  void displayActivity() {
    super.displayActivity();
    print('  Laps:     $_laps');
  }

  // Swimming: about 8 kcal per minute.
  @override
  double calculateCalories() => duration * 8.0;
}

// ---------------------------------------------------------------
// Demo (uses real user input)
// ---------------------------------------------------------------
void runSection3() {
  print('--- Part 1: Activity class (named constructor) ---');
  Activity general = Activity.withDefaults();
  general.displayActivity();

  print('');
  print('--- Part 2: Inheritance (enter your activities) ---');
  List<Activity> activities = [];
  while (true) {
    Activity? activity = askActivity();
    if (activity == null) break;
    activities.add(activity);
  }

  if (activities.isEmpty) {
    print('No activities entered. Nothing more to show.');
    return;
  }

  // Each subclass uses its own overridden displayActivity().
  print('');
  for (int i = 0; i < activities.length; i++) {
    print('#${i + 1}');
    activities[i].displayActivity();
  }

  print('');
  print('--- Part 3: Abstract class methods ---');
  for (Activity activity in activities) {
    print('${activity.activityName}: '
        'estimated ${activity.calculateCalories().toStringAsFixed(1)} kcal '
        '(you entered ${activity.calories.toStringAsFixed(1)} kcal), '
        '${activity.calculateMonthlyActivity()} min per month if done daily');
  }

  print('');
  print('--- Part 4: Mixin methods ---');
  int totalMinutes = 0;
  for (Activity activity in activities) {
    totalMinutes += activity.duration;
  }
  print('Total time today: $totalMinutes min');
  general.showWarning(totalMinutes);
  general.showTip();
  double average = general.calculateAverageDuration(activities);
  print('Average duration: ${average.toStringAsFixed(1)} min');

  print('');
  print('--- Setter demo ---');
  int number =
      askInt('Which activity do you want to edit (1-${activities.length})? ');
  if (number < 1 || number > activities.length) {
    print('There is no activity number $number. Nothing changed.');
    return;
  }

  Activity chosen = activities[number - 1];
  print('Old duration: ${chosen.duration} min');
  chosen.duration = askInt('New duration (minutes): '); // uses the setter
  print('Updated activity:');
  chosen.displayActivity();
  print('New estimated calories: '
      '${chosen.calculateCalories().toStringAsFixed(1)} kcal');
}
