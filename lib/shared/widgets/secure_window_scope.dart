import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Enables Android [FLAG_SECURE] while mounted (blocks screenshots / recent
/// apps preview for this activity). No-op if the platform channel fails.
class SecureWindowScope extends StatefulWidget {
  const SecureWindowScope({required this.child, super.key});

  final Widget child;

  static const MethodChannel _channel = MethodChannel(
    'com.mdglabs.proxdroid/security',
  );

  @override
  State<SecureWindowScope> createState() => _SecureWindowScopeState();
}

class _SecureWindowScopeState extends State<SecureWindowScope> {
  @override
  void initState() {
    super.initState();
    _setSecure(true);
  }

  @override
  void dispose() {
    _setSecure(false);
    super.dispose();
  }

  Future<void> _setSecure(bool value) async {
    try {
      await SecureWindowScope._channel.invokeMethod<void>('setSecure', value);
    } on Object {
      // Non-Android or older embedding — ignore.
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
