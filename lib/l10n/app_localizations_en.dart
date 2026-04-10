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
  String get serverFieldUsernameHint => 'root@pam';

  @override
  String get serverFieldPassword => 'Password';

  @override
  String get serverAuthTypeApiToken => 'API token';

  @override
  String get serverAuthTypeUsernamePassword => 'Password';

  @override
  String get serverFormAuthentication => 'Authentication';

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
}
