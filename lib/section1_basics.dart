// SECTION 1: Basics (variables, null safety, if, switch, loops)
// All values now come from the user (typed in the terminal).
import 'input_helper.dart';

// Entry point for Section 1. It runs each small part one after another.
void runSection1() {
  int dailyGoal = showUserVariables();

  // Lists filled in part 2 and used again in part 5.
  List<String> exerciseNames = [];
  List<String> exerciseTypes = [];
  int todayMinutes = showDailyTotals(exerciseNames, exerciseTypes);

  rateDailyActivity(todayMinutes, dailyGoal);
  compareMonths();
  showLoops(exerciseNames, exerciseTypes);
  print('--- Section 1 complete. Returning to the main menu. ---');
}

// Asks for a whole number that is 0 or more (asks again if it is negative).
int askZeroOrMore(String question) {
  int value = askInt(question);
  while (value < 0) {
    print('  The number cannot be negative.');
    value = askInt(question);
  }
  return value;
}

// ---------------------------------------------------------------
// 1. Variables and null safety (returns the daily goal)
// ---------------------------------------------------------------
int showUserVariables() {
  print('--- 1. User variables ---');

  // Basic information about the user.
  String userName = askText('Your name: ');
  int age = askZeroOrMore('Your age: ');
  double weight = askDouble('Your weight (kg): ');
  int dailyGoal = askZeroOrMore('Your daily goal (minutes): ');

  // One activity the user did.
  String activityName = askText('Activity name: ');
  int duration = askZeroOrMore('Duration (minutes): ');
  double calories = askDouble('Calories burned: ');
  DateTime date = DateTime.now(); // today

  // Null safety: the favorite activity may be left empty -> null.
  String answer = askText('Favorite activity (press Enter to skip): ');
  String? favoriteActivity = answer.isEmpty ? null : answer;

  print('');
  print('Name: $userName');
  print('Age: $age years');
  print('Weight: $weight kg');
  print('Daily goal: $dailyGoal minutes');
  print('Activity: $activityName');
  print('Duration: $duration minutes');
  print('Calories burned: $calories kcal');
  print('Date: ${date.year}-${date.month}-${date.day}');

  // "??" gives a default value when the variable is null.
  print('Favorite activity: ${favoriteActivity ?? 'Not chosen yet'}');
  print('');
  return dailyGoal;
}

// ---------------------------------------------------------------
// 2. Total minutes and calories for the day (returns the total minutes)
// ---------------------------------------------------------------
int showDailyTotals(List<String> exerciseNames, List<String> exerciseTypes) {
  print('--- 2. Daily totals ---');

  int count = askZeroOrMore('How many exercises did you do today? ');

  int totalMinutes = 0;
  double totalCalories = 0;

  // Ask the details of each exercise.
  for (int i = 1; i <= count; i++) {
    print('Exercise $i:');
    String name = askText('  Name: ');
    String type = askText('  Type (e.g. Cardio, Strength): ');
    int minutes = askZeroOrMore('  Minutes: ');
    double calories = askDouble('  Calories: ');

    exerciseNames.add(name);
    exerciseTypes.add(type);
    totalMinutes += minutes;
    totalCalories += calories;
  }

  if (count == 0) {
    print('No exercises today.');
  }
  print('Total exercise time: $totalMinutes minutes');
  print('Total calories burned: $totalCalories kcal');
  print('');
  return totalMinutes;
}

// ---------------------------------------------------------------
// 3. Rate the daily activity with if / else if
// ---------------------------------------------------------------
void rateDailyActivity(int totalMinutes, int dailyGoal) {
  print('--- 3. Daily activity rating ---');

  String rating;
  if (totalMinutes < 30) {
    rating = 'Low activity';
  } else if (totalMinutes < 60) {
    rating = 'Good activity';
  } else if (totalMinutes < 90) {
    rating = 'High activity';
  } else {
    rating = 'Very high activity';
  }

  print('Total minutes today: $totalMinutes');
  print('Rating: $rating');

  // Check the daily goal.
  if (totalMinutes == dailyGoal) {
    print('Daily goal of $dailyGoal minutes reached. Well done!');
  }
  else if (totalMinutes > dailyGoal) {
    print('Daily goal of $dailyGoal minutes exceeded by ${totalMinutes - dailyGoal} minutes. Excellent!');
  } 
   else {
    print('Daily goal not reached: ${dailyGoal - totalMinutes} minutes left.');
  }
  print('');
}

// ---------------------------------------------------------------
// 4. Month names with switch, and compare two months
// ---------------------------------------------------------------

// Returns the name of a month (1 to 12) using a switch statement.
String getMonthName(int month) {
  switch (month) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return 'Invalid month';
  }
}

void compareMonths() {
  print('--- 4. Monthly comparison (switch) ---');

  // Ask until the month number is between 1 and 12.
  int currentMonth = askInt('Current month number (1-12): ');
  while (currentMonth < 1 || currentMonth > 12) {
    print('  ${getMonthName(currentMonth)}, please try again.');
    currentMonth = askInt('Current month number (1-12): ');
  }

  // The month before January is December.
  int previousMonth = currentMonth == 1 ? 12 : currentMonth - 1;

  String currentName = getMonthName(currentMonth);
  String previousName = getMonthName(previousMonth);
  print('Current month: $currentName');

  int currentMinutes = askZeroOrMore('Total minutes in $currentName: ');
  int previousMinutes = askZeroOrMore('Total minutes in $previousName: ');

  int difference = currentMinutes - previousMinutes;
  if (difference > 0) {
    print('$currentName is higher by $difference minutes. Great progress!');
  } else if (difference < 0) {
    print('$previousName was higher by ${-difference} minutes. Keep going!');
  } else {
    print('Both months have the same activity.');
  }
  print('');
}

// ---------------------------------------------------------------
// 5. Loops: for, for-in and forEach
// ---------------------------------------------------------------
void showLoops(List<String> exerciseNames, List<String> exerciseTypes) {
  print('--- 5. Loops ---');

  // Classic for loops: record and print activities from each of the last
  // three months.
  List<List<String>> monthlyActivities = [];
  for (int i = 1; i <= 3; i++) {
    int count = askZeroOrMore(
        'How many activities were recorded $i month(s) ago? ');
    List<String> activities = [];
    for (int j = 1; j <= count; j++) {
      activities.add(askText('  Activity $j name: '));
    }
    monthlyActivities.add(activities);
  }

  print('Activities recorded over the last three months (for loop):');
  for (int i = 0; i < monthlyActivities.length; i++) {
    print('  ${i + 1} month(s) ago:');
    if (monthlyActivities[i].isEmpty) {
      print('    (no activities recorded)');
    }
    for (int j = 0; j < monthlyActivities[i].length; j++) {
      print('    - ${monthlyActivities[i][j]}');
    }
  }

  // for-in loop: go over all the exercises entered in part 2.
  print('All exercises (for-in loop):');
  if (exerciseNames.isEmpty) {
    print('  (no exercises entered)');
  }
  for (String exercise in exerciseNames) {
    print('  - $exercise');
  }

  // forEach: print the activity types (toSet() removes duplicates).
  print('Activity types (forEach):');
  if (exerciseTypes.isEmpty) {
    print('  (no activity types entered)');
  }
  exerciseTypes.toSet().forEach((type) {
    print('  * $type');
  });
  print('');
}
