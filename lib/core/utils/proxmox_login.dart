/// Proxmox `/access/ticket` expects `username` as `login@realm` (e.g. `root@pam`).
library;

/// Default realm when the stored value has no `@` (legacy forms).
const String kDefaultProxmoxRealm = 'pam';

/// Known realms shown first in the UI; "other" is free text.
const List<String> kCommonProxmoxRealms = ['pam', 'pve'];

/// Builds `login@realm` for API and secure storage.
///
/// [login] must not contain `@`. [realm] is trimmed and must be non-empty.
String buildProxmoxLoginId(String login, String realm) {
  final l = login.trim();
  final r = realm.trim();
  if (l.contains('@')) {
    throw ArgumentError.value(login, 'login', 'must not contain @');
  }
  if (r.isEmpty) {
    throw ArgumentError.value(realm, 'realm', 'must not be empty');
  }
  if (r.contains(' ') || r.contains('@')) {
    throw ArgumentError.value(realm, 'realm', 'must not contain spaces or @');
  }
  return '$l@$r';
}

/// Splits a stored `user@realm` for the editor form.
///
/// If there is no `@`, returns `(stored, kDefaultProxmoxRealm)`.
(String login, String realm) parseProxmoxLoginIdForForm(String stored) {
  final s = stored.trim();
  final at = s.indexOf('@');
  if (at < 0) {
    return (s, kDefaultProxmoxRealm);
  }
  final login = s.substring(0, at).trim();
  final realm = s.substring(at + 1).trim();
  if (realm.isEmpty) {
    return (login.isEmpty ? s : login, kDefaultProxmoxRealm);
  }
  return (login, realm);
}

/// Whether [realm] is one of [kCommonProxmoxRealms] (case-sensitive as stored).
bool isPresetRealm(String realm) => kCommonProxmoxRealms.contains(realm);
