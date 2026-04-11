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

  /// Short tagline under the app name in the navigation drawer.
  ///
  /// In en, this message translates to:
  /// **'Proxmox cluster client'**
  String get appDrawerSubtitle;

  /// Navigation drawer group label for servers, dashboard, VMs, containers, storage.
  ///
  /// In en, this message translates to:
  /// **'Infrastructure'**
  String get drawerSectionInfrastructure;

  /// Navigation drawer group label for backups, tasks, settings.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get drawerSectionOperations;

  /// Persistent banner when the device has no connectivity (Phase 6.1).
  ///
  /// In en, this message translates to:
  /// **'No network connection. Some actions may not work until you are back online.'**
  String get offlineBannerMessage;

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

  /// Server list tile subtitle: host and API port (no scheme).
  ///
  /// In en, this message translates to:
  /// **'{host}:{port}'**
  String serverListHostPortSubtitle(String host, int port);

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
  /// **'e.g. root'**
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

  /// Section header for server name, host, and port fields.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get serverFormIdentitySection;

  /// Section title above auth type and credential fields.
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get serverFormAuthentication;

  /// Section header for SSL / certificate options.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get serverFormSecuritySection;

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

  /// Proxmox auth realm (pam, pve, ldap, …).
  ///
  /// In en, this message translates to:
  /// **'Realm'**
  String get serverFieldRealm;

  /// Preset realm label for pam.
  ///
  /// In en, this message translates to:
  /// **'Linux PAM (pam)'**
  String get serverRealmPam;

  /// Preset realm label for pve.
  ///
  /// In en, this message translates to:
  /// **'Proxmox VE (pve)'**
  String get serverRealmPve;

  /// Custom realm option in dropdown.
  ///
  /// In en, this message translates to:
  /// **'Other…'**
  String get serverRealmOther;

  /// Label for text field when realm is Other.
  ///
  /// In en, this message translates to:
  /// **'Custom realm'**
  String get serverFieldRealmCustom;

  /// Hint for custom realm.
  ///
  /// In en, this message translates to:
  /// **'e.g. ldap'**
  String get serverFieldRealmCustomHint;

  /// Validator when custom realm is empty.
  ///
  /// In en, this message translates to:
  /// **'Enter a realm.'**
  String get serverRealmErrorEmpty;

  /// Validator for custom realm characters.
  ///
  /// In en, this message translates to:
  /// **'Realm must not contain spaces or @.'**
  String get serverRealmErrorInvalid;

  /// Helper under username/realm for password auth.
  ///
  /// In en, this message translates to:
  /// **'Sign-in uses login@realm (set below).'**
  String get serverLoginComposeHint;

  /// Validator when user types @ in login field.
  ///
  /// In en, this message translates to:
  /// **'Enter only the login name here. Choose the realm below.'**
  String get serverUsernameErrorContainsAt;

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

  /// Second line after summary; detail may be English from Proxmox, Dio, or a proxy.
  ///
  /// In en, this message translates to:
  /// **'{detail}'**
  String errorProxmoxTechnicalDetails(String detail);

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

  /// App bar title for cluster node detail screen.
  ///
  /// In en, this message translates to:
  /// **'Node'**
  String get nodeDetailTitle;

  /// Detail screen when node name is not in the current list.
  ///
  /// In en, this message translates to:
  /// **'Node not found'**
  String get nodeNotFoundTitle;

  /// Body when a node cannot be resolved from the list.
  ///
  /// In en, this message translates to:
  /// **'This node is not in the current list. Go back and refresh the list.'**
  String get nodeNotFoundMessage;

  /// Metric grid label for Proxmox node online/offline state.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get labelNodeHostStatus;

  /// Label for swap usage on node detail.
  ///
  /// In en, this message translates to:
  /// **'Swap'**
  String get metricSwap;

  /// Label for one-minute load average.
  ///
  /// In en, this message translates to:
  /// **'Load (1m)'**
  String get metricLoadAvg1m;

  /// Label for CPU I/O wait when shown on node detail.
  ///
  /// In en, this message translates to:
  /// **'I/O wait'**
  String get metricIoWait;

  /// Label for QEMU guest count on this node.
  ///
  /// In en, this message translates to:
  /// **'Virtual machines'**
  String get metricGuestVms;

  /// Label for LXC count on this node.
  ///
  /// In en, this message translates to:
  /// **'Containers'**
  String get metricGuestContainers;

  /// Running vs total guest count for node detail grid.
  ///
  /// In en, this message translates to:
  /// **'{running} running · {total} total'**
  String nodeDetailRunningTotalCount(int running, int total);

  /// Explains empty node-level Disk I/O chart on Proxmox VE 9+.
  ///
  /// In en, this message translates to:
  /// **'Host disk throughput is not included in node statistics on newer Proxmox VE versions (node RRD no longer exposes read/write rates). Per-guest Disk I/O charts still work on VM and container detail screens.'**
  String get chartDiskIoUnavailableOnNode;

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

  /// Dialog button to dismiss without acting.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// Dialog button to confirm a destructive or important action.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get actionConfirm;

  /// Alert title for graceful shutdown confirmation.
  ///
  /// In en, this message translates to:
  /// **'Shut down guest?'**
  String get powerConfirmStopTitle;

  /// Alert body for graceful shutdown.
  ///
  /// In en, this message translates to:
  /// **'This sends a shutdown signal so the operating system can stop cleanly.'**
  String get powerConfirmStopBody;

  /// Alert title for immediate power-off.
  ///
  /// In en, this message translates to:
  /// **'Force stop?'**
  String get powerConfirmForceStopTitle;

  /// Alert body for force stop.
  ///
  /// In en, this message translates to:
  /// **'The guest will be powered off immediately without a clean shutdown.'**
  String get powerConfirmForceStopBody;

  /// Extra warning in force-stop dialog about data loss.
  ///
  /// In en, this message translates to:
  /// **'Unsaved data may be lost. This is equivalent to pulling the power cord.'**
  String get powerConfirmForceStopWarning;

  /// Alert title for reboot confirmation.
  ///
  /// In en, this message translates to:
  /// **'Reboot guest?'**
  String get powerConfirmRebootTitle;

  /// Alert body for reboot confirmation.
  ///
  /// In en, this message translates to:
  /// **'The guest will restart. Unsaved work may be lost if applications do not shut down cleanly.'**
  String get powerConfirmRebootBody;

  /// SnackBar after a power task completes with OK status.
  ///
  /// In en, this message translates to:
  /// **'{actionName} finished successfully.'**
  String powerActionCompleted(String actionName);

  /// SnackBar or message when Proxmox task status is error.
  ///
  /// In en, this message translates to:
  /// **'The operation finished with an error on the server.'**
  String get powerActionTaskFailed;

  /// When task polling ends in unknown state.
  ///
  /// In en, this message translates to:
  /// **'Could not confirm the final task status.'**
  String get powerActionTaskUnknown;

  /// Empty state title for merged task list.
  ///
  /// In en, this message translates to:
  /// **'No tasks'**
  String get taskListEmptyTitle;

  /// Empty state body for task list.
  ///
  /// In en, this message translates to:
  /// **'No recent tasks were returned for this cluster.'**
  String get taskListEmptyMessage;

  /// Error when task list fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load tasks.'**
  String get taskListLoadError;

  /// Tooltip / label for opening the task list guest filter.
  ///
  /// In en, this message translates to:
  /// **'Filter by guest'**
  String get taskFilterByGuest;

  /// Clears the task list guest filter to show every guest.
  ///
  /// In en, this message translates to:
  /// **'All guests'**
  String get taskFilterAllGuests;

  /// Title for the task list guest filter bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get taskGuestFilterTitle;

  /// Label for resolved VM/CT name or ID in task row.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get taskRowGuest;

  /// Label for task status in row.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get taskRowStatus;

  /// Label for task start time.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get taskRowStarted;

  /// Label for task duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get taskRowDuration;

  /// Task finished successfully (terminal ok).
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get taskStatusCompleted;

  /// Task finished with error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get taskStatusFailed;

  /// Label for node name on task detail.
  ///
  /// In en, this message translates to:
  /// **'Node'**
  String get taskDetailNodeLabel;

  /// Label for raw UPID on task detail.
  ///
  /// In en, this message translates to:
  /// **'UPID'**
  String get taskDetailUpidLabel;

  /// Section title for task log output.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get taskDetailLogTitle;

  /// Placeholder while task log is fetched.
  ///
  /// In en, this message translates to:
  /// **'Loading log…'**
  String get taskDetailLogLoading;

  /// Error when task log request fails.
  ///
  /// In en, this message translates to:
  /// **'Could not load the task log.'**
  String get taskDetailLogError;

  /// When log endpoint returns no lines.
  ///
  /// In en, this message translates to:
  /// **'No log output.'**
  String get taskDetailLogEmpty;

  /// RRD chart range: last hour.
  ///
  /// In en, this message translates to:
  /// **'1h'**
  String get chartTimeframeHour;

  /// RRD chart range: last day.
  ///
  /// In en, this message translates to:
  /// **'1d'**
  String get chartTimeframeDay;

  /// RRD chart range: last week.
  ///
  /// In en, this message translates to:
  /// **'1w'**
  String get chartTimeframeWeek;

  /// RRD chart range: last month.
  ///
  /// In en, this message translates to:
  /// **'1m'**
  String get chartTimeframeMonth;

  /// When RRD series is empty or all-null.
  ///
  /// In en, this message translates to:
  /// **'No chart data for this period.'**
  String get chartNoData;

  /// When rrddata request fails on a chart.
  ///
  /// In en, this message translates to:
  /// **'Could not load chart data.'**
  String get chartLoadError;

  /// Network chart legend for inbound traffic.
  ///
  /// In en, this message translates to:
  /// **'In'**
  String get chartNetworkIn;

  /// Network chart legend for outbound traffic.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get chartNetworkOut;

  /// Disk I/O chart legend for read rate.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get chartDiskRead;

  /// Disk I/O chart legend for write rate.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get chartDiskWrite;

  /// Section title for disk throughput chart (distinct from disk usage).
  ///
  /// In en, this message translates to:
  /// **'Disk I/O'**
  String get chartDiskIoSectionTitle;

  /// Open manual vzdump backup flow from VM/container detail or backups screen.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get actionBackup;

  /// Empty state when no storage is returned for the cluster.
  ///
  /// In en, this message translates to:
  /// **'No storage pools'**
  String get storageEmptyTitle;

  /// Body for empty storage list.
  ///
  /// In en, this message translates to:
  /// **'No storage pools were found on any online node.'**
  String get storageEmptyMessage;

  /// Label above storage usage bar on list cards.
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get storageUsageSection;

  /// Label for supported content kinds (backup, images, …).
  ///
  /// In en, this message translates to:
  /// **'Content types'**
  String get storageContentTypesLabel;

  /// Badge when storage pool is active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get storageActive;

  /// Badge when storage pool is not active.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get storageInactive;

  /// Section title for storage content list.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get storageDetailContentTitle;

  /// When storage content API returns an empty list.
  ///
  /// In en, this message translates to:
  /// **'No volumes in this pool.'**
  String get storageContentEmpty;

  /// Storage pool type (lvm, dir, pbs, …).
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get storageTypeLabel;

  /// Storage id and owning node for dropdown labels.
  ///
  /// In en, this message translates to:
  /// **'{pool} · {node}'**
  String storagePoolOnNode(String pool, String node);

  /// When no backup content rows were aggregated.
  ///
  /// In en, this message translates to:
  /// **'No backup files'**
  String get backupListEmptyTitle;

  /// Body when backup file list is empty.
  ///
  /// In en, this message translates to:
  /// **'No backup volumes were found on storages that support backups.'**
  String get backupListEmptyMessage;

  /// Header for cluster backup job list from GET /cluster/backup.
  ///
  /// In en, this message translates to:
  /// **'Scheduled jobs'**
  String get backupSectionScheduledJobs;

  /// Header for aggregated backup content.
  ///
  /// In en, this message translates to:
  /// **'Backup files'**
  String get backupSectionFiles;

  /// Header for vzdump task history.
  ///
  /// In en, this message translates to:
  /// **'Recent backup tasks'**
  String get backupSectionRecentTasks;

  /// Group title when backup has no vmid (e.g. manual uploads).
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get backupGroupedUnknownGuest;

  /// Comma-separated vmids covered by a backup job.
  ///
  /// In en, this message translates to:
  /// **'Guests: {ids}'**
  String backupJobVmids(String ids);

  /// Next scheduled backup run time.
  ///
  /// In en, this message translates to:
  /// **'Next run: {when}'**
  String backupJobNextRun(String when);

  /// Last backup job run time when API provides it.
  ///
  /// In en, this message translates to:
  /// **'Last run: {when}'**
  String backupJobLastRun(String when);

  /// Bottom sheet title for manual vzdump.
  ///
  /// In en, this message translates to:
  /// **'Run backup'**
  String get backupTriggerTitle;

  /// Field label for VM or LXC selection.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get backupFieldGuest;

  /// Field label for backup target storage pool.
  ///
  /// In en, this message translates to:
  /// **'Destination storage'**
  String get backupFieldStorage;

  /// Vzdump compression option.
  ///
  /// In en, this message translates to:
  /// **'Compression'**
  String get backupFieldCompress;

  /// Vzdump mode snapshot/suspend/stop.
  ///
  /// In en, this message translates to:
  /// **'Backup mode'**
  String get backupFieldMode;

  /// Compression option label.
  ///
  /// In en, this message translates to:
  /// **'Zstandard (zstd)'**
  String get backupCompressZstd;

  /// Compression option label.
  ///
  /// In en, this message translates to:
  /// **'LZO'**
  String get backupCompressLzo;

  /// Compression option label.
  ///
  /// In en, this message translates to:
  /// **'Gzip'**
  String get backupCompressGzip;

  /// No compression.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get backupCompressNone;

  /// Vzdump snapshot mode.
  ///
  /// In en, this message translates to:
  /// **'Snapshot'**
  String get backupModeSnapshot;

  /// Vzdump suspend mode.
  ///
  /// In en, this message translates to:
  /// **'Suspend'**
  String get backupModeSuspend;

  /// Vzdump stop mode.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get backupModeStop;

  /// Submit button for vzdump bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Start backup'**
  String get backupTriggerStart;

  /// When no pool has backup content type for vzdump target.
  ///
  /// In en, this message translates to:
  /// **'No storage supports backups in this cluster.'**
  String get backupNoDestinationStorage;

  /// FAB on backup list screen.
  ///
  /// In en, this message translates to:
  /// **'Run backup'**
  String get backupFabTooltip;

  /// Generic format label (backup vma/tar, …).
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get labelFormat;

  /// Proxmox volume id / path label.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get labelVolumeId;

  /// Storage content kind (backup, iso, …).
  ///
  /// In en, this message translates to:
  /// **'Kind'**
  String get labelContentKind;

  /// Label for free space on a storage pool.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get storageLabelAvailable;

  /// Free space on a storage pool.
  ///
  /// In en, this message translates to:
  /// **'Available: {size}'**
  String storageAvailableSpace(String size);

  /// Dismiss a dialog (e.g. license summary).
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// Subtitle for Settings row that opens the server list.
  ///
  /// In en, this message translates to:
  /// **'Add, edit, or switch the active Proxmox server.'**
  String get settingsServersSubtitle;

  /// Settings row title for the Preferences screen.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settingsPreferencesTitle;

  /// Subtitle for Settings row that opens Preferences (appearance + charts).
  ///
  /// In en, this message translates to:
  /// **'Theme, default chart time range, and other app preferences.'**
  String get settingsPreferencesSubtitle;

  /// App bar title on the Preferences screen.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesScreenTitle;

  /// Preferences section for chart-related defaults.
  ///
  /// In en, this message translates to:
  /// **'Charts'**
  String get preferencesChartsSection;

  /// Label for the default RRD chart timeframe control.
  ///
  /// In en, this message translates to:
  /// **'Default time range'**
  String get preferencesDefaultChartTimeframeTitle;

  /// Explains where the default chart timeframe applies.
  ///
  /// In en, this message translates to:
  /// **'Used for CPU, memory, network, and disk charts on VM, container, and node detail screens.'**
  String get preferencesDefaultChartTimeframeSubtitle;

  /// Settings section: theme / display.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceSection;

  /// Settings section: connection diagnostics and advanced options.
  ///
  /// In en, this message translates to:
  /// **'Troubleshooting'**
  String get settingsTroubleshootingSection;

  /// Toggle: show a technical dialog after a failed Test connection.
  ///
  /// In en, this message translates to:
  /// **'Verbose connection errors'**
  String get settingsVerboseConnectionErrors;

  /// Subtitle for verbose connection errors toggle.
  ///
  /// In en, this message translates to:
  /// **'After a failed connection test, show technical details in a dialog (types, messages, HTTP status). Passwords are never shown.'**
  String get settingsVerboseConnectionErrorsSubtitle;

  /// AlertDialog title after failed test when verbose is on.
  ///
  /// In en, this message translates to:
  /// **'Connection diagnostics'**
  String get connectionDiagnosticsTitle;

  /// Theme option: dark mode.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// Theme option: light mode.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// Theme option: follow OS light/dark (short label for segmented control).
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// Settings section: version and project info.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutSection;

  /// Label for app version row in Settings.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// About row subtitle: semantic version and build number.
  ///
  /// In en, this message translates to:
  /// **'{version} ({buildNumber})'**
  String settingsVersionSubtitle(String version, String buildNumber);

  /// Placeholder while package info loads.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get settingsLoading;

  /// When package version could not be read.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get settingsVersionUnavailable;

  /// Link to GitHub repository.
  ///
  /// In en, this message translates to:
  /// **'Source code'**
  String get settingsSourceCode;

  /// MIT license dialog title and list tile title.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get settingsLicenseTitle;

  /// Subtitle on license row in Settings.
  ///
  /// In en, this message translates to:
  /// **'MIT License — tap for summary'**
  String get settingsLicenseTileSubtitle;

  /// Short MIT summary in About dialog (not full legal text).
  ///
  /// In en, this message translates to:
  /// **'ProxDroid is licensed under the MIT License. You may use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the software, subject to including the copyright notice and permission notice in all copies. The software is provided \"as is\", without warranty of any kind. See the LICENSE file in the repository for the full text.'**
  String get settingsLicenseSummary;

  /// Settings section: donations / sponsorship.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get settingsSupportSection;

  /// Support link title for Ko-fi.
  ///
  /// In en, this message translates to:
  /// **'Ko-fi'**
  String get settingsSupportKofi;

  /// Support link title for GitHub Sponsors.
  ///
  /// In en, this message translates to:
  /// **'GitHub Sponsors'**
  String get settingsSupportGithubSponsors;

  /// Snackbar when url_launcher fails.
  ///
  /// In en, this message translates to:
  /// **'Could not open link'**
  String get settingsCouldNotOpenLink;

  /// Bottom navigation bar label for the Dashboard tab.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// Bottom navigation bar label for the Virtual Machines tab (abbreviated for space).
  ///
  /// In en, this message translates to:
  /// **'VMs'**
  String get navVMs;

  /// Bottom navigation bar label for the LXC Containers tab.
  ///
  /// In en, this message translates to:
  /// **'Containers'**
  String get navContainers;

  /// Bottom navigation bar label for the Proxmox Tasks tab.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get navTasks;

  /// Bottom navigation bar label for the More tab, which opens the full navigation drawer.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// Section title for Proxmox guest tags on VM / container detail screens.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get sectionGuestTags;

  /// Tooltip / label to open VM or LXC config editor.
  ///
  /// In en, this message translates to:
  /// **'Edit configuration'**
  String get actionEditGuestConfig;

  /// App bar title for QEMU VM Tier-A config editor.
  ///
  /// In en, this message translates to:
  /// **'Edit VM'**
  String get screenEditVmConfig;

  /// App bar title for LXC Tier-A config editor.
  ///
  /// In en, this message translates to:
  /// **'Edit container'**
  String get screenEditContainerConfig;

  /// Grouped form section: name, description, tags.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get guestConfigSectionIdentity;

  /// Grouped form section: memory, swap, etc.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get guestConfigSectionResources;

  /// Grouped form section: sockets, cores, limits.
  ///
  /// In en, this message translates to:
  /// **'CPU'**
  String get guestConfigSectionCpu;

  /// Grouped form section: on boot, startup order.
  ///
  /// In en, this message translates to:
  /// **'Boot'**
  String get guestConfigSectionBoot;

  /// Grouped form section: agent, features, etc.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get guestConfigSectionOptions;

  /// QEMU VM config field label for name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get guestConfigFieldVmName;

  /// LXC config field label for hostname.
  ///
  /// In en, this message translates to:
  /// **'Hostname'**
  String get guestConfigFieldHostname;

  /// Guest config notes / description field.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get guestConfigFieldDescription;

  /// Proxmox tags string (semicolon-separated in API).
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get guestConfigFieldTags;

  /// RAM size field for VM or CT.
  ///
  /// In en, this message translates to:
  /// **'Memory (MiB)'**
  String get guestConfigFieldMemory;

  /// QEMU CPU socket count.
  ///
  /// In en, this message translates to:
  /// **'CPU sockets'**
  String get guestConfigFieldSockets;

  /// QEMU cores per socket.
  ///
  /// In en, this message translates to:
  /// **'Cores per socket'**
  String get guestConfigFieldCores;

  /// QEMU vCPU count override.
  ///
  /// In en, this message translates to:
  /// **'vCPUs'**
  String get guestConfigFieldVcpus;

  /// QEMU cpu= argument (e.g. host).
  ///
  /// In en, this message translates to:
  /// **'CPU type'**
  String get guestConfigFieldCpuType;

  /// ostype= for QEMU or LXC.
  ///
  /// In en, this message translates to:
  /// **'Guest OS'**
  String get guestConfigFieldGuestOs;

  /// LXC arch= field.
  ///
  /// In en, this message translates to:
  /// **'Architecture'**
  String get guestConfigFieldArchitecture;

  /// LXC swap size.
  ///
  /// In en, this message translates to:
  /// **'Swap (MiB)'**
  String get guestConfigFieldSwap;

  /// LXC cpulimit (0–800 or 0 for unlimited).
  ///
  /// In en, this message translates to:
  /// **'CPU limit'**
  String get guestConfigFieldCpuLimit;

  /// LXC cpuunits scheduling weight.
  ///
  /// In en, this message translates to:
  /// **'CPU units'**
  String get guestConfigFieldCpuUnits;

  /// Proxmox startup= ordering string.
  ///
  /// In en, this message translates to:
  /// **'Startup order'**
  String get guestConfigFieldStartupOrder;

  /// Whether the guest starts when the node boots.
  ///
  /// In en, this message translates to:
  /// **'Start at boot'**
  String get guestConfigFieldOnBoot;

  /// agent= string for QEMU.
  ///
  /// In en, this message translates to:
  /// **'QEMU guest agent'**
  String get guestConfigFieldQemuAgent;

  /// LXC unprivileged flag.
  ///
  /// In en, this message translates to:
  /// **'Unprivileged container'**
  String get guestConfigFieldUnprivileged;

  /// LXC features= string.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get guestConfigFieldFeatures;

  /// LXC rootfs= (read-only in Tier A editor).
  ///
  /// In en, this message translates to:
  /// **'Root filesystem'**
  String get guestConfigFieldRootfs;

  /// Helper under read-only rootfs field.
  ///
  /// In en, this message translates to:
  /// **'Root filesystem cannot be edited here yet.'**
  String get guestConfigRootfsReadOnlyHint;

  /// Helper when LXC rootfs is editable (guest stopped).
  ///
  /// In en, this message translates to:
  /// **'Changing rootfs is dangerous; confirm before saving.'**
  String get guestConfigRootfsEditHint;

  /// Reset form to last loaded server values.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get guestConfigActionDiscard;

  /// Snackbar after successful PUT config.
  ///
  /// In en, this message translates to:
  /// **'Configuration saved'**
  String get guestConfigSaveSuccess;

  /// Snackbar when save tapped with empty delta.
  ///
  /// In en, this message translates to:
  /// **'No changes to save'**
  String get guestConfigSaveNothingChanged;

  /// Grouped section title for net0.. on VM/LXC config editor.
  ///
  /// In en, this message translates to:
  /// **'Network interfaces'**
  String get guestConfigSectionNetworks;

  /// Grouped section title for QEMU disk keys on VM config editor.
  ///
  /// In en, this message translates to:
  /// **'Disks'**
  String get guestConfigSectionDisks;

  /// Grouped section title for LXC mpN lines.
  ///
  /// In en, this message translates to:
  /// **'Mount points'**
  String get guestConfigSectionMounts;

  /// Explains why QEMU network rows are read-only while running.
  ///
  /// In en, this message translates to:
  /// **'Stop the machine to add, remove, or reorder network interfaces.'**
  String get guestConfigNetworksLockedWhileRunning;

  /// Explains why QEMU disk rows are read-only while running.
  ///
  /// In en, this message translates to:
  /// **'Stop the machine to add, remove, or reorder disk definitions.'**
  String get guestConfigDisksLockedWhileRunning;

  /// Explains why LXC mp rows are read-only while running.
  ///
  /// In en, this message translates to:
  /// **'Stop the container to add, remove, or reorder mount points.'**
  String get guestConfigMountsLockedWhileRunning;

  /// Explains why LXC rootfs field is read-only while running.
  ///
  /// In en, this message translates to:
  /// **'Stop the container to edit the root filesystem string.'**
  String get guestConfigRootfsLockedWhileRunning;

  /// Label for a single QEMU/LXC netN row; {name} is e.g. net0.
  ///
  /// In en, this message translates to:
  /// **'Interface ({name})'**
  String guestConfigNetworkLineLabel(String name);

  /// Button to append a new netN row.
  ///
  /// In en, this message translates to:
  /// **'Add interface'**
  String get guestConfigAddNetwork;

  /// Tooltip for delete on a net row.
  ///
  /// In en, this message translates to:
  /// **'Remove interface'**
  String get guestConfigRemoveInterface;

  /// Button to append a new scsiN disk row on QEMU editor.
  ///
  /// In en, this message translates to:
  /// **'Add disk (SCSI)'**
  String get guestConfigAddDisk;

  /// Tooltip for delete on a QEMU disk row.
  ///
  /// In en, this message translates to:
  /// **'Remove disk'**
  String get guestConfigRemoveDisk;

  /// Button to append a new mpN row on LXC editor.
  ///
  /// In en, this message translates to:
  /// **'Add mount point'**
  String get guestConfigAddMountPoint;

  /// Tooltip for delete on an LXC mp row.
  ///
  /// In en, this message translates to:
  /// **'Remove mount point'**
  String get guestConfigRemoveMountPoint;

  /// Title for confirm dialog before saving disk/net/mp/rootfs mutations.
  ///
  /// In en, this message translates to:
  /// **'Apply high-risk changes?'**
  String get guestConfigRiskConfirmTitle;

  /// Body for high-risk save confirmation.
  ///
  /// In en, this message translates to:
  /// **'Network, disk, mount point, or root filesystem changes can break a guest or destroy data. Continue only if you understand the impact.'**
  String get guestConfigRiskConfirmBody;

  /// Confirm button on high-risk save dialog.
  ///
  /// In en, this message translates to:
  /// **'Apply changes'**
  String get guestConfigRiskConfirmAction;

  /// Generic required field validation.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get validationFieldRequired;

  /// Validation for integer fields such as memory.
  ///
  /// In en, this message translates to:
  /// **'Enter a positive whole number.'**
  String get validationIntegerPositive;

  /// Proxmox VM/CT id lower bound hint.
  ///
  /// In en, this message translates to:
  /// **'Guest ID must be at least 100.'**
  String get validationVmidMin;

  /// App bar title for minimal QEMU create form.
  ///
  /// In en, this message translates to:
  /// **'Create Virtual Machine'**
  String get guestCreateVmTitle;

  /// App bar title for minimal LXC create form.
  ///
  /// In en, this message translates to:
  /// **'Create container'**
  String get guestCreateCtTitle;

  /// Primary button on create VM/CT forms.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get guestCreateSubmit;

  /// FAB tooltip on VM list.
  ///
  /// In en, this message translates to:
  /// **'Create Virtual Machine'**
  String get guestCreateFabVm;

  /// FAB tooltip on container list.
  ///
  /// In en, this message translates to:
  /// **'Create container'**
  String get guestCreateFabCt;

  /// Form section: node and guest id.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get guestCreateSectionTarget;

  /// Form section for QEMU disk and net0.
  ///
  /// In en, this message translates to:
  /// **'Disk and network'**
  String get guestCreateSectionDiskNet;

  /// QEMU scsihw= field label.
  ///
  /// In en, this message translates to:
  /// **'SCSI controller (scsihw)'**
  String get guestCreateFieldScsihw;

  /// Helper for scsihw field.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to omit; virtio-scsi is common with scsi0.'**
  String get guestCreateFieldScsihwHint;

  /// QEMU boot disk volume string.
  ///
  /// In en, this message translates to:
  /// **'Disk (scsi0)'**
  String get guestCreateFieldScsi0;

  /// Example scsi0 Proxmox volume string.
  ///
  /// In en, this message translates to:
  /// **'Example: local-lvm:32'**
  String get guestCreateFieldScsi0Hint;

  /// QEMU/LXC net0 string label.
  ///
  /// In en, this message translates to:
  /// **'Network (net0)'**
  String get guestCreateFieldNet0;

  /// QEMU net0 example.
  ///
  /// In en, this message translates to:
  /// **'Example: virtio,bridge=vmbr0'**
  String get guestCreateFieldNet0Hint;

  /// LXC net0 example.
  ///
  /// In en, this message translates to:
  /// **'Example: name=eth0,bridge=vmbr0,ip=dhcp'**
  String get guestCreateFieldNet0HintCt;

  /// LXC create root password field.
  ///
  /// In en, this message translates to:
  /// **'Root password'**
  String get guestCreateFieldRootPassword;

  /// LXC rootfs volume example.
  ///
  /// In en, this message translates to:
  /// **'Example: local-lvm:8'**
  String get guestCreateFieldRootfsHint;

  /// QEMU ostype helper.
  ///
  /// In en, this message translates to:
  /// **'Example: l26 (Linux 2.6+), win11, other.'**
  String get guestCreateVmOstypeHint;

  /// LXC ostype helper.
  ///
  /// In en, this message translates to:
  /// **'Template id, e.g. debian or ubuntu.'**
  String get guestCreateCtOstypeHint;

  /// Footer note on create VM screen.
  ///
  /// In en, this message translates to:
  /// **'Creating a VM runs a server task. Ensure disk and network strings match your node.'**
  String get guestCreateVmDisclaimer;

  /// Footer note on create CT screen.
  ///
  /// In en, this message translates to:
  /// **'Creating a container runs a server task. Match rootfs and templates to your cluster.'**
  String get guestCreateCtDisclaimer;

  /// Empty node list on create guest screen.
  ///
  /// In en, this message translates to:
  /// **'No cluster nodes are available.'**
  String get guestCreateNoNodes;

  /// Short name for success snackbar (powerActionCompleted).
  ///
  /// In en, this message translates to:
  /// **'Create Virtual Machine'**
  String get guestCreateVmActionName;

  /// Short name for success snackbar after CT create.
  ///
  /// In en, this message translates to:
  /// **'Create container'**
  String get guestCreateCtActionName;
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
