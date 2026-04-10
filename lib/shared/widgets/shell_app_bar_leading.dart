import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/shared/routing/shell_drawer_root_paths.dart';

/// [AppBar.leading] for shell routes: drawer on section roots, back on nested
/// routes ([isShellDrawerRootPath]). Do not use [GoRouter.canPop] — it can stay
/// true on section roots after redirects or pops, which hides the drawer.
///
/// Phase 3 (§6.3): behavior stays **path-based** only; any visual tweaks must not
/// change when the menu vs back control appears.
Widget? shellAppBarLeading(BuildContext context) {
  final path = GoRouterState.of(context).uri.path;
  if (isShellDrawerRootPath(path)) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () => Scaffold.of(context).openDrawer(),
    );
  }
  return IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => context.pop(),
  );
}
