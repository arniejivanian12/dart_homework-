// SECTION 4: Error handling
import 'input_helper.dart';
import 'section3_oop.dart';

// ---------- 1. Custom exception ----------

// Our own exception for activities with wrong data.
class InvalidActivityException implements Exception {
  final String message;

  InvalidActivityException(this.message);

  @override
  String toString() => 'InvalidActivityException: $message';
}

// Checks the activity and adds it to the list.
// Throws InvalidActivityException if the data is not valid.
void addActivity(List<Activity> activities, Activity activity) {
  if (activity.activityName.trim().isEmpty) {
    throw InvalidActivityException('Activity name cannot be empty.');
  }
  if (activity.duration < 0) {
    throw InvalidActivityException(
        'Duration cannot be negative (got ${activity.duration}).');
  }
  if (activity.calories < 0) {
    throw InvalidActivityException(
        'Calories cannot be negative (got ${activity.calories}).');
  }
  activities.add(activity);
  print('Added: ${activity.activityName}');
}

// ---------- 2. try / on / catch / finally ----------

// Tries to add one activity and handles any error.
void tryToAdd(List<Activity> activities, Activity activity) {
  try {
    addActivity(activities, activity);
  } on InvalidActivityException catch (e) {
    // Our custom exception
    print('Error: ${e.message}');
  } catch (e) {
    // Any other kind of error
    print('Unexpected error: $e');
  } finally {
    // Always runs, error or not
    print('Operation attempted');
  }
}

// ---------- 3. rethrow ----------

// Reads a duration from text. If it fails, prints a warning
// and passes the same error up to the caller with rethrow.
int parseDuration(String text) {
  try {
    return int.parse(text);
  } catch (e) {
    print('Warning: could not read duration "$text".');
    rethrow;
  }
}

void runSection4() {
  List<Activity> activities = [];

  // ---------- Part 1: custom exception ----------
  print('--- Part 1: Add your activities ---');
  print('Tip: try some wrong values to see the error handling,');
  print('for example an empty name (type 4), negative minutes or negative calories.');

  while (true) {
    Activity? activity = askActivity();
    if (activity == null) {
      break; // user typed 0
    }
    tryToAdd(activities, activity);
  }

  // ---------- Part 2: general catch ----------
  print('');
  print('--- Part 2: View an activity (general catch) ---');
  print('You have ${activities.length} valid activities.');
  int number = askInt('Which activity number do you want to see? ');
  try {
    // A wrong number throws a RangeError
    Activity chosen = activities[number - 1];
    print('Activity $number:');
    chosen.displayActivity();
  } catch (e) {
    print('Sorry, there is no activity number $number.');
    print('Unexpected error: $e');
  } finally {
    print('Operation attempted');
  }

  // ---------- Part 3: rethrow ----------
  print('');
  print('--- Part 3: Type a duration (rethrow) ---');
  String text = askText('Type a duration in minutes (try letters like "twenty"): ');
  try {
    int minutes = parseDuration(text);
    print('Duration is $minutes minutes');
  } on FormatException catch (e) {
    // The error was rethrown from parseDuration and handled here
    print('Handled rethrown error in runSection4: ${e.message}');
  }

  // ---------- Part 4: final list ----------
  print('');
  print('--- Part 4: Final list of valid activities ---');
  for (Activity activity in activities) {
    activity.displayActivity();
  }
  print('Total valid activities: ${activities.length}');
}
