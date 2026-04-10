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

  /// Navigation or screen title for the VM list.
  ///
  /// In en, this message translates to:
  /// **'Virtual machines'**
  String get sectionVms;

  /// Navigation or screen title for the LXC container list.
  ///
  /// In en, this message translates to:
  /// **'Containers'**
  String get sectionContainers;

  /// Navigation or screen title for backup content and jobs.
  ///
  /// In en, this message translates to:
  /// **'Backups'**
  String get sectionBackups;

  /// Navigation or screen title for the Proxmox task viewer.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get sectionTasks;

  /// App bar title for adding a Proxmox server.
  ///
  /// In en, this message translates to:
  /// **'Add server'**
  String get screenAddServer;

  /// App bar title for editing a saved server.
  ///
  /// In en, this message translates to:
  /// **'Edit server'**
  String get screenEditServer;

  /// Short debug label for Phase 0 placeholder screens.
  ///
  /// In en, this message translates to:
  /// **'Placeholder — {name}'**
  String debugScreenBody(String name);

  /// Button label to retry a failed load.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// Button label to save server configuration.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// Button to verify Proxmox connectivity via GET /version.
  ///
  /// In en, this message translates to:
  /// **'Test connection'**
  String get actionTestConnection;

  /// SnackBar action to undo a destructive operation.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get actionUndo;

  /// Button to leave a screen after an error or missing entity.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get actionGoBack;

  /// Tooltip for the server list floating action button.
  ///
  /// In en, this message translates to:
  /// **'Add server'**
  String get serversFabAddTooltip;

  /// Title when no Proxmox servers are configured.
  ///
  /// In en, this message translates to:
  /// **'No servers yet'**
  String get serversEmptyTitle;

  /// Body text for empty server list.
  ///
  /// In en, this message translates to:
  /// **'Add a server to connect to your Proxmox cluster.'**
  String get serversEmptyMessage;

  /// CTA button on empty server list.
  ///
  /// In en, this message translates to:
  /// **'Add server'**
  String get serversEmptyCta;

  /// Generic error when server list fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load servers.'**
  String get serversLoadError;

  /// SnackBar after swipe-to-delete on a server.
  ///
  /// In en, this message translates to:
  /// **'Server removed'**
  String get serverDeletedSnackbar;

  /// Label for the friendly server name field.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get serverFieldName;

  /// Hint for display name field.
  ///
  /// In en, this message translates to:
  /// **'e.g. Home lab'**
  String get serverFieldNameHint;

  /// Label for hostname or IP (HTTPS only, no scheme).
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get serverFieldHost;

  /// Hint for host field.
  ///
  /// In en, this message translates to:
  /// **'proxmox.example.com or 192.168.1.10'**
  String get serverFieldHostHint;

  /// Label for HTTPS API port.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get serverFieldPort;

  /// Label for full PVE API token value.
  ///
  /// In en, this message translates to:
  /// **'API token'**
  String get serverFieldApiToken;

  /// Hint format for API token.
  ///
  /// In en, this message translates to:
  /// **'USER@REALM!TOKENID=SECRET'**
  String get serverFieldApiTokenHint;

  /// Label for Proxmox username (e.g. root@pam).
  ///
  /// In en, this message translates to:
  /// **'User name'**
  String get serverFieldUsername;

  /// Hint for username field.
  ///
  /// In en, this message translates to:
  /// **'root@pam'**
  String get serverFieldUsernameHint;

  /// Label for password field.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get serverFieldPassword;

  /// Segment label for API token authentication.
  ///
  /// In en, this message translates to:
  /// **'API token'**
  String get serverAuthTypeApiToken;

  /// Segment label for username/password authentication.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get serverAuthTypeUsernamePassword;

  /// Section title above auth type and credential fields.
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get serverFormAuthentication;

  /// Switch label to trust self-signed TLS certificates.
  ///
  /// In en, this message translates to:
  /// **'Allow self-signed certificate'**
  String get serverAllowSelfSigned;

  /// Validation when host is empty.
  ///
  /// In en, this message translates to:
  /// **'Enter a host name or IP address.'**
  String get serverHostErrorEmpty;

  /// Validation when host contains http://.
  ///
  /// In en, this message translates to:
  /// **'Do not include http://. The app always uses HTTPS.'**
  String get serverHostErrorHttp;

  /// Validation when host contains https://.
  ///
  /// In en, this message translates to:
  /// **'Enter the host without https:// (scheme is added automatically).'**
  String get serverHostErrorHttps;

  /// Validation when port is not a valid integer in range.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid port number (1–65535).'**
  String get serverPortErrorInvalid;

  /// Validation when display name is empty.
  ///
  /// In en, this message translates to:
  /// **'Enter a display name.'**
  String get serverNameErrorEmpty;

  /// Validation when API token is required but empty.
  ///
  /// In en, this message translates to:
  /// **'Enter your API token.'**
  String get serverApiTokenErrorEmpty;

  /// Validation when username is required but empty.
  ///
  /// In en, this message translates to:
  /// **'Enter your Proxmox user name.'**
  String get serverUsernameErrorEmpty;

  /// Validation when password is required on add.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get serverPasswordErrorEmpty;

  /// Hint on edit when password optional.
  ///
  /// In en, this message translates to:
  /// **'Leave blank to keep the current password.'**
  String get serverPasswordLeaveBlankHint;

  /// Hint on edit when API token optional.
  ///
  /// In en, this message translates to:
  /// **'Leave blank to keep the current token.'**
  String get serverApiTokenLeaveBlankHint;

  /// Shown when edit route id does not exist.
  ///
  /// In en, this message translates to:
  /// **'This server was not found.'**
  String get serverNotFound;

  /// Error loading server metadata for edit screen.
  ///
  /// In en, this message translates to:
  /// **'Could not open this server for editing.'**
  String get serverEditLoadError;

  /// Mapped message for AuthException.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Check your token or password.'**
  String get errorProxmoxAuth;

  /// Mapped message for NetworkException.
  ///
  /// In en, this message translates to:
  /// **'Network error. Check the host, port, and connectivity.'**
  String get errorProxmoxNetwork;

  /// Mapped message for ApiTimeoutException.
  ///
  /// In en, this message translates to:
  /// **'The request timed out. Try again.'**
  String get errorProxmoxTimeout;

  /// Mapped message for PermissionException.
  ///
  /// In en, this message translates to:
  /// **'Permission denied for this account.'**
  String get errorProxmoxPermission;

  /// Mapped message for ServerException.
  ///
  /// In en, this message translates to:
  /// **'Server returned HTTP {statusCode}.'**
  String errorProxmoxServer(int statusCode);

  /// Fallback for unexpected errors.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get errorProxmoxUnknown;

  /// SnackBar after successful GET /version.
  ///
  /// In en, this message translates to:
  /// **'Connected. Proxmox version {version}.'**
  String serverConnectionTestSuccess(String version);

  /// Shown while connection test runs.
  ///
  /// In en, this message translates to:
  /// **'Testing connection…'**
  String get serverConnectionTestInProgress;

  /// Title for the dashboard summary card.
  ///
  /// In en, this message translates to:
  /// **'Cluster summary'**
  String get dashboardClusterSummary;

  /// Label for total VM count on dashboard.
  ///
  /// In en, this message translates to:
  /// **'Total VMs'**
  String get dashboardSummaryTotalVms;

  /// Label for running (including paused) VM count.
  ///
  /// In en, this message translates to:
  /// **'Running VMs'**
  String get dashboardSummaryRunningVms;

  /// Label for total LXC container count.
  ///
  /// In en, this message translates to:
  /// **'Total containers'**
  String get dashboardSummaryTotalContainers;

  /// Empty state when cluster returns no node resources.
  ///
  /// In en, this message translates to:
  /// **'No nodes'**
  String get dashboardEmptyNodesTitle;

  /// Body for empty dashboard node list.
  ///
  /// In en, this message translates to:
  /// **'No node data was returned for this server.'**
  String get dashboardEmptyNodesMessage;

  /// Filter option meaning no restriction.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// Label for node filter dropdown.
  ///
  /// In en, this message translates to:
  /// **'Node'**
  String get filterByNode;

  /// Label for status filter dropdown.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get filterByStatus;

  /// Status filter: running (VMs include paused).
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get filterRunning;

  /// Status filter: stopped only.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get filterStopped;

  /// Hint for VM list search field.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get searchVmsHint;

  /// Hint for container list search field.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get searchContainersHint;

  /// Empty VM list title.
  ///
  /// In en, this message translates to:
  /// **'No virtual machines'**
  String get vmListEmptyTitle;

  /// Empty VM list body.
  ///
  /// In en, this message translates to:
  /// **'No VMs were returned for this cluster.'**
  String get vmListEmptyMessage;

  /// Empty container list title.
  ///
  /// In en, this message translates to:
  /// **'No containers'**
  String get containerListEmptyTitle;

  /// Empty container list body.
  ///
  /// In en, this message translates to:
  /// **'No LXC containers were returned for this cluster.'**
  String get containerListEmptyMessage;

  /// When filters exclude every row.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get listFilteredEmptyTitle;

  /// Hint when filtered list is empty.
  ///
  /// In en, this message translates to:
  /// **'Try changing search or filters.'**
  String get listFilteredEmptyMessage;

  /// Detail screen when VM id or route is invalid.
  ///
  /// In en, this message translates to:
  /// **'VM not found'**
  String get vmNotFoundTitle;

  /// Body when VM cannot be resolved.
  ///
  /// In en, this message translates to:
  /// **'This VM is not in the current list. Go back and refresh the list.'**
  String get vmNotFoundMessage;

  /// Detail screen when container id or route is invalid.
  ///
  /// In en, this message translates to:
  /// **'Container not found'**
  String get containerNotFoundTitle;

  /// Body when container cannot be resolved.
  ///
  /// In en, this message translates to:
  /// **'This container is not in the current list. Go back and refresh the list.'**
  String get containerNotFoundMessage;

  /// Label for QEMU guest ID.
  ///
  /// In en, this message translates to:
  /// **'VM ID'**
  String get labelVmid;

  /// Label for LXC container ID.
  ///
  /// In en, this message translates to:
  /// **'CT ID'**
  String get labelCtid;

  /// Label for LXC ostype field.
  ///
  /// In en, this message translates to:
  /// **'OS type'**
  String get labelContainerOsType;

  /// Placeholder when a numeric or text value is missing.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get valueUnavailable;
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
