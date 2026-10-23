// SECTION 5: Asynchronous programming
// Future, async/await, Stream and Isolate with the user's own activities.
import 'dart:async';
import 'dart:isolate';

import 'input_helper.dart';
import 'section3_oop.dart';
import 'section4_errors.dart';

// ---------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------

// Asks the user for activities until they type 0.
// Each activity is validated with addActivity (Section 4).
List<Activity> readActivities() {
  List<Activity> activities = [];
  while (true) {
    Activity? activity = askActivity();
    if (activity == null) {
      return activities; // the user typed 0
    }
    try {
      addActivity(activities, activity);
    } on InvalidActivityException catch (e) {
      print('Error: ${e.message} The activity was not added.');
    }
  }
}

// Turn an Activity into a plain Map so it can be sent to an Isolate.
Map<String, dynamic> activityToMap(Activity activity) {
  return {
    'name': activity.activityName,
    'duration': activity.duration,
    'calories': activity.calories,
  };
}

// Adds up the calories of a list (no waiting).
double sumCalories(List<Activity> activities) {
  double total = 0;
  for (Activity a in activities) {
    total += a.calories;
  }
  return total;
}

// Prints the list with numbers starting at 1.
void printNumberedList(List<Activity> activities) {
  for (int i = 0; i < activities.length; i++) {
    Activity a = activities[i];
    print('  ${i + 1}. ${a.activityName} - ${a.duration} min, '
        '${a.calories.toStringAsFixed(1)} kcal');
  }
}

// ---------------------------------------------------------------
// Part 1: Future with .then() and .catchError()
// ---------------------------------------------------------------

// Returns the total calories after a short delay.
// Throws an error if the list is empty.
Future<double> getTotalCaloriesLater(List<Activity> activities) {
  return Future.delayed(Duration(milliseconds: 300), () {
    if (activities.isEmpty) {
      throw Exception('No activities to calculate calories from.');
    }
    return sumCalories(activities);
  });
}

Future<void> part1Future(List<Activity> activities) async {
  print('');
  print('--- Part 1: Future with then() / catchError() ---');

  // Success case with your activities.
  // We "await" the chain so the section waits for it to finish.
  print('Calculating total calories of your activities...');
  await getTotalCaloriesLater(activities).then((total) {
    print('Total burned calories: ${total.toStringAsFixed(1)} kcal');
  }).catchError((error) {
    print('Error: $error');
  });

  // Error case: we call it once with an EMPTY list on purpose.
  print('Now with an empty list (to show the error path):');
  await getTotalCaloriesLater([]).then((total) {
    print('Total burned calories: ${total.toStringAsFixed(1)} kcal');
  }).catchError((error) {
    print('Error caught: $error');
  });
}

// ---------------------------------------------------------------
// Part 2: async / await
// ---------------------------------------------------------------

// Adds up the calories, waiting a little for each activity
// (like reading data from a database).
Future<double> calculateTotalCalories(List<Activity> activities) async {
  double total = 0;
  for (Activity a in activities) {
    await Future.delayed(Duration(milliseconds: 100));
    total += a.calories;
  }
  return total;
}

Future<void> part2AsyncAwait(List<Activity> activities) async {
  print('');
  print('--- Part 2: async / await ---');

  print('Calculating calories...');
  double total = await calculateTotalCalories(activities);

  print('Report:');
  for (Activity a in activities) {
    a.displayActivity();
  }
  print('Total calories: ${total.toStringAsFixed(1)} kcal');
}

// ---------------------------------------------------------------
// Part 3: Stream with StreamController
// ---------------------------------------------------------------

Future<void> part3Stream(List<Activity> activities) async {
  print('');
  print('--- Part 3: Stream of total calories ---');

  // The controller sends the new total every time the list changes.
  StreamController<double> controller = StreamController<double>();

  // Listen and print each update.
  controller.stream.listen((total) {
    print('  [Stream] Total calories now: ${total.toStringAsFixed(1)} kcal');
  });

  // Send the current total and give the listener time to print it.
  Future<void> sendTotal() async {
    controller.add(sumCalories(activities));
    await Future.delayed(Duration(milliseconds: 50));
  }

  // 1) Add one more activity.
  print('Add one more activity (or 0 to skip):');
  Activity? extra = askActivity();
  if (extra != null) {
    try {
      addActivity(activities, extra);
      await sendTotal();
    } on InvalidActivityException catch (e) {
      print('Error: ${e.message} The activity was not added.');
    }
  }

  // 2) Edit the calories of one activity (uses the setter).
  print('');
  print('Your activities:');
  printNumberedList(activities);
  int editNumber = askInt('Number of the activity to edit (0 to skip): ');
  if (editNumber >= 1 && editNumber <= activities.length) {
    double newCalories = askDouble('New calories: ');
    if (newCalories < 0) {
      print('Error: calories cannot be negative. Nothing changed.');
    } else {
      activities[editNumber - 1].calories = newCalories;
      print('Edited: ${activities[editNumber - 1].activityName}');
      await sendTotal();
    }
  } else if (editNumber != 0) {
    print('There is no activity number $editNumber. Nothing changed.');
  }

  // 3) Remove one activity.
  print('');
  print('Your activities:');
  printNumberedList(activities);
  int removeNumber = askInt('Number of the activity to remove (0 to skip): ');
  if (removeNumber >= 1 && removeNumber <= activities.length) {
    Activity removed = activities.removeAt(removeNumber - 1);
    print('Removed: ${removed.activityName}');
    await sendTotal();
  } else if (removeNumber != 0) {
    print('There is no activity number $removeNumber. Nothing changed.');
  }

  // Always close the controller so the program can finish.
  await controller.close();
}

// ---------------------------------------------------------------
// Part 4: Isolate for weekly statistics
// ---------------------------------------------------------------

// Finds the activity name that appears the most.
String findMostFrequent(List<Map<String, dynamic>> data) {
  Map<String, int> typeCount = {};
  for (Map<String, dynamic> item in data) {
    String name = item['name'] as String;
    typeCount[name] = (typeCount[name] ?? 0) + 1;
  }

  String mostFrequent = 'None';
  int maxCount = 0;
  typeCount.forEach((name, count) {
    if (count > maxCount) {
      maxCount = count;
      mostFrequent = name;
    }
  });
  return mostFrequent;
}

// Runs inside the Isolate. It only uses plain data (Maps, numbers, strings).
Map<String, dynamic> computeWeeklyStats(List<Map<String, dynamic>> data) {
  double totalCalories = 0;
  int totalMinutes = 0;
  for (Map<String, dynamic> item in data) {
    totalCalories += item['calories'] as double;
    totalMinutes += item['duration'] as int;
  }

  return {
    'totalCalories': totalCalories,
    'averageDailyMinutes': totalMinutes / 7, // 7 days in a week
    'mostFrequent': findMostFrequent(data),
  };
}

Future<void> part4Isolate(List<Activity> activities) async {
  print('');
  print('--- Part 4: Isolate for weekly statistics ---');

  // Convert to plain Maps before sending to the Isolate.
  List<Map<String, dynamic>> data = activities.map(activityToMap).toList();

  print('Computing weekly statistics in a background Isolate...');
  Map<String, dynamic> stats =
      await Isolate.run(() => computeWeeklyStats(data));

  print('Weekly statistics:');
  print('  Total calories        : '
      '${(stats['totalCalories'] as double).toStringAsFixed(1)} kcal');
  print('  Average daily duration: '
      '${(stats['averageDailyMinutes'] as double).toStringAsFixed(1)} min');
  print('  Most frequent activity: ${stats['mostFrequent']}');
}

// ---------------------------------------------------------------
// Part 5: Full integration - one day
// ---------------------------------------------------------------

// Future: compute total minutes and classify the activity level.
Future<String> classifyDay(List<Activity> activities) {
  return Future.delayed(Duration(milliseconds: 200), () {
    int totalMinutes = 0;
    for (Activity a in activities) {
      totalMinutes += a.duration;
    }
    String level;
    if (totalMinutes < 30) {
      level = 'Low';
    } else if (totalMinutes < 60) {
      level = 'Good';
    } else if (totalMinutes < 90) {
      level = 'High';
    } else {
      level = 'Very high';
    }
    return '$totalMinutes min -> level: $level';
  });
}

// Runs inside the Isolate: daily statistics from plain data.
Map<String, dynamic> computeDailyStats(List<Map<String, dynamic>> data) {
  int totalMinutes = 0;
  double totalCalories = 0;
  for (Map<String, dynamic> item in data) {
    totalMinutes += item['duration'] as int;
    totalCalories += item['calories'] as double;
  }

  return {
    'totalMinutes': totalMinutes,
    'totalCalories': totalCalories,
    'averageDuration': data.isEmpty ? 0.0 : totalMinutes / data.length,
    'mostFrequent': findMostFrequent(data),
    'count': data.length,
  };
}

Future<void> part5FullDay() async {
  print('');
  print('--- Part 5: Full day (enter your activities) ---');

  // Ask the daily goal (30 minutes if the answer is not positive).
  int dailyGoal = askInt('Your daily goal in minutes (e.g. 30): ');
  if (dailyGoal <= 0) {
    dailyGoal = 30;
    print('Using the default goal: 30 minutes.');
  }

  List<Activity> dayLog = [];
  bool goalReached = false;
  bool goalClassified = false;

  // The stream sends (total minutes, total calories) after each new activity.
  StreamController<(int, double)> controller =
      StreamController<(int, double)>();

  // Listen to updates and notice when the goal is reached.
  controller.stream.listen((update) {
    var (minutes, calories) = update;
    print('  [Stream] Total: $minutes min, '
        '${calories.toStringAsFixed(1)} kcal');
    if (!goalReached && minutes >= dailyGoal) {
      goalReached = true;
      print('  Daily goal of $dailyGoal min reached!');
    }
  });

  // Keep asking for activities until the user types 0.
  while (true) {
    Activity? activity = askActivity();
    if (activity == null) {
      break;
    }

    // Validate and add (Section 4). Skip the activity if it is invalid.
    try {
      addActivity(dayLog, activity);
    } on InvalidActivityException catch (e) {
      print('Error: ${e.message} The activity was not added.');
      continue;
    }

    // Send the new totals to the stream.
    int minutes = 0;
    for (Activity a in dayLog) {
      minutes += a.duration;
    }
    controller.add((minutes, sumCalories(dayLog)));

    // Give the listener a moment to print the update.
    await Future.delayed(Duration.zero);

    // Goal just reached: use a Future to classify the level (only once).
    if (goalReached && !goalClassified) {
      goalClassified = true;
      String result = await classifyDay(dayLog);
      print('  [Future] Classification at goal time: $result');
    }
  }

  // The day is over: close the stream.
  await controller.close();
  print('The day has ended.');

  if (dayLog.isEmpty) {
    print('No activities were entered today.');
    return;
  }

  // Final classification for the whole day.
  String finalLevel = await classifyDay(dayLog);

  // Isolate: compute daily statistics with plain data.
  List<Map<String, dynamic>> data = dayLog.map(activityToMap).toList();
  print('Computing daily statistics in a background Isolate...');
  Map<String, dynamic> stats = await Isolate.run(() => computeDailyStats(data));

  // Final daily report.
  print('');
  print('========== FINAL DAILY REPORT ==========');
  print('Number of activities  : ${stats['count']}');
  print('Total minutes         : ${stats['totalMinutes']} min');
  print('Total calories        : '
      '${(stats['totalCalories'] as double).toStringAsFixed(1)} kcal');
  print('Average duration      : '
      '${(stats['averageDuration'] as double).toStringAsFixed(1)} min');
  print('Most frequent activity: ${stats['mostFrequent']}');
  print('Daily goal            : $dailyGoal min '
      '(${goalReached ? 'reached' : 'not reached'})');
  print('Activity level        : $finalLevel');
  print('========================================');
}

// ---------------------------------------------------------------
// Entry point for Section 5
// ---------------------------------------------------------------
Future<void> runSection5() async {
  // Ask for the week's activities once, then use them in Parts 1-4.
  print('Enter your activities for this week (type 0 when you are done).');
  List<Activity> activities = readActivities();
  if (activities.isEmpty) {
    print('No activities entered, so there is nothing to calculate.');
    return;
  }

  await part1Future(activities);
  await part2AsyncAwait(activities);
  await part3Stream(activities);
  await part4Isolate(activities);
  await part5FullDay();
}
