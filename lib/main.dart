import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pomodoratimerapp/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:wakelock_plus/wakelock_plus.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock to portrait mode to prevent rotation-based Impeller/Vulkan crashes on certain devices
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  tz.initializeTimeZones();
  
  if (!kIsWeb) {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
        
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  runApp(const PomodoroApp());
}

// ─────────────────────────────────────────────
//  MODELS
// ─────────────────────────────────────────────

class Task {
  String title;
  bool isCompleted;
  int completedPomodoros;
  int estimatedPomodoros;

  Task({
    required this.title,
    this.isCompleted = false,
    this.completedPomodoros = 0,
    this.estimatedPomodoros = 1,
  });
}

class SessionRecord {
  final DateTime time;
  final String type; // 'work' | 'short_break' | 'long_break'
  final int durationMinutes;

  SessionRecord({
    required this.time,
    required this.type,
    required this.durationMinutes,
  });
}

class DistractionNote {
  final String note;
  final DateTime time;

  DistractionNote({required this.note, required this.time});
}

// ─────────────────────────────────────────────
//  APP ROOT
// ─────────────────────────────────────────────

class PomodoroApp extends StatefulWidget {
  const PomodoroApp({super.key});

  @override
  State<PomodoroApp> createState() => _PomodoroAppState();
}

class _PomodoroAppState extends State<PomodoroApp> {
  bool isDarkMode = false;
  String localeCode = 'en';

  @override
  void initState() {
    super.initState();
    _loadInitialLocale();
  }

  Future<void> _loadInitialLocale() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      localeCode = prefs.getString('localeCode') ?? 'en';
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  void toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    setState(() => isDarkMode = value);
  }

  void changeLocale(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('localeCode', code);
    setState(() => localeCode = code);
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final base = isDark ? ThemeData.dark() : ThemeData.light();
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFF44336),
        brightness: brightness,
      ),
      textTheme: GoogleFonts.outfitTextTheme(base.textTheme),
      scaffoldBackgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      cardColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      useMaterial3: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)?.appTitle ?? 'PomoFocus',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(localeCode),
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        onThemeToggle: toggleTheme,
        isDarkMode: isDarkMode,
        currentLocale: localeCode,
        onLocaleChange: changeLocale,
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HOME SCREEN (holds all state)
// ─────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  final ValueChanged<bool> onThemeToggle;
  final ValueChanged<String> onLocaleChange;
  final bool isDarkMode;
  final String currentLocale;

  const HomeScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
    required this.onLocaleChange,
    required this.currentLocale,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  // ── Navigation ──
  int _currentTab = 0;

  // ── Timer Settings ──
  int workDuration = 25 * 60;
  int shortBreakDuration = 5 * 60;
  int longBreakDuration = 15 * 60;
  int sessionsBeforeLongBreak = 4;
  bool autoStart = false;
  bool playAlarmOnce = false;
  String selectedSound = 'bell';

  // ── Timer State ──
  int timeLeft = 25 * 60;
  int sessionCount = 0;
  bool isRunning = false;
  bool isWorkSession = true;
  bool isAlarmRinging = false;
  Timer? _timer;
  DateTime? _endTime;

  // ── Tasks ──
  List<Task> tasks = [];
  int selectedTaskIndex = -1;

  // ── Stats / History ──
  List<SessionRecord> sessionHistory = [];
  List<DistractionNote> distractions = [];

  // ── Audio ──
  final AudioPlayer _audioPlayer = AudioPlayer();

  // ── Animations ──
  late AnimationController _colorController;
  late Animation<Color?> _bgAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
        
    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bgAnimation = ColorTween(
      begin: const Color(0xFF0F172A),
      end: const Color(0xFF0F172A),
    ).animate(_colorController);
    _loadPrefs();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _audioPlayer.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (kIsWeb) return;
    if (state == AppLifecycleState.paused) {
      if (isRunning && _endTime != null) {
        _scheduleNotification();
      }
    } else if (state == AppLifecycleState.resumed) {
      flutterLocalNotificationsPlugin.cancelAll();
      if (isRunning && _endTime != null) {
        final remaining = _endTime!.difference(DateTime.now()).inSeconds;
        if (remaining <= 0) {
          _onSessionComplete();
        } else {
          setState(() => timeLeft = remaining);
        }
      }
    }
  }

  Future<void> _scheduleNotification() async {
    await flutterLocalNotificationsPlugin.show(
      1,
      'Pomodoro Timer',
      isWorkSession ? 'Focus session is running...' : 'Break time is running...',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'pomodoro_ongoing',
          'Ongoing Timer',
          channelDescription: 'Shows that the timer is active',
          importance: Importance.low,
          priority: Priority.low,
          ongoing: true,
          autoCancel: false,
        ),
      ),
    );

    final title = isWorkSession ? 'Focus Session Complete!' : 'Break Complete!';
    final body = isWorkSession ? 'Ready for a short break?' : 'Ready to focus?';
    
    final scheduledDate = tz.TZDateTime.from(_endTime!, tz.local);
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) return;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'pomodoro_alerts',
          'Pomodoro Alerts',
          channelDescription: 'Alerts when pomodoro timers finish',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ─── Persistence ─────────────────────────────

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      workDuration = (prefs.getInt('workDuration') ?? 25) * 60;
      shortBreakDuration = (prefs.getInt('shortBreak') ?? 5) * 60;
      longBreakDuration = (prefs.getInt('longBreak') ?? 15) * 60;
      sessionsBeforeLongBreak = prefs.getInt('sessionsBeforeLongBreak') ?? 4;
      autoStart = prefs.getBool('autoStart') ?? false;
      playAlarmOnce = prefs.getBool('playAlarmOnce') ?? false;
      selectedSound = prefs.getString('selectedSound') ?? 'bell';
      timeLeft = workDuration;
    });
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('workDuration', workDuration ~/ 60);
    await prefs.setInt('shortBreak', shortBreakDuration ~/ 60);
    await prefs.setInt('longBreak', longBreakDuration ~/ 60);
    await prefs.setInt('sessionsBeforeLongBreak', sessionsBeforeLongBreak);
    await prefs.setBool('autoStart', autoStart);
    await prefs.setBool('playAlarmOnce', playAlarmOnce);
    await prefs.setString('selectedSound', selectedSound);
  }

  // ─── Timer Logic ─────────────────────────────

  void stopAlarm() {
    _audioPlayer.stop();
    setState(() => isAlarmRinging = false);
  }

  void startTimer() {
    if (isAlarmRinging) stopAlarm();
    if (isRunning) return;
    WakelockPlus.enable(); // Keep screen awake
    _endTime = DateTime.now().add(Duration(seconds: timeLeft));
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remaining = _endTime!.difference(DateTime.now()).inSeconds;
      if (remaining <= 0) {
        _onSessionComplete();
      } else {
        setState(() => timeLeft = remaining);
      }
    });
    setState(() => isRunning = true);
  }

  void pauseTimer() {
    if (isAlarmRinging) stopAlarm();
    _timer?.cancel();
    WakelockPlus.disable();
    setState(() => isRunning = false);
  }

  void resetTimer() {
    if (isAlarmRinging) stopAlarm();
    _timer?.cancel();
    WakelockPlus.disable();
    setState(() {
      timeLeft = workDuration;
      isRunning = false;
      isWorkSession = true;
      sessionCount = 0;
    });
  }

  void _onSessionComplete() {
    _timer?.cancel();
    WakelockPlus.disable();
    
    // Native flutter haptic pulse instead of third-party plugin that fails on latest Android
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 250), HapticFeedback.heavyImpact);
    Future.delayed(const Duration(milliseconds: 500), HapticFeedback.heavyImpact);

    _playAlertSound();

    final completedType = isWorkSession
        ? 'work'
        : (sessionCount % sessionsBeforeLongBreak == 0
            ? 'long_break'
            : 'short_break');
    final completedDurationMin = isWorkSession
        ? workDuration ~/ 60
        : (sessionCount % sessionsBeforeLongBreak == 0
            ? longBreakDuration ~/ 60
            : shortBreakDuration ~/ 60);

    setState(() {
      sessionHistory.add(SessionRecord(
        time: DateTime.now(),
        type: completedType,
        durationMinutes: completedDurationMin,
      ));

      if (isWorkSession) {
        sessionCount++;
        if (selectedTaskIndex != -1 && selectedTaskIndex < tasks.length) {
          tasks[selectedTaskIndex].completedPomodoros++;
        }
        timeLeft = (sessionCount % sessionsBeforeLongBreak == 0)
            ? longBreakDuration
            : shortBreakDuration;
      } else {
        timeLeft = workDuration;
      }

      isWorkSession = !isWorkSession;
      isRunning = false;
    });

    _showSessionSnackBar(completedType);

    if (autoStart) {
      Future.delayed(const Duration(seconds: 1), startTimer);
    }
  }

  void _showSessionSnackBar(String completedType) {
    if (!mounted) return;
    final msg = completedType == 'work'
        ? '🎉 Focus session done! Time for a break.'
        : '⚡ Break over! Ready to focus?';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.outfit()),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _playAlertSound() async {
    if (selectedSound == 'none') return;
    try {
      final sounds = {
        'bell': 'sounds/bell-bowl.wav',
        'digital': 'sounds/new-notification.wav',
        'chime': 'sounds/single-church-bell.wav',
        'reality': 'sounds/soundreality-bell.wav',
      };
      
      await _audioPlayer.setReleaseMode(playAlarmOnce ? ReleaseMode.release : ReleaseMode.loop);
      
      if (!playAlarmOnce) {
        setState(() => isAlarmRinging = true);
      }
      
      await _audioPlayer.play(AssetSource(sounds[selectedSound] ?? sounds['bell']!));
    } catch (_) {
      // Sound fails gracefully — visual notification always shows
    }
  }

  // ─── Settings Dialog ─────────────────────────

  void _openSettings() {
    final workCtrl =
        TextEditingController(text: (workDuration ~/ 60).toString());
    final shortCtrl =
        TextEditingController(text: (shortBreakDuration ~/ 60).toString());
    final longCtrl =
        TextEditingController(text: (longBreakDuration ~/ 60).toString());
    final sessCtrl =
        TextEditingController(text: sessionsBeforeLongBreak.toString());

    String tempSound = selectedSound;
    bool tempAutoStart = autoStart;
    bool tempPlayAlarmOnce = playAlarmOnce;
    bool tempDark = widget.isDarkMode;
    String tempLocale = widget.currentLocale;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.settings_outlined),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(ctx)?.settings ?? 'Settings', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            ],
          ),
          scrollable: true,
          content: SizedBox(
            width: 340,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel(AppLocalizations.of(ctx)?.timerDurations ?? '⏱️ Timer Durations'),
                const SizedBox(height: 8),
                _settingField(workCtrl, AppLocalizations.of(ctx)?.workMinutes ?? 'Work (minutes)'),
                _settingField(shortCtrl, AppLocalizations.of(ctx)?.shortBreakMinutes ?? 'Short Break (minutes)'),
                _settingField(longCtrl, AppLocalizations.of(ctx)?.longBreakMinutes ?? 'Long Break (minutes)'),
                _settingField(sessCtrl, AppLocalizations.of(ctx)?.sessionsBeforeLongBreak ?? 'Sessions before long break'),
                const Divider(height: 28),
                _sectionLabel(AppLocalizations.of(ctx)?.preferences ?? '⚙️ Preferences'),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(AppLocalizations.of(ctx)?.autoStart ?? 'Auto-start next session'),
                  subtitle: Text(AppLocalizations.of(ctx)?.autoStartSubtitle ?? 'Automatically begin next session when timer ends'),
                  value: tempAutoStart,
                  activeColor: _sessionColor,
                  onChanged: (v) => setLocal(() => tempAutoStart = v),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(AppLocalizations.of(ctx)?.playAlarmOnce ?? 'Play alarm only once'),
                  subtitle: Text(AppLocalizations.of(ctx)?.playAlarmOnceSubtitle ?? 'If off, alarm loops until you stop it'),
                  value: tempPlayAlarmOnce,
                  activeColor: _sessionColor,
                  onChanged: (v) => setLocal(() => tempPlayAlarmOnce = v),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(AppLocalizations.of(ctx)?.darkMode ?? 'Dark Mode'),
                  value: tempDark,
                  activeColor: _sessionColor,
                  onChanged: (v) => setLocal(() => tempDark = v),
                ),
                const Divider(height: 28),
                _sectionLabel(AppLocalizations.of(ctx)?.alarmSound ?? '🔔 Alarm Sound'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: ['bell', 'digital', 'chime', 'reality', 'none'].contains(tempSound) ? tempSound : 'bell',
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: 'bell', child: Text(AppLocalizations.of(ctx)?.bell ?? '🔔 Bell Bowl')),
                    DropdownMenuItem(
                        value: 'digital', child: Text(AppLocalizations.of(ctx)?.notification ?? '📱 Notification')),
                    DropdownMenuItem(value: 'chime', child: Text(AppLocalizations.of(ctx)?.churchBell ?? '🎵 Church Bell')),
                    DropdownMenuItem(value: 'reality', child: Text(AppLocalizations.of(ctx)?.realityBell ?? '🔊 Reality Bell')),
                    DropdownMenuItem(value: 'none', child: Text(AppLocalizations.of(ctx)?.silent ?? '🔇 Silent')),
                  ],
                  onChanged: (v) => setLocal(() => tempSound = v!),
                ),
                const Divider(height: 28),
                _sectionLabel(AppLocalizations.of(ctx)?.language ?? '🌍 Language'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: tempLocale,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'hi', child: Text('हिन्दी (Hindi)')),
                    DropdownMenuItem(value: 'mr', child: Text('मराठी (Marathi)')),
                    DropdownMenuItem(value: 'ta', child: Text('தமிழ் (Tamil)')),
                    DropdownMenuItem(value: 'te', child: Text('తెలుగు (Telugu)')),
                    DropdownMenuItem(value: 'en_IN', child: Text('Hinglish')),
                  ],
                  onChanged: (v) => setLocal(() => tempLocale = v!),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(AppLocalizations.of(ctx)?.cancel ?? 'Cancel'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  workDuration = (int.tryParse(workCtrl.text) ?? 25) * 60;
                  shortBreakDuration =
                      (int.tryParse(shortCtrl.text) ?? 5) * 60;
                  longBreakDuration =
                      (int.tryParse(longCtrl.text) ?? 15) * 60;
                  sessionsBeforeLongBreak =
                      int.tryParse(sessCtrl.text) ?? 4;
                  autoStart = tempAutoStart;
                  playAlarmOnce = tempPlayAlarmOnce;
                  selectedSound = tempSound;
                  timeLeft = workDuration;
                  isRunning = false;
                  _timer?.cancel();
                });
                widget.onThemeToggle(tempDark);
                if (tempLocale != widget.currentLocale) {
                  widget.onLocaleChange(tempLocale);
                }
                _savePrefs();
                Navigator.pop(ctx);
              },
              child: Text(AppLocalizations.of(ctx)?.saveSettings ?? 'Save Settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) =>
      Text(text, style: GoogleFonts.outfit(fontWeight: FontWeight.w600));

  Widget _settingField(TextEditingController ctrl, String label) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            isDense: true,
          ),
        ),
      );

  // ─── Task Actions ─────────────────────────────

  void _addTask() {
    final titleCtrl = TextEditingController();
    final estCtrl = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.newTask ?? 'New Task', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              autofocus: true,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.taskName ?? 'Task name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: estCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.estimatedPomodoros ?? 'Estimated pomodoros 🍅',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                isDense: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel')),
          FilledButton(
            onPressed: () {
              if (titleCtrl.text.trim().isEmpty) return;
              setState(() {
                tasks.add(Task(
                  title: titleCtrl.text.trim(),
                  estimatedPomodoros: int.tryParse(estCtrl.text) ?? 1,
                ));
              });
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)?.addTask ?? 'Add Task'),
          ),
        ],
      ),
    );
  }

  // ─── Distraction Logging ──────────────────────

  void _logDistraction() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.amber),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context)?.logDistraction ?? 'Log Distraction',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ],
        ),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)?.whatDistractedYou ?? 'What distracted you?',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel')),
          FilledButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                setState(() {
                  distractions.add(DistractionNote(
                    note: ctrl.text.trim(),
                    time: DateTime.now(),
                  ));
                });
              }
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)?.logIt ?? 'Log It'),
          ),
        ],
      ),
    );
  }

  // ─── Computed Helpers ─────────────────────────

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Color get _sessionColor {
    if (isWorkSession) return const Color(0xFFF44336); // Red for Work
    if (sessionCount % sessionsBeforeLongBreak == 0) {
      return const Color(0xFF2196F3); // Blue for Long Break
    }
    return const Color(0xFF4CAF50); // Green for Short Break
  }

  String _getSessionLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (isWorkSession) return l10n?.focusTime ?? 'Focus Time';
    if (sessionCount % sessionsBeforeLongBreak == 0) return l10n?.longBreak ?? 'Long Break';
    return l10n?.shortBreak ?? 'Short Break';
  }

  double get _sessionTotal {
    if (isWorkSession) return workDuration.toDouble();
    if (sessionCount % sessionsBeforeLongBreak == 0) {
      return longBreakDuration.toDouble();
    }
    return shortBreakDuration.toDouble();
  }

  int get _todayWorkSessions {
    final today = DateTime.now();
    return sessionHistory
        .where((s) =>
            s.type == 'work' &&
            s.time.year == today.year &&
            s.time.month == today.month &&
            s.time.day == today.day)
        .length;
  }

  int get _todayFocusMinutes {
    final today = DateTime.now();
    return sessionHistory
        .where((s) =>
            s.type == 'work' &&
            s.time.year == today.year &&
            s.time.month == today.month &&
            s.time.day == today.day)
        .fold(0, (sum, s) => sum + s.durationMinutes);
  }

  // ─────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _buildTimerTab(),
      _buildTasksTab(),
      _buildStatsTab(),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: tabs[_currentTab],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTab,
        onDestinationSelected: (i) => setState(() => _currentTab = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.timer_outlined),
            selectedIcon: const Icon(Icons.timer),
            label: AppLocalizations.of(context)?.timer ?? 'Timer',
          ),
          NavigationDestination(
            icon: const Icon(Icons.checklist_outlined),
            selectedIcon: const Icon(Icons.checklist),
            label: AppLocalizations.of(context)?.tasks ?? 'Tasks',
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: AppLocalizations.of(context)?.stats ?? 'Stats',
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  TIMER TAB
  // ─────────────────────────────────────────────

  Widget _buildTimerTab() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progress = timeLeft / _sessionTotal;

    return Container(
      key: const ValueKey('timer'),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
              : [const Color(0xFFF8FAFC), const Color(0xFFEEF2FF)],
        ),
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // ── App Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset('assets/images/appstore.png', width: 32, height: 32),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'PomoFocus',
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      // Distraction button (only during active focus)
                      if (isRunning && isWorkSession)
                        IconButton(
                          onPressed: _logDistraction,
                          tooltip: 'Log a distraction',
                          icon: const Icon(Icons.warning_amber_rounded,
                              color: Colors.amber),
                        ),
                      IconButton(
                        onPressed: _openSettings,
                        icon: const Icon(Icons.settings_outlined),
                        tooltip: 'Settings',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ── Session Label ──
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: _sessionColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _sessionColor.withOpacity(0.3)),
              ),
              child: Text(
                _getSessionLabel(context),
                style: GoogleFonts.outfit(
                  color: _sessionColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 44),

            // ── Timer Circle ──
            Stack(
              alignment: Alignment.center,
              children: [
                // Glow effect
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _sessionColor.withOpacity(0.18),
                        blurRadius: 60,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
                // Progress ring
                SizedBox(
                  width: 230,
                  height: 230,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 10,
                    backgroundColor: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation(_sessionColor),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                // Time + label
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(timeLeft),
                      style: GoogleFonts.outfit(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -2,
                      ),
                    ),
                    Text(
                      autoStart ? (AppLocalizations.of(context)?.autoStartOn ?? 'Auto-start ON') : AppLocalizations.of(context)?.sessionNumber(sessionCount + 1) ?? 'Session #${sessionCount + 1}',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 48),

            // ── Control Buttons ──
            if (isAlarmRinging)
              GestureDetector(
                onTap: stopAlarm,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: Colors.redAccent.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.notifications_off, color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Text(AppLocalizations.of(context)?.stopAlarm ?? 'Stop Alarm', style: GoogleFonts.outfit(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _iconControlButton(
                      Icons.refresh, AppLocalizations.of(context)?.reset ?? 'Reset', resetTimer, theme),
                  const SizedBox(width: 20),
                  _primaryPlayButton(),
                  const SizedBox(width: 20),
                  _iconControlButton(
                      Icons.skip_next, AppLocalizations.of(context)?.skip ?? 'Skip', () {
                        if (isAlarmRinging) stopAlarm();
                        _onSessionComplete();
                      }, theme),
                ],
              ),

            const SizedBox(height: 32),

            // ── Session Progress Dots ──
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(sessionsBeforeLongBreak, (i) {
                final done = i < (sessionCount % sessionsBeforeLongBreak);
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: done ? 22 : 12,
                  height: 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: done
                        ? _sessionColor
                        : (isDark ? Colors.white24 : Colors.black12),
                  ),
                );
              }),
            ),

            const Spacer(),

            // ── Active Task Banner ──
            if (selectedTaskIndex != -1 &&
                selectedTaskIndex < tasks.length)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.radio_button_checked,
                        color: _sessionColor, size: 16),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        tasks[selectedTaskIndex].title,
                        style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${tasks[selectedTaskIndex].completedPomodoros}'
                      '/${tasks[selectedTaskIndex].estimatedPomodoros} 🍅',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  AppLocalizations.of(context)?.goToTasks ?? 'Go to Tasks to select a task',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline),
                ),
              ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _primaryPlayButton() {
    return GestureDetector(
      onTap: isRunning ? pauseTimer : startTimer,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _sessionColor,
          boxShadow: [
            BoxShadow(
              color: _sessionColor.withOpacity(0.45),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(
          isRunning ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  Widget _iconControlButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
    ThemeData theme,
  ) {
    return Column(
      children: [
        IconButton.outlined(
          onPressed: onPressed,
          icon: Icon(icon),
          style: IconButton.styleFrom(
            side: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.3)),
          ),
        ),
        const SizedBox(height: 2),
        Text(label,
            style: GoogleFonts.outfit(
                fontSize: 11, color: theme.colorScheme.outline)),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  TASKS TAB
  // ─────────────────────────────────────────────

  Widget _buildTasksTab() {
    final theme = Theme.of(context);

    return Scaffold(
      key: const ValueKey('tasks'),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset('assets/images/appstore.png'),
          ),
        ),
        title: Text(AppLocalizations.of(context)?.tasks ?? 'Tasks',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          if (tasks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                '${tasks.where((t) => t.isCompleted).length}/${tasks.length} done',
                style: theme.textTheme.bodySmall,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTask,
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)?.addTask ?? 'Add Task', style: GoogleFonts.outfit()),
        backgroundColor: _sessionColor,
        foregroundColor: Colors.white,
      ),
      body: tasks.isEmpty
          ? _emptyState(
              theme,
              Icons.checklist_rounded,
              AppLocalizations.of(context)?.noTasksYet ?? 'No tasks yet',
              AppLocalizations.of(context)?.tapToAddFirstTask ?? 'Tap + to add your first task',
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: tasks.length,
              itemBuilder: (_, i) => _buildTaskTile(tasks[i], i, theme),
            ),
    );
  }

  Widget _buildTaskTile(Task task, int i, ThemeData theme) {
    final isSelected = selectedTaskIndex == i;

    return Dismissible(
      key: Key('task_$i${task.title}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child:
            const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) {
        setState(() {
          if (selectedTaskIndex == i) selectedTaskIndex = -1;
          if (selectedTaskIndex > i) selectedTaskIndex--;
          tasks.removeAt(i);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isSelected ? _sessionColor.withOpacity(0.08) : theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? _sessionColor : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          leading: Checkbox(
            value: task.isCompleted,
            activeColor: _sessionColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            onChanged: (v) => setState(() => task.isCompleted = v!),
          ),
          title: Text(
            task.title,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w600,
              decoration:
                  task.isCompleted ? TextDecoration.lineThrough : null,
              color: task.isCompleted ? theme.colorScheme.outline : null,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Text(
                  '${task.completedPomodoros}/${task.estimatedPomodoros} 🍅',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(width: 8),
                // Mini progress bar
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: task.estimatedPomodoros > 0
                          ? (task.completedPomodoros /
                                  task.estimatedPomodoros)
                              .clamp(0, 1)
                          : 0,
                      backgroundColor: theme.colorScheme.outline.withOpacity(0.15),
                      valueColor: AlwaysStoppedAnimation(_sessionColor),
                      minHeight: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          trailing: GestureDetector(
            onTap: () =>
                setState(() => selectedTaskIndex = isSelected ? -1 : i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? _sessionColor
                    : theme.colorScheme.outline.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isSelected ? (AppLocalizations.of(context)?.active ?? 'Active') : (AppLocalizations.of(context)?.select ?? 'Select'),
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : theme.colorScheme.outline,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  STATS TAB
  // ─────────────────────────────────────────────

  Widget _buildStatsTab() {
    final theme = Theme.of(context);
    final totalWorkSessions =
        sessionHistory.where((s) => s.type == 'work').length;
    final totalFocusMinutes =
        sessionHistory.where((s) => s.type == 'work').fold(
              0,
              (sum, s) => sum + s.durationMinutes,
            );

    return Scaffold(
      key: const ValueKey('stats'),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset('assets/images/appstore.png'),
          ),
        ),
        title: Text(AppLocalizations.of(context)?.stats ?? 'Statistics',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Today Summary Cards ──
          Text(AppLocalizations.of(context)?.today ?? 'Today',
              style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _statCard('🍅\n${AppLocalizations.of(context)?.sessionsCount ?? 'Sessions'}', '$_todayWorkSessions',
                      theme)),
              const SizedBox(width: 12),
              Expanded(
                  child: _statCard('⏱️\n${AppLocalizations.of(context)?.focusTime ?? 'Focus Time'}',
                      '${_todayFocusMinutes}m', theme)),
              const SizedBox(width: 12),
              Expanded(
                  child: _statCard('📊\n${AppLocalizations.of(context)?.allTime ?? 'All Time'}',
                      '$totalWorkSessions ${AppLocalizations.of(context)?.sessionsCount ?? 'sessions'}', theme)),
            ],
          ),

          const SizedBox(height: 8),

          // Total focus time all time
          _wideStatCard(
            AppLocalizations.of(context)?.totalFocusTimeLabel ?? '🕐 Total Focus Time',
            AppLocalizations.of(context)?.minutesApproxHours(totalFocusMinutes, (totalFocusMinutes / 60).toStringAsFixed(1)) ?? '${totalFocusMinutes} minutes  ≈  ${(totalFocusMinutes / 60).toStringAsFixed(1)} hours',
            theme,
          ),

          const SizedBox(height: 28),

          // ── Session History ──
          Row(
            children: [
              Text(AppLocalizations.of(context)?.sessionHistory ?? 'Session History',
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const Spacer(),
              if (sessionHistory.isNotEmpty)
                Text(
                  '${sessionHistory.length} ${AppLocalizations.of(context)?.totalLabel ?? 'total'}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (sessionHistory.isEmpty)
            _emptyState(theme, Icons.history, AppLocalizations.of(context)?.noSessionsYet ?? 'No sessions yet',
                AppLocalizations.of(context)?.completeSessionToSee ?? 'Complete a session to see history here')
          else
            ...sessionHistory.reversed
                .take(20)
                .map((s) => _sessionHistoryTile(s, theme)),

          const SizedBox(height: 28),

          // ── Distractions ──
          Row(
            children: [
              Text(
                  AppLocalizations.of(context)?.distractionsTitle(distractions.length) ?? 'Distractions (${distractions.length})',
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const Spacer(),
              if (distractions.isNotEmpty)
                TextButton(
                  onPressed: () => setState(() => distractions.clear()),
                  child: const Text('Clear all'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (distractions.isEmpty)
            _emptyState(
              theme,
              Icons.check_circle_outline,
              AppLocalizations.of(context)?.noDistractionsLogged ?? 'No distractions logged!',
              AppLocalizations.of(context)?.tapToLogOne ?? 'Tap ⚠️ during a focus session to log one',
            )
          else
            ...distractions.reversed.map((d) => _distractionTile(d, theme)),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.outfit(fontSize: 11, height: 1.7,
                  color: theme.colorScheme.outline)),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _sessionColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _wideStatCard(String title, String value, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _sessionColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _sessionColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time_rounded, color: _sessionColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.outfit(
                        fontSize: 11, color: theme.colorScheme.outline)),
                Text(value,
                    style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sessionHistoryTile(SessionRecord s, ThemeData theme) {
    final icon =
        s.type == 'work' ? '💻' : s.type == 'long_break' ? '🛌' : '☕';
    final label = s.type == 'work'
        ? (AppLocalizations.of(context)?.focusLabel ?? 'Focus')
        : s.type == 'long_break'
            ? (AppLocalizations.of(context)?.longBreak ?? 'Long Break')
            : (AppLocalizations.of(context)?.shortBreak ?? 'Short Break');
    final timeStr =
        '${s.time.hour.toString().padLeft(2, '0')}:${s.time.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text('$label · ${s.durationMinutes} min',
                style: GoogleFonts.outfit(fontWeight: FontWeight.w500)),
          ),
          Text(timeStr,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.outline)),
        ],
      ),
    );
  }

  Widget _distractionTile(DistractionNote d, ThemeData theme) {
    final timeStr =
        '${d.time.hour.toString().padLeft(2, '0')}:${d.time.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
              child: Text(d.note,
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w500))),
          Text(timeStr,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.outline)),
        ],
      ),
    );
  }

  Widget _emptyState(
      ThemeData theme, IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(icon, size: 56, color: theme.colorScheme.outline.withOpacity(0.5)),
          const SizedBox(height: 12),
          Text(title,
              style: GoogleFonts.outfit(
                  fontSize: 16, color: theme.colorScheme.outline)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: theme.colorScheme.outline.withOpacity(0.7))),
        ],
      ),
    );
  }
}
