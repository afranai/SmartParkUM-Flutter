
import 'package:flutter/foundation.dart';

class ClassSchedule {
  final String subject;
  final String day;
  final String time;
  final String faculty;
  final String building;

  ClassSchedule({
    required this.subject,
    required this.day,
    required this.time,
    required this.faculty,
    required this.building,
  });
}

class LocalAccount {
  final String name;
  final String identity;
  final String password;

  LocalAccount({
    required this.name,
    required this.identity,
    required this.password,
  });
}

class AppData {
  static String name = 'Naila';
  static String nim = '2300000000';
  static String email = 'naila@student.um.ac.id';
  static String faculty = 'Fakultas Teknik';
  static bool loggedIn = false;

  static final List<ClassSchedule> schedules = [];
  static final List<LocalAccount> accounts = [];

  // Notifier untuk memberi tahu semua halaman ketika jadwal berubah.
  static final ValueNotifier<int> scheduleVersion = ValueNotifier<int>(0);

  static void notifyScheduleChanged() {
    scheduleVersion.value++;
  }
}
