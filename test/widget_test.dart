import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/app/app.dart';

void main() {
  testWidgets('ProxDroidApp loads MaterialApp', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ProxDroidApp()));
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
