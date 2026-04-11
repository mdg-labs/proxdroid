import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import 'package:proxdroid/core/network/proxmox_server_host.dart';

/// Normalizes a user-entered or stored TLS pin (lowercase hex, no spaces).
String? normalizePinnedTlsSha256(String? raw) {
  if (raw == null) return null;
  final s = raw.trim().replaceAll(RegExp(r'\s'), '').toLowerCase();
  if (s.isEmpty) return null;
  if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(s)) return null;
  return s;
}

/// Whether [raw] is non-null and a valid 64-char lowercase hex SHA-256 string.
bool isValidPinnedTlsSha256Format(String? raw) =>
    normalizePinnedTlsSha256(raw) != null;

/// SHA-256 of the leaf certificate DER as lowercase hex (64 chars).
String leafCertificateSha256Hex(X509Certificate cert) =>
    sha256.convert(cert.der).toString();

bool _constantTimeBytesEqual(Uint8List a, Uint8List b) {
  if (a.length != b.length) return false;
  var r = 0;
  for (var i = 0; i < a.length; i++) {
    r |= a[i] ^ b[i];
  }
  return r == 0;
}

/// Decodes [hexLower] (64 hex chars) to 32 bytes; returns null if invalid.
Uint8List? _hexSha256ToBytes(String hexLower) {
  if (hexLower.length != 64) return null;
  final out = Uint8List(32);
  for (var i = 0; i < 32; i++) {
    final hi = _hexNibble(hexLower.codeUnitAt(i * 2));
    final lo = _hexNibble(hexLower.codeUnitAt(i * 2 + 1));
    if (hi < 0 || lo < 0) return null;
    out[i] = (hi << 4) + lo;
  }
  return out;
}

int _hexNibble(int c) {
  if (c >= 0x30 && c <= 0x39) return c - 0x30;
  if (c >= 0x61 && c <= 0x66) return c - 0x61 + 10;
  return -1;
}

/// True if [cert]'s leaf DER SHA-256 matches [pinnedHex] (after [normalizePinnedTlsSha256]).
bool certificateMatchesPin(X509Certificate cert, String pinnedHex) {
  final normalized = normalizePinnedTlsSha256(pinnedHex);
  if (normalized == null) return false;
  final expected = _hexSha256ToBytes(normalized);
  if (expected == null) return false;
  final actual = Uint8List.fromList(sha256.convert(cert.der).bytes);
  return _constantTimeBytesEqual(actual, expected);
}

/// Opens a TLS socket to [host]:[port], accepts any server cert once, returns
/// leaf SHA-256 hex or null on failure. Does not send application data.
Future<String?> fetchLeafCertSha256Hex({
  required String host,
  required int port,
  Duration timeout = const Duration(seconds: 15),
}) async {
  Future<String?> inner() async {
    SecureSocket? socket;
    try {
      final h = normalizeProxmoxServerHost(host);
      socket = await SecureSocket.connect(
        h,
        port,
        onBadCertificate: (_) => true,
      );
      final cert = socket.peerCertificate;
      if (cert == null) return null;
      return leafCertificateSha256Hex(cert);
    } on Object {
      return null;
    } finally {
      await socket?.close();
    }
  }

  try {
    return await inner().timeout(timeout);
  } on Object {
    return null;
  }
}
