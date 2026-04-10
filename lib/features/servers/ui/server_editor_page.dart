import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/core/api/api_exceptions.dart';
import 'package:proxdroid/core/api/proxmox_api_client.dart';
import 'package:proxdroid/core/models/server.dart';
import 'package:proxdroid/core/storage/server_storage.dart';
import 'package:proxdroid/core/utils/proxmox_login.dart';
import 'package:proxdroid/features/servers/providers/server_providers.dart';
import 'package:proxdroid/features/settings/providers/settings_providers.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
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
  final _tokenController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _customRealmController = TextEditingController();

  /// Dropdown value: [_realmPam], [_realmPve], or [_realmOther].
  String _realmDropdownValue = _realmPam;

  ServerAuthType _authType = ServerAuthType.apiToken;
  bool _allowSelfSigned = false;
  bool _credentialsLoaded = false;
  bool _testingConnection = false;
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
    _tokenController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _customRealmController.dispose();
    super.dispose();
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
    showDialog<void>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(l10n.connectionDiagnosticsTitle),
            content: SingleChildScrollView(
              child: SelectableText(proxmoxExceptionDiagnosticsText(error)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(l10n.actionClose),
              ),
            ],
          ),
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
      final t = _tokenController.text.trim();
      if (t.isNotEmpty) {
        apiToken = t;
      } else if (existingId != null) {
        apiToken = await storage.readApiToken(existingId);
      }
      if (apiToken == null || apiToken.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.serverApiTokenErrorEmpty)),
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
    } on ArgumentError {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.serverHostErrorHttps)));
      _maybeShowConnectionDiagnostics('ArgumentError: invalid host');
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

    final id = widget.existingServer?.id ?? Uuid().v4();
    final server = Server(
      id: id,
      name: _nameController.text.trim(),
      host: _hostController.text.trim(),
      port: port,
      authType: _authType,
      allowSelfSigned: _allowSelfSigned,
    );

    String? apiToken;
    String? username;
    String? password;

    if (_authType == ServerAuthType.apiToken) {
      final t = _tokenController.text.trim();
      if (_isEdit) {
        apiToken = t.isEmpty ? null : t;
      } else {
        apiToken = t;
      }
      if (!_isEdit && (apiToken == null || apiToken.isEmpty)) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.serverApiTokenErrorEmpty)));
        return;
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
              padding: const EdgeInsets.all(16),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.serverFieldName,
                    hintText: l10n.serverFieldNameHint,
                    border: const OutlineInputBorder(),
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
                    border: const OutlineInputBorder(),
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
                    border: const OutlineInputBorder(),
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
                const SizedBox(height: 24),
                Text(
                  l10n.serverFormAuthentication,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                SegmentedButton<ServerAuthType>(
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
                ),
                const SizedBox(height: 16),
                if (_authType == ServerAuthType.apiToken) ...[
                  TextFormField(
                    controller: _tokenController,
                    decoration: InputDecoration(
                      labelText: l10n.serverFieldApiToken,
                      hintText: l10n.serverFieldApiTokenHint,
                      border: const OutlineInputBorder(),
                      helperText:
                          _isEdit ? l10n.serverApiTokenLeaveBlankHint : null,
                    ),
                    obscureText: true,
                    autocorrect: false,
                    validator: (v) {
                      if (_isEdit) return null;
                      if (v == null || v.trim().isEmpty) {
                        return l10n.serverApiTokenErrorEmpty;
                      }
                      return null;
                    },
                  ),
                ] else ...[
                  Text(
                    l10n.serverLoginComposeHint,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: l10n.serverFieldUsername,
                      hintText: l10n.serverFieldUsernameHint,
                      border: const OutlineInputBorder(),
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
                      border: const OutlineInputBorder(),
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
                        border: const OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      validator: (v) {
                        if (_realmDropdownValue != _realmOther) return null;
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
                      border: const OutlineInputBorder(),
                      helperText:
                          _isEdit ? l10n.serverPasswordLeaveBlankHint : null,
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
                const SizedBox(height: 16),
                SwitchListTile(
                  title: Text(l10n.serverAllowSelfSigned),
                  value: _allowSelfSigned,
                  onChanged: (v) => setState(() => _allowSelfSigned = v),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
