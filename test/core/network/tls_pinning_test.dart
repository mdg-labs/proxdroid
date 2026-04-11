import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/core/network/tls_pinning.dart';

void main() {
  const kValidPin =
      'abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789';

  test('normalizePinnedTlsSha256 trims and lowercases', () {
    expect(
      normalizePinnedTlsSha256('  ${kValidPin.toUpperCase()}  '),
      kValidPin,
    );
  });

  test('normalizePinnedTlsSha256 rejects wrong length', () {
    expect(normalizePinnedTlsSha256('abc'), isNull);
    expect(normalizePinnedTlsSha256('g' * 64), isNull);
  });

  test('isValidPinnedTlsSha256Format', () {
    expect(isValidPinnedTlsSha256Format(kValidPin), isTrue);
    expect(isValidPinnedTlsSha256Format(null), isFalse);
    expect(isValidPinnedTlsSha256Format(''), isFalse);
  });
}
