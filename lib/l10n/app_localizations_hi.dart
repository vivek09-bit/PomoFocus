// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'PomoFocus';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get timerDurations => '⏱️ टाइमर की अवधि';

  @override
  String get workMinutes => 'काम (मिनट)';

  @override
  String get shortBreakMinutes => 'छोटा ब्रेक (मिनट)';

  @override
  String get longBreakMinutes => 'लंबा ब्रेक (मिनट)';

  @override
  String get sessionsBeforeLongBreak => 'लंबे ब्रेक से पहले सत्र';

  @override
  String get preferences => '⚙️ प्राथमिकताएं';

  @override
  String get autoStart => 'अगला सत्र स्वतः प्रारंभ करें';

  @override
  String get autoStartSubtitle =>
      'टाइमर समाप्त होने पर स्वतः अगला सत्र शुरू करें';

  @override
  String get playAlarmOnce => 'अलार्म केवल एक बार बजाएं';

  @override
  String get playAlarmOnceSubtitle =>
      'यदि बंद है, तो अलार्म आपके रोकने तक बजता रहेगा';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get alarmSound => '🔔 अलार्म ध्वनि';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get saveSettings => 'सेटिंग्स सहेजें';

  @override
  String get bell => '🔔 घंटी';

  @override
  String get notification => '📱 सूचना';

  @override
  String get churchBell => '🎵 चर्च की घंटी';

  @override
  String get realityBell => '🔊 रियलिटी घंटी';

  @override
  String get silent => '🔇 शांत';

  @override
  String get newTask => 'नया कार्य';

  @override
  String get taskName => 'कार्य का नाम';

  @override
  String get estimatedPomodoros => 'अनुमानित पोमोडोरो 🍅';

  @override
  String get addTask => 'कार्य जोड़ें';

  @override
  String get logDistraction => 'ध्यान भटकाने वाली बातें दर्ज करें';

  @override
  String get whatDistractedYou => 'आपका ध्यान किसने भटकाया?';

  @override
  String get logIt => 'इसे दर्ज करें';

  @override
  String get focusSessionDone => '🎉 काम का सत्र पूरा हुआ! अब ब्रेक लें।';

  @override
  String get breakOver => '⚡ ब्रेक खत्म! काम शुरू करने के लिए तैयार?';

  @override
  String get focusSessionRunning => 'काम का सत्र चल रहा है...';

  @override
  String get breakTimeRunning => 'ब्रेक का समय चल रहा है...';

  @override
  String get focusSessionComplete => 'काम का सत्र पूरा हुआ!';

  @override
  String get breakComplete => 'ब्रेक पूरा हुआ!';

  @override
  String get readyForBreak => 'छोटे ब्रेक के लिए तैयार हैं?';

  @override
  String get readyToFocus => 'काम पर ध्यान केंद्रित करने के लिए तैयार?';

  @override
  String get timer => 'टाइमर';

  @override
  String get tasks => 'कार्य';

  @override
  String get stats => 'आंकड़े';

  @override
  String get focusTime => 'काम का समय';

  @override
  String get longBreak => 'लंबा ब्रेक';

  @override
  String get shortBreak => 'छोटा ब्रेक';

  @override
  String get language => 'भाषा';

  @override
  String sessionNumber(Object count) {
    return 'सत्र #$count';
  }

  @override
  String get reset => 'रीसेट करें';

  @override
  String get skip => 'छोड़ें';

  @override
  String get goToTasks => 'कार्य का चयन करने के लिए कार्य (Tasks) पर जाएं';

  @override
  String get stopAlarm => 'अलार्म रोकें';

  @override
  String get autoStartOn => 'स्वतः प्रारंभ चालू';

  @override
  String get active => 'सक्रिय';

  @override
  String get select => 'चुनें';

  @override
  String get noTasksYet => 'अभी कोई कार्य नहीं';

  @override
  String get tapToAddFirstTask => 'अपना पहला कार्य जोड़ने के लिए + टैप करें';

  @override
  String get today => 'आज';

  @override
  String get sessionsCount => 'सत्र';

  @override
  String get allTime => 'सभी समय';

  @override
  String get totalFocusTime => 'कुल एकाग्र समय';

  @override
  String get totalFocusTimeLabel => '🕐 कुल एकाग्र समय';

  @override
  String minutesApproxHours(int minutes, String hours) {
    return '$minutes मिनट ≈ $hours घंटे';
  }

  @override
  String get sessionHistory => 'सत्र इतिहास';

  @override
  String get noSessionsYet => 'अभी कोई सत्र नहीं';

  @override
  String get completeSessionToSee =>
      'यहां इतिहास देखने के लिए एक सत्र पूरा करें';

  @override
  String get clearAll => 'सभी साफ़ करें';

  @override
  String get noDistractionsLogged => 'कोई ध्यान भंग दर्ज नहीं किया गया!';

  @override
  String get tapToLogOne => 'दर्ज करने के लिए कार्य सत्र के दौरान ⚠️ टैप करें';

  @override
  String distractionsTitle(Object count) {
    return 'धयन भटकव ($count)';
  }

  @override
  String get totalLabel => 'कल';

  @override
  String get focusLabel => 'एकगरत';
}
