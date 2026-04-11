import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/core/models/proxmox_version.dart';

void main() {
  group('ProxmoxVersion.fromDataJson', () {
    test('parses version without tag-colors', () {
      final v = ProxmoxVersion.fromDataJson(<String, dynamic>{
        'version': '8.2.4',
        'release': '1',
      });
      expect(v.version, '8.2.4');
      expect(v.release, '1');
      expect(v.tagBackgroundHexByTagLabel, isEmpty);
    });

    test('parses tag-colors map of hex strings', () {
      final v = ProxmoxVersion.fromDataJson(<String, dynamic>{
        'version': '8',
        'tag-colors': <String, dynamic>{'Prod': 'ff00aa', 'web': '#112233'},
      });
      expect(v.tagBackgroundHexByTagLabel['prod'], 'FF00AA');
      expect(v.tagBackgroundHexByTagLabel['web'], '112233');
    });

    test('parses tag-style name:bg:fg string values', () {
      final v = ProxmoxVersion.fromDataJson(<String, dynamic>{
        'version': '8',
        'tag-colors': <String, dynamic>{'x': 'ignoredname:ABCDEF:000000'},
      });
      expect(v.tagBackgroundHexByTagLabel['x'], 'ABCDEF');
    });

    test('parses nested color key in map value', () {
      final v = ProxmoxVersion.fromDataJson(<String, dynamic>{
        'version': '8',
        'tag-colors': <String, dynamic>{
          'db': <String, dynamic>{'color': '00FFAA'},
        },
      });
      expect(v.tagBackgroundHexByTagLabel['db'], '00FFAA');
    });
  });
}
