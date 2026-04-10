import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Opt-in integration / device tests. Does not require a live Proxmox server.
///
/// Run:
/// `flutter test integration_test --tags integration`
///
/// For future end-to-end tests against a real PVE host, keep them in this
/// directory, tag them, and gate any network calls on environment variables
/// (see CONTRIBUTING.md).
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('integration scaffold placeholder', (WidgetTester tester) async {
    expect(true, isTrue);
  }, tags: ['integration']);
}
