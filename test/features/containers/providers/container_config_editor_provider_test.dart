import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/features/containers/data/container_repository.dart';
import 'package:proxdroid/features/containers/providers/container_config_providers.dart';
import 'package:proxdroid/features/containers/providers/container_providers.dart';
import 'package:proxdroid/shared/constants/api_endpoints.dart';

import '../../../support/proxmox_test_client.dart';

void main() {
  test(
    'LxcContainerConfigEditor save sends PUT delta then refetches GET config',
    () async {
      final (client, adapter) = proxmoxClientWithFakeAdapter([
        jsonResponse(<String, dynamic>{'hostname': 'alpha', 'memory': '512'}),
        jsonResponse(null),
        jsonResponse(<String, dynamic>{'hostname': 'beta', 'memory': '512'}),
        jsonResponse(<String, dynamic>{'hostname': 'beta', 'memory': '512'}),
      ]);
      final repo = ContainerRepository(client);

      final container = ProviderContainer(
        overrides: [
          containerRepositoryProvider.overrideWith((ref) async => repo),
        ],
      );
      addTearDown(container.dispose);

      const node = 'n1';
      const ctid = 8;

      final keepAlive = container.listen(
        lxcContainerConfigEditorProvider(node, ctid),
        (_, _) {},
      );
      addTearDown(keepAlive.close);

      await container.read(lxcContainerConfigEditorProvider(node, ctid).future);
      expect(adapter.requests, hasLength(1));
      expect(adapter.requests.single.method, 'GET');
      expect(
        adapter.requests.single.path,
        ApiEndpoints.nodeLxcCtConfig(node, ctid),
      );

      final notifier = container.read(
        lxcContainerConfigEditorProvider(node, ctid).notifier,
      );
      final loaded =
          container
              .read(lxcContainerConfigEditorProvider(node, ctid))
              .requireValue;
      expect(loaded.draft.hostname, 'alpha');

      notifier.updateDraft(loaded.draft.copyWith(hostname: 'beta'));
      await notifier.save();
      final after = await container.read(
        lxcContainerConfigEditorProvider(node, ctid).future,
      );

      expect(adapter.requests.length, greaterThanOrEqualTo(3));
      expect(adapter.requests[1].method, 'PUT');
      expect(
        adapter.requests[1].path,
        ApiEndpoints.nodeLxcCtConfig(node, ctid),
      );
      expect(adapter.requests[1].data, {'hostname': 'beta'});
      expect(after.draft.hostname, 'beta');
    },
  );

  test('LxcContainerConfigEditor empty delta skips PUT', () async {
    final (client, adapter) = proxmoxClientWithFakeAdapter([
      jsonResponse(<String, dynamic>{'hostname': 'same'}),
    ]);
    final repo = ContainerRepository(client);
    final container = ProviderContainer(
      overrides: [
        containerRepositoryProvider.overrideWith((ref) async => repo),
      ],
    );
    addTearDown(container.dispose);

    final keepAlive = container.listen(
      lxcContainerConfigEditorProvider('n', 2),
      (_, _) {},
    );
    addTearDown(keepAlive.close);
    await container.read(lxcContainerConfigEditorProvider('n', 2).future);
    await container
        .read(lxcContainerConfigEditorProvider('n', 2).notifier)
        .save();

    expect(adapter.requests, hasLength(1));
  });
}
