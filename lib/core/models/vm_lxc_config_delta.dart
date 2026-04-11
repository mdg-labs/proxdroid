import 'package:proxdroid/core/models/lxc_container_config.dart';
import 'package:proxdroid/core/models/qemu_vm_config.dart';

/// Builds a minimal `application/x-www-form-urlencoded` body for
/// `PUT /nodes/{node}/qemu|lxc/{vmid}/config`.
///
/// **Passthrough / unchanged keys:** Omitted from the delta when values are
/// unchanged. Proxmox VE treats omitted config keys on PUT as “leave
/// unchanged” (same as the web UI partial updates), so we do **not** re-send
/// the full passthrough map on every save.
Map<String, String> qemuVmConfigDelta(
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

  final keys =
      original.passthrough.keys.toSet()..addAll(edited.passthrough.keys);
  for (final k in keys) {
    final a = original.passthrough[k];
    final b = edited.passthrough[k];
    if (a != b) {
      out[k] = b ?? '';
    }
  }

  return out;
}

/// Same semantics as [qemuVmConfigDelta] for LXC `PUT …/lxc/{vmid}/config`.
Map<String, String> lxcContainerConfigDelta(
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

  final keys =
      original.passthrough.keys.toSet()..addAll(edited.passthrough.keys);
  for (final k in keys) {
    final a = original.passthrough[k];
    final b = edited.passthrough[k];
    if (a != b) {
      out[k] = b ?? '';
    }
  }

  return out;
}
