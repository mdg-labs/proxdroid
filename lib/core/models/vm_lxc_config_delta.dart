import 'package:proxdroid/core/models/guest_config_indexed_line.dart';
import 'package:proxdroid/core/models/lxc_container_config.dart';
import 'package:proxdroid/core/models/qemu_vm_config.dart';

/// Result of diffing two guest configs for `PUT …/config` plus optional
/// `delete=` (comma-separated keys per Proxmox).
class GuestConfigDeltaResult {
  GuestConfigDeltaResult({
    required Map<String, String> body,
    required List<String> deleteKeys,
  }) : body = Map.unmodifiable(body),
       deleteKeys = List.unmodifiable(deleteKeys);

  final Map<String, String> body;
  final List<String> deleteKeys;

  bool get isEmpty => body.isEmpty && deleteKeys.isEmpty;

  /// Network / disk / mount / rootfs mutations are high-impact; require
  /// explicit confirmation in the UI when the guest is stopped.
  bool get needsRiskConfirmation {
    if (deleteKeys.isNotEmpty) {
      return true;
    }
    for (final k in body.keys) {
      if (guestConfigIsNetKey(k) ||
          guestConfigIsQemuDiskKey(k) ||
          guestConfigIsLxcMpKey(k) ||
          k == 'rootfs') {
        return true;
      }
    }
    return false;
  }
}

/// Builds a minimal `application/x-www-form-urlencoded` body for
/// `PUT /nodes/{node}/qemu|lxc/{vmid}/config` plus [GuestConfigDeltaResult.deleteKeys].
///
/// **Passthrough / unchanged keys:** Omitted from the body when values are
/// unchanged. Proxmox VE treats omitted config keys on PUT as “leave
/// unchanged”. `netN` / QEMU disk keys removed from the model emit
/// `deleteKeys` entries so indices are actually dropped on the server.
GuestConfigDeltaResult qemuVmConfigDeltaResult(
  QemuVmConfig original,
  QemuVmConfig edited,
) {
  final out = <String, String>{};
  void putIfChanged(String key, String? a, String? b) {
    if (a != b) {
      out[key] = b ?? '';
    }
  }

  putIfChanged('name', original.name, edited.name);
  putIfChanged('description', original.description, edited.description);
  putIfChanged('tags', original.tags, edited.tags);
  putIfChanged('memory', original.memory, edited.memory);
  putIfChanged('sockets', original.sockets, edited.sockets);
  putIfChanged('cores', original.cores, edited.cores);
  putIfChanged('vcpus', original.vcpus, edited.vcpus);
  putIfChanged('cpu', original.cpu, edited.cpu);
  putIfChanged('ostype', original.ostype, edited.ostype);
  putIfChanged('onboot', original.onboot, edited.onboot);
  putIfChanged('startup', original.startup, edited.startup);
  putIfChanged('agent', original.agent, edited.agent);

  final origFlat = original.toFlatConfigMap();
  final editFlat = edited.toFlatConfigMap();

  bool indexedGuestKey(String k) =>
      guestConfigIsNetKey(k) || guestConfigIsQemuDiskKey(k);

  final origIdx = origFlat.keys.where(indexedGuestKey).toSet();
  final editIdx = editFlat.keys.where(indexedGuestKey).toSet();
  final deleteKeys = origIdx.difference(editIdx).toList()..sort();

  for (final k in editIdx) {
    if (origFlat[k] != editFlat[k]) {
      out[k] = editFlat[k] ?? '';
    }
  }

  final keys =
      original.passthrough.keys.toSet()..addAll(edited.passthrough.keys);
  for (final k in keys) {
    if (guestConfigIsNetKey(k) || guestConfigIsQemuDiskKey(k)) {
      continue;
    }
    final a = original.passthrough[k];
    final b = edited.passthrough[k];
    if (a != b) {
      out[k] = b ?? '';
    }
  }

  return GuestConfigDeltaResult(body: out, deleteKeys: deleteKeys);
}

/// Same semantics as [qemuVmConfigDeltaResult] for LXC `PUT …/lxc/{vmid}/config`.
GuestConfigDeltaResult lxcContainerConfigDeltaResult(
  LxcContainerConfig original,
  LxcContainerConfig edited,
) {
  final out = <String, String>{};
  void putIfChanged(String key, String? a, String? b) {
    if (a != b) {
      out[key] = b ?? '';
    }
  }

  putIfChanged('hostname', original.hostname, edited.hostname);
  putIfChanged('description', original.description, edited.description);
  putIfChanged('tags', original.tags, edited.tags);
  putIfChanged('memory', original.memory, edited.memory);
  putIfChanged('swap', original.swap, edited.swap);
  putIfChanged('cores', original.cores, edited.cores);
  putIfChanged('cpulimit', original.cpulimit, edited.cpulimit);
  putIfChanged('cpuunits', original.cpuunits, edited.cpuunits);
  putIfChanged('ostype', original.ostype, edited.ostype);
  putIfChanged('arch', original.arch, edited.arch);
  putIfChanged('onboot', original.onboot, edited.onboot);
  putIfChanged('startup', original.startup, edited.startup);
  putIfChanged('unprivileged', original.unprivileged, edited.unprivileged);
  putIfChanged('features', original.features, edited.features);
  putIfChanged('rootfs', original.rootfs, edited.rootfs);

  final origFlat = original.toFlatConfigMap();
  final editFlat = edited.toFlatConfigMap();

  bool indexedLxcGuestKey(String k) =>
      guestConfigIsNetKey(k) || guestConfigIsLxcMpKey(k);

  final origIdx = origFlat.keys.where(indexedLxcGuestKey).toSet();
  final editIdx = editFlat.keys.where(indexedLxcGuestKey).toSet();
  final deleteKeys = origIdx.difference(editIdx).toList()..sort();

  for (final k in editIdx) {
    if (origFlat[k] != editFlat[k]) {
      out[k] = editFlat[k] ?? '';
    }
  }

  final keys =
      original.passthrough.keys.toSet()..addAll(edited.passthrough.keys);
  for (final k in keys) {
    if (guestConfigIsNetKey(k) || guestConfigIsLxcMpKey(k)) {
      continue;
    }
    final a = original.passthrough[k];
    final b = edited.passthrough[k];
    if (a != b) {
      out[k] = b ?? '';
    }
  }

  return GuestConfigDeltaResult(body: out, deleteKeys: deleteKeys);
}
