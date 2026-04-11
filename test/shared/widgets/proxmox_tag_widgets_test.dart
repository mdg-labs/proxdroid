import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/core/models/proxmox_guest_tag.dart';
import 'package:proxdroid/shared/widgets/proxmox_tag_widgets.dart';

void main() {
  testWidgets('ProxmoxTagRow renders tag label', (tester) async {
    const tags = [
      ProxmoxGuestTag(label: 'prod', inlineBackgroundHex: 'FF0000'),
    ];
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProxmoxTagRow(tags: tags, clusterTagHexByLabel: {}),
        ),
      ),
    );
    expect(find.text('prod'), findsOneWidget);
  });

  testWidgets('ProxmoxTagBadge shows icon when iconKey set', (tester) async {
    const tag = ProxmoxGuestTag(label: 'db', iconKey: 'computer');
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProxmoxTagBadge(
            tag: tag,
            clusterTagHexByLabel: {},
            density: ProxmoxTagDensity.comfortable,
          ),
        ),
      ),
    );
    expect(find.text('db'), findsOneWidget);
    expect(find.byIcon(Icons.computer_outlined), findsOneWidget);
  });
}
