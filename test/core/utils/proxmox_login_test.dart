import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/core/utils/proxmox_login.dart';

void main() {
  test('buildProxmoxLoginId composes login@realm', () {
    expect(buildProxmoxLoginId('root', 'pam'), 'root@pam');
    expect(buildProxmoxLoginId('michael', 'pve'), 'michael@pve');
  });

  test('buildProxmoxLoginId rejects @ in login', () {
    expect(
      () => buildProxmoxLoginId('a@b', 'pam'),
      throwsArgumentError,
    );
  });

  test('parseProxmoxLoginIdForForm splits user@realm', () {
    expect(parseProxmoxLoginIdForForm('michael@pam'), ('michael', 'pam'));
    expect(parseProxmoxLoginIdForForm('root@pve'), ('root', 'pve'));
  });

  test('parseProxmoxLoginIdForForm uses default realm without @', () {
    expect(parseProxmoxLoginIdForForm('root'), ('root', kDefaultProxmoxRealm));
  });

  test('isPresetRealm', () {
    expect(isPresetRealm('pam'), true);
    expect(isPresetRealm('pve'), true);
    expect(isPresetRealm('ldap'), false);
  });
}
