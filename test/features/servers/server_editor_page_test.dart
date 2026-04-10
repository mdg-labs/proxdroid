import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:proxdroid/core/models/server.dart';
import 'package:proxdroid/core/storage/server_adapter.dart';
import 'package:proxdroid/core/storage/server_storage.dart';
import 'package:proxdroid/features/servers/ui/server_editor_page.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/l10n/app_localizations_en.dart';

import '../../support/in_memory_secure_storage.dart';

void main() {
  late Directory tempDir;
  late Box<Server> box;
  late ServerStorage serverStorage;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = Directory.systemTemp.createTempSync(
      'proxdroid_server_editor_test',
    );
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(ServerAdapter().typeId)) {
      Hive.registerAdapter(ServerAdapter());
    }
    final hash = tempDir.path.hashCode.abs();
    box = await Hive.openBox<Server>('servers_$hash');
    serverStorage = ServerStorage(
      box: box,
      secureStorage: InMemorySecureStorage(),
    );
  });

  tearDown(() async {
    final name = box.name;
    await box.close();
    await Hive.deleteBoxFromDisk(name);
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  testWidgets('Save with empty name shows validator message', (
    WidgetTester tester,
  ) async {
    final l10n = AppLocalizationsEn();
    await tester.binding.setSurfaceSize(const Size(1200, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder:
              (context, state) => Scaffold(
                drawer: const Drawer(),
                body: const ServerEditorPage(),
              ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [serverStorageProvider.overrideWithValue(serverStorage)],
        child: MaterialApp.router(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    await tester.tap(find.text(l10n.actionSave));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text(l10n.serverNameErrorEmpty), findsOneWidget);
  });
}
