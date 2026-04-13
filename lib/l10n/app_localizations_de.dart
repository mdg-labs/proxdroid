// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get actionBackup => 'Sicherung';

  @override
  String get actionCancel => 'Abbrechen';

  @override
  String get actionClose => 'Schließen';

  @override
  String get actionConfirm => 'Bestätigen';

  @override
  String get actionEditGuestConfig => 'Konfiguration bearbeiten';

  @override
  String get actionForceStop => 'Zwangsstopp';

  @override
  String get actionGoBack => 'Zurück';

  @override
  String get actionReboot => 'Neustart';

  @override
  String get actionRetry => 'Erneut versuchen';

  @override
  String get actionSave => 'Speichern';

  @override
  String get actionStart => 'Starten';

  @override
  String get actionStop => 'Stop';

  @override
  String get actionTestConnection => 'Verbindung testen';

  @override
  String get actionUndo => 'Rückgängig';

  @override
  String get appDrawerSubtitle => 'Proxmox-Cluster-Client';

  @override
  String get appTitle => 'ProxDroid';

  @override
  String get backupCompressGzip => 'Gzip';

  @override
  String get backupCompressLzo => 'LZO';

  @override
  String get backupCompressNone => 'Keine';

  @override
  String get backupCompressZstd => 'Zstandard (zstd)';

  @override
  String get backupFabTooltip => 'Backup ausführen';

  @override
  String get backupFieldCompress => 'Kompression';

  @override
  String get backupFieldGuest => 'Gast';

  @override
  String get backupFieldMode => 'Sicherungsmodus';

  @override
  String get backupFieldStorage => 'Zielspeicher';

  @override
  String get backupGroupedUnknownGuest => 'Andere';

  @override
  String backupJobLastRun(String when) {
    return 'Letzter Lauf: $when';
  }

  @override
  String backupJobNextRun(String when) {
    return 'Nächster Lauf: $when';
  }

  @override
  String backupJobVmids(String ids) {
    return 'Gäste: $ids';
  }

  @override
  String get backupListEmptyMessage =>
      'Es wurden keine Backup-Volumes auf Speichern gefunden, die Backups unterstützen.';

  @override
  String get backupListEmptyTitle => 'Keine Sicherungsdateien';

  @override
  String get backupModeSnapshot => 'Schnappschuss';

  @override
  String get backupModeStop => 'Stop';

  @override
  String get backupModeSuspend => 'Suspendieren';

  @override
  String get backupNoDestinationStorage =>
      'Kein Speicher unterstützt Backups in diesem Cluster.';

  @override
  String get backupSectionFiles => 'Sicherungsdateien';

  @override
  String get backupSectionRecentTasks => 'Aktuelle Sicherungsaufgaben';

  @override
  String get backupSectionScheduledJobs => 'Geplante Jobs';

  @override
  String get backupTriggerStart => 'Sicherung starten';

  @override
  String get backupTriggerTitle => 'Backup ausführen';

  @override
  String get chartDiskIoSectionTitle => 'Festplatten-I/O';

  @override
  String get chartDiskIoUnavailableOnNode =>
      'Der Datendurchsatz der Hosts wird in den Knotenstatistiken in neueren Proxmox VE-Versionen nicht mehr erfasst (der Knoten-RRD zeigt keine Lese-/Schreibraten mehr an). Die Disk-I/O-Diagramme pro Gast funktionieren weiterhin auf den Detailbildschirmen von VM und Containern.';

  @override
  String get chartDiskRead => 'Lesen';

  @override
  String get chartDiskWrite => 'Schreiben';

  @override
  String get chartLoadError => 'Chartdaten konnten nicht geladen werden.';

  @override
  String get chartNetworkIn => 'In';

  @override
  String get chartNetworkOut => 'Aus';

  @override
  String get chartNoData => 'Keine Diagrammdaten für diesen Zeitraum.';

  @override
  String get chartTimeframeDay => '1 Tag';

  @override
  String get chartTimeframeHour => '1 Std.';

  @override
  String get chartTimeframeMonth => '1m';

  @override
  String get chartTimeframeWeek => '1W';

  @override
  String get connectionDiagnosticsTitle => 'Verbindungsdiagnose';

  @override
  String get containerListEmptyMessage =>
      'Es wurden keine LXC-Container für diesen Cluster zurückgegeben.';

  @override
  String get containerListEmptyTitle => 'Keine Container';

  @override
  String get containerNotFoundMessage =>
      'Dieser Container befindet sich nicht in der aktuellen Liste. Gehen Sie zurück und aktualisieren Sie die Liste.';

  @override
  String get containerNotFoundTitle => 'Container nicht gefunden';

  @override
  String get dashboardClusterSummary => 'Clusterübersicht';

  @override
  String get dashboardEmptyNodesMessage =>
      'Es wurden keine Knotendaten für diesen Server zurückgegeben.';

  @override
  String get dashboardEmptyNodesTitle => 'Keine Knoten';

  @override
  String get dashboardSummaryOnlineNodes => 'Online-Knoten';

  @override
  String get dashboardSummaryRunningVms => 'Laufende VMs';

  @override
  String get dashboardSummaryTotalContainers => 'Gesamtcontainer';

  @override
  String get dashboardSummaryTotalVms => 'Gesamt-VMs';

  @override
  String debugScreenBody(String name) {
    return 'Platzhalter — $name';
  }

  @override
  String get drawerSectionInfrastructure => 'Infrastruktur';

  @override
  String get drawerSectionOperations => 'Betrieb';

  @override
  String get entityBackup => 'Sicherung';

  @override
  String get entityContainer => 'Container';

  @override
  String get entityNode => 'Knoten';

  @override
  String get entityStorage => 'Speicher';

  @override
  String get entityTask => 'Aufgabe';

  @override
  String get entityVirtualMachine => 'Virtuelle Maschine';

  @override
  String get errorProxmoxAuth =>
      'Authentifizierung fehlgeschlagen. Überprüfen Sie Ihr Token oder Passwort.';

  @override
  String get errorProxmoxNetwork =>
      'Netzwerkfehler. Überprüfen Sie den Host, den Port und die Konnektivität.';

  @override
  String get errorProxmoxPermission => 'Zugriff für dieses Konto verweigert.';

  @override
  String errorProxmoxServer(int statusCode) {
    return 'Server hat HTTP $statusCode zurückgegeben.';
  }

  @override
  String errorProxmoxTechnicalDetails(String detail) {
    return '$detail';
  }

  @override
  String get errorProxmoxTimeout =>
      'Die Anfrage hat eine Zeitüberschreitung. Versuchen Sie es erneut.';

  @override
  String get errorProxmoxUnknown =>
      'Etwas ist schiefgegangen. Versuche es erneut.';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterByNode => 'Knoten';

  @override
  String get filterByStatus => 'Status';

  @override
  String get filterRunning => 'Laufend';

  @override
  String get filterStopped => 'Gestoppt';

  @override
  String get guestConfigActionDiscard => 'Verwerfen';

  @override
  String get guestConfigAddDisk => 'Festplatte hinzufügen (SCSI)';

  @override
  String get guestConfigAddMountPoint => 'Mountpunkt hinzufügen';

  @override
  String get guestConfigAddNetwork => 'Schnittstelle hinzufügen';

  @override
  String get guestConfigDisksLockedWhileRunning =>
      'Stoppen Sie die Maschine, um Festplattendefinitionen hinzuzufügen, zu entfernen oder neu anzuordnen.';

  @override
  String get guestConfigFieldArchitecture => 'Architektur';

  @override
  String get guestConfigFieldCores => 'Kerne pro Sockel';

  @override
  String get guestConfigFieldCpuLimit => 'CPU-Limit';

  @override
  String get guestConfigFieldCpuType => 'CPU-Typ';

  @override
  String get guestConfigFieldCpuUnits => 'CPU-Einheiten';

  @override
  String get guestConfigFieldDescription => 'Beschreibung';

  @override
  String get guestConfigFieldFeatures => 'Funktionen';

  @override
  String get guestConfigFieldGuestOs => 'Gäste-Betriebssystem';

  @override
  String get guestConfigFieldHostname => 'Hostname';

  @override
  String get guestConfigFieldMemory => 'Speicher (MiB)';

  @override
  String get guestConfigFieldOnBoot => 'Beim Booten starten';

  @override
  String get guestConfigFieldQemuAgent => 'QEMU-Gastagent';

  @override
  String get guestConfigFieldRootfs => 'Root-Dateisystem';

  @override
  String get guestConfigFieldSockets => 'CPU-Sockel';

  @override
  String get guestConfigFieldStartupOrder => 'Startreihenfolge';

  @override
  String get guestConfigFieldSwap => 'Swap (MiB)';

  @override
  String get guestConfigFieldTags => 'Tags';

  @override
  String get guestConfigFieldUnprivileged => 'Unprivilegierter Container';

  @override
  String get guestConfigFieldVcpus => 'vCPUs';

  @override
  String get guestConfigFieldVmName => 'Name';

  @override
  String get guestConfigMountsLockedWhileRunning =>
      'Stoppen Sie den Container, um Einhängepunkte hinzuzufügen, zu entfernen oder neu anzuordnen.';

  @override
  String guestConfigNetworkLineLabel(String name) {
    return 'Schnittstelle ($name)';
  }

  @override
  String get guestConfigNetworksLockedWhileRunning =>
      'Stoppen Sie die Maschine, um Netzwerkschnittstellen hinzuzufügen, zu entfernen oder neu anzuordnen.';

  @override
  String get guestConfigRemoveDisk => 'Festplatte entfernen';

  @override
  String get guestConfigRemoveInterface => 'Schnittstelle entfernen';

  @override
  String get guestConfigRemoveMountPoint => 'Mountpunkt entfernen';

  @override
  String get guestConfigRiskConfirmAction => 'Änderungen anwenden';

  @override
  String get guestConfigRiskConfirmBody =>
      'Änderungen am Netzwerk, an der Festplatte, am Einhängepunkt oder am Root-Dateisystem können einen Gast beeinträchtigen oder Daten zerstören. Setzen Sie fort, wenn Sie die Auswirkungen verstehen.';

  @override
  String get guestConfigRiskConfirmTitle => 'Hochriskante Änderungen anwenden?';

  @override
  String get guestConfigRootfsEditHint =>
      'Das Ändern des rootfs ist gefährlich; bestätigen Sie vor dem Speichern.';

  @override
  String get guestConfigRootfsLockedWhileRunning =>
      'Stoppen Sie den Container, um den Root-Dateisystem-String zu bearbeiten.';

  @override
  String get guestConfigRootfsReadOnlyHint =>
      'Das Root-Dateisystem kann hier noch nicht bearbeitet werden.';

  @override
  String get guestConfigSaveNothingChanged => 'Keine Änderungen zu speichern';

  @override
  String get guestConfigSaveSuccess => 'Konfiguration gespeichert';

  @override
  String get guestConfigSectionBoot => 'Boot';

  @override
  String get guestConfigSectionCpu => 'CPU';

  @override
  String get guestConfigSectionDisks => 'Festplatten';

  @override
  String get guestConfigSectionIdentity => 'Identität';

  @override
  String get guestConfigSectionMounts => 'Mountpunkte';

  @override
  String get guestConfigSectionNetworks => 'Netzwerkschnittstellen';

  @override
  String get guestConfigSectionOptions => 'Optionen';

  @override
  String get guestConfigSectionResources => 'Ressourcen';

  @override
  String get guestCreateCtActionName => 'Container erstellt';

  @override
  String get guestCreateCtDisclaimer =>
      'Das Erstellen eines Containers führt zu einer Serveraufgabe. Passen Sie rootfs und Vorlagen an Ihren Cluster an.';

  @override
  String get guestCreateCtOstypeHint =>
      'Template-ID, z. B. debian oder ubuntu.';

  @override
  String get guestCreateCtTitle => 'Container erstellen';

  @override
  String get guestCreateFabCt => 'Container erstellen';

  @override
  String get guestCreateFabVm => 'Virtuelle Maschine erstellen';

  @override
  String get guestCreateFieldNet0 => 'Netzwerk (net0)';

  @override
  String get guestCreateFieldNet0Hint => 'Beispiel: virtio,bridge=vmbr0';

  @override
  String get guestCreateFieldNet0HintCt =>
      'Beispiel: name=eth0,bridge=vmbr0,ip=dhcp';

  @override
  String get guestCreateFieldRootPassword => 'Root-Passwort';

  @override
  String get guestCreateFieldRootfsHint => 'Beispiel: local-lvm:8';

  @override
  String get guestCreateFieldScsi0 => 'Festplatte (scsi0)';

  @override
  String get guestCreateFieldScsi0Hint => 'Beispiel: local-lvm:32';

  @override
  String get guestCreateFieldScsihw => 'SCSI-Controller (scsihw)';

  @override
  String get guestCreateFieldScsihwHint =>
      'Leer lassen, um zu überspringen; virtio-scsi ist häufig bei scsi0.';

  @override
  String get guestCreateNoNodes => 'Keine Clusterknoten verfügbar.';

  @override
  String get guestCreateSectionDiskNet => 'Festplatte und Netzwerk';

  @override
  String get guestCreateSectionTarget => 'Ziel';

  @override
  String get guestCreateSubmit => 'Erstellen';

  @override
  String get guestCreateVmActionName => 'Virtuelle Maschine erstellen';

  @override
  String get guestCreateVmDisclaimer =>
      'Die Erstellung einer VM führt eine Serveraufgabe aus. Stellen Sie sicher, dass die Disk- und Netzwerkbezeichner mit Ihrem Knoten übereinstimmen.';

  @override
  String get guestCreateVmOstypeHint =>
      'Beispiel: l26 (Linux 2.6+), win11, andere.';

  @override
  String get guestCreateVmTitle => 'Virtuelle Maschine erstellen';

  @override
  String get guestDetailMetricGridSemantics =>
      'CPU-, Speicher-, Netzwerk- und Festplattenaktivität für diesen Gast.';

  @override
  String get guestPickerAdvancedRaw => 'Erweitert (roher Text)';

  @override
  String get guestPickerBridge => 'Brücke';

  @override
  String get guestPickerDiskModeExisting => 'Vorhandenes Volumen';

  @override
  String get guestPickerDiskModeNew => 'Neues Volume (Größe in GiB)';

  @override
  String get guestPickerIfaceName => 'Schnittstelle';

  @override
  String get guestPickerLoadingBridges => 'Brücken werden geladen…';

  @override
  String get guestPickerNetIpDhcp => 'DHCP';

  @override
  String get guestPickerNetIpMode => 'IPv4';

  @override
  String get guestPickerNetIpNone => 'IP weglassen (nur Brücke)';

  @override
  String get guestPickerNetIpStatic => 'statisch';

  @override
  String get guestPickerNetStaticHint => 'z.B. 192.168.1.50/24';

  @override
  String get guestPickerNicModel => 'Netzwerkmodell';

  @override
  String get guestPickerNoBridges =>
      'Keine Brücken-Schnittstellen gefunden. Verwenden Sie den erweiterten Rohdaten-Eingang.';

  @override
  String get guestPickerNoStoragePools =>
      'Keine Speicherpools auf diesem Knoten unterstützen diesen Inhaltstyp. Verwenden Sie den erweiterten Rohdateneintrag.';

  @override
  String get guestPickerParseFallbackHint =>
      'Dieser Wert verwendet Optionen, die der vereinfachte Editor nicht verarbeitet. Bearbeiten Sie als Rohtext oder passen Sie in Proxmox an.';

  @override
  String get guestPickerSizeGiB => 'Größe (GiB)';

  @override
  String get guestPickerStaticIpLabel => 'Statische CIDR';

  @override
  String get guestPickerStoragePool => 'Speicherpool';

  @override
  String get guestPickerUseSimpleEditor => 'Verwende vereinfachten Editor';

  @override
  String get guestPickerVolume => 'Lautstärke';

  @override
  String get labelContainerOsType => 'OS-Typ';

  @override
  String get labelContentKind => 'Art';

  @override
  String get labelCtid => 'CT-ID';

  @override
  String get labelFormat => 'Format';

  @override
  String get labelNodeHostStatus => 'Status';

  @override
  String get labelVmid => 'VM-ID';

  @override
  String get labelVolumeId => 'Lautstärke';

  @override
  String get listFilteredEmptyMessage =>
      'Versuchen Sie, die Suche oder Filter zu ändern.';

  @override
  String get listFilteredEmptyTitle => 'Keine Übereinstimmungen';

  @override
  String get metricCpu => 'CPU';

  @override
  String get metricDisk => 'Festplatte';

  @override
  String get metricGuestContainers => 'Container';

  @override
  String get metricGuestVms => 'Virtuelle Maschinen';

  @override
  String get metricIoWait => 'I/O-Wartezeit';

  @override
  String get metricLoadAvg1m => 'Last (1m)';

  @override
  String get metricMemory => 'Speicher';

  @override
  String get metricNetwork => 'Netzwerk';

  @override
  String get metricSwap => 'Tausch';

  @override
  String get metricUptime => 'Betriebszeit';

  @override
  String get navContainers => 'Container';

  @override
  String get navDashboard => 'Überblick';

  @override
  String get navMore => 'Mehr';

  @override
  String get navTasks => 'Aufgaben';

  @override
  String get navVMs => 'VMs';

  @override
  String nodeDetailRunningTotalCount(int total, int running) {
    return '$running laufend · $total insgesamt';
  }

  @override
  String get nodeDetailTitle => 'Knoten';

  @override
  String get nodeNotFoundMessage =>
      'Dieser Knoten befindet sich nicht in der aktuellen Liste. Gehen Sie zurück und aktualisieren Sie die Liste.';

  @override
  String get nodeNotFoundTitle => 'Knoten nicht gefunden';

  @override
  String get offlineBannerMessage =>
      'Keine Netzwerkverbindung. Einige Aktionen funktionieren möglicherweise nicht, bis Sie wieder online sind.';

  @override
  String powerActionCompleted(String actionName) {
    return '$actionName wurde erfolgreich abgeschlossen.';
  }

  @override
  String get powerActionTaskFailed =>
      'Der Vorgang wurde mit einem Fehler auf dem Server abgeschlossen.';

  @override
  String get powerActionTaskUnknown =>
      'Der endgültige Status der Aufgabe konnte nicht bestätigt werden.';

  @override
  String get powerConfirmForceStopBody =>
      'Der Gast wird sofort ohne sauberes Herunterfahren abgeschaltet.';

  @override
  String get powerConfirmForceStopTitle => 'Zwangsstopp?';

  @override
  String get powerConfirmForceStopWarning =>
      'Nicht gespeicherte Daten können verloren gehen. Das ist vergleichbar mit dem Ziehen des Stromkabels.';

  @override
  String get powerConfirmRebootBody =>
      'Der Gast wird neu gestartet. Ungespeicherte Arbeiten können verloren gehen, wenn Anwendungen nicht ordnungsgemäß heruntergefahren werden.';

  @override
  String get powerConfirmRebootTitle => 'Gast neu starten?';

  @override
  String get powerConfirmStopBody =>
      'Dies sendet ein Shutdown-Signal, damit das Betriebssystem sauber gestoppt werden kann.';

  @override
  String get powerConfirmStopTitle => 'Gast herunterfahren?';

  @override
  String get preferencesChartsSection => 'Diagramme';

  @override
  String get preferencesDefaultChartTimeframeSubtitle =>
      'Verwendet für CPU-, Speicher-, Netzwerk- und Festplattendiagramme auf den Detailbildschirmen von VM, Container und Node.';

  @override
  String get preferencesDefaultChartTimeframeTitle => 'Standardzeitraum';

  @override
  String get preferencesScreenTitle => 'Einstellungen';

  @override
  String get screenAddServer => 'Server hinzufügen';

  @override
  String get screenEditContainerConfig => 'Container bearbeiten';

  @override
  String get screenEditServer => 'Server bearbeiten';

  @override
  String get screenEditVmConfig => 'VM bearbeiten';

  @override
  String get searchClearTooltip => 'Suche löschen';

  @override
  String get searchContainersHint => 'Nach Namen suchen';

  @override
  String get searchVmsHint => 'Nach Namen suchen';

  @override
  String get sectionAbout => 'Über';

  @override
  String get sectionBackups => 'Sicherungen';

  @override
  String get sectionContainers => 'Container';

  @override
  String get sectionDashboard => 'Benutzeroberfläche';

  @override
  String get sectionGuestTags => 'Tags';

  @override
  String get sectionServers => 'Server';

  @override
  String get sectionSettings => 'Einstellungen';

  @override
  String get sectionTasks => 'Aufgaben';

  @override
  String get sectionVms => 'Virtuelle Maschinen';

  @override
  String get serverAllowSelfSigned => 'Selbstsigniertes Zertifikat erlauben';

  @override
  String get serverApiTokenErrorBothRequired =>
      'Geben Sie sowohl die Token-ID als auch das Geheimnis ein.';

  @override
  String get serverApiTokenErrorPartial =>
      'Geben Sie sowohl die Token-ID als auch das Geheimnis ein, oder lassen Sie beide Felder leer, um den aktuellen Token beizubehalten.';

  @override
  String get serverApiTokenIdErrorEmpty => 'Geben Sie die Token-ID ein.';

  @override
  String get serverApiTokenIdErrorInvalid =>
      'Token-ID muss wie USER@REALM!name aussehen und darf kein = enthalten.';

  @override
  String get serverApiTokenLeaveBlankHint =>
      'Beide Felder leer lassen, um den aktuellen Token beizubehalten.';

  @override
  String get serverApiTokenPasteClipboardEmpty =>
      'Die Zwischenablage ist leer.';

  @override
  String get serverApiTokenPasteFull => 'Token vollständig einfügen';

  @override
  String get serverApiTokenPasteInvalid =>
      'Der Text aus der Zwischenablage sah nicht aus wie USER@REALM!NAME=SECRET.';

  @override
  String get serverApiTokenSecretErrorEmpty => 'Geben Sie das Geheimnis ein.';

  @override
  String get serverAuthTfaUseApiTokenHint =>
      'Wenn dieses Konto die zwei-Faktor-Authentifizierung (TFA) aktiviert hat, verwenden Sie stattdessen die Anmeldung mit API-Token. Erstellen Sie ein Token in der Proxmox-Web-UI (Rechenzentrum oder Ihr Benutzer → API-Token).';

  @override
  String get serverAuthTypeApiToken => 'API-Token';

  @override
  String get serverAuthTypeUsernamePassword => 'Passwort';

  @override
  String get serverConnectionTestInProgress => 'Verbindung wird getestet…';

  @override
  String serverConnectionTestSuccess(String version) {
    return 'Verbunden. Proxmox-Version $version.';
  }

  @override
  String get serverDeletedSnackbar => 'Server entfernt';

  @override
  String get serverEditLoadError =>
      'Konnte diesen Server nicht zum Bearbeiten öffnen.';

  @override
  String get serverFieldApiTokenId => 'Token-ID';

  @override
  String get serverFieldApiTokenIdHint => 'z.B. root@pam!mytoken';

  @override
  String get serverFieldApiTokenSecret => 'Geheim';

  @override
  String get serverFieldApiTokenSecretHint =>
      'UUID, der bei der Erstellung des Tokens angezeigt wird';

  @override
  String get serverFieldHost => 'Host';

  @override
  String get serverFieldHostHint => 'proxmox.beispiel.de oder 192.168.1.10';

  @override
  String get serverFieldName => 'Anzeigename';

  @override
  String get serverFieldNameHint => 'z.B. Home-Labor';

  @override
  String get serverFieldPassword => 'Passwort';

  @override
  String get serverFieldPort => 'Port';

  @override
  String get serverFieldRealm => 'Realm';

  @override
  String get serverFieldRealmCustom => 'Benutzerdefinierter Bereich';

  @override
  String get serverFieldRealmCustomHint => 'z.B. ldap';

  @override
  String get serverFieldUsername => 'Benutzername';

  @override
  String get serverFieldUsernameHint => 'z.B. root';

  @override
  String get serverFormAuthentication => 'Authentifizierung';

  @override
  String get serverFormIdentitySection => 'Identität';

  @override
  String get serverFormSecuritySection => 'Sicherheit';

  @override
  String get serverHostErrorEmpty =>
      'Geben Sie einen Hostnamen oder eine IP-Adresse ein.';

  @override
  String get serverHostErrorHttp =>
      'http:// bitte nicht einfügen. Die App verwendet immer HTTPS.';

  @override
  String get serverHostErrorHttps =>
      'Geben Sie den Host ohne https:// ein (Scheme wird automatisch hinzugefügt).';

  @override
  String serverListHostPortSubtitle(String host, int port) {
    return '$host:$port';
  }

  @override
  String get serverLoginComposeHint =>
      'Die Anmeldung verwendet login@realm (unten festgelegt).';

  @override
  String get serverNameErrorEmpty => 'Geben Sie einen Anzeigenamen ein.';

  @override
  String get serverNotFound => 'Dieser Server wurde nicht gefunden.';

  @override
  String get serverPasswordErrorEmpty => 'Geben Sie Ihr Passwort ein.';

  @override
  String get serverPasswordLeaveBlankHint =>
      'Leer lassen, um das aktuelle Passwort beizubehalten.';

  @override
  String get serverPortErrorInvalid =>
      'Geben Sie eine gültige Portnummer ein (1–65535).';

  @override
  String get serverRealmErrorEmpty => 'Geben Sie ein Reich ein.';

  @override
  String get serverRealmErrorInvalid =>
      'Realm darf keine Leerzeichen oder @ enthalten.';

  @override
  String get serverRealmOther => 'Andere…';

  @override
  String get serverRealmPam => 'Linux PAM (pam)';

  @override
  String get serverRealmPve => 'Proxmox VE (pve)';

  @override
  String get serverTlsPinErrorRequired =>
      'Wenn die Selbstsignierung aktiviert ist, holen Sie sich den Fingerabdruck des Zertifikats oder fügen Sie ihn ein.';

  @override
  String get serverTlsPinFetch => 'Zertifikat-Fingerabdruck abrufen';

  @override
  String get serverTlsPinFetchFailed =>
      'Konnte das Serverzertifikat nicht lesen. Überprüfen Sie Host, Port und Netzwerk.';

  @override
  String get serverTlsPinFetchSuccess =>
      'Fingerprint geladen. Speichern Sie den Server, um ihn zu behalten.';

  @override
  String get serverTlsPinHint =>
      '64 Hex-Zeichen. Tippen Sie auf Abrufen, nachdem Sie Host und Port eingegeben haben. Erneut abrufen, wenn das Serverzertifikat erneuert wurde.';

  @override
  String get serverTlsPinLabel => 'Zertifikat-Fingerabdruck (SHA-256)';

  @override
  String get serverUsernameErrorContainsAt =>
      'Geben Sie hier nur den Anmeldenamen ein. Wählen Sie das Reich unten aus.';

  @override
  String get serverUsernameErrorEmpty =>
      'Geben Sie Ihren Proxmox-Benutzernamen ein.';

  @override
  String get serversEmptyCta => 'Server hinzufügen';

  @override
  String get serversEmptyMessage =>
      'Fügen Sie einen Server hinzu, um eine Verbindung zu Ihrem Proxmox-Cluster herzustellen.';

  @override
  String get serversEmptyTitle => 'Noch keine Server';

  @override
  String get serversFabAddTooltip => 'Server hinzufügen';

  @override
  String get serversLoadError => 'Konnte Server nicht laden.';

  @override
  String get settingsAboutSection => 'Über';

  @override
  String get settingsAppearanceSection => 'Aussehen';

  @override
  String get settingsCouldNotOpenLink => 'Konnte den Link nicht öffnen';

  @override
  String get settingsLanguageEnglish => 'Englisch';

  @override
  String get settingsLanguageGerman => 'Deutsch';

  @override
  String get settingsLanguageSection => 'Sprache';

  @override
  String get settingsLanguageSystem => 'Systemstandard';

  @override
  String get settingsLicenseSummary =>
      'ProxDroid ist unter der MIT-Lizenz lizenziert. Sie dürfen die Software verwenden, kopieren, modifizieren, zusammenführen, veröffentlichen, verbreiten, unterlizenzieren und/oder Kopien der Software verkaufen, sofern Sie die Urheberrechtshinweise und die Genehmigungshinweise in allen Kopien beifügen. Die Software wird \"wie sie ist\" bereitgestellt, ohne Garantie jeglicher Art. Siehe die LICENSE-Datei im Repository für den vollständigen Text.';

  @override
  String get settingsLicenseTileSubtitle =>
      'MIT-Lizenz — tippen Sie für eine Zusammenfassung';

  @override
  String get settingsLicenseTitle => 'Lizenz';

  @override
  String get settingsLoading => 'Laden…';

  @override
  String get settingsPreferencesSubtitle =>
      'Design, standard Diagramm-Zeitraum und andere App-Einstellungen.';

  @override
  String get settingsPreferencesTitle => 'Einstellungen';

  @override
  String get settingsServersSubtitle =>
      'Fügen Sie den aktiven Proxmox-Server hinzu, bearbeiten Sie ihn oder wechseln Sie.';

  @override
  String get settingsSourceCode => 'Quellcode';

  @override
  String get settingsSupportGithubSponsors => 'GitHub-Sponsoren';

  @override
  String get settingsSupportKofi => 'Ko-fi';

  @override
  String get settingsSupportSection => 'Unterstützung';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsTroubleshootingSection => 'Fehlerbehebung';

  @override
  String get settingsVerboseConnectionErrors =>
      'Ausführliche Verbindungsfehler';

  @override
  String get settingsVerboseConnectionErrorsSubtitle =>
      'Nach einem fehlgeschlagenen Verbindungstest technische Einzelheiten in einem Dialog anzeigen (Typen, Nachrichten, HTTP-Status). Passwörter werden niemals angezeigt.';

  @override
  String get settingsVersion => 'Version';

  @override
  String settingsVersionSubtitle(String version, String buildNumber) {
    return '$version ($buildNumber)';
  }

  @override
  String get settingsVersionUnavailable => 'Nicht verfügbar';

  @override
  String get shellConnectedLabel => 'Verbunden';

  @override
  String shellConnectedPillSemantics(String serverName) {
    return 'Verbunden mit $serverName. Server wechseln oder verwalten.';
  }

  @override
  String get shellOpenNavigationMenu => 'Navigationsmenü öffnen';

  @override
  String get shellServerPillTooltip => 'Server wechseln oder verwalten';

  @override
  String get statusOffline => 'Offline';

  @override
  String get statusOnline => 'Online';

  @override
  String get statusPaused => 'Pausiert';

  @override
  String get statusRunning => 'Laufend';

  @override
  String get statusStopped => 'Gestoppt';

  @override
  String get statusUnknown => 'Unbekannt';

  @override
  String get storageActive => 'Aktiv';

  @override
  String storageAvailableSpace(String size) {
    return 'Verfügbar: $size';
  }

  @override
  String get storageClusterHeroSubtitle =>
      'Summe der Pools, die den verwendeten und den Gesamtspeicher melden';

  @override
  String get storageClusterHeroTitle => 'Clusterkapazität';

  @override
  String get storageContentEmpty => 'Keine Volumes in diesem Pool.';

  @override
  String get storageContentTypesLabel => 'Inhaltstypen';

  @override
  String get storageDetailContentTitle => 'Inhalt';

  @override
  String get storageEmptyMessage =>
      'Es wurden keine Speicherpools auf einem Online-Knoten gefunden.';

  @override
  String get storageEmptyTitle => 'Keine Speicherpools';

  @override
  String get storageInactive => 'Inaktiv';

  @override
  String get storageLabelAvailable => 'Verfügbar';

  @override
  String get storageNodeDistributionTitle =>
      'Verwendeter Speicherplatz nach Knoten';

  @override
  String get storagePoolHealthAtRiskLabel => 'In Gefahr';

  @override
  String get storagePoolHealthHealthyLabel => 'Gesund';

  @override
  String storagePoolOnNode(String node, String pool) {
    return '$pool · $node';
  }

  @override
  String get storagePoolsSectionTitle => 'Speicherpools';

  @override
  String get storageTypeLabel => 'Typ';

  @override
  String get storageUsageSection => 'Verwendung';

  @override
  String get taskDetailLogEmpty => 'Kein Protokollausgabe.';

  @override
  String get taskDetailLogError => 'Konnte das Aufgabenprotokoll nicht laden.';

  @override
  String get taskDetailLogLoading => 'Protokoll wird geladen…';

  @override
  String get taskDetailLogTitle => 'Protokoll';

  @override
  String get taskDetailNodeLabel => 'Knoten';

  @override
  String get taskDetailUpidLabel => 'UPID';

  @override
  String get taskFilterAllGuests => 'Alle Gäste';

  @override
  String get taskFilterByGuest => 'Nach Gast filtern';

  @override
  String get taskGuestFilterTitle => 'Gast';

  @override
  String get taskListEmptyMessage =>
      'Es wurden keine aktuellen Aufgaben für diesen Cluster zurückgegeben.';

  @override
  String get taskListEmptyTitle => 'Keine Aufgaben';

  @override
  String get taskListLoadError => 'Konnte Aufgaben nicht laden.';

  @override
  String get taskRowDuration => 'Dauer';

  @override
  String get taskRowGuest => 'Gast';

  @override
  String get taskRowStarted => 'Gestartet';

  @override
  String get taskRowStatus => 'Status';

  @override
  String get taskStatusCompleted =>
      'Aufgabe erfolgreich abgeschlossen (Terminal ok).';

  @override
  String get taskStatusFailed => 'Fehler';

  @override
  String get validationFieldRequired => 'Dieses Feld ist erforderlich.';

  @override
  String get validationIntegerPositive =>
      'Geben Sie eine positive ganze Zahl ein.';

  @override
  String get validationVmidMin => 'Die Gast-ID muss mindestens 100 betragen.';

  @override
  String get valueUnavailable => '—';

  @override
  String get vmListEmptyMessage =>
      'Es wurden keine VMs für diesen Cluster zurückgegeben.';

  @override
  String get vmListEmptyTitle => 'Keine virtuellen Maschinen';

  @override
  String get vmNotFoundMessage =>
      'Diese VM befindet sich nicht in der aktuellen Liste. Gehen Sie zurück und aktualisieren Sie die Liste.';

  @override
  String get vmNotFoundTitle => 'VM nicht gefunden';
}
