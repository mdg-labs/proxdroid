// Parse and build Proxmox `netN` lines for QEMU and LXC (common cases only).

enum GuestNetIpMode { none, dhcp, static }

/// Parsed QEMU net line (`virtio,bridge=vmbr0`, …).
class ParsedQemuNetLine {
  const ParsedQemuNetLine({
    required this.model,
    required this.bridge,
    this.extraOptions = '',
  });

  final String model;
  final String bridge;

  /// Comma-separated tail not represented in structured fields (preserved).
  final String extraOptions;

  bool get isStructured =>
      model.isNotEmpty && bridge.isNotEmpty && extraOptions.isEmpty;
}

/// Parsed LXC net line (`name=eth0,bridge=vmbr0,ip=dhcp`, …).
class ParsedLxcNetLine {
  const ParsedLxcNetLine({
    required this.name,
    required this.bridge,
    this.ipMode = GuestNetIpMode.none,
    this.staticIp = '',
    this.extraOptions = '',
  });

  final String name;
  final String bridge;
  final GuestNetIpMode ipMode;
  final String staticIp;
  final String extraOptions;

  bool get isStructured =>
      name.isNotEmpty &&
      bridge.isNotEmpty &&
      extraOptions.isEmpty &&
      (ipMode != GuestNetIpMode.static || staticIp.trim().isNotEmpty);
}

ParsedQemuNetLine? tryParseQemuNetLine(String raw) {
  final s = raw.trim();
  if (s.isEmpty) {
    return null;
  }
  final parts = s.split(',');
  if (parts.isEmpty) {
    return null;
  }
  String? model;
  String? bridge;
  final tail = <String>[];
  for (final p in parts) {
    final t = p.trim();
    if (t.isEmpty) {
      continue;
    }
    if (!t.contains('=')) {
      if (model == null) {
        model = t;
      } else {
        tail.add(t);
      }
      continue;
    }
    final eq = t.indexOf('=');
    final k = t.substring(0, eq).trim().toLowerCase();
    final v = t.substring(eq + 1).trim();
    if (k == 'bridge') {
      bridge = v;
    } else {
      tail.add(t);
    }
  }
  if (model == null || bridge == null || bridge.isEmpty) {
    return null;
  }
  if (tail.isNotEmpty) {
    return ParsedQemuNetLine(
      model: model,
      bridge: bridge,
      extraOptions: tail.join(','),
    );
  }
  return ParsedQemuNetLine(model: model, bridge: bridge);
}

ParsedLxcNetLine? tryParseLxcNetLine(String raw) {
  final s = raw.trim();
  if (s.isEmpty) {
    return null;
  }
  final parts = s.split(',');
  String? name;
  String? bridge;
  GuestNetIpMode ipMode = GuestNetIpMode.none;
  String staticIp = '';
  final tail = <String>[];
  for (final p in parts) {
    final t = p.trim();
    if (t.isEmpty) {
      continue;
    }
    if (!t.contains('=')) {
      tail.add(t);
      continue;
    }
    final eq = t.indexOf('=');
    final k = t.substring(0, eq).trim().toLowerCase();
    final v = t.substring(eq + 1).trim();
    if (k == 'name') {
      name = v;
    } else if (k == 'bridge') {
      bridge = v;
    } else if (k == 'ip') {
      final low = v.toLowerCase();
      if (low == 'dhcp') {
        ipMode = GuestNetIpMode.dhcp;
      } else {
        ipMode = GuestNetIpMode.static;
        staticIp = v;
      }
    } else {
      tail.add(t);
    }
  }
  if (name == null || bridge == null || bridge.isEmpty) {
    return null;
  }
  if (tail.isNotEmpty) {
    return ParsedLxcNetLine(
      name: name,
      bridge: bridge,
      ipMode: ipMode,
      staticIp: staticIp,
      extraOptions: tail.join(','),
    );
  }
  return ParsedLxcNetLine(
    name: name,
    bridge: bridge,
    ipMode: ipMode,
    staticIp: staticIp,
  );
}

String buildQemuNetLine({
  required String model,
  required String bridge,
  String extraOptions = '',
}) {
  final b = bridge.trim();
  final m = model.trim();
  final core = '$m,bridge=$b';
  final x = extraOptions.trim();
  if (x.isEmpty) {
    return core;
  }
  return '$core,$x';
}

String buildLxcNetLine({
  required String name,
  required String bridge,
  GuestNetIpMode ipMode = GuestNetIpMode.dhcp,
  String staticIp = '',
  String extraOptions = '',
}) {
  final parts = <String>['name=${name.trim()}', 'bridge=${bridge.trim()}'];
  switch (ipMode) {
    case GuestNetIpMode.none:
      break;
    case GuestNetIpMode.dhcp:
      parts.add('ip=dhcp');
    case GuestNetIpMode.static:
      parts.add('ip=${staticIp.trim()}');
  }
  final x = extraOptions.trim();
  if (x.isNotEmpty) {
    parts.add(x);
  }
  return parts.join(',');
}
