// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'PomoFocus';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get timerDurations => '⏱️ டைமர் காலங்கள்';

  @override
  String get workMinutes => 'வேலை (நிமிடங்கள்)';

  @override
  String get shortBreakMinutes => 'சிறிய இடைவேளை (நிமிடங்கள்)';

  @override
  String get longBreakMinutes => 'நீண்ட இடைவேளை (நிமிடங்கள்)';

  @override
  String get sessionsBeforeLongBreak => 'நீண்ட இடைவேளைக்கு முன் அமர்வுகள்';

  @override
  String get preferences => '⚙️ விருப்பங்கள்';

  @override
  String get autoStart => 'அடுத்த அமர்வை தானாக தொடங்கவும்';

  @override
  String get autoStartSubtitle => 'டைமர் முடிந்தவுடன் தானாக தொடங்கவும்';

  @override
  String get playAlarmOnce => 'அலாரத்தை ஒருமுறை மட்டும் ஒலிக்கவும்';

  @override
  String get playAlarmOnceSubtitle =>
      'இல்லையெனினில், நீங்கள் நிறுத்தும் வரை ஒலிக்கும்';

  @override
  String get darkMode => 'டார்க் மோட்';

  @override
  String get alarmSound => '🔔 அலாரம் ஒலி';

  @override
  String get cancel => 'ரத்துசெய்';

  @override
  String get saveSettings => 'அமைப்புகளைச் சேமி';

  @override
  String get bell => '🔔 மணி';

  @override
  String get notification => '📱 அறிவிப்பு';

  @override
  String get churchBell => '🎵 தேவாலய மணி';

  @override
  String get realityBell => '🔊 ரியாலிட்டி மணி';

  @override
  String get silent => '🔇 அமைதி';

  @override
  String get newTask => 'புதிய பணி';

  @override
  String get taskName => 'பணியின் பெயர்';

  @override
  String get estimatedPomodoros => 'மதிப்பிடப்பட்ட போமோடோரோக்கள் 🍅';

  @override
  String get addTask => 'பணியைச் சேர்';

  @override
  String get logDistraction => 'கவனச்சிதறலைப் பதிவுசெய்';

  @override
  String get whatDistractedYou => 'உங்களைக் கவனச்சிதறச் செய்தது எது?';

  @override
  String get logIt => 'பதிவுசெய்';

  @override
  String get focusSessionDone =>
      '🎉 வேலை அமர்வு முடிந்தது! இடைவேளைக்கான நேரம்.';

  @override
  String get breakOver => '⚡ இடைவேளை முடிந்தது! வேலைக்கு தயாராகிறீர்களா?';

  @override
  String get focusSessionRunning => 'வேலை அமர்வு நடக்கிறது...';

  @override
  String get breakTimeRunning => 'இடைவேளை நேரம் நடக்கிறது...';

  @override
  String get focusSessionComplete => 'வேலை அமர்வு முடிந்தது!';

  @override
  String get breakComplete => 'இடைவேளை முடிந்தது!';

  @override
  String get readyForBreak => 'சிறிய இடைவேளைக்கு தயாராகிறீர்களா?';

  @override
  String get readyToFocus => 'கவனம் செலுத்த தயாராகிறீர்களா?';

  @override
  String get timer => 'டைமர்';

  @override
  String get tasks => 'பணிகள்';

  @override
  String get stats => 'புள்ளிவிவரங்கள்';

  @override
  String get focusTime => 'கவன நேரம்';

  @override
  String get longBreak => 'நீண்ட இடைவேளை';

  @override
  String get shortBreak => 'சிறிய இடைவேளை';

  @override
  String get language => 'மொழி';

  @override
  String sessionNumber(Object count) {
    return 'அமர்வு #$count';
  }

  @override
  String get reset => 'மீட்டமை';

  @override
  String get skip => 'தவிர்';

  @override
  String get goToTasks =>
      'பணியைத் தேர்ந்தெடுக்க பணிகளுக்குச் (Tasks) செல்லவும்';

  @override
  String get stopAlarm => 'அலாரத்தை நிறுத்து';

  @override
  String get autoStartOn => 'தானியங்கி தொடக்கம் ஆன்';

  @override
  String get active => 'செயலில் உள்ளது';

  @override
  String get select => 'தேர்ந்தெடு';

  @override
  String get noTasksYet => 'இதுவரை எந்த பணிகளும் இல்லை';

  @override
  String get tapToAddFirstTask => 'உங்கள் முதல் பணியைச் சேர்க்க + ஐத் தட்டவும்';

  @override
  String get today => 'இன்று';

  @override
  String get sessionsCount => 'அமர்வுகள்';

  @override
  String get allTime => 'எல்லா நேரமும்';

  @override
  String get totalFocusTime => 'மொத்த கவன நேரம்';

  @override
  String get totalFocusTimeLabel => '🕐 மொத்த கவன நேரம்';

  @override
  String minutesApproxHours(int minutes, String hours) {
    return '$minutes நிமிடங்கள் ≈ $hours மணி';
  }

  @override
  String get sessionHistory => 'அமர்வு வரலாறு';

  @override
  String get noSessionsYet => 'இதுவரை அமர்வுகள் இல்லை';

  @override
  String get completeSessionToSee =>
      'இங்கே வரலாற்றைப் பார்க்க ஒரு அமர்வை முடிக்கவும்';

  @override
  String get clearAll => 'அனைத்தையும் அழிக்கவும்';

  @override
  String get noDistractionsLogged =>
      'எந்தக் கவனச்சிதறலும் பதிவு செய்யப்படவில்லை!';

  @override
  String get tapToLogOne => 'கவனச்சிதறலைப் பதிவு செய்ய ⚠️ ஐத் தட்டவும்';

  @override
  String distractionsTitle(Object count) {
    return 'கவனசசதறலகள ($count)';
  }

  @override
  String get totalLabel => 'மததம';

  @override
  String get focusLabel => 'கவனம';
}
