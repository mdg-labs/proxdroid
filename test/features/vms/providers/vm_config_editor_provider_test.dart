import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/features/vms/data/vm_repository.dart';
import 'package:proxdroid/features/vms/providers/vm_config_providers.dart';
import 'package:proxdroid/features/vms/providers/vm_providers.dart';
import 'package:proxdroid/shared/constants/api_endpoints.dart';

import '../../../support/proxmox_test_client.dart';

void main() {
  test(
    'QemuVmConfigEditor save sends PUT delta then refetches GET config',
    () async {
      final (client, adapter) = proxmoxClientWithFakeAdapter([
        jsonResponse(<String, dynamic>{'name': 'alpha', 'memory': '512'}),
        jsonResponse(null),
        jsonResponse(<String, dynamic>{'name': 'beta', 'memory': '512'}),
        // Editor + qemuVmConfig invalidation may schedule more than one GET.
        jsonResponse(<String, dynamic>{'name': 'beta', 'memory': '512'}),
      ]);
      final repo = VmRepository(client);

      final container = ProviderContainer(
        overrides: [vmRepositoryProvider.overrideWith((ref) async => repo)],
      );
      addTearDown(container.dispose);

      const node = 'n1';
      const vmid = 7;

      // Hold subscription before first await so autoDispose does not drop the
      // editor between awaits (which would re-fetch and consume canned PUT).
      final keepAlive = container.listen(
        qemuVmConfigEditorProvider(node, vmid),
        (_, _) {},
      );
      addTearDown(keepAlive.close);

      await container.read(qemuVmConfigEditorProvider(node, vmid).future);
      expect(adapter.requests, hasLength(1));
      expect(adapter.requests.single.method, 'GET');
      expect(
        adapter.requests.single.path,
        ApiEndpoints.nodeQemuVmConfig(node, vmid),
      );

      final notifier = container.read(
        qemuVmConfigEditorProvider(node, vmid).notifier,
      );
      final loaded =
          container.read(qemuVmConfigEditorProvider(node, vmid)).requireValue;
      expect(loaded.draft.name, 'alpha');

      notifier.updateDraft(loaded.draft.copyWith(name: 'beta'));
      await notifier.save();
      final after = await container.read(
        qemuVmConfigEditorProvider(node, vmid).future,
      );

      expect(adapter.requests.length, greaterThanOrEqualTo(3));
      expect(adapter.requests[1].method, 'PUT');
      expect(
        adapter.requests[1].path,
        ApiEndpoints.nodeQemuVmConfig(node, vmid),
      );
      expect(adapter.requests[1].data, {'name': 'beta'});
      expect(after.draft.name, 'beta');
    },
  );

  test('QemuVmConfigEditor empty delta skips PUT', () async {
    final (client, adapter) = proxmoxClientWithFakeAdapter([
      jsonResponse(<String, dynamic>{'name': 'same'}),
    ]);
    final repo = VmRepository(client);
    final container = ProviderContainer(
      overrides: [vmRepositoryProvider.overrideWith((ref) async => repo)],
    );
    addTearDown(container.dispose);

    final keepAlive = container.listen(
      qemuVmConfigEditorProvider('n', 1),
      (_, _) {},
    );
    addTearDown(keepAlive.close);
    await container.read(qemuVmConfigEditorProvider('n', 1).future);
    await container.read(qemuVmConfigEditorProvider('n', 1).notifier).save();

    expect(adapter.requests, hasLength(1));
  });
}
