import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:proxdroid/core/guest_config/pve_net_line.dart';
import 'package:proxdroid/core/models/node_network_iface.dart';
import 'package:proxdroid/features/dashboard/providers/dashboard_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/constants/pve_guest_enums.dart';
import 'package:proxdroid/shared/widgets/guest_config/guest_string_dropdown.dart';

/// Structured QEMU or LXC `netN` editor with optional raw fallback.
class GuestNetLineEditor extends ConsumerStatefulWidget {
  const GuestNetLineEditor({
    required this.node,
    required this.isQemu,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.forceStructured = false,
    super.key,
  });

  final String node;
  final bool isQemu;

  /// Current full net line string.
  final String value;
  final ValueChanged<String> onChanged;
  final bool enabled;

  /// When true, never auto-switch to raw (e.g. while user edits structured).
  final bool forceStructured;

  @override
  ConsumerState<GuestNetLineEditor> createState() => _GuestNetLineEditorState();
}

class _GuestNetLineEditorState extends ConsumerState<GuestNetLineEditor> {
  late bool _rawMode;
  late final TextEditingController _raw = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rawMode = _computeInitialRawMode();
    _raw.text = widget.value;
  }

  @override
  void didUpdateWidget(covariant GuestNetLineEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _rawMode) {
      _raw.text = widget.value;
    }
    if (widget.forceStructured) {
      _rawMode = false;
    }
  }

  bool _computeInitialRawMode() {
    if (widget.forceStructured) {
      return false;
    }
    if (widget.isQemu) {
      final p = tryParseQemuNetLine(widget.value);
      return p == null || !p.isStructured;
    }
    final p = tryParseLxcNetLine(widget.value);
    return p == null || !p.isStructured;
  }

  @override
  void dispose() {
    _raw.dispose();
    super.dispose();
  }

  void _emitRaw(String text) {
    widget.onChanged(text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bridgesAsync = ref.watch(nodeNetworkBridgesProvider(widget.node));

    if (_rawMode) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _raw,
            enabled: widget.enabled,
            decoration: InputDecoration(
              labelText:
                  widget.isQemu
                      ? l10n.guestCreateFieldNet0
                      : l10n.guestCreateFieldNet0,
            ),
            maxLines: 2,
            onChanged: widget.enabled ? _emitRaw : null,
          ),
          if (widget.enabled) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                final parsed =
                    widget.isQemu
                        ? tryParseQemuNetLine(_raw.text)
                        : tryParseLxcNetLine(_raw.text);
                final ok =
                    widget.isQemu
                        ? parsed is ParsedQemuNetLine && parsed.isStructured
                        : parsed is ParsedLxcNetLine && parsed.isStructured;
                if (ok) {
                  setState(() => _rawMode = false);
                  _emitRaw(_raw.text.trim());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.guestPickerParseFallbackHint)),
                  );
                }
              },
              child: Text(l10n.guestPickerUseSimpleEditor),
            ),
          ],
        ],
      );
    }

    return bridgesAsync.when(
      loading:
          () => ListTile(
            title: Text(l10n.guestPickerLoadingBridges),
            trailing: const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
      error:
          (Object? error, StackTrace stack) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.guestPickerNoBridges),
              TextFormField(
                initialValue: widget.value,
                enabled: widget.enabled,
                decoration: const InputDecoration(),
                onChanged: widget.enabled ? _emitRaw : null,
              ),
            ],
          ),
      data: (List<NodeNetworkIface> bridges) {
        if (widget.isQemu) {
          final p = tryParseQemuNetLine(widget.value);
          var model = p?.model ?? 'virtio';
          var bridge =
              p?.bridge ?? (bridges.isNotEmpty ? bridges.first.iface : '');
          if (bridges.isNotEmpty &&
              bridge.isNotEmpty &&
              !bridges.any((b) => b.iface == bridge)) {
            bridge = bridges.first.iface;
          }
          if (!pveQemuNicModels.contains(model)) {
            model = pveQemuNicModels.first;
          }
          return _QemuStructured(
            bridges: bridges,
            model: model,
            bridge: bridge,
            enabled: widget.enabled,
            onStructChanged: (m, b) {
              widget.onChanged(buildQemuNetLine(model: m, bridge: b));
            },
            onShowRaw:
                () => setState(() {
                  _rawMode = true;
                  _raw.text = widget.value;
                }),
            l10n: l10n,
          );
        }
        final p = tryParseLxcNetLine(widget.value);
        var name = p?.name ?? 'eth0';
        var bridge =
            p?.bridge ?? (bridges.isNotEmpty ? bridges.first.iface : '');
        if (bridges.isNotEmpty &&
            bridge.isNotEmpty &&
            !bridges.any((b) => b.iface == bridge)) {
          bridge = bridges.first.iface;
        }
        var ipMode = p?.ipMode ?? GuestNetIpMode.dhcp;
        var staticIp = p?.staticIp ?? '';
        return _LxcStructured(
          bridges: bridges,
          name: name,
          bridge: bridge,
          ipMode: ipMode,
          staticIp: staticIp,
          enabled: widget.enabled,
          onStructChanged: (n, b, mode, sip) {
            widget.onChanged(
              buildLxcNetLine(name: n, bridge: b, ipMode: mode, staticIp: sip),
            );
          },
          onShowRaw:
              () => setState(() {
                _rawMode = true;
                _raw.text = widget.value;
              }),
          l10n: l10n,
        );
      },
    );
  }
}

class _QemuStructured extends StatefulWidget {
  const _QemuStructured({
    required this.bridges,
    required this.model,
    required this.bridge,
    required this.enabled,
    required this.onStructChanged,
    required this.onShowRaw,
    required this.l10n,
  });

  final List<NodeNetworkIface> bridges;
  final String model;
  final String bridge;
  final bool enabled;
  final void Function(String model, String bridge) onStructChanged;
  final VoidCallback onShowRaw;
  final AppLocalizations l10n;

  @override
  State<_QemuStructured> createState() => _QemuStructuredState();
}

class _QemuStructuredState extends State<_QemuStructured> {
  late String _model;
  late String _bridge;

  @override
  void initState() {
    super.initState();
    _model = widget.model;
    _bridge = widget.bridge;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.bridges.isEmpty) {
        return;
      }
      final resolved =
          widget.bridges.any((b) => b.iface == _bridge)
              ? _bridge
              : widget.bridges.first.iface;
      if (resolved != _bridge) {
        setState(() => _bridge = resolved);
      }
      widget.onStructChanged(_model, resolved);
    });
  }

  @override
  void didUpdateWidget(covariant _QemuStructured oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.model != widget.model) {
      _model = widget.model;
    }
    if (oldWidget.bridge != widget.bridge) {
      _bridge = widget.bridge;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final bridgeItems =
        widget.bridges.isEmpty
            ? <DropdownMenuItem<String>>[
              DropdownMenuItem(value: _bridge, child: Text(_bridge)),
            ]
            : widget.bridges
                .map(
                  (b) => DropdownMenuItem(value: b.iface, child: Text(b.iface)),
                )
                .toList();
    if (widget.bridges.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.guestPickerNoBridges),
          if (widget.enabled)
            TextButton(
              onPressed: widget.onShowRaw,
              child: Text(l10n.guestPickerAdvancedRaw),
            ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GuestStringDropdown(
          label: l10n.guestPickerNicModel,
          ids: pveQemuNicModels,
          value: _model,
          enabled: widget.enabled,
          onChanged:
              widget.enabled
                  ? (v) {
                    if (v != null) {
                      setState(() => _model = v);
                      widget.onStructChanged(v, _bridge);
                    }
                  }
                  : (_) {},
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          // ignore: deprecated_member_use
          value: _bridge.isEmpty ? bridgeItems.first.value : _bridge,
          decoration: InputDecoration(labelText: l10n.guestPickerBridge),
          items: bridgeItems,
          onChanged:
              widget.enabled
                  ? (v) {
                    if (v != null) {
                      setState(() => _bridge = v);
                      widget.onStructChanged(_model, v);
                    }
                  }
                  : null,
        ),
        if (widget.enabled) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: widget.onShowRaw,
              child: Text(l10n.guestPickerAdvancedRaw),
            ),
          ),
        ],
      ],
    );
  }
}

class _LxcStructured extends StatefulWidget {
  const _LxcStructured({
    required this.bridges,
    required this.name,
    required this.bridge,
    required this.ipMode,
    required this.staticIp,
    required this.enabled,
    required this.onStructChanged,
    required this.onShowRaw,
    required this.l10n,
  });

  final List<NodeNetworkIface> bridges;
  final String name;
  final String bridge;
  final GuestNetIpMode ipMode;
  final String staticIp;
  final bool enabled;
  final void Function(
    String name,
    String bridge,
    GuestNetIpMode mode,
    String staticIp,
  )
  onStructChanged;
  final VoidCallback onShowRaw;
  final AppLocalizations l10n;

  @override
  State<_LxcStructured> createState() => _LxcStructuredState();
}

class _LxcStructuredState extends State<_LxcStructured> {
  late String _bridge;
  late GuestNetIpMode _ipMode;
  late final TextEditingController _name = TextEditingController();
  late final TextEditingController _static = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name.text = widget.name;
    _bridge = widget.bridge;
    _ipMode = widget.ipMode;
    _static.text = widget.staticIp;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.bridges.isEmpty) {
        return;
      }
      final resolved =
          widget.bridges.any((b) => b.iface == _bridge)
              ? _bridge
              : widget.bridges.first.iface;
      if (resolved != _bridge) {
        setState(() => _bridge = resolved);
      }
      widget.onStructChanged(
        _name.text.trim().isEmpty ? 'eth0' : _name.text.trim(),
        resolved,
        _ipMode,
        _static.text.trim(),
      );
    });
  }

  @override
  void didUpdateWidget(covariant _LxcStructured oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.staticIp != widget.staticIp) {
      _static.text = widget.staticIp;
    }
    if (oldWidget.name != widget.name) {
      _name.text = widget.name;
    }
    if (oldWidget.bridge != widget.bridge) {
      _bridge = widget.bridge;
    }
    if (oldWidget.ipMode != widget.ipMode) {
      _ipMode = widget.ipMode;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _static.dispose();
    super.dispose();
  }

  void _notify() {
    widget.onStructChanged(
      _name.text.trim().isEmpty ? 'eth0' : _name.text.trim(),
      _bridge,
      _ipMode,
      _static.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final bridgeItems =
        widget.bridges.isEmpty
            ? <DropdownMenuItem<String>>[
              DropdownMenuItem(value: _bridge, child: Text(_bridge)),
            ]
            : widget.bridges
                .map(
                  (b) => DropdownMenuItem(value: b.iface, child: Text(b.iface)),
                )
                .toList();
    if (widget.bridges.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.guestPickerNoBridges),
          if (widget.enabled)
            TextButton(
              onPressed: widget.onShowRaw,
              child: Text(l10n.guestPickerAdvancedRaw),
            ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _name,
          enabled: widget.enabled,
          decoration: InputDecoration(labelText: l10n.guestPickerIfaceName),
          onChanged: widget.enabled ? (_) => _notify() : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          // ignore: deprecated_member_use
          value: _bridge.isEmpty ? bridgeItems.first.value : _bridge,
          decoration: InputDecoration(labelText: l10n.guestPickerBridge),
          items: bridgeItems,
          onChanged:
              widget.enabled
                  ? (v) {
                    if (v != null) {
                      setState(() => _bridge = v);
                      _notify();
                    }
                  }
                  : null,
        ),
        const SizedBox(height: 12),
        Text(
          l10n.guestPickerNetIpMode,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SegmentedButton<GuestNetIpMode>(
          segments: [
            ButtonSegment(
              value: GuestNetIpMode.none,
              label: Text(l10n.guestPickerNetIpNone),
            ),
            ButtonSegment(
              value: GuestNetIpMode.dhcp,
              label: Text(l10n.guestPickerNetIpDhcp),
            ),
            ButtonSegment(
              value: GuestNetIpMode.static,
              label: Text(l10n.guestPickerNetIpStatic),
            ),
          ],
          selected: {_ipMode},
          onSelectionChanged:
              widget.enabled
                  ? (s) {
                    setState(() => _ipMode = s.first);
                    _notify();
                  }
                  : null,
        ),
        if (_ipMode == GuestNetIpMode.static) ...[
          const SizedBox(height: 8),
          TextFormField(
            controller: _static,
            enabled: widget.enabled,
            decoration: InputDecoration(
              labelText: l10n.guestPickerStaticIpLabel,
              hintText: l10n.guestPickerNetStaticHint,
            ),
            onChanged: widget.enabled ? (_) => _notify() : null,
          ),
        ],
        if (widget.enabled) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: widget.onShowRaw,
              child: Text(l10n.guestPickerAdvancedRaw),
            ),
          ),
        ],
      ],
    );
  }
}
