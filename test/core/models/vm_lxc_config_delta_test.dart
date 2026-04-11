import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/core/models/lxc_container_config.dart';
import 'package:proxdroid/core/models/qemu_vm_config.dart';
import 'package:proxdroid/core/models/vm_lxc_config_delta.dart';

void main() {
  test('qemuVmConfigDelta: only name change emits only name', () {
    final raw =
        jsonDecode(File('test/fixtures/qemu_config_8x.json').readAsStringSync())
            as Map<String, dynamic>;
    final original = QemuVmConfig.fromProxmoxConfigData(raw);
    final edited = original.copyWith(name: 'renamed-only');
    final delta = qemuVmConfigDeltaResult(original, edited);
    expect(delta.body.keys, unorderedEquals(['name']));
    expect(delta.body['name'], 'renamed-only');
    expect(delta.deleteKeys, isEmpty);
  });

  test('lxcContainerConfigDelta: only hostname change emits only hostname', () {
    final raw =
        jsonDecode(File('test/fixtures/lxc_config_9x.json').readAsStringSync())
            as Map<String, dynamic>;
    final original = LxcContainerConfig.fromProxmoxConfigData(raw);
    final edited = original.copyWith(hostname: 'new-host');
    final delta = lxcContainerConfigDeltaResult(original, edited);
    expect(delta.body.keys, unorderedEquals(['hostname']));
    expect(delta.body['hostname'], 'new-host');
    expect(delta.deleteKeys, isEmpty);
  });
}
