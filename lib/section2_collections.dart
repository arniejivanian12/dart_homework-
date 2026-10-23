// SECTION 2: Collections (List, Set, Map)
//
// This section shows how to store sports activities using
// the three main Dart collections: List, Set and Map.
// All values come from the user (typed in the terminal).
import 'input_helper.dart';

/// Entry point for Section 2 (called from the main menu).
void runSection2() {
  listExample();
  print('');
  setExample();
  print('');
  mapExample();
}

/// Part 1: a List keeps activities in order and allows duplicates.
void listExample() {
  print('--- 1. List of activities ---');

  // Start with an empty list of today's activities.
  List<String> activities = [];

  // Add activities: at least 3, then the user may type 'done'.
  print('Add your activities for today (at least 3).');
  while (true) {
    String name = askText('Activity name (or "done" to finish): ');
    if (name.toLowerCase() == 'done') {
      if (activities.length >= 3) {
        break;
      }
      print('  Please add at least 3 activities first '
          '(you have ${activities.length}).');
    } else if (name.isEmpty) {
      print('  The name cannot be empty.');
    } else {
      activities.add(name);
    }
  }
  print('After adding:');
  printActivityList(activities);

  // Update an existing activity.
  int? updateIndex =
      askIndex('Number of the activity to update: ', activities.length);
  if (updateIndex != null) {
    String newName = askText('New name: ');
    if (newName.isEmpty) {
      print('  The name cannot be empty. Nothing was updated.');
    } else {
      String oldName = activities[updateIndex];
      activities[updateIndex] = newName;
      print('After updating "$oldName" to "$newName":');
    }
  }
  printActivityList(activities);

  // Delete an activity.
  int? deleteIndex =
      askIndex('Number of the activity to delete: ', activities.length);
  if (deleteIndex != null) {
    String removed = activities.removeAt(deleteIndex);
    print('After deleting "$removed":');
  }
  printActivityList(activities);
}

/// Asks for an activity number (1..length) and returns its index (0-based).
/// Returns null (and prints a message) if the input is wrong.
int? askIndex(String question, int length) {
  while (true) {
    String answer = askText(question);
    if (answer.isEmpty) {
      print('  No activity selected. Nothing was changed.');
      return null;
    }

    int? number = int.tryParse(answer);
    if (number == null) {
      print('  That is not a number. Please try again.');
      continue;
    }
    if (number < 1 || number > length) {
      print('  There is no activity number $number '
          '(choose 1 to $length). Please try again.');
      continue;
    }
    return number - 1;
  }
}

/// Prints the list of activities, one per line.
void printActivityList(List<String> activities) {
  if (activities.isEmpty) {
    print('  (no activities)');
    return;
  }
  for (int i = 0; i < activities.length; i++) {
    print('  ${i + 1}. ${activities[i]}');
  }
}

/// Part 2: a Set keeps only unique values (no duplicates).
void setExample() {
  print('--- 2. Set of activity types ---');

  // The user types names on one line; repeats are allowed on purpose.
  print('Type activity names separated by commas.');
  print('Repeats are allowed (example: Walking, Running, Walking).');
  List<String> loggedNames = splitByComma(askText('Activity names: '));
  print('Names typed (with repeats): $loggedNames');

  // addAll ignores names that are already in the set.
  Set<String> activityTypes = {};
  activityTypes.addAll(loggedNames);

  int duplicates = loggedNames.length - activityTypes.length;
  print('Unique activity types: $activityTypes');
  print('Number of unique types: ${activityTypes.length}');
  print('Duplicates ignored: $duplicates');
}

/// Part 3: a Map links each day to the activities done that day.
void mapExample() {
  print('--- 3. Map of daily activity log ---');

  Map<String, List<String>> activityLog = {};

  // Add days: at least 3, then the user may type 'done'.
  print('Add at least 3 days to your activity log.');
  while (true) {
    String day = askText('Day name (or "done" to finish): ');
    if (day.toLowerCase() == 'done') {
      if (activityLog.length >= 3) {
        break;
      }
      print('  Please add at least 3 days first '
          '(you have ${activityLog.length}).');
    } else if (day.isEmpty) {
      print('  The day cannot be empty.');
    } else {
      activityLog[day] =
          splitByComma(askText('Activities on $day (comma-separated): '));
    }
  }
  print('After adding the days:');
  printActivityLog(activityLog);

  // Modify one day's activities.
  String? dayToChange =
      askExistingDay(activityLog, 'Which day do you want to modify? ');
  if (dayToChange != null) {
    activityLog[dayToChange] = splitByComma(
        askText('New activities for $dayToChange (comma-separated): '));
    print('After modifying $dayToChange:');
  }
  printActivityLog(activityLog);

  // Remove a day.
  String? dayToRemove =
      askExistingDay(activityLog, 'Which day do you want to remove? ');
  if (dayToRemove != null) {
    activityLog.remove(dayToRemove);
    print('After removing $dayToRemove:');
  }
  printActivityLog(activityLog);
}

/// Asks for a day in the log; an empty answer cancels the operation.
String? askExistingDay(Map<String, List<String>> activityLog, String question) {
  while (true) {
    String day = askText(question);
    if (day.isEmpty) {
      print('  No day selected. Nothing was changed.');
      return null;
    }
    if (activityLog.containsKey(day)) {
      return day;
    }
    print('  "$day" is not in the log. Please try again.');
  }
}

/// Splits comma-separated text into a clean list
/// (spaces trimmed, empty parts skipped).
List<String> splitByComma(String text) {
  List<String> result = [];
  for (String part in text.split(',')) {
    String name = part.trim();
    if (name.isNotEmpty) {
      result.add(name);
    }
  }
  return result;
}

/// Prints the activity log, one line per day.
void printActivityLog(Map<String, List<String>> log) {
  if (log.isEmpty) {
    print('  (no days recorded)');
    return;
  }
  log.forEach((day, activities) {
    String text = activities.isEmpty ? '(none)' : activities.join(', ');
    print('  $day: $text');
  });
}
