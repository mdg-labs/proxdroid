import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/core/api/api_exceptions.dart';
import 'package:proxdroid/core/api/proxmox_api_client.dart';
import 'package:proxdroid/core/models/server.dart';
import 'package:proxdroid/core/network/tls_pinning.dart';
import 'package:proxdroid/core/storage/server_storage.dart';
import 'package:proxdroid/core/utils/proxmox_api_token.dart';
import 'package:proxdroid/core/utils/proxmox_login.dart';
import 'package:proxdroid/features/servers/providers/server_providers.dart';
import 'package:proxdroid/features/settings/providers/settings_providers.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/grouped_section.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/pill_segmented.dart';
import 'package:proxdroid/shared/widgets/premium_modals.dart';
import 'package:proxdroid/shared/widgets/section_header.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';
import 'package:uuid/uuid.dart';

const int _kDefaultProxmoxPort = 8006;

const String _realmPam = 'pam';
const String _realmPve = 'pve';
const String _realmOther = 'other';

/// Add or edit server form (shared). [existingServer] null ⇒ add.
class ServerEditorPage extends ConsumerStatefulWidget {
  const ServerEditorPage({super.key, this.existingServer});

  final Server? existingServer;

  @override
  ConsumerState<ServerEditorPage> createState() => _ServerEditorPageState();
}

class _ServerEditorPageState extends ConsumerState<ServerEditorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _hostController = TextEditingController();
  final _portController = TextEditingController(text: '$_kDefaultProxmoxPort');
  final _apiTokenIdController = TextEditingController();
  final _apiTokenSecretController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _customRealmController = TextEditingController();
  final _pinController = TextEditingController();

  /// Dropdown value: [_realmPam], [_realmPve], or [_realmOther].
  String _realmDropdownValue = _realmPam;

  ServerAuthType _authType = ServerAuthType.apiToken;
  bool _allowSelfSigned = false;
  bool _credentialsLoaded = false;
  bool _testingConnection = false;
  bool _fetchingTlsPin = false;
  bool _saving = false;

  /// Stored `login@realm` from secure storage (for edit password/username logic).
  String _initialUsername = '';

  bool get _isEdit => widget.existingServer != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingServer;
    if (existing != null) {
      _nameController.text = existing.name;
      _hostController.text = existing.host;
      _portController.text = '${existing.port}';
      _authType = existing.authType;
      _allowSelfSigned = existing.allowSelfSigned;
      _pinController.text = existing.pinnedTlsSha256 ?? '';
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _loadEditCredentials(),
      );
    } else {
      _credentialsLoaded = true;
    }
  }

  Future<void> _loadEditCredentials() async {
    final existing = widget.existingServer;
    if (existing == null) return;

    final storage = ref.read(serverStorageProvider);
    if (existing.authType == ServerAuthType.usernamePassword) {
      final creds = await storage.readUsernamePassword(existing.id);
      if (!mounted) return;
      final stored = creds?.username ?? '';
      final (login, realm) = parseProxmoxLoginIdForForm(stored);
      setState(() {
        _usernameController.text = login;
        _initialUsername = stored;
        if (isPresetRealm(realm)) {
          _realmDropdownValue = realm;
          _customRealmController.clear();
        } else {
          _realmDropdownValue = _realmOther;
          _customRealmController.text = realm;
        }
        _credentialsLoaded = true;
      });
    } else {
      if (!mounted) return;
      setState(() => _credentialsLoaded = true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _apiTokenIdController.dispose();
    _apiTokenSecretController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _customRealmController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  String? _resolvedTlsPinForTest() {
    if (!_allowSelfSigned) return null;
    final fromField = normalizePinnedTlsSha256(_pinController.text);
    if (fromField != null) return fromField;
    if (_isEdit && widget.existingServer?.allowSelfSigned == true) {
      return normalizePinnedTlsSha256(widget.existingServer?.pinnedTlsSha256);
    }
    return null;
  }

  Future<void> _fetchTlsCertificateFingerprint() async {
    final l10n = AppLocalizations.of(context)!;
    final hostErr = _validateHost(_hostController.text, l10n);
    if (hostErr != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(hostErr)));
      return;
    }
    final port = _parsePort(l10n);
    if (port == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.serverPortErrorInvalid)));
      return;
    }
    setState(() => _fetchingTlsPin = true);
    try {
      final hex = await fetchLeafCertSha256Hex(
        host: _hostController.text.trim(),
        port: port,
      );
      if (!mounted) return;
      if (hex == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.serverTlsPinFetchFailed)));
        return;
      }
      setState(() => _pinController.text = hex);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.serverTlsPinFetchSuccess)));
    } finally {
      if (mounted) setState(() => _fetchingTlsPin = false);
    }
  }

  String? _validateHost(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.serverHostErrorEmpty;
    }
    final lower = value.trim().toLowerCase();
    if (lower.contains('http://')) {
      return l10n.serverHostErrorHttp;
    }
    if (lower.contains('https://')) {
      return l10n.serverHostErrorHttps;
    }
    return null;
  }

  int? _parsePort(AppLocalizations l10n) {
    final raw = _portController.text.trim();
    final p = int.tryParse(raw);
    if (p == null || p < 1 || p > 65535) {
      return null;
    }
    return p;
  }

  String? _effectiveRealmString(AppLocalizations l10n) {
    switch (_realmDropdownValue) {
      case _realmPam:
        return _realmPam;
      case _realmPve:
        return _realmPve;
      case _realmOther:
        final c = _customRealmController.text.trim();
        if (c.isEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.serverRealmErrorEmpty)));
          return null;
        }
        if (c.contains(' ') || c.contains('@')) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.serverRealmErrorInvalid)));
          return null;
        }
        return c;
      default:
        return _realmPam;
    }
  }

  String? _composeLoginForConnectionTest(AppLocalizations l10n) {
    final u = _usernameController.text.trim();
    if (u.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.serverUsernameErrorEmpty)));
      return null;
    }
    if (u.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.serverUsernameErrorContainsAt)),
      );
      return null;
    }
    final realm = _effectiveRealmString(l10n);
    if (realm == null) return null;
    try {
      return buildProxmoxLoginId(u, realm);
    } on ArgumentError {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.serverRealmErrorInvalid)));
      return null;
    }
  }

  void _maybeShowConnectionDiagnostics(Object error) {
    if (!ref.read(verboseConnectionErrorsProvider)) return;
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    showPremiumDialog<void>(
      context: context,
      title: Text(l10n.connectionDiagnosticsTitle),
      content: Container(
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: SelectableText(
          proxmoxExceptionDiagnosticsText(error),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.actionClose),
        ),
      ],
    );
  }

  /// Call only after [FormState.validate] succeeds for username/password auth.
  String _composeLoginFromFormFields() {
    final u = _usernameController.text.trim();
    final realm =
        _realmDropdownValue == _realmOther
            ? _customRealmController.text.trim()
            : _realmDropdownValue;
    return buildProxmoxLoginId(u, realm);
  }

  Future<void> _pasteFullApiTokenFromClipboard() async {
    final l10n = AppLocalizations.of(context)!;
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text;
    if (text == null || text.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.serverApiTokenPasteClipboardEmpty)),
      );
      return;
    }
    final split = trySplitFullApiToken(text);
    if (!mounted) return;
    if (split == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.serverApiTokenPasteInvalid)));
      return;
    }
    setState(() {
      _apiTokenIdController.text = split.tokenId;
      _apiTokenSecretController.text = split.secret;
    });
  }

  Future<void> _testConnection() async {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();

    final hostErr = _validateHost(_hostController.text, l10n);
    if (hostErr != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(hostErr)));
      return;
    }

    final port = _parsePort(l10n);
    if (port == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.serverPortErrorInvalid)));
      return;
    }

    final storage = ref.read(serverStorageProvider);
    final existingId = widget.existingServer?.id;

    String? apiToken;
    String? loginIdForPassword;
    String? password;

    if (_authType == ServerAuthType.apiToken) {
      final id = _apiTokenIdController.text.trim();
      final sec = _apiTokenSecretController.text.trim();
      if (id.isEmpty && sec.isEmpty) {
        if (existingId != null) {
          apiToken = await storage.readApiToken(existingId);
        }
      } else if (isPartialApiTokenPair(id, sec)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.serverApiTokenErrorPartial)),
          );
        }
        return;
      } else {
        try {
          apiToken = composeProxmoxApiTokenValue(id, sec);
        } on ArgumentError {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.serverApiTokenIdErrorInvalid)),
            );
          }
          return;
        }
      }
      if (apiToken == null || apiToken.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.serverApiTokenErrorBothRequired)),
          );
        }
        return;
      }
    } else {
      loginIdForPassword = _composeLoginForConnectionTest(l10n);
      if (loginIdForPassword == null) return;
      var resolvedPassword = _passwordController.text;
      if (resolvedPassword.isEmpty && existingId != null) {
        final creds = await storage.readUsernamePassword(existingId);
        if (creds != null && creds.username == loginIdForPassword) {
          resolvedPassword = creds.password;
        }
      }
      if (resolvedPassword.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.serverPasswordErrorEmpty)),
          );
        }
        return;
      }
      password = resolvedPassword;
    }

    if (!mounted) return;

    if (_allowSelfSigned) {
      final pin = _resolvedTlsPinForTest();
      if (pin == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.serverTlsPinErrorRequired)));
        return;
      }
    }

    setState(() => _testingConnection = true);
    try {
      final testServer = Server(
        id: 'connection-test',
        name:
            _nameController.text.trim().isEmpty
                ? 'test'
                : _nameController.text.trim(),
        host: _hostController.text.trim(),
        port: port,
        authType: _authType,
        allowSelfSigned: _allowSelfSigned,
        pinnedTlsSha256: _resolvedTlsPinForTest(),
      );

      final ProxmoxApiClient client;
      if (_authType == ServerAuthType.apiToken) {
        client = ProxmoxApiClient(server: testServer, apiToken: apiToken!);
      } else {
        client = ProxmoxApiClient(
          server: testServer,
          username: loginIdForPassword!,
          password: password!,
        );
      }

      final version = await client.fetchVersion();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.serverConnectionTestSuccess(version.version)),
        ),
      );
    } on ProxmoxException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(proxmoxExceptionMessage(e, l10n))));
      _maybeShowConnectionDiagnostics(e);
    } on ArgumentError catch (e) {
      if (!mounted) return;
      final msg = e.message?.toString() ?? '';
      final text =
          msg.contains('pinnedTlsSha256')
              ? l10n.serverTlsPinErrorRequired
              : l10n.serverHostErrorHttps;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
      _maybeShowConnectionDiagnostics(e);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.errorProxmoxUnknown)));
      _maybeShowConnectionDiagnostics(e);
    } finally {
      if (mounted) {
        setState(() => _testingConnection = false);
      }
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    final port = _parsePort(l10n);
    if (port == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.serverPortErrorInvalid)));
      return;
    }

    if (_allowSelfSigned) {
      final pin = normalizePinnedTlsSha256(_pinController.text);
      if (pin == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.serverTlsPinErrorRequired)));
        return;
      }
    }

    final id = widget.existingServer?.id ?? Uuid().v4();
    final server = Server(
      id: id,
      name: _nameController.text.trim(),
      host: _hostController.text.trim(),
      port: port,
      authType: _authType,
      allowSelfSigned: _allowSelfSigned,
      pinnedTlsSha256:
          _allowSelfSigned
              ? normalizePinnedTlsSha256(_pinController.text)
              : null,
    );

    String? apiToken;
    String? username;
    String? password;

    if (_authType == ServerAuthType.apiToken) {
      final id = _apiTokenIdController.text.trim();
      final sec = _apiTokenSecretController.text.trim();
      if (_isEdit) {
        if (id.isEmpty && sec.isEmpty) {
          apiToken = null;
        } else if (isPartialApiTokenPair(id, sec)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.serverApiTokenErrorPartial)),
          );
          return;
        } else {
          try {
            apiToken = composeProxmoxApiTokenValue(id, sec);
          } on ArgumentError {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.serverApiTokenIdErrorInvalid)),
            );
            return;
          }
        }
      } else {
        if (id.isEmpty || sec.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.serverApiTokenErrorBothRequired)),
          );
          return;
        }
        try {
          apiToken = composeProxmoxApiTokenValue(id, sec);
        } on ArgumentError {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.serverApiTokenIdErrorInvalid)),
          );
          return;
        }
      }
    } else {
      late final String composedLogin;
      try {
        composedLogin = _composeLoginFromFormFields();
      } on ArgumentError {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.serverRealmErrorInvalid)));
        return;
      }
      final p = _passwordController.text;
      if (_isEdit) {
        password = p.isEmpty ? null : p;
        username = composedLogin == _initialUsername ? null : composedLogin;
      } else {
        username = composedLogin;
        password = p;
        if (password.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.serverPasswordErrorEmpty)),
          );
          return;
        }
      }
    }

    setState(() => _saving = true);
    try {
      await ref
          .read(serverListNotifierProvider.notifier)
          .addOrUpdate(
            server,
            apiToken: apiToken,
            username: username,
            password: password,
          );
      if (mounted) context.pop();
    } on ProxmoxException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(proxmoxExceptionMessage(e, l10n))),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.errorProxmoxUnknown)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    if (!_credentialsLoaded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            leading: shellAppBarLeading(context),
            titleSpacing: AppSpacing.sm,
            title: Text(_isEdit ? l10n.screenEditServer : l10n.screenAddServer),
          ),
          const Expanded(child: LoadingShimmer()),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(
          leading: shellAppBarLeading(context),
          titleSpacing: AppSpacing.sm,
          title: Text(_isEdit ? l10n.screenEditServer : l10n.screenAddServer),
          actions: [
            TextButton(
              onPressed: _testingConnection || _saving ? null : _testConnection,
              child:
                  _testingConnection
                      ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: scheme.primary,
                        ),
                      )
                      : Text(l10n.actionTestConnection),
            ),
            TextButton(
              onPressed: _saving || _testingConnection ? null : _save,
              child:
                  _saving
                      ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: scheme.primary,
                        ),
                      )
                      : Text(l10n.actionSave),
            ),
          ],
        ),
        Expanded(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                GroupedSection(
                  topSpacing: 0,
                  header: SectionHeader(title: l10n.serverFormIdentitySection),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: l10n.serverFieldName,
                            hintText: l10n.serverFieldNameHint,
                          ),
                          textInputAction: TextInputAction.next,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return l10n.serverNameErrorEmpty;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _hostController,
                          decoration: InputDecoration(
                            labelText: l10n.serverFieldHost,
                            hintText: l10n.serverFieldHostHint,
                          ),
                          textInputAction: TextInputAction.next,
                          autocorrect: false,
                          validator: (v) => _validateHost(v, l10n),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _portController,
                          decoration: InputDecoration(
                            labelText: l10n.serverFieldPort,
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return l10n.serverPortErrorInvalid;
                            }
                            final p = int.tryParse(v.trim());
                            if (p == null || p < 1 || p > 65535) {
                              return l10n.serverPortErrorInvalid;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                GroupedSection(
                  topSpacing: 0,
                  header: SectionHeader(title: l10n.serverFormAuthentication),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PillSegmentedButton<ServerAuthType>(
                          segments: [
                            ButtonSegment(
                              value: ServerAuthType.apiToken,
                              label: Text(l10n.serverAuthTypeApiToken),
                            ),
                            ButtonSegment(
                              value: ServerAuthType.usernamePassword,
                              label: Text(l10n.serverAuthTypeUsernamePassword),
                            ),
                          ],
                          selected: {_authType},
                          onSelectionChanged: (selection) {
                            setState(() => _authType = selection.first);
                          },
                          padding: EdgeInsets.zero,
                        ),
                        const SizedBox(height: 16),
                        if (_authType == ServerAuthType.apiToken) ...[
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: TextButton(
                              onPressed: _pasteFullApiTokenFromClipboard,
                              child: Text(l10n.serverApiTokenPasteFull),
                            ),
                          ),
                          TextFormField(
                            controller: _apiTokenIdController,
                            decoration: InputDecoration(
                              labelText: l10n.serverFieldApiTokenId,
                              hintText: l10n.serverFieldApiTokenIdHint,
                              helperText:
                                  _isEdit
                                      ? l10n.serverApiTokenLeaveBlankHint
                                      : null,
                            ),
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            validator: (v) {
                              if (_isEdit) return null;
                              final t = v?.trim() ?? '';
                              if (t.isEmpty) {
                                return l10n.serverApiTokenIdErrorEmpty;
                              }
                              if (!isWellFormedApiTokenId(t)) {
                                return l10n.serverApiTokenIdErrorInvalid;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _apiTokenSecretController,
                            decoration: InputDecoration(
                              labelText: l10n.serverFieldApiTokenSecret,
                              hintText: l10n.serverFieldApiTokenSecretHint,
                            ),
                            obscureText: true,
                            autocorrect: false,
                            textInputAction: TextInputAction.done,
                            validator: (v) {
                              if (_isEdit) return null;
                              if (v == null || v.trim().isEmpty) {
                                return l10n.serverApiTokenSecretErrorEmpty;
                              }
                              return null;
                            },
                          ),
                        ] else ...[
                          Text(
                            l10n.serverAuthTfaUseApiTokenHint,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.serverLoginComposeHint,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: l10n.serverFieldUsername,
                              hintText: l10n.serverFieldUsernameHint,
                            ),
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return l10n.serverUsernameErrorEmpty;
                              }
                              if (v.contains('@')) {
                                return l10n.serverUsernameErrorContainsAt;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            // Controlled after async load; `initialValue` only applies on first build.
                            // ignore: deprecated_member_use
                            value: _realmDropdownValue,
                            decoration: InputDecoration(
                              labelText: l10n.serverFieldRealm,
                            ),
                            items: [
                              DropdownMenuItem(
                                value: _realmPam,
                                child: Text(l10n.serverRealmPam),
                              ),
                              DropdownMenuItem(
                                value: _realmPve,
                                child: Text(l10n.serverRealmPve),
                              ),
                              DropdownMenuItem(
                                value: _realmOther,
                                child: Text(l10n.serverRealmOther),
                              ),
                            ],
                            onChanged: (v) {
                              if (v == null) return;
                              setState(() => _realmDropdownValue = v);
                            },
                          ),
                          if (_realmDropdownValue == _realmOther) ...[
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _customRealmController,
                              decoration: InputDecoration(
                                labelText: l10n.serverFieldRealmCustom,
                                hintText: l10n.serverFieldRealmCustomHint,
                              ),
                              textInputAction: TextInputAction.next,
                              autocorrect: false,
                              validator: (v) {
                                if (_realmDropdownValue != _realmOther) {
                                  return null;
                                }
                                if (v == null || v.trim().isEmpty) {
                                  return l10n.serverRealmErrorEmpty;
                                }
                                if (v.contains(' ') || v.contains('@')) {
                                  return l10n.serverRealmErrorInvalid;
                                }
                                return null;
                              },
                            ),
                          ],
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: l10n.serverFieldPassword,
                              helperText:
                                  _isEdit
                                      ? l10n.serverPasswordLeaveBlankHint
                                      : null,
                            ),
                            obscureText: true,
                            autocorrect: false,
                            validator: (v) {
                              if (_isEdit) return null;
                              if (v == null || v.isEmpty) {
                                return l10n.serverPasswordErrorEmpty;
                              }
                              return null;
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                GroupedSection(
                  topSpacing: 0,
                  header: SectionHeader(title: l10n.serverFormSecuritySection),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SwitchListTile(
                        title: Text(l10n.serverAllowSelfSigned),
                        value: _allowSelfSigned,
                        onChanged: (v) {
                          setState(() {
                            _allowSelfSigned = v;
                            if (!v) _pinController.clear();
                          });
                        },
                      ),
                      if (_allowSelfSigned) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.lg,
                            0,
                            AppSpacing.lg,
                            AppSpacing.sm,
                          ),
                          child: Material(
                            color: scheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(12),
                            clipBehavior: Clip.antiAlias,
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextFormField(
                                    controller: _pinController,
                                    decoration: InputDecoration(
                                      labelText: l10n.serverTlsPinLabel,
                                      helperText: l10n.serverTlsPinHint,
                                    ),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      fontFamily: 'monospace',
                                      fontFamilyFallback: const ['monospace'],
                                      color: scheme.onSurfaceVariant,
                                    ),
                                    autocorrect: false,
                                    maxLines: 2,
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: FilledButton.tonalIcon(
                                      onPressed:
                                          _fetchingTlsPin
                                              ? null
                                              : _fetchTlsCertificateFingerprint,
                                      icon:
                                          _fetchingTlsPin
                                              ? SizedBox(
                                                width: 18,
                                                height: 18,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: scheme.primary,
                                                    ),
                                              )
                                              : const Icon(Icons.fingerprint),
                                      label: Text(l10n.serverTlsPinFetch),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
