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
  String get appDrawerSubtitle => 'Proxmox cluster client';

  @override
  String get drawerSectionInfrastructure => 'Infrastructure';

  @override
  String get drawerSectionOperations => 'Operations';

  @override
  String get offlineBannerMessage =>
      'No network connection. Some actions may not work until you are back online.';

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

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionSave => 'Save';

  @override
  String get actionTestConnection => 'Test connection';

  @override
  String get actionUndo => 'Undo';

  @override
  String get actionGoBack => 'Go back';

  @override
  String get serversFabAddTooltip => 'Add server';

  @override
  String get serversEmptyTitle => 'No servers yet';

  @override
  String get serversEmptyMessage =>
      'Add a server to connect to your Proxmox cluster.';

  @override
  String get serversEmptyCta => 'Add server';

  @override
  String get serversLoadError => 'Could not load servers.';

  @override
  String get serverDeletedSnackbar => 'Server removed';

  @override
  String serverListHostPortSubtitle(String host, int port) {
    return '$host:$port';
  }

  @override
  String get serverFieldName => 'Display name';

  @override
  String get serverFieldNameHint => 'e.g. Home lab';

  @override
  String get serverFieldHost => 'Host';

  @override
  String get serverFieldHostHint => 'proxmox.example.com or 192.168.1.10';

  @override
  String get serverFieldPort => 'Port';

  @override
  String get serverFieldApiToken => 'API token';

  @override
  String get serverFieldApiTokenHint => 'USER@REALM!TOKENID=SECRET';

  @override
  String get serverFieldUsername => 'User name';

  @override
  String get serverFieldUsernameHint => 'e.g. root';

  @override
  String get serverFieldPassword => 'Password';

  @override
  String get serverAuthTypeApiToken => 'API token';

  @override
  String get serverAuthTypeUsernamePassword => 'Password';

  @override
  String get serverFormIdentitySection => 'Identity';

  @override
  String get serverFormAuthentication => 'Authentication';

  @override
  String get serverFormSecuritySection => 'Security';

  @override
  String get serverAllowSelfSigned => 'Allow self-signed certificate';

  @override
  String get serverHostErrorEmpty => 'Enter a host name or IP address.';

  @override
  String get serverHostErrorHttp =>
      'Do not include http://. The app always uses HTTPS.';

  @override
  String get serverHostErrorHttps =>
      'Enter the host without https:// (scheme is added automatically).';

  @override
  String get serverPortErrorInvalid => 'Enter a valid port number (1–65535).';

  @override
  String get serverNameErrorEmpty => 'Enter a display name.';

  @override
  String get serverApiTokenErrorEmpty => 'Enter your API token.';

  @override
  String get serverFieldRealm => 'Realm';

  @override
  String get serverRealmPam => 'Linux PAM (pam)';

  @override
  String get serverRealmPve => 'Proxmox VE (pve)';

  @override
  String get serverRealmOther => 'Other…';

  @override
  String get serverFieldRealmCustom => 'Custom realm';

  @override
  String get serverFieldRealmCustomHint => 'e.g. ldap';

  @override
  String get serverRealmErrorEmpty => 'Enter a realm.';

  @override
  String get serverRealmErrorInvalid => 'Realm must not contain spaces or @.';

  @override
  String get serverLoginComposeHint => 'Sign-in uses login@realm (set below).';

  @override
  String get serverUsernameErrorContainsAt =>
      'Enter only the login name here. Choose the realm below.';

  @override
  String get serverUsernameErrorEmpty => 'Enter your Proxmox user name.';

  @override
  String get serverPasswordErrorEmpty => 'Enter your password.';

  @override
  String get serverPasswordLeaveBlankHint =>
      'Leave blank to keep the current password.';

  @override
  String get serverApiTokenLeaveBlankHint =>
      'Leave blank to keep the current token.';

  @override
  String get serverNotFound => 'This server was not found.';

  @override
  String get serverEditLoadError => 'Could not open this server for editing.';

  @override
  String get errorProxmoxAuth =>
      'Authentication failed. Check your token or password.';

  @override
  String get errorProxmoxNetwork =>
      'Network error. Check the host, port, and connectivity.';

  @override
  String get errorProxmoxTimeout => 'The request timed out. Try again.';

  @override
  String get errorProxmoxPermission => 'Permission denied for this account.';

  @override
  String errorProxmoxServer(int statusCode) {
    return 'Server returned HTTP $statusCode.';
  }

  @override
  String get errorProxmoxUnknown => 'Something went wrong. Try again.';

  @override
  String errorProxmoxTechnicalDetails(String detail) {
    return '$detail';
  }

  @override
  String serverConnectionTestSuccess(String version) {
    return 'Connected. Proxmox version $version.';
  }

  @override
  String get serverConnectionTestInProgress => 'Testing connection…';

  @override
  String get dashboardClusterSummary => 'Cluster summary';

  @override
  String get dashboardSummaryTotalVms => 'Total VMs';

  @override
  String get dashboardSummaryRunningVms => 'Running VMs';

  @override
  String get dashboardSummaryTotalContainers => 'Total containers';

  @override
  String get dashboardEmptyNodesTitle => 'No nodes';

  @override
  String get dashboardEmptyNodesMessage =>
      'No node data was returned for this server.';

  @override
  String get filterAll => 'All';

  @override
  String get filterByNode => 'Node';

  @override
  String get filterByStatus => 'Status';

  @override
  String get filterRunning => 'Running';

  @override
  String get filterStopped => 'Stopped';

  @override
  String get searchVmsHint => 'Search by name';

  @override
  String get searchContainersHint => 'Search by name';

  @override
  String get vmListEmptyTitle => 'No virtual machines';

  @override
  String get vmListEmptyMessage => 'No VMs were returned for this cluster.';

  @override
  String get containerListEmptyTitle => 'No containers';

  @override
  String get containerListEmptyMessage =>
      'No LXC containers were returned for this cluster.';

  @override
  String get listFilteredEmptyTitle => 'No matches';

  @override
  String get listFilteredEmptyMessage => 'Try changing search or filters.';

  @override
  String get vmNotFoundTitle => 'VM not found';

  @override
  String get vmNotFoundMessage =>
      'This VM is not in the current list. Go back and refresh the list.';

  @override
  String get nodeDetailTitle => 'Node';

  @override
  String get nodeNotFoundTitle => 'Node not found';

  @override
  String get nodeNotFoundMessage =>
      'This node is not in the current list. Go back and refresh the list.';

  @override
  String get labelNodeHostStatus => 'Status';

  @override
  String get containerNotFoundTitle => 'Container not found';

  @override
  String get containerNotFoundMessage =>
      'This container is not in the current list. Go back and refresh the list.';

  @override
  String get labelVmid => 'VM ID';

  @override
  String get labelCtid => 'CT ID';

  @override
  String get labelContainerOsType => 'OS type';

  @override
  String get valueUnavailable => '—';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get powerConfirmStopTitle => 'Shut down guest?';

  @override
  String get powerConfirmStopBody =>
      'This sends a shutdown signal so the operating system can stop cleanly.';

  @override
  String get powerConfirmForceStopTitle => 'Force stop?';

  @override
  String get powerConfirmForceStopBody =>
      'The guest will be powered off immediately without a clean shutdown.';

  @override
  String get powerConfirmForceStopWarning =>
      'Unsaved data may be lost. This is equivalent to pulling the power cord.';

  @override
  String get powerConfirmRebootTitle => 'Reboot guest?';

  @override
  String get powerConfirmRebootBody =>
      'The guest will restart. Unsaved work may be lost if applications do not shut down cleanly.';

  @override
  String powerActionCompleted(String actionName) {
    return '$actionName finished successfully.';
  }

  @override
  String get powerActionTaskFailed =>
      'The operation finished with an error on the server.';

  @override
  String get powerActionTaskUnknown =>
      'Could not confirm the final task status.';

  @override
  String get taskListEmptyTitle => 'No tasks';

  @override
  String get taskListEmptyMessage =>
      'No recent tasks were returned for this cluster.';

  @override
  String get taskListLoadError => 'Could not load tasks.';

  @override
  String get taskRowGuest => 'Guest';

  @override
  String get taskRowStatus => 'Status';

  @override
  String get taskRowStarted => 'Started';

  @override
  String get taskRowDuration => 'Duration';

  @override
  String get taskStatusCompleted => 'OK';

  @override
  String get taskStatusFailed => 'Error';

  @override
  String get taskDetailNodeLabel => 'Node';

  @override
  String get taskDetailUpidLabel => 'UPID';

  @override
  String get taskDetailLogTitle => 'Log';

  @override
  String get taskDetailLogLoading => 'Loading log…';

  @override
  String get taskDetailLogError => 'Could not load the task log.';

  @override
  String get taskDetailLogEmpty => 'No log output.';

  @override
  String get chartTimeframeHour => '1h';

  @override
  String get chartTimeframeDay => '1d';

  @override
  String get chartTimeframeWeek => '1w';

  @override
  String get chartTimeframeMonth => '1m';

  @override
  String get chartNoData => 'No chart data for this period.';

  @override
  String get chartLoadError => 'Could not load chart data.';

  @override
  String get chartNetworkIn => 'In';

  @override
  String get chartNetworkOut => 'Out';

  @override
  String get chartDiskRead => 'Read';

  @override
  String get chartDiskWrite => 'Write';

  @override
  String get chartDiskIoSectionTitle => 'Disk I/O';

  @override
  String get actionBackup => 'Backup';

  @override
  String get storageEmptyTitle => 'No storage pools';

  @override
  String get storageEmptyMessage =>
      'No storage pools were found on any online node.';

  @override
  String get storageUsageSection => 'Usage';

  @override
  String get storageContentTypesLabel => 'Content types';

  @override
  String get storageActive => 'Active';

  @override
  String get storageInactive => 'Inactive';

  @override
  String get storageDetailContentTitle => 'Content';

  @override
  String get storageContentEmpty => 'No volumes in this pool.';

  @override
  String get storageTypeLabel => 'Type';

  @override
  String storagePoolOnNode(String pool, String node) {
    return '$pool · $node';
  }

  @override
  String get backupListEmptyTitle => 'No backup files';

  @override
  String get backupListEmptyMessage =>
      'No backup volumes were found on storages that support backups.';

  @override
  String get backupSectionScheduledJobs => 'Scheduled jobs';

  @override
  String get backupSectionFiles => 'Backup files';

  @override
  String get backupSectionRecentTasks => 'Recent backup tasks';

  @override
  String get backupGroupedUnknownGuest => 'Other';

  @override
  String backupJobVmids(String ids) {
    return 'Guests: $ids';
  }

  @override
  String backupJobNextRun(String when) {
    return 'Next run: $when';
  }

  @override
  String backupJobLastRun(String when) {
    return 'Last run: $when';
  }

  @override
  String get backupTriggerTitle => 'Run backup';

  @override
  String get backupFieldGuest => 'Guest';

  @override
  String get backupFieldStorage => 'Destination storage';

  @override
  String get backupFieldCompress => 'Compression';

  @override
  String get backupFieldMode => 'Backup mode';

  @override
  String get backupCompressZstd => 'Zstandard (zstd)';

  @override
  String get backupCompressLzo => 'LZO';

  @override
  String get backupCompressGzip => 'Gzip';

  @override
  String get backupCompressNone => 'None';

  @override
  String get backupModeSnapshot => 'Snapshot';

  @override
  String get backupModeSuspend => 'Suspend';

  @override
  String get backupModeStop => 'Stop';

  @override
  String get backupTriggerStart => 'Start backup';

  @override
  String get backupNoDestinationStorage =>
      'No storage supports backups in this cluster.';

  @override
  String get backupFabTooltip => 'Run backup';

  @override
  String get labelFormat => 'Format';

  @override
  String get labelVolumeId => 'Volume';

  @override
  String get labelContentKind => 'Kind';

  @override
  String get storageLabelAvailable => 'Available';

  @override
  String storageAvailableSpace(String size) {
    return 'Available: $size';
  }

  @override
  String get actionClose => 'Close';

  @override
  String get settingsServersSubtitle =>
      'Add, edit, or switch the active Proxmox server.';

  @override
  String get settingsAppearanceSection => 'Appearance';

  @override
  String get settingsTroubleshootingSection => 'Troubleshooting';

  @override
  String get settingsVerboseConnectionErrors => 'Verbose connection errors';

  @override
  String get settingsVerboseConnectionErrorsSubtitle =>
      'After a failed connection test, show technical details in a dialog (types, messages, HTTP status). Passwords are never shown.';

  @override
  String get connectionDiagnosticsTitle => 'Connection diagnostics';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsAboutSection => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String settingsVersionSubtitle(String version, String buildNumber) {
    return '$version ($buildNumber)';
  }

  @override
  String get settingsLoading => 'Loading…';

  @override
  String get settingsVersionUnavailable => 'Unavailable';

  @override
  String get settingsSourceCode => 'Source code';

  @override
  String get settingsLicenseTitle => 'License';

  @override
  String get settingsLicenseTileSubtitle => 'MIT License — tap for summary';

  @override
  String get settingsLicenseSummary =>
      'ProxDroid is licensed under the MIT License. You may use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the software, subject to including the copyright notice and permission notice in all copies. The software is provided \"as is\", without warranty of any kind. See the LICENSE file in the repository for the full text.';

  @override
  String get settingsSupportSection => 'Support';

  @override
  String get settingsSupportKofi => 'Ko-fi';

  @override
  String get settingsSupportGithubSponsors => 'GitHub Sponsors';

  @override
  String get settingsCouldNotOpenLink => 'Could not open link';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navVMs => 'VMs';

  @override
  String get navContainers => 'Containers';

  @override
  String get navTasks => 'Tasks';

  @override
  String get navMore => 'More';

  @override
  String get sectionGuestTags => 'Tags';
}
