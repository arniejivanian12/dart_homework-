// Shared helpers for reading user input from the terminal.
// Every section uses these so input works the same everywhere.
import 'dart:io';

import 'section3_oop.dart';

// Asks a question and returns the text the user typed (trimmed).
String askText(String question) {
  stdout.write(question);
  String? line = stdin.readLineSync();
  // null means the input was closed (e.g. Ctrl+D): stop the program.
  if (line == null) {
    print('\nInput closed. Goodbye!');
    exit(0);
  }
  return line.trim();
}

// Asks until the user types a whole number that is 0 or more.
int askInt(String question) {
  while (true) {
    int? value = int.tryParse(askText(question));
    if (value != null && value >= 0) {
      return value;
    }
    if (value != null) {
      print('  The number cannot be negative.');
    } else {
      print('  Please type a whole number (example: 30).');
    }
  }
}

// Asks until the user types a number that is 0 or more (decimals allowed).
double askDouble(String question) {
  while (true) {
    double? value = double.tryParse(askText(question));
    if (value != null && value >= 0) {
      return value;
    }
    if (value != null) {
      print('  The number cannot be negative.');
    } else {
      print('  Please type a number (example: 120.5).');
    }
  }
}

// Asks for one activity and creates the right object for its type.
// Returns null when the user types 0 (finished entering).
// Additional activity-specific validation is handled in Section 4.
Activity? askActivity() {
  print('');
  print('Activity type: 1) Walking  2) Running  3) Swimming  4) Other  0) Done');

  while (true) {
    String type = askText('Choose type: ');
    DateTime today = DateTime.now();

    switch (type) {
      case '0':
        return null;
      case '1':
        int duration = askInt('Duration (minutes): ');
        double calories = askDouble('Calories burned: ');
        int steps = askInt('Steps: ');
        return WalkingActivity('Walking', duration, calories, today, steps);
      case '2':
        int duration = askInt('Duration (minutes): ');
        double calories = askDouble('Calories burned: ');
        double distance = askDouble('Distance (km): ');
        return RunningActivity('Running', duration, calories, today, distance);
      case '3':
        int duration = askInt('Duration (minutes): ');
        double calories = askDouble('Calories burned: ');
        int laps = askInt('Laps: ');
        return SwimmingActivity('Swimming', duration, calories, today, laps);
      case '4':
        String name = askText('Activity name: ');
        int duration = askInt('Duration (minutes): ');
        double calories = askDouble('Calories burned: ');
        return Activity(name, duration, calories, today);
      default:
        print('  Please type 0, 1, 2, 3 or 4.');
    }
  }
}
