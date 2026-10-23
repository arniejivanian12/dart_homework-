// Main display page: a simple menu in the terminal that runs each section.
import 'dart:io';

import 'package:activity_tracker/section1_basics.dart';
import 'package:activity_tracker/section2_collections.dart';
import 'package:activity_tracker/section3_oop.dart';
import 'package:activity_tracker/section4_errors.dart';
import 'package:activity_tracker/section5_async.dart';

void printMenu() {
  print('');
  print('==============================================');
  print('     DAILY SPORTS ACTIVITY MANAGER (Dart)     ');
  print('==============================================');
  print('  1. Section 1 - Basics');
  print('  2. Section 2 - Collections');
  print('  3. Section 3 - Object-Oriented Programming');
  print('  4. Section 4 - Error Handling');
  print('  5. Section 5 - Asynchronous Programming');
  print('  6. Run all sections');
  print('  7. Start my day (enter your activities)');
  print('  0. Exit');
  print('----------------------------------------------');
  stdout.write('Choose an option: ');
}

void printTitle(String title) {
  print('');
  print('############## $title ##############');
  print('');
}

void pause() {
  stdout.write('Press Enter to continue... | اضغط Enter للمتابعة... ');
  stdin.readLineSync();
}

Future<void> runChoice(String choice) async {
  switch (choice) {
    case '1':
      printTitle('SECTION 1: BASICS');
      runSection1();
      pause();
    case '2':
      printTitle('SECTION 2: COLLECTIONS');
      runSection2();
      pause();
    case '3':
      printTitle('SECTION 3: OOP');
      runSection3();
      pause();
    case '4':
      printTitle('SECTION 4: ERROR HANDLING');
      runSection4();
      pause();
    case '5':
      printTitle('SECTION 5: ASYNC PROGRAMMING');
      await runSection5();
      pause();
    case '6':
      for (var i = 1; i <= 5; i++) {
        await runChoice('$i');
      }
    case '7':
      printTitle('MY DAY');
      await part5FullDay();
      pause();
    default:
      print('Invalid option, please try again.');
  }
}

Future<void> main() async {
  while (true) {
    printMenu();
    final choice = stdin.readLineSync()?.trim() ?? '0';

    if (choice == '0') {
      print('Goodbye!');
      break;
    }

    await runChoice(choice);
  }
}
