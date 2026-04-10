import 'package:flutter_test/flutter_test.dart';

/// Opt-in tests under `integration_test/`. Tagged so CI can skip them when
/// using `flutter test` on `test/` only.
///
/// **Note:** Importing `package:integration_test/integration_test.dart` forces
/// the integration test device workflow (e.g. building a Linux desktop binary),
/// which requires host tooling such as CMake on Linux. This placeholder uses
/// only `flutter_test` so `flutter test integration_test --tags integration`
/// runs as a normal test compile without a desktop build.
///
/// When you add real device or live-PVE tests, add the `integration_test`
/// dependency usage and run on an Android emulator, Chrome, or a properly
/// configured desktop target (see Flutter integration test docs).
///
/// On Linux, prefer `-d flutter-tester` unless CMake/Linux desktop build is
/// set up (see CONTRIBUTING.md).
void main() {
  testWidgets('integration scaffold placeholder', (WidgetTester tester) async {
    expect(true, isTrue);
  }, tags: ['integration']);
}
