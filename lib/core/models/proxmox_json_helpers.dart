/// Shared JSON coercion for Proxmox `api2/json` payloads (nums, nested maps).
library;

int? proxmoxInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

double? proxmoxDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

String proxmoxString(dynamic value, {String fallback = ''}) {
  if (value == null) return fallback;
  if (value is String) return value;
  return value.toString();
}

/// Normalizes PVE-style hex colors to 6 uppercase hex digits, or null if invalid.
String? proxmoxNormalizeHexColor(String? raw) {
  if (raw == null) return null;
  var s = raw.trim();
  if (s.isEmpty) return null;
  if (s.startsWith('#')) s = s.substring(1);
  if (s.length == 3) {
    final a = s.split('');
    if (a.length == 3) {
      s = '${a[0]}${a[0]}${a[1]}${a[1]}${a[2]}${a[2]}';
    }
  }
  if (!RegExp(r'^[0-9A-Fa-f]{6}$').hasMatch(s)) {
    return null;
  }
  return s.toUpperCase();
}
