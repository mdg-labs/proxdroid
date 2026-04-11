import 'package:flutter/material.dart';
import 'package:proxdroid/features/servers/ui/server_editor_page.dart';
import 'package:proxdroid/shared/widgets/secure_window_scope.dart';

class AddServerScreen extends StatelessWidget {
  const AddServerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SecureWindowScope(child: ServerEditorPage());
  }
}
