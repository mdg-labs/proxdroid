import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:proxdroid/core/guest_config/pve_disk_line.dart';
import 'package:proxdroid/core/models/backup.dart';
import 'package:proxdroid/core/models/storage.dart';
import 'package:proxdroid/features/storage/providers/storage_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';

enum _GuestDiskMode { newGiB, existingVol }

/// Pick storage pool + new size (GiB) or existing volume; builds `STORAGE:…`.
class GuestDiskVolumeEditor extends ConsumerStatefulWidget {
  const GuestDiskVolumeEditor({
    required this.node,
    required this.contentKind,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });

  final String node;

  /// PVE storage `content` filter for pools, e.g. `images` or `rootdir`.
  final String contentKind;
  final String value;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  ConsumerState<GuestDiskVolumeEditor> createState() =>
      _GuestDiskVolumeEditorState();
}

class _GuestDiskVolumeEditorState extends ConsumerState<GuestDiskVolumeEditor> {
  late bool _rawMode;
  late final TextEditingController _raw = TextEditingController();
  _GuestDiskMode _mode = _GuestDiskMode.newGiB;
  String? _pool;
  String? _volid;
  late final TextEditingController _sizeGiB = TextEditingController(text: '32');
  bool _seededEmptyValue = false;

  @override
  void initState() {
    super.initState();
    final parsed = tryParsePveDiskPrefix(widget.value);
    _rawMode = parsed == null || !parsed.isStructured;
    _raw.text = widget.value;
    if (!_rawMode && parsed != null) {
      _pool = parsed.storage;
      if (parsed.kind == PveDiskVolumeKind.newSizeGb) {
        _mode = _GuestDiskMode.newGiB;
        _sizeGiB.text = parsed.volumeOrSize;
      } else {
        _mode = _GuestDiskMode.existingVol;
        _volid = '${parsed.storage}:${parsed.volumeOrSize}';
      }
    }
  }

  @override
  void didUpdateWidget(covariant GuestDiskVolumeEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _rawMode) {
      _raw.text = widget.value;
    }
  }

  @override
  void dispose() {
    _raw.dispose();
    _sizeGiB.dispose();
    super.dispose();
  }

  void _emitStructured() {
    final p = _pool?.trim();
    if (p == null || p.isEmpty) {
      return;
    }
    if (_mode == _GuestDiskMode.newGiB) {
      final sz = _sizeGiB.text.trim();
      if (sz.isEmpty) {
        return;
      }
      widget.onChanged(
        buildPveDiskPrefix(
          storage: p,
          kind: PveDiskVolumeKind.newSizeGb,
          volumeOrSize: sz,
        ),
      );
    } else {
      final v = _volid?.trim();
      if (v == null || v.isEmpty) {
        return;
      }
      // [BackupContent.volid] is typically the full `pool:volume` id from PVE.
      widget.onChanged(v);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final poolsAsync = ref.watch(
      nodeStoragePoolsWithKindProvider(widget.node, widget.contentKind),
    );

    ref.listen(
      nodeStoragePoolsWithKindProvider(widget.node, widget.contentKind),
      (prev, next) {
        next.whenData((pools) {
          if (_rawMode ||
              pools.isEmpty ||
              !widget.enabled ||
              widget.value.trim().isNotEmpty ||
              _seededEmptyValue) {
            return;
          }
          _seededEmptyValue = true;
          if (!mounted) {
            return;
          }
          setState(() => _pool = pools.first.id);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _emitStructured();
            }
          });
        });
      },
    );

    if (_rawMode) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _raw,
            enabled: widget.enabled,
            decoration: const InputDecoration(),
            maxLines: 2,
            onChanged:
                widget.enabled ? (t) => widget.onChanged(t.trim()) : null,
          ),
          if (widget.enabled)
            TextButton(
              onPressed: () {
                final parsed = tryParsePveDiskPrefix(_raw.text);
                if (parsed != null && parsed.isStructured) {
                  setState(() {
                    _rawMode = false;
                    _pool = parsed.storage;
                    if (parsed.kind == PveDiskVolumeKind.newSizeGb) {
                      _mode = _GuestDiskMode.newGiB;
                      _sizeGiB.text = parsed.volumeOrSize;
                    } else {
                      _mode = _GuestDiskMode.existingVol;
                      _volid = '${parsed.storage}:${parsed.volumeOrSize}';
                    }
                  });
                  widget.onChanged(_raw.text.trim());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.guestPickerParseFallbackHint)),
                  );
                }
              },
              child: Text(l10n.guestPickerUseSimpleEditor),
            ),
        ],
      );
    }

    return poolsAsync.when(
      loading:
          () => const ListTile(
            title: Text(''),
            trailing: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
      error:
          (Object? error, StackTrace stackTrace) =>
              Text(l10n.guestPickerNoStoragePools),
      data: (List<Storage> pools) {
        if (pools.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.guestPickerNoStoragePools),
              if (widget.enabled)
                TextButton(
                  onPressed:
                      () => setState(() {
                        _rawMode = true;
                        _raw.text = widget.value;
                      }),
                  child: Text(l10n.guestPickerAdvancedRaw),
                ),
            ],
          );
        }
        final poolId =
            _pool != null && pools.any((s) => s.id == _pool)
                ? _pool!
                : pools.first.id;

        final volsAsync = ref.watch(
          guestStorageContentByKindProvider(
            widget.node,
            poolId,
            widget.contentKind,
          ),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              // ignore: deprecated_member_use
              value: poolId,
              decoration: InputDecoration(
                labelText: l10n.guestPickerStoragePool,
              ),
              items:
                  pools
                      .map(
                        (s) => DropdownMenuItem(value: s.id, child: Text(s.id)),
                      )
                      .toList(),
              onChanged:
                  widget.enabled
                      ? (v) {
                        if (v != null) {
                          setState(() {
                            _pool = v;
                            _volid = null;
                          });
                          _emitStructured();
                        }
                      }
                      : null,
            ),
            const SizedBox(height: 12),
            IgnorePointer(
              ignoring: !widget.enabled,
              child: SegmentedButton<_GuestDiskMode>(
                segments: [
                  ButtonSegment(
                    value: _GuestDiskMode.newGiB,
                    label: Text(l10n.guestPickerDiskModeNew),
                  ),
                  ButtonSegment(
                    value: _GuestDiskMode.existingVol,
                    label: Text(l10n.guestPickerDiskModeExisting),
                  ),
                ],
                selected: {_mode},
                onSelectionChanged: (s) {
                  if (s.isEmpty) {
                    return;
                  }
                  setState(() => _mode = s.first);
                  _emitStructured();
                },
              ),
            ),
            if (_mode == _GuestDiskMode.newGiB)
              TextFormField(
                controller: _sizeGiB,
                enabled: widget.enabled,
                decoration: InputDecoration(labelText: l10n.guestPickerSizeGiB),
                keyboardType: TextInputType.number,
                onChanged: widget.enabled ? (_) => _emitStructured() : null,
              )
            else
              volsAsync.when(
                loading:
                    () => const Padding(
                      padding: EdgeInsets.all(8),
                      child: LinearProgressIndicator(),
                    ),
                error:
                    (Object? error, StackTrace stackTrace) =>
                        Text(l10n.guestPickerNoStoragePools),
                data: (List<BackupContent> vols) {
                  if (vols.isEmpty) {
                    return Text(l10n.guestPickerNoStoragePools);
                  }
                  final ids = vols.map((v) => v.volid).toList();
                  final v0 =
                      _volid != null && ids.contains(_volid)
                          ? _volid!
                          : ids.first;
                  return DropdownButtonFormField<String>(
                    // ignore: deprecated_member_use
                    value: v0,
                    decoration: InputDecoration(
                      labelText: l10n.guestPickerVolume,
                    ),
                    isExpanded: true,
                    items:
                        vols
                            .map(
                              (v) => DropdownMenuItem(
                                value: v.volid,
                                child: Text(
                                  v.volid,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                    onChanged:
                        widget.enabled
                            ? (v) {
                              if (v != null) {
                                setState(() => _volid = v);
                                _emitStructured();
                              }
                            }
                            : null,
                  );
                },
              ),
            if (widget.enabled) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed:
                      () => setState(() {
                        _rawMode = true;
                        _raw.text = widget.value;
                      }),
                  child: Text(l10n.guestPickerAdvancedRaw),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
