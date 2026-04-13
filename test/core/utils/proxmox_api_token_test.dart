import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/core/utils/proxmox_api_token.dart';

void main() {
  group('composeProxmoxApiTokenValue', () {
    test('joins token id and secret', () {
      expect(
        composeProxmoxApiTokenValue('root@pam!tok', 'uuid-secret'),
        'root@pam!tok=uuid-secret',
      );
    });

    test('trims whitespace', () {
      expect(
        composeProxmoxApiTokenValue('  root@pam!tok  ', '  uuid  '),
        'root@pam!tok=uuid',
      );
    });

    test('rejects token id without !', () {
      expect(
        () => composeProxmoxApiTokenValue('root@pam', 'x'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects token id containing =', () {
      expect(
        () => composeProxmoxApiTokenValue('root@pam!a=b', 'x'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects empty secret', () {
      expect(
        () => composeProxmoxApiTokenValue('root@pam!tok', '   '),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects empty token id', () {
      expect(
        () => composeProxmoxApiTokenValue('', 'sec'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('trySplitFullApiToken', () {
    test('splits standard combined value', () {
      final r = trySplitFullApiToken('root@pam!mytoken=abc-def-0123');
      expect(r?.tokenId, 'root@pam!mytoken');
      expect(r?.secret, 'abc-def-0123');
    });

    test('splits on first = after !', () {
      final r = trySplitFullApiToken('user@realm!name=part2=part3');
      expect(r?.tokenId, 'user@realm!name');
      expect(r?.secret, 'part2=part3');
    });

    test('strips PVEAPIToken= prefix case-insensitively', () {
      final r = trySplitFullApiToken('PVEAPIToken=root@pam!t=secret');
      expect(r?.tokenId, 'root@pam!t');
      expect(r?.secret, 'secret');
      final r2 = trySplitFullApiToken('pveapitoken=root@pam!t=sec2');
      expect(r2?.secret, 'sec2');
    });

    test('returns null without !', () {
      expect(trySplitFullApiToken('root@pam=tok'), isNull);
    });

    test('returns null without = after !', () {
      expect(trySplitFullApiToken('root@pam!tok'), isNull);
    });

    test('returns null for empty', () {
      expect(trySplitFullApiToken(''), isNull);
      expect(trySplitFullApiToken('   '), isNull);
    });

    test('returns null when token id would contain =', () {
      expect(trySplitFullApiToken('bad=tok!x=y'), isNull);
    });
  });

  group('stripProxmoxApiTokenHeaderPrefix', () {
    test('leaves plain token unchanged', () {
      expect(stripProxmoxApiTokenHeaderPrefix('root@pam!t=s'), 'root@pam!t=s');
    });
  });

  group('isWellFormedApiTokenId', () {
    test('accepts valid id', () {
      expect(isWellFormedApiTokenId('root@pam!tok'), isTrue);
    });

    test('rejects missing bang', () {
      expect(isWellFormedApiTokenId('root@pam'), isFalse);
    });

    test('rejects equals in id', () {
      expect(isWellFormedApiTokenId('a!b=c'), isFalse);
    });
  });

  group('isPartialApiTokenPair', () {
    test('false when both empty', () {
      expect(isPartialApiTokenPair('', ''), isFalse);
    });

    test('false when both non-empty', () {
      expect(isPartialApiTokenPair('a!b', 'c'), isFalse);
    });

    test('true when only id', () {
      expect(isPartialApiTokenPair('root@pam!t', ''), isTrue);
    });

    test('true when only secret', () {
      expect(isPartialApiTokenPair('', 'secret'), isTrue);
    });
  });
}
