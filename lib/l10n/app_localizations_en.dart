// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PomoFocus';

  @override
  String get settings => 'Settings';

  @override
  String get timerDurations => '⏱️ Timer Durations';

  @override
  String get workMinutes => 'Work (minutes)';

  @override
  String get shortBreakMinutes => 'Short Break (minutes)';

  @override
  String get longBreakMinutes => 'Long Break (minutes)';

  @override
  String get sessionsBeforeLongBreak => 'Sessions before long break';

  @override
  String get preferences => '⚙️ Preferences';

  @override
  String get autoStart => 'Auto-start next session';

  @override
  String get autoStartSubtitle =>
      'Automatically begin next session when timer ends';

  @override
  String get playAlarmOnce => 'Play alarm only once';

  @override
  String get playAlarmOnceSubtitle => 'If off, alarm loops until you stop it';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get alarmSound => '🔔 Alarm Sound';

  @override
  String get cancel => 'Cancel';

  @override
  String get saveSettings => 'Save Settings';

  @override
  String get bell => '🔔 Bell Bowl';

  @override
  String get notification => '📱 Notification';

  @override
  String get churchBell => '🎵 Church Bell';

  @override
  String get realityBell => '🔊 Reality Bell';

  @override
  String get silent => '🔇 Silent';

  @override
  String get newTask => 'New Task';

  @override
  String get taskName => 'Task name';

  @override
  String get estimatedPomodoros => 'Estimated pomodoros 🍅';

  @override
  String get addTask => 'Add Task';

  @override
  String get logDistraction => 'Log Distraction';

  @override
  String get whatDistractedYou => 'What distracted you?';

  @override
  String get logIt => 'Log It';

  @override
  String get focusSessionDone => '🎉 Focus session done! Time for a break.';

  @override
  String get breakOver => '⚡ Break over! Ready to focus?';

  @override
  String get focusSessionRunning => 'Focus session is running...';

  @override
  String get breakTimeRunning => 'Break time is running...';

  @override
  String get focusSessionComplete => 'Focus Session Complete!';

  @override
  String get breakComplete => 'Break Complete!';

  @override
  String get readyForBreak => 'Ready for a short break?';

  @override
  String get readyToFocus => 'Ready to focus?';

  @override
  String get timer => 'Timer';

  @override
  String get tasks => 'Tasks';

  @override
  String get stats => 'Stats';

  @override
  String get focusTime => 'Focus Time';

  @override
  String get longBreak => 'Long Break';

  @override
  String get shortBreak => 'Short Break';

  @override
  String get language => 'Language';

  @override
  String sessionNumber(Object count) {
    return 'Session #$count';
  }

  @override
  String get reset => 'Reset';

  @override
  String get skip => 'Skip';

  @override
  String get goToTasks => 'Go to Tasks to select a task';

  @override
  String get stopAlarm => 'Stop Alarm';

  @override
  String get autoStartOn => 'Auto-start ON';

  @override
  String get active => 'Active';

  @override
  String get select => 'Select';

  @override
  String get noTasksYet => 'No tasks yet';

  @override
  String get tapToAddFirstTask => 'Tap + to add your first task';

  @override
  String get today => 'Today';

  @override
  String get sessionsCount => 'Sessions';

  @override
  String get allTime => 'All Time';

  @override
  String get totalFocusTime => 'Total Focus Time';

  @override
  String get totalFocusTimeLabel => '🕐 Total Focus Time';

  @override
  String minutesApproxHours(int minutes, String hours) {
    return '$minutes minutes ≈ $hours hours';
  }

  @override
  String get sessionHistory => 'Session History';

  @override
  String get noSessionsYet => 'No sessions yet';

  @override
  String get completeSessionToSee => 'Complete a session to see history here';

  @override
  String get clearAll => 'Clear all';

  @override
  String get noDistractionsLogged => 'No distractions logged!';

  @override
  String get tapToLogOne => 'Tap ⚠️ during a focus session to log one';

  @override
  String distractionsTitle(Object count) {
    return 'Distractions ($count)';
  }

  @override
  String get totalLabel => 'total';

  @override
  String get focusLabel => 'Focus';
}

/// The translations for English, as used in India (`en_IN`).
class AppLocalizationsEnIn extends AppLocalizationsEn {
  AppLocalizationsEnIn() : super('en_IN');

  @override
  String get appTitle => 'PomoFocus';

  @override
  String get settings => 'Settings';

  @override
  String get timerDurations => '⏱️ Timer Durations';

  @override
  String get workMinutes => 'Kaam (minutes)';

  @override
  String get shortBreakMinutes => 'Chota Break (minutes)';

  @override
  String get longBreakMinutes => 'Lamba Break (minutes)';

  @override
  String get sessionsBeforeLongBreak => 'Lambe break se pehle sessions';

  @override
  String get preferences => '⚙️ Preferences';

  @override
  String get autoStart => 'Agla session auto-start karein';

  @override
  String get autoStartSubtitle =>
      'Timer khatam hone par agla session shuru karein';

  @override
  String get playAlarmOnce => 'Alarm sirf ek baar bajayein';

  @override
  String get playAlarmOnceSubtitle =>
      'Agar band hai, toh roke jaane tak bajega';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get alarmSound => '🔔 Alarm Sound';

  @override
  String get cancel => 'Cancel';

  @override
  String get saveSettings => 'Settings save karein';

  @override
  String get bell => '🔔 Bell Bowl';

  @override
  String get notification => '📱 Notification';

  @override
  String get churchBell => '🎵 Church Bell';

  @override
  String get realityBell => '🔊 Reality Bell';

  @override
  String get silent => '🔇 Silent';

  @override
  String get newTask => 'Naya Task';

  @override
  String get taskName => 'Task ka naam';

  @override
  String get estimatedPomodoros => 'Estimated pomodoros 🍅';

  @override
  String get addTask => 'Task add karein';

  @override
  String get logDistraction => 'Distraction log karein';

  @override
  String get whatDistractedYou => 'Dhyan kisne bhatkaya?';

  @override
  String get logIt => 'Log karein';

  @override
  String get focusSessionDone => '🎉 Kaam ka session poora hua! Ab break lein.';

  @override
  String get breakOver => '⚡ Break khatam! Kaam shuru karne ke liye taiyaar?';

  @override
  String get focusSessionRunning => 'Kaam ka session chal raha hai...';

  @override
  String get breakTimeRunning => 'Break chal raha hai...';

  @override
  String get focusSessionComplete => 'Kaam ka session poora hua!';

  @override
  String get breakComplete => 'Break poora hua!';

  @override
  String get readyForBreak => 'Chhote break ke liye taiyaar?';

  @override
  String get readyToFocus => 'Focus karne ke liye taiyaar?';

  @override
  String get timer => 'Timer';

  @override
  String get tasks => 'Tasks';

  @override
  String get stats => 'Stats';

  @override
  String get focusTime => 'Focus Time';

  @override
  String get longBreak => 'Lamba Break';

  @override
  String get shortBreak => 'Chota Break';

  @override
  String get language => 'Language';

  @override
  String sessionNumber(Object count) {
    return 'Session #$count';
  }

  @override
  String get reset => 'Reset';

  @override
  String get skip => 'Skip';

  @override
  String get goToTasks => 'Task select karne ke liye Tasks par jayein';

  @override
  String get stopAlarm => 'Alarm Rokein';

  @override
  String get autoStartOn => 'Auto-start Chalu';

  @override
  String get active => 'Active';

  @override
  String get select => 'Select';

  @override
  String get noTasksYet => 'Koi tasks nahi';

  @override
  String get tapToAddFirstTask => 'Pehla task jodne ke liye + par tap karein';

  @override
  String get today => 'Aaj';

  @override
  String get sessionsCount => 'Sessions';

  @override
  String get allTime => 'All Time';

  @override
  String get totalFocusTime => 'Kul Focus Time';

  @override
  String get totalFocusTimeLabel => '🕐 Kul Focus Time';

  @override
  String minutesApproxHours(int minutes, String hours) {
    return '$minutes minutes ≈ $hours hours';
  }

  @override
  String get sessionHistory => 'Session History';

  @override
  String get noSessionsYet => 'Koi sessions nahi';

  @override
  String get completeSessionToSee =>
      'Itihas dekhne ke liye session poora karein';

  @override
  String get clearAll => 'Sab saaf karein';

  @override
  String get noDistractionsLogged => 'Koi distraction log nahi hua!';

  @override
  String get tapToLogOne => 'Log karne ke liye ⚠️ tap karein';

  @override
  String distractionsTitle(Object count) {
    return 'Distractions ($count)';
  }

  @override
  String get totalLabel => 'total';

  @override
  String get focusLabel => 'Focus';
}
