// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ProxDroid';

  @override
  String get entityNode => 'Node';

  @override
  String get entityVirtualMachine => 'Virtual Machine';

  @override
  String get entityContainer => 'Container';

  @override
  String get entityStorage => 'Storage';

  @override
  String get entityTask => 'Task';

  @override
  String get entityBackup => 'Backup';

  @override
  String get actionStart => 'Start';

  @override
  String get actionStop => 'Stop';

  @override
  String get actionForceStop => 'Force stop';

  @override
  String get actionReboot => 'Reboot';

  @override
  String get statusRunning => 'Running';

  @override
  String get statusStopped => 'Stopped';

  @override
  String get statusPaused => 'Paused';

  @override
  String get statusUnknown => 'Unknown';

  @override
  String get statusOnline => 'Online';

  @override
  String get statusOffline => 'Offline';

  @override
  String get metricCpu => 'CPU';

  @override
  String get metricMemory => 'Memory';

  @override
  String get metricDisk => 'Disk';

  @override
  String get metricNetwork => 'Network';

  @override
  String get metricUptime => 'Uptime';

  @override
  String get sectionDashboard => 'Dashboard';

  @override
  String get sectionSettings => 'Settings';

  @override
  String get sectionAbout => 'About';

  @override
  String get sectionServers => 'Servers';

  @override
  String get sectionVms => 'Virtual machines';

  @override
  String get sectionContainers => 'Containers';

  @override
  String get sectionBackups => 'Backups';

  @override
  String get sectionTasks => 'Tasks';

  @override
  String get screenAddServer => 'Add server';

  @override
  String get screenEditServer => 'Edit server';

  @override
  String debugScreenBody(String name) {
    return 'Placeholder — $name';
  }
}
