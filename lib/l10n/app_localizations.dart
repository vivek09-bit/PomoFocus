import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('en', 'IN'),
    Locale('hi'),
    Locale('mr'),
    Locale('ta'),
    Locale('te'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'PomoFocus'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @timerDurations.
  ///
  /// In en, this message translates to:
  /// **'⏱️ Timer Durations'**
  String get timerDurations;

  /// No description provided for @workMinutes.
  ///
  /// In en, this message translates to:
  /// **'Work (minutes)'**
  String get workMinutes;

  /// No description provided for @shortBreakMinutes.
  ///
  /// In en, this message translates to:
  /// **'Short Break (minutes)'**
  String get shortBreakMinutes;

  /// No description provided for @longBreakMinutes.
  ///
  /// In en, this message translates to:
  /// **'Long Break (minutes)'**
  String get longBreakMinutes;

  /// No description provided for @sessionsBeforeLongBreak.
  ///
  /// In en, this message translates to:
  /// **'Sessions before long break'**
  String get sessionsBeforeLongBreak;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'⚙️ Preferences'**
  String get preferences;

  /// No description provided for @autoStart.
  ///
  /// In en, this message translates to:
  /// **'Auto-start next session'**
  String get autoStart;

  /// No description provided for @autoStartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Automatically begin next session when timer ends'**
  String get autoStartSubtitle;

  /// No description provided for @playAlarmOnce.
  ///
  /// In en, this message translates to:
  /// **'Play alarm only once'**
  String get playAlarmOnce;

  /// No description provided for @playAlarmOnceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'If off, alarm loops until you stop it'**
  String get playAlarmOnceSubtitle;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @alarmSound.
  ///
  /// In en, this message translates to:
  /// **'🔔 Alarm Sound'**
  String get alarmSound;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @saveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get saveSettings;

  /// No description provided for @bell.
  ///
  /// In en, this message translates to:
  /// **'🔔 Bell Bowl'**
  String get bell;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'📱 Notification'**
  String get notification;

  /// No description provided for @churchBell.
  ///
  /// In en, this message translates to:
  /// **'🎵 Church Bell'**
  String get churchBell;

  /// No description provided for @realityBell.
  ///
  /// In en, this message translates to:
  /// **'🔊 Reality Bell'**
  String get realityBell;

  /// No description provided for @silent.
  ///
  /// In en, this message translates to:
  /// **'🔇 Silent'**
  String get silent;

  /// No description provided for @newTask.
  ///
  /// In en, this message translates to:
  /// **'New Task'**
  String get newTask;

  /// No description provided for @taskName.
  ///
  /// In en, this message translates to:
  /// **'Task name'**
  String get taskName;

  /// No description provided for @estimatedPomodoros.
  ///
  /// In en, this message translates to:
  /// **'Estimated pomodoros 🍅'**
  String get estimatedPomodoros;

  /// No description provided for @addTask.
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get addTask;

  /// No description provided for @logDistraction.
  ///
  /// In en, this message translates to:
  /// **'Log Distraction'**
  String get logDistraction;

  /// No description provided for @whatDistractedYou.
  ///
  /// In en, this message translates to:
  /// **'What distracted you?'**
  String get whatDistractedYou;

  /// No description provided for @logIt.
  ///
  /// In en, this message translates to:
  /// **'Log It'**
  String get logIt;

  /// No description provided for @focusSessionDone.
  ///
  /// In en, this message translates to:
  /// **'🎉 Focus session done! Time for a break.'**
  String get focusSessionDone;

  /// No description provided for @breakOver.
  ///
  /// In en, this message translates to:
  /// **'⚡ Break over! Ready to focus?'**
  String get breakOver;

  /// No description provided for @focusSessionRunning.
  ///
  /// In en, this message translates to:
  /// **'Focus session is running...'**
  String get focusSessionRunning;

  /// No description provided for @breakTimeRunning.
  ///
  /// In en, this message translates to:
  /// **'Break time is running...'**
  String get breakTimeRunning;

  /// No description provided for @focusSessionComplete.
  ///
  /// In en, this message translates to:
  /// **'Focus Session Complete!'**
  String get focusSessionComplete;

  /// No description provided for @breakComplete.
  ///
  /// In en, this message translates to:
  /// **'Break Complete!'**
  String get breakComplete;

  /// No description provided for @readyForBreak.
  ///
  /// In en, this message translates to:
  /// **'Ready for a short break?'**
  String get readyForBreak;

  /// No description provided for @readyToFocus.
  ///
  /// In en, this message translates to:
  /// **'Ready to focus?'**
  String get readyToFocus;

  /// No description provided for @timer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timer;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @focusTime.
  ///
  /// In en, this message translates to:
  /// **'Focus Time'**
  String get focusTime;

  /// No description provided for @longBreak.
  ///
  /// In en, this message translates to:
  /// **'Long Break'**
  String get longBreak;

  /// No description provided for @shortBreak.
  ///
  /// In en, this message translates to:
  /// **'Short Break'**
  String get shortBreak;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @sessionNumber.
  ///
  /// In en, this message translates to:
  /// **'Session #{count}'**
  String sessionNumber(Object count);

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @goToTasks.
  ///
  /// In en, this message translates to:
  /// **'Go to Tasks to select a task'**
  String get goToTasks;

  /// No description provided for @stopAlarm.
  ///
  /// In en, this message translates to:
  /// **'Stop Alarm'**
  String get stopAlarm;

  /// No description provided for @autoStartOn.
  ///
  /// In en, this message translates to:
  /// **'Auto-start ON'**
  String get autoStartOn;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @noTasksYet.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get noTasksYet;

  /// No description provided for @tapToAddFirstTask.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first task'**
  String get tapToAddFirstTask;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @sessionsCount.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessionsCount;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get allTime;

  /// No description provided for @totalFocusTime.
  ///
  /// In en, this message translates to:
  /// **'Total Focus Time'**
  String get totalFocusTime;

  /// No description provided for @totalFocusTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'🕐 Total Focus Time'**
  String get totalFocusTimeLabel;

  /// No description provided for @minutesApproxHours.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes ≈ {hours} hours'**
  String minutesApproxHours(int minutes, String hours);

  /// No description provided for @sessionHistory.
  ///
  /// In en, this message translates to:
  /// **'Session History'**
  String get sessionHistory;

  /// No description provided for @noSessionsYet.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet'**
  String get noSessionsYet;

  /// No description provided for @completeSessionToSee.
  ///
  /// In en, this message translates to:
  /// **'Complete a session to see history here'**
  String get completeSessionToSee;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @noDistractionsLogged.
  ///
  /// In en, this message translates to:
  /// **'No distractions logged!'**
  String get noDistractionsLogged;

  /// No description provided for @tapToLogOne.
  ///
  /// In en, this message translates to:
  /// **'Tap ⚠️ during a focus session to log one'**
  String get tapToLogOne;

  /// No description provided for @distractionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Distractions ({count})'**
  String distractionsTitle(Object count);

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'total'**
  String get totalLabel;

  /// No description provided for @focusLabel.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get focusLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'mr', 'ta', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en':
      {
        switch (locale.countryCode) {
          case 'IN':
            return AppLocalizationsEnIn();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
