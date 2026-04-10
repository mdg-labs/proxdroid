import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// [AppBar.leading] for shell routes: opens drawer at root, pops when stacked.
Widget? shellAppBarLeading(BuildContext context) {
  if (context.canPop()) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => context.pop(),
    );
  }
  return IconButton(
    icon: const Icon(Icons.menu),
    onPressed: () => Scaffold.of(context).openDrawer(),
  );
}
