// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'PomoFocus';

  @override
  String get settings => 'సెట్టింగ్‌లు';

  @override
  String get timerDurations => '⏱️ టైమర్ వ్యవధులు';

  @override
  String get workMinutes => 'పని (నిమిషాలు)';

  @override
  String get shortBreakMinutes => 'చిన్న విరామం (నిమిషాలు)';

  @override
  String get longBreakMinutes => 'పెద్ద విరామం (నిమిషాలు)';

  @override
  String get sessionsBeforeLongBreak => 'పెద్ద విరామానికి ముందు సెషన్లు';

  @override
  String get preferences => '⚙️ ప్రాధాన్యతలు';

  @override
  String get autoStart => 'తదుపరి సెషన్‌ను స్వయంచాలకంగా ప్రారంభించండి';

  @override
  String get autoStartSubtitle =>
      'టైమర్ ముగిసినప్పుడు స్వయంచాలకంగా ప్రారంభించండి';

  @override
  String get playAlarmOnce => 'అలారం ఒక్కసారి మాత్రమే మోగించండి';

  @override
  String get playAlarmOnceSubtitle => 'లేకపోతే, మీరు ఆపేంత వరకు మోగుతుంది';

  @override
  String get darkMode => 'డార్క్ మోడ్';

  @override
  String get alarmSound => '🔔 అలారం ధ్వని';

  @override
  String get cancel => 'రద్దు చేయండి';

  @override
  String get saveSettings => 'సెట్టింగ్‌లను సేవ్ చేయండి';

  @override
  String get bell => '🔔 గంట';

  @override
  String get notification => '📱 నోటిఫికేషన్';

  @override
  String get churchBell => '🎵 చర్చి గంట';

  @override
  String get realityBell => '🔊 రియాలిటీ గంట';

  @override
  String get silent => '🔇 నిశ్శబ్దం';

  @override
  String get newTask => 'కొత్త విధి';

  @override
  String get taskName => 'విధి పేరు';

  @override
  String get estimatedPomodoros => 'అంచనా వేసిన పోమోడోరోలు 🍅';

  @override
  String get addTask => 'విధిని జోడించండి';

  @override
  String get logDistraction => 'పరధ్యానాన్ని లాగ్ చేయండి';

  @override
  String get whatDistractedYou => 'మిమ్మల్ని ఏది పరధ్యానానికి గురి చేసింది?';

  @override
  String get logIt => 'లాగ్ చేయండి';

  @override
  String get focusSessionDone => '🎉 పని సెషన్ పూర్తయింది! విరామం తీసుకోండి.';

  @override
  String get breakOver => '⚡ విరామం ముగిసింది! పనికి సిద్ధమా?';

  @override
  String get focusSessionRunning => 'పని సెషన్ నడుస్తోంది...';

  @override
  String get breakTimeRunning => 'విరామం సమయం నడుస్తోంది...';

  @override
  String get focusSessionComplete => 'పని సెషన్ పూర్తయింది!';

  @override
  String get breakComplete => 'విరామం పూర్తయింది!';

  @override
  String get readyForBreak => 'చిన్న విరామానికి సిద్ధమా?';

  @override
  String get readyToFocus => 'దృష్టి పెట్టడానికి సిద్ధమా?';

  @override
  String get timer => 'టైమర్';

  @override
  String get tasks => 'పనులు';

  @override
  String get stats => 'గణాంకాలు';

  @override
  String get focusTime => 'పని సమయం';

  @override
  String get longBreak => 'పెద్ద విరామం';

  @override
  String get shortBreak => 'చిన్న విరామం';

  @override
  String get language => 'భాష';

  @override
  String sessionNumber(Object count) {
    return 'సెషన్ #$count';
  }

  @override
  String get reset => 'రీసెట్ చేయండి';

  @override
  String get skip => 'దాటవేయి';

  @override
  String get goToTasks => 'పనిని ఎంచుకోవడానికి పనులకు (Tasks) వెళ్ళండి';

  @override
  String get stopAlarm => 'అలారం ఆపండి';

  @override
  String get autoStartOn => 'స్వయంచాలక ప్రారంభం ఆన్';

  @override
  String get active => 'క్రియాశీలమైనది';

  @override
  String get select => 'ఎంచుకోండి';

  @override
  String get noTasksYet => 'ఇంకా పనులు లేవు';

  @override
  String get tapToAddFirstTask => 'మీ మొదటి పనిని జోడించడానికి + నొక్కండి';

  @override
  String get today => 'ఈ రోజు';

  @override
  String get sessionsCount => 'సెషన్లు';

  @override
  String get allTime => 'అన్ని సమయాలు';

  @override
  String get totalFocusTime => 'కలిపిన పని సమయం';

  @override
  String get totalFocusTimeLabel => '🕐 కలిపిన పని సమయం';

  @override
  String minutesApproxHours(int minutes, String hours) {
    return '$minutes నిమిషాలు ≈ $hours గంటలు';
  }

  @override
  String get sessionHistory => 'సెషన్ చరిత్ర';

  @override
  String get noSessionsYet => 'ఇంకా సెషన్లు లేవు';

  @override
  String get completeSessionToSee =>
      'చరిత్రను చూడటానికి సెషన్‌ను పూర్తి చేయండి';

  @override
  String get clearAll => 'అన్నీ తుడిచివేయండి';

  @override
  String get noDistractionsLogged => 'ఎలాంటి పరధ్యానాలు లాగ్ చేయబడలేదు!';

  @override
  String get tapToLogOne => 'లాగ్ చేయడానికి సెషన్ సమయంలో ⚠️ నొక్కండి';

  @override
  String distractionsTitle(Object count) {
    return 'పరధయనల ($count)';
  }

  @override
  String get totalLabel => 'మతత';

  @override
  String get focusLabel => 'ఏకగరత';
}
