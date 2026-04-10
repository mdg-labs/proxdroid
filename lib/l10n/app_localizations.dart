import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Application title shown in the system UI (e.g. task switcher, launcher label).
  ///
  /// In en, this message translates to:
  /// **'ProxDroid'**
  String get appTitle;

  /// Proxmox cluster node entity label (matches PVE terminology).
  ///
  /// In en, this message translates to:
  /// **'Node'**
  String get entityNode;

  /// QEMU/KVM virtual machine entity label (matches PVE terminology).
  ///
  /// In en, this message translates to:
  /// **'Virtual Machine'**
  String get entityVirtualMachine;

  /// LXC container entity label (matches PVE terminology).
  ///
  /// In en, this message translates to:
  /// **'Container'**
  String get entityContainer;

  /// Storage pool or volume entity label (matches PVE terminology).
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get entityStorage;

  /// Proxmox task (UPID) entity label (matches PVE terminology).
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get entityTask;

  /// Backup job or backup content entity label (matches PVE terminology).
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get entityBackup;

  /// Action to start a VM or container.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get actionStart;

  /// Action to gracefully stop a VM or container.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get actionStop;

  /// Action to forcibly stop a VM or container (hard stop).
  ///
  /// In en, this message translates to:
  /// **'Force stop'**
  String get actionForceStop;

  /// Action to reboot a VM or container.
  ///
  /// In en, this message translates to:
  /// **'Reboot'**
  String get actionReboot;

  /// Resource is running.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get statusRunning;

  /// Resource is stopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get statusStopped;

  /// VM is paused (not used for LXC in MVP).
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get statusPaused;

  /// Status could not be determined.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get statusUnknown;

  /// Node or service is reachable (online).
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get statusOnline;

  /// Node or service is not reachable (offline).
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get statusOffline;

  /// Label for CPU usage metric.
  ///
  /// In en, this message translates to:
  /// **'CPU'**
  String get metricCpu;

  /// Label for memory (RAM) usage metric.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get metricMemory;

  /// Label for disk usage or I/O metric.
  ///
  /// In en, this message translates to:
  /// **'Disk'**
  String get metricDisk;

  /// Label for network traffic metric.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get metricNetwork;

  /// Label for uptime duration metric.
  ///
  /// In en, this message translates to:
  /// **'Uptime'**
  String get metricUptime;

  /// Navigation or screen title for the cluster/node dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get sectionDashboard;

  /// Navigation or screen title for app settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get sectionSettings;

  /// Navigation or screen title for about / app info.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get sectionAbout;

  /// Navigation or screen title for configured Proxmox servers list.
  ///
  /// In en, this message translates to:
  /// **'Servers'**
  String get sectionServers;
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
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
