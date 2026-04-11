import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/core/models/proxmox_guest_tag.dart';

void main() {
  group('parseProxmoxGuestTagsString', () {
    test('empty and whitespace', () {
      expect(parseProxmoxGuestTagsString(''), isEmpty);
      expect(parseProxmoxGuestTagsString('  \t  '), isEmpty);
    });

    test('simple semicolon-separated names', () {
      final tags = parseProxmoxGuestTagsString('prod; web;test ');
      expect(tags, hasLength(3));
      expect(tags[0].label, 'prod');
      expect(tags[1].label, 'web');
      expect(tags[2].label, 'test');
    });

    test('merges color= onto previous segment', () {
      final tags = parseProxmoxGuestTagsString('prod;color=EE00FF;web');
      expect(tags, hasLength(2));
      expect(tags[0].label, 'prod');
      expect(tags[0].inlineBackgroundHex, 'EE00FF');
      expect(tags[1].label, 'web');
    });

    test('inline icon key', () {
      final tags = parseProxmoxGuestTagsString('db;icon=computer');
      expect(tags.single.label, 'db');
      expect(tags.single.iconKey, 'computer');
    });

    test('guestTagsFromJson null', () {
      expect(guestTagsFromJson(null), isEmpty);
    });
  });

  group('mergeProxmoxTagSegments', () {
    test('property-only attaches to previous', () {
      expect(
        mergeProxmoxTagSegments(['a', 'color=112233']),
        ['a;color=112233'],
      );
    });
  });
}
