import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:proxdroid/features/servers/providers/server_providers.dart';

part 'proxmox_tag_colors_provider.g.dart';

/// Cluster datacenter tag → background hex (`GET /version` → `tag-colors`).
///
/// Empty when no server is selected. Invalidates when [apiClientProvider] changes.
@Riverpod(keepAlive: true)
Future<Map<String, String>> proxmoxTagColors(Ref ref) async {
  final client = await ref.watch(apiClientProvider.future);
  if (client == null) {
    return const {};
  }
  final version = await client.fetchVersion();
  return version.tagBackgroundHexByTagLabel;
}
