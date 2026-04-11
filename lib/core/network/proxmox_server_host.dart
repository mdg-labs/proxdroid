/// Strips accidental scheme; rejects cleartext. IPv6 may be stored with or
/// without brackets — [Uri] / [SecureSocket] expect the host without brackets.
String normalizeProxmoxServerHost(String raw) {
  var h = raw.trim();
  if (h.isEmpty) {
    throw ArgumentError('Server host is empty');
  }
  final lower = h.toLowerCase();
  if (lower.startsWith('http://')) {
    throw ArgumentError(
      'Cleartext HTTP is not supported. Enter host without http:// — '
      'the app always uses HTTPS.',
    );
  }
  if (lower.startsWith('https://')) {
    h = h.substring(8);
    final slash = h.indexOf('/');
    if (slash >= 0) {
      h = h.substring(0, slash);
    }
  }
  if (h.startsWith('[') && h.endsWith(']')) {
    h = h.substring(1, h.length - 1);
  }
  return h;
}
