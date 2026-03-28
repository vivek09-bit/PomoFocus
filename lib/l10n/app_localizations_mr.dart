// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'PomoFocus';

  @override
  String get settings => 'सेटिंग्ज';

  @override
  String get timerDurations => '⏱️ टायमरची वेळ';

  @override
  String get workMinutes => 'काम (मिनिटे)';

  @override
  String get shortBreakMinutes => 'लहान ब्रेक (मिनिटे)';

  @override
  String get longBreakMinutes => 'मोठा ब्रेक (मिनिटे)';

  @override
  String get sessionsBeforeLongBreak => 'मोठ्या ब्रेकपूर्वीची सत्रे';

  @override
  String get preferences => '⚙️ प्राधान्ये';

  @override
  String get autoStart => 'पुढील सत्र स्वयंचलितपणे सुरू करा';

  @override
  String get autoStartSubtitle => 'टायमर संपल्यावर स्वयंचलितपणे सुरू करा';

  @override
  String get playAlarmOnce => 'अलार्म फक्त एकदा वाजवा';

  @override
  String get playAlarmOnceSubtitle => 'बंद असल्यास थांबवेपर्यंत अलार्म वाजेल';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get alarmSound => '🔔 अलार्मचा आवाज';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get saveSettings => 'सेटिंग्ज जतन करा';

  @override
  String get bell => '🔔 घंटी';

  @override
  String get notification => '📱 सूचना';

  @override
  String get churchBell => '🎵 चर्चची घंटी';

  @override
  String get realityBell => '🔊 रियलिटी घंटी';

  @override
  String get silent => '🔇 शांत';

  @override
  String get newTask => 'नवीन कार्य';

  @override
  String get taskName => 'कार्याचे नाव';

  @override
  String get estimatedPomodoros => 'अंदाजे पोमोडोरो 🍅';

  @override
  String get addTask => 'कार्य जोडा';

  @override
  String get logDistraction => 'लक्ष विचलित नोंदवा';

  @override
  String get whatDistractedYou => 'तुमचे लक्ष कशाने विचलित केले?';

  @override
  String get logIt => 'नोंदवा';

  @override
  String get focusSessionDone => '🎉 कामाचे सत्र पूर्ण! आता ब्रेक घ्या.';

  @override
  String get breakOver => '⚡ ब्रेक संपला! कामासाठी तयार?';

  @override
  String get focusSessionRunning => 'कामाचे सत्र चालू आहे...';

  @override
  String get breakTimeRunning => 'ब्रेकची वेळ चालू आहे...';

  @override
  String get focusSessionComplete => 'कामाचे सत्र पूर्ण झाले!';

  @override
  String get breakComplete => 'ब्रेक पूर्ण झाला!';

  @override
  String get readyForBreak => 'लहान ब्रेकसाठी तयार आहात?';

  @override
  String get readyToFocus => 'कामावर लक्ष केंद्रित करण्यासाठी तयार?';

  @override
  String get timer => 'टायमर';

  @override
  String get tasks => 'कार्ये';

  @override
  String get stats => 'आकडेवारी';

  @override
  String get focusTime => 'कामाची वेळ';

  @override
  String get longBreak => 'मोठा ब्रेक';

  @override
  String get shortBreak => 'लहान ब्रेक';

  @override
  String get language => 'भाषा';

  @override
  String sessionNumber(Object count) {
    return 'सत्र #$count';
  }

  @override
  String get reset => 'रीसेट करा';

  @override
  String get skip => 'सोडा';

  @override
  String get goToTasks => 'कार्य निवडण्यासाठी कार्यांवर (Tasks) जा';

  @override
  String get stopAlarm => 'अलार्म थांबवा';

  @override
  String get autoStartOn => 'स्वयंचलित प्रारंभ चालू';

  @override
  String get active => 'सक्रिय';

  @override
  String get select => 'निवडा';

  @override
  String get noTasksYet => 'अद्याप कोणतीही कार्ये नाहीत';

  @override
  String get tapToAddFirstTask => 'तुमचे पहिले कार्य जोडण्यासाठी + वर टॅप करा';

  @override
  String get today => 'आज';

  @override
  String get sessionsCount => 'सत्रे';

  @override
  String get allTime => 'सर्वकाळ';

  @override
  String get totalFocusTime => 'एकूण लक्ष केंद्रित वेळ';

  @override
  String get totalFocusTimeLabel => '🕐 एकूण लक्ष केंद्रित वेळ';

  @override
  String minutesApproxHours(int minutes, String hours) {
    return '$minutes मिनिटे ≈ $hours तास';
  }

  @override
  String get sessionHistory => 'सत्र इतिहास';

  @override
  String get noSessionsYet => 'अद्याप कोणतेही सत्र नाही';

  @override
  String get completeSessionToSee => 'इथे इतिहास पाहण्यासाठी एक सत्र पूर्ण करा';

  @override
  String get clearAll => 'सर्व साफ करा';

  @override
  String get noDistractionsLogged => 'लक्ष विचलित नोंदवले नाही!';

  @override
  String get tapToLogOne =>
      'नोंदवण्यासाठी लक्ष केंद्रित सत्रादरम्यान ⚠️ टॅप करा';

  @override
  String distractionsTitle(Object count) {
    return 'वयतयय ($count)';
  }

  @override
  String get totalLabel => 'एकण';

  @override
  String get focusLabel => 'एकगरत';
}
