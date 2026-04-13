/// Helpers for Proxmox API token form entry (`USER@REALM!TOKENID=SECRET` for
/// `Authorization: PVEAPIToken=...`).
library;

/// Optional prefix when users paste a full Authorization header fragment.
const String kProxmoxApiTokenHeaderPrefix = 'PVEAPIToken=';

/// Builds the value sent as `PVEAPIToken=<return>` (not including the prefix).
///
/// [tokenId] must contain `!` and must not contain `=`. [secret] must be
/// non-empty after trim.
String composeProxmoxApiTokenValue(String tokenId, String secret) {
  final id = tokenId.trim();
  final sec = secret.trim();
  if (id.isEmpty || sec.isEmpty) {
    throw ArgumentError('Token ID and secret must be non-empty');
  }
  if (!id.contains('!')) {
    throw ArgumentError.value(
      tokenId,
      'tokenId',
      'must contain ! (e.g. root@pam!mytoken)',
    );
  }
  if (id.contains('=')) {
    throw ArgumentError.value(
      tokenId,
      'tokenId',
      'must not contain =; enter the secret in the separate field',
    );
  }
  return '$id=$sec';
}

/// Strips a leading `PVEAPIToken=` (case-insensitive) and surrounding whitespace.
String stripProxmoxApiTokenHeaderPrefix(String input) {
  var s = input.trim();
  final lower = s.toLowerCase();
  final p = kProxmoxApiTokenHeaderPrefix.toLowerCase();
  if (lower.startsWith(p)) {
    s = s.substring(p.length).trim();
  }
  return s;
}

/// Splits a pasted combined token into Token ID and Secret.
///
/// Uses the first `=` that appears after the first `!`, matching Proxmox
/// `USER@REALM!NAME=SECRET`. Returns null if the shape is not recognized.
({String tokenId, String secret})? trySplitFullApiToken(String pasted) {
  final s = stripProxmoxApiTokenHeaderPrefix(pasted);
  if (s.isEmpty) return null;
  final bang = s.indexOf('!');
  if (bang < 0) return null;
  final eq = s.indexOf('=', bang);
  if (eq < 0 || eq >= s.length - 1) return null;
  final tokenId = s.substring(0, eq).trim();
  final secret = s.substring(eq + 1).trim();
  if (tokenId.isEmpty || secret.isEmpty) return null;
  if (!tokenId.contains('!')) return null;
  if (tokenId.contains('=')) return null;
  return (tokenId: tokenId, secret: secret);
}

/// Whether [tokenId] is non-empty, contains `!`, and has no `=`.
bool isWellFormedApiTokenId(String tokenId) {
  final t = tokenId.trim();
  return t.isNotEmpty && t.contains('!') && !t.contains('=');
}

/// True if exactly one of the trimmed fields is non-empty (invalid pair).
bool isPartialApiTokenPair(String tokenId, String secret) {
  final a = tokenId.trim().isNotEmpty;
  final b = secret.trim().isNotEmpty;
  return a != b;
}
